Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607CD8F4D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560070; cv=none; b=RsxlJreje16kGHOjnul+sExOmUH7PXjSl9jzi4yZIktJbB6eznJ0jGRP7yuHRht88BHe935p2WPr/uBEkgmbvQMAaZdncvnwEqRG05WLDrqJDcwc6kFogJ6pqyjUssl78m2z7OssnzkGDBo996LwOuXv8JRs6O7E+vZrtMFU0bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560070; c=relaxed/simple;
	bh=VkWfRxBJvXsjMTY9bkHgKg2UgTAfOuKyjgicg9samwk=;
	h=Date:To:From:Subject:Message-Id; b=B01zQIv51sq73DR8HbCFJnj2qlHt2qJJDm9sBoKkGr/PB6lU4EW0g0plEaL/zDeOTPifPz1n+nTw7YlPVMsL/g7zm6uWvd0PbytC/S1KSK6150+h3ARI4lG+rpA3Rw/MVVVuA4Zz0g1nnC7IbR8kB+gfph77F+eisF60eyhZJ6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dZHEAWM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dZHEAWM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8584C433A6;
	Thu, 22 Feb 2024 00:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560070;
	bh=VkWfRxBJvXsjMTY9bkHgKg2UgTAfOuKyjgicg9samwk=;
	h=Date:To:From:Subject:From;
	b=dZHEAWM61xDHxGzfI5Ai2mqLYaPWg0btzrM6zG2XVUnRdQzqr8CoGo5LXgsv7I/7r
	 Hx6XnmLQLhH2a47prCDMPUfrsgJu+zL9SvLh3M0Xqtd2OG7xnb+jMvMEfDb16wt86F
	 cUIqbNEMrsdLpzyrBMjuqa6hbDCZ7554Jls7Id9A=
Date: Wed, 21 Feb 2024 16:01:09 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-convert-mem_cgroup_move_charge_pte_range-to-use-a-folio.patch removed from -mm tree
Message-Id: <20240222000109.E8584C433A6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: convert mem_cgroup_move_charge_pte_range() to use a folio
has been removed from the -mm tree.  Its filename was
     memcg-convert-mem_cgroup_move_charge_pte_range-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memcg: convert mem_cgroup_move_charge_pte_range() to use a folio
Date: Thu, 11 Jan 2024 18:12:16 +0000

Patch series "Convert memcontrol charge moving to use folios".

No part of these patches should change behaviour; all the called functions
already convert from page to folio, so this ought to simply be a reduction
in the number of calls to compound_head().  


This patch (of 4):

Remove many calls to compound_head() by calling page_folio() once at the
start of each stanza which receives a struct page from 'target'.  There
should be no change in behaviour here as all the called functions start
out by converting the page to its folio.

Link: https://lkml.kernel.org/r/20240111181219.3462852-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240111181219.3462852-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   49 ++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

--- a/mm/memcontrol.c~memcg-convert-mem_cgroup_move_charge_pte_range-to-use-a-folio
+++ a/mm/memcontrol.c
@@ -5965,23 +5965,22 @@ static struct page *mc_handle_file_pte(s
 }
 
 /**
- * mem_cgroup_move_account - move account of the page
- * @page: the page
+ * mem_cgroup_move_account - move account of the folio
+ * @folio: The folio.
  * @compound: charge the page as compound or small page
- * @from: mem_cgroup which the page is moved from.
- * @to:	mem_cgroup which the page is moved to. @from != @to.
+ * @from: mem_cgroup which the folio is moved from.
+ * @to:	mem_cgroup which the folio is moved to. @from != @to.
  *
- * The page must be locked and not on the LRU.
+ * The folio must be locked and not on the LRU.
  *
  * This function doesn't do "charge" to new cgroup and doesn't do "uncharge"
  * from old cgroup.
  */
-static int mem_cgroup_move_account(struct page *page,
+static int mem_cgroup_move_account(struct folio *folio,
 				   bool compound,
 				   struct mem_cgroup *from,
 				   struct mem_cgroup *to)
 {
-	struct folio *folio = page_folio(page);
 	struct lruvec *from_vec, *to_vec;
 	struct pglist_data *pgdat;
 	unsigned int nr_pages = compound ? folio_nr_pages(folio) : 1;
@@ -6431,7 +6430,7 @@ static int mem_cgroup_move_charge_pte_ra
 	spinlock_t *ptl;
 	enum mc_target_type target_type;
 	union mc_target target;
-	struct page *page;
+	struct folio *folio;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
@@ -6441,26 +6440,26 @@ static int mem_cgroup_move_charge_pte_ra
 		}
 		target_type = get_mctgt_type_thp(vma, addr, *pmd, &target);
 		if (target_type == MC_TARGET_PAGE) {
-			page = target.page;
-			if (isolate_lru_page(page)) {
-				if (!mem_cgroup_move_account(page, true,
+			folio = page_folio(target.page);
+			if (folio_isolate_lru(folio)) {
+				if (!mem_cgroup_move_account(folio, true,
 							     mc.from, mc.to)) {
 					mc.precharge -= HPAGE_PMD_NR;
 					mc.moved_charge += HPAGE_PMD_NR;
 				}
-				putback_lru_page(page);
+				folio_putback_lru(folio);
 			}
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 		} else if (target_type == MC_TARGET_DEVICE) {
-			page = target.page;
-			if (!mem_cgroup_move_account(page, true,
+			folio = page_folio(target.page);
+			if (!mem_cgroup_move_account(folio, true,
 						     mc.from, mc.to)) {
 				mc.precharge -= HPAGE_PMD_NR;
 				mc.moved_charge += HPAGE_PMD_NR;
 			}
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 		}
 		spin_unlock(ptl);
 		return 0;
@@ -6483,28 +6482,28 @@ retry:
 			device = true;
 			fallthrough;
 		case MC_TARGET_PAGE:
-			page = target.page;
+			folio = page_folio(target.page);
 			/*
 			 * We can have a part of the split pmd here. Moving it
 			 * can be done but it would be too convoluted so simply
 			 * ignore such a partial THP and keep it in original
 			 * memcg. There should be somebody mapping the head.
 			 */
-			if (PageTransCompound(page))
+			if (folio_test_large(folio))
 				goto put;
-			if (!device && !isolate_lru_page(page))
+			if (!device && !folio_isolate_lru(folio))
 				goto put;
-			if (!mem_cgroup_move_account(page, false,
+			if (!mem_cgroup_move_account(folio, false,
 						mc.from, mc.to)) {
 				mc.precharge--;
 				/* we uncharge from mc.from later. */
 				mc.moved_charge++;
 			}
 			if (!device)
-				putback_lru_page(page);
+				folio_putback_lru(folio);
 put:			/* get_mctgt_type() gets & locks the page */
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			break;
 		case MC_TARGET_SWAP:
 			ent = target.ent;
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-replace-two-calls-to-compound_order-with-folio_order.patch
writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch
writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch
writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch
writeback-simplify-the-loops-in-write_cache_pages.patch
pagevec-add-ability-to-iterate-a-queue.patch
writeback-use-the-folio_batch-queue-iterator.patch
writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch
writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

