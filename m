From: akpm@linux-foundation.org
Subject: + mm-uninline-page_xchg_last_nid.patch added to -mm tree
Date: Wed, 23 Jan 2013 13:51:14 -0800
Message-ID: <20130123215114.A94C831C27E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:39335 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3AWVvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jan 2013 16:51:16 -0500
Received: by mail-qa0-f73.google.com with SMTP id bv4so11805qab.0
        for <mm-commits@vger.kernel.org>; Wed, 23 Jan 2013 13:51:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de


The patch titled
     Subject: mm: uninline page_xchg_last_nid()
has been added to the -mm tree.  Its filename is
     mm-uninline-page_xchg_last_nid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: uninline page_xchg_last_nid()

Andrew Morton pointed out that page_xchg_last_nid() and
reset_page_last_nid() were "getting nuttily large" and asked that it be
investigated.

reset_page_last_nid() is on the page free path and it would be unfortunate
to make that path more expensive than it needs to be.  Due to the internal
use of page_xchg_last_nid() it is already too expensive but fortunately,
it should also be impossible for the page->flags to be updated in parallel
when we call reset_page_last_nid().  Instead of unlining the function, it
uses a simplier implementation that assumes no parallel updates and should
now be sufficiently short for inlining.

page_xchg_last_nid() is called in paths that are already quite expensive
(splitting huge page, fault handling, migration) and it is reasonable to
uninline.  There was not really a good place to place the function but
mm/mmzone.c was the closest fit IMO.

This patch saved 128 bytes of text in the vmlinux file for the kernel
configuration I used for testing automatic NUMA balancing.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   21 +++++----------------
 mm/mmzone.c        |   20 +++++++++++++++++++-
 2 files changed, 24 insertions(+), 17 deletions(-)

diff -puN include/linux/mm.h~mm-uninline-page_xchg_last_nid include/linux/mm.h
--- a/include/linux/mm.h~mm-uninline-page_xchg_last_nid
+++ a/include/linux/mm.h
@@ -677,25 +677,14 @@ static inline int page_last_nid(struct p
 	return (page->flags >> LAST_NID_PGSHIFT) & LAST_NID_MASK;
 }
 
-static inline int page_xchg_last_nid(struct page *page, int nid)
-{
-	unsigned long old_flags, flags;
-	int last_nid;
-
-	do {
-		old_flags = flags = page->flags;
-		last_nid = page_last_nid(page);
-
-		flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
-		flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
-	} while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
-
-	return last_nid;
-}
+extern int page_xchg_last_nid(struct page *page, int nid);
 
 static inline void reset_page_last_nid(struct page *page)
 {
-	page_xchg_last_nid(page, (1 << LAST_NID_SHIFT) - 1);
+	int nid = (1 << LAST_NID_SHIFT) - 1;
+
+	page->flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
+	page->flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
 }
 #endif /* LAST_NID_NOT_IN_PAGE_FLAGS */
 #else
diff -puN mm/mmzone.c~mm-uninline-page_xchg_last_nid mm/mmzone.c
--- a/mm/mmzone.c~mm-uninline-page_xchg_last_nid
+++ a/mm/mmzone.c
@@ -1,7 +1,7 @@
 /*
  * linux/mm/mmzone.c
  *
- * management codes for pgdats and zones.
+ * management codes for pgdats, zones and page flags
  */
 
 
@@ -96,3 +96,21 @@ void lruvec_init(struct lruvec *lruvec)
 	for_each_lru(lru)
 		INIT_LIST_HEAD(&lruvec->lists[lru]);
 }
+
+#if defined(CONFIG_NUMA_BALANCING) && !defined(LAST_NID_NOT_IN_PAGE_FLAGS)
+int page_xchg_last_nid(struct page *page, int nid)
+{
+	unsigned long old_flags, flags;
+	int last_nid;
+
+	do {
+		old_flags = flags = page->flags;
+		last_nid = page_last_nid(page);
+
+		flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
+		flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
+	} while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
+
+	return last_nid;
+}
+#endif
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mmksm-use-new-hashtable-implementation.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-avoid-calling-pgdat_balanced-needlessly.patch
mm-dont-wait-on-congested-zones-in-balance_pgdat.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch
mm-numa-fix-minor-typo-in-numa_next_scan.patch
mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch
mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch
mm-move-page-flags-layout-to-separate-header.patch
mm-fold-page-_last_nid-into-page-flags-where-possible.patch
mm-numa-cleanup-flow-of-transhuge-page-migration.patch
mm-uninline-page_xchg_last_nid.patch
mm-memmap_init_zone-performance-improvement.patch

