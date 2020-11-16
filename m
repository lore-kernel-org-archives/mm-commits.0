Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1599CC63697
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A83FA22370
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:57:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="EfyaIMUV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgKPV5n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 16:57:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:42702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbgKPV5n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 16:57:43 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DC3D222EC;
        Mon, 16 Nov 2020 21:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605563862;
        bh=PVizCwKELBcxlyEWcS6eWnicPEH31qKTwq4i/Xm+DlM=;
        h=Date:From:To:Subject:From;
        b=EfyaIMUVgZ3oy87ON5d07bg4cjYx3FsbEeye6dZoy5Hd95pyJTVchB9bsubXXcD8x
         Qdlyoz9a2nKry3tIXj6/SA0/oLHEIewtAgGU6Nsy514PtP+v/UP0lQzeexGddPvKW/
         TPMJ5AV0UUs8JnSuc2pq80ejgGZhqZRmCJ/tfP7I=
Date:   Mon, 16 Nov 2020 13:57:39 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, alex.shi@linux.alibaba.com,
        alexander.duyck@gmail.com, aryabinin@virtuozzo.com,
        daniel.m.jordan@oracle.com, hannes@cmpxchg.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, jannh@google.com,
        khlebnikov@yandex-team.ru, kirill.shutemov@linux.intel.com,
        kirill@shutemov.name, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mika.penttila@nextfour.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, rong.a.chen@intel.com,
        shakeelb@google.com, tglx@linutronix.de, tj@kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, ying.huang@intel.com
Subject:  +
 mm-compaction-do-page-isolation-first-in-compaction.patch added to -mm tree
Message-ID: <20201116215739.MkwPkTOQN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: do page isolation first in compaction
has been added to the -mm tree.  Its filename is
     mm-compaction-do-page-isolation-first-in-compaction.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-do-page-isolati=
on-first-in-compaction.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-do-page-isolati=
on-first-in-compaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/compaction: do page isolation first in compaction

Currently, compaction would get the lru_lock and then do page isolation
which works fine with pgdat->lru_lock, since any page isoltion would
compete for the lru_lock.  If we want to change to memcg lru_lock, we have
to isolate the page before getting lru_lock, thus isoltion would block
page's memcg change which relay on page isoltion too.  Then we could
safely use per memcg lru_lock later.

The new page isolation use previous introduced TestClearPageLRU() + pgdat
lru locking which will be changed to memcg lru lock later.

Hugh Dickins <hughd@google.com> fixed following bugs in this patch's early
version:

Fix lots of crashes under compaction load: isolate_migratepages_block()
must clean up appropriately when rejecting a page, setting PageLRU again
if it had been cleared; and a put_page() after get_page_unless_zero()
cannot safely be done while holding locked_lruvec - it may turn out to be
the final put_page(), which will take an lruvec lock when PageLRU.

And move __isolate_lru_page_prepare back after get_page_unless_zero to
make trylock_page() safe: trylock_page() is not safe to use at this time:
its setting PG_locked can race with the page being freed or allocated
("Bad page"), and can also erase flags being set by one of those "sole
owners" of a freshly allocated page who use non-atomic __SetPageFlag().

Link: https://lkml.kernel.org/r/1604566549-62481-16-git-send-email-alex.shi=
@linux.alibaba.com
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttil=C3=A4 <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 -
 mm/compaction.c      |   42 +++++++++++++++++++++++++++++++---------
 mm/vmscan.c          |   43 ++++++++++++++++++++---------------------
 3 files changed, 56 insertions(+), 31 deletions(-)

--- a/include/linux/swap.h~mm-compaction-do-page-isolation-first-in-compact=
ion
+++ a/include/linux/swap.h
@@ -356,7 +356,7 @@ extern void lru_cache_add_inactive_or_un
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int orde=
r,
 					gfp_t gfp_mask, nodemask_t *mask);
-extern int __isolate_lru_page(struct page *page, isolate_mode_t mode);
+extern int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mo=
de);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
--- a/mm/compaction.c~mm-compaction-do-page-isolation-first-in-compaction
+++ a/mm/compaction.c
@@ -890,6 +890,7 @@ isolate_migratepages_block(struct compac
 		if (!valid_page && IS_ALIGNED(low_pfn, pageblock_nr_pages)) {
 			if (!cc->ignore_skip_hint && get_pageblock_skip(page)) {
 				low_pfn =3D end_pfn;
+				page =3D NULL;
 				goto isolate_abort;
 			}
 			valid_page =3D page;
@@ -971,6 +972,21 @@ isolate_migratepages_block(struct compac
 		if (!(cc->gfp_mask & __GFP_FS) && page_mapping(page))
 			goto isolate_fail;
=20
+		/*
+		 * Be careful not to clear PageLRU until after we're
+		 * sure the page is not being freed elsewhere -- the
+		 * page release code relies on it.
+		 */
+		if (unlikely(!get_page_unless_zero(page)))
+			goto isolate_fail;
+
+		if (__isolate_lru_page_prepare(page, isolate_mode) !=3D 0)
+			goto isolate_fail_put;
+
+		/* Try isolate the page */
+		if (!TestClearPageLRU(page))
+			goto isolate_fail_put;
+
 		/* If we already hold the lock, we can skip some rechecking */
 		if (!locked) {
 			locked =3D compact_lock_irqsave(&pgdat->lru_lock,
@@ -983,10 +999,6 @@ isolate_migratepages_block(struct compac
 					goto isolate_abort;
 			}
=20
-			/* Recheck PageLRU and PageCompound under lock */
-			if (!PageLRU(page))
-				goto isolate_fail;
-
 			/*
 			 * Page become compound since the non-locked check,
 			 * and it's on LRU. It can only be a THP so the order
@@ -994,16 +1006,13 @@ isolate_migratepages_block(struct compac
 			 */
 			if (unlikely(PageCompound(page) && !cc->alloc_contig)) {
 				low_pfn +=3D compound_nr(page) - 1;
-				goto isolate_fail;
+				SetPageLRU(page);
+				goto isolate_fail_put;
 			}
 		}
=20
 		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
=20
-		/* Try isolate the page */
-		if (__isolate_lru_page(page, isolate_mode) !=3D 0)
-			goto isolate_fail;
-
 		/* The whole page is taken off the LRU; skip the tail pages. */
 		if (PageCompound(page))
 			low_pfn +=3D compound_nr(page) - 1;
@@ -1032,6 +1041,15 @@ isolate_success:
 		}
=20
 		continue;
+
+isolate_fail_put:
+		/* Avoid potential deadlock in freeing page under lru_lock */
+		if (locked) {
+			spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+			locked =3D false;
+		}
+		put_page(page);
+
 isolate_fail:
 		if (!skip_on_failure)
 			continue;
@@ -1068,9 +1086,15 @@ isolate_fail:
 	if (unlikely(low_pfn > end_pfn))
 		low_pfn =3D end_pfn;
=20
+	page =3D NULL;
+
 isolate_abort:
 	if (locked)
 		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+	if (page) {
+		SetPageLRU(page);
+		put_page(page);
+	}
=20
 	/*
 	 * Updated the cached scanner pfn once the pageblock has been scanned
--- a/mm/vmscan.c~mm-compaction-do-page-isolation-first-in-compaction
+++ a/mm/vmscan.c
@@ -1540,7 +1540,7 @@ unsigned int reclaim_clean_pages_from_li
  *
  * returns 0 on success, -ve errno on failure.
  */
-int __isolate_lru_page(struct page *page, isolate_mode_t mode)
+int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
 {
 	int ret =3D -EBUSY;
=20
@@ -1592,22 +1592,9 @@ int __isolate_lru_page(struct page *page
 	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
 		return ret;
=20
-	if (likely(get_page_unless_zero(page))) {
-		/*
-		 * Be careful not to clear PageLRU until after we're
-		 * sure the page is not being freed elsewhere -- the
-		 * page release code relies on it.
-		 */
-		if (TestClearPageLRU(page))
-			ret =3D 0;
-		else
-			put_page(page);
-	}
-
-	return ret;
+	return 0;
 }
=20
-
 /*
  * Update LRU sizes after isolating pages. The LRU size updates must
  * be complete before mem_cgroup_update_lru_size due to a sanity check.
@@ -1687,20 +1674,34 @@ static unsigned long isolate_lru_pages(u
 		 * only when the page is being freed somewhere else.
 		 */
 		scan +=3D nr_pages;
-		switch (__isolate_lru_page(page, mode)) {
+		switch (__isolate_lru_page_prepare(page, mode)) {
 		case 0:
+			/*
+			 * Be careful not to clear PageLRU until after we're
+			 * sure the page is not being freed elsewhere -- the
+			 * page release code relies on it.
+			 */
+			if (unlikely(!get_page_unless_zero(page)))
+				goto busy;
+
+			if (!TestClearPageLRU(page)) {
+				/*
+				 * This page may in other isolation path,
+				 * but we still hold lru_lock.
+				 */
+				put_page(page);
+				goto busy;
+			}
+
 			nr_taken +=3D nr_pages;
 			nr_zone_taken[page_zonenum(page)] +=3D nr_pages;
 			list_move(&page->lru, dst);
 			break;
=20
-		case -EBUSY:
+		default:
+busy:
 			/* else it is being freed elsewhere */
 			list_move(&page->lru, src);
-			continue;
-
-		default:
-			BUG();
 		}
 	}
=20
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
fs-ntfs-remove-unused-varibles.patch
fs-ntfs-remove-unused-varible-attr_len.patch
mm-memcg-update-page-struct-member-in-comments.patch
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-use-head-for-head-page-in-lru_add_page_tail.patch
mm-thp-simplify-lru_add_page_tail.patch
mm-thp-narrow-lru-locking.patch
mm-vmscan-remove-unnecessary-lruvec-adding.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping-fix.patch
mm-memcg-add-debug-checking-in-lock_page_memcg.patch
mm-swapc-fold-vm-event-pgrotated-into-pagevec_move_tail_fn.patch
mm-lru-move-lock-into-lru_note_cost.patch
mm-vmscan-remove-lruvec-reget-in-move_pages_to_lru.patch
mm-mlock-remove-lru_lock-on-testclearpagemlocked.patch
mm-mlock-remove-__munlock_isolate_lru_page.patch
mm-lru-introduce-testclearpagelru.patch
mm-compaction-do-page-isolation-first-in-compaction.patch
mm-swapc-serialize-memcg-changes-in-pagevec_lru_move_fn.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix-2.patch
mm-lru-introduce-the-relock_page_lruvec-function-fix.patch
docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

