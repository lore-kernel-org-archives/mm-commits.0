Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F59C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjASBQc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjASBOx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A839689F2
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05E71618FE
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64064C433D2;
        Thu, 19 Jan 2023 01:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090865;
        bh=pE+C+jv6K7bhLAxmIJAyHHOEETSQum16EZQl+2k/F94=;
        h=Date:To:From:Subject:From;
        b=f5LFvLgnPCJhQM5ucPah3aoRGdQtLVClCPt9TVIUmpQlFhRysYd3ClJhUzvhcJxQC
         rzNZUu+KGyncPqWj+sCXVVAz1rEOHDw5/0J1O0Au6CGIXqUKMM8/ACSMafML0gNr6t
         ixGCuDiBAJgAqC4shqlXmmZh5tB+n+h8FmSWskSI=
Date:   Wed, 18 Jan 2023 17:14:24 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hughd@google.com, hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-skip-moving-non-present-pages-that-are-mapped-elsewhere.patch removed from -mm tree
Message-Id: <20230119011425.64064C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcontrol: skip moving non-present pages that are mapped elsewhere
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-skip-moving-non-present-pages-that-are-mapped-elsewhere.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: skip moving non-present pages that are mapped elsewhere
Date: Tue, 6 Dec 2022 18:13:39 +0100

Patch series "mm: push down lock_page_memcg()", v2.


This patch (of 3):

During charge moving, the pte lock and the page lock cover nearly all
cases of stabilizing page_mapped().  The only exception is when we're
looking at a non-present pte and find a page in the page cache or in the
swapcache: if the page is mapped elsewhere, it can become unmapped outside
of our control.  For this reason, rmap needs lock_page_memcg().

We don't like cgroup-specific locks in generic MM code - especially in
performance-critical MM code - and for a legacy feature that's unlikely to
have many users left - if any.

So remove the exception.  Arguably that's better semantics anyway: the
page is shared, and another process seems to be the more active user.

Once we stop moving such pages, rmap doesn't need lock_page_memcg()
anymore.  The next patch will remove it.

Link: https://lkml.kernel.org/r/20221206171340.139790-1-hannes@cmpxchg.org
Link: https://lkml.kernel.org/r/20221206171340.139790-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   52 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 14 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-skip-moving-non-present-pages-that-are-mapped-elsewhere
+++ a/mm/memcontrol.c
@@ -5692,7 +5692,7 @@ static struct page *mc_handle_file_pte(s
  * @from: mem_cgroup which the page is moved from.
  * @to:	mem_cgroup which the page is moved to. @from != @to.
  *
- * The caller must make sure the page is not on LRU (isolate_page() is useful.)
+ * The page must be locked and not on the LRU.
  *
  * This function doesn't do "charge" to new cgroup and doesn't do "uncharge"
  * from old cgroup.
@@ -5709,20 +5709,13 @@ static int mem_cgroup_move_account(struc
 	int nid, ret;
 
 	VM_BUG_ON(from == to);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 	VM_BUG_ON(compound && !folio_test_large(folio));
 
-	/*
-	 * Prevent mem_cgroup_migrate() from looking at
-	 * page's memory cgroup of its source page while we change it.
-	 */
-	ret = -EBUSY;
-	if (!folio_trylock(folio))
-		goto out;
-
 	ret = -EINVAL;
 	if (folio_memcg(folio) != from)
-		goto out_unlock;
+		goto out;
 
 	pgdat = folio_pgdat(folio);
 	from_vec = mem_cgroup_lruvec(from, pgdat);
@@ -5809,8 +5802,6 @@ static int mem_cgroup_move_account(struc
 	mem_cgroup_charge_statistics(from, -nr_pages);
 	memcg_check_events(from, nid);
 	local_irq_enable();
-out_unlock:
-	folio_unlock(folio);
 out:
 	return ret;
 }
@@ -5859,6 +5850,29 @@ static enum mc_target_type get_mctgt_typ
 	else if (is_swap_pte(ptent))
 		page = mc_handle_swap_pte(vma, ptent, &ent);
 
+	if (target && page) {
+		if (!trylock_page(page)) {
+			put_page(page);
+			return ret;
+		}
+		/*
+		 * page_mapped() must be stable during the move. This
+		 * pte is locked, so if it's present, the page cannot
+		 * become unmapped. If it isn't, we have only partial
+		 * control over the mapped state: the page lock will
+		 * prevent new faults against pagecache and swapcache,
+		 * so an unmapped page cannot become mapped. However,
+		 * if the page is already mapped elsewhere, it can
+		 * unmap, and there is nothing we can do about it.
+		 * Alas, skip moving the page in this case.
+		 */
+		if (!pte_present(ptent) && page_mapped(page)) {
+			unlock_page(page);
+			put_page(page);
+			return ret;
+		}
+	}
+
 	if (!page && !ent.val)
 		return ret;
 	if (page) {
@@ -5875,8 +5889,11 @@ static enum mc_target_type get_mctgt_typ
 			if (target)
 				target->page = page;
 		}
-		if (!ret || !target)
+		if (!ret || !target) {
+			if (target)
+				unlock_page(page);
 			put_page(page);
+		}
 	}
 	/*
 	 * There is a swap entry and a page doesn't exist or isn't charged.
@@ -5916,6 +5933,10 @@ static enum mc_target_type get_mctgt_typ
 		ret = MC_TARGET_PAGE;
 		if (target) {
 			get_page(page);
+			if (!trylock_page(page)) {
+				put_page(page);
+				return MC_TARGET_NONE;
+			}
 			target->page = page;
 		}
 	}
@@ -6154,6 +6175,7 @@ static int mem_cgroup_move_charge_pte_ra
 				}
 				putback_lru_page(page);
 			}
+			unlock_page(page);
 			put_page(page);
 		} else if (target_type == MC_TARGET_DEVICE) {
 			page = target.page;
@@ -6162,6 +6184,7 @@ static int mem_cgroup_move_charge_pte_ra
 				mc.precharge -= HPAGE_PMD_NR;
 				mc.moved_charge += HPAGE_PMD_NR;
 			}
+			unlock_page(page);
 			put_page(page);
 		}
 		spin_unlock(ptl);
@@ -6204,7 +6227,8 @@ retry:
 			}
 			if (!device)
 				putback_lru_page(page);
-put:			/* get_mctgt_type() gets the page */
+put:			/* get_mctgt_type() gets & locks the page */
+			unlock_page(page);
 			put_page(page);
 			break;
 		case MC_TARGET_SWAP:
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


