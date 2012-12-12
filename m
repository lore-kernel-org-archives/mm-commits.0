From: akpm@linux-foundation.org
Subject: [folded-merged] mm-introduce-new-field-managed_pages-to-struct-zone-fix.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:40:13 -0800
Message-ID: <20121212214014.5CA6C82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35653 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab2LLVkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:40:15 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so130596qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:40:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jiang.liu@huawei.com, liuj97@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-new-field-managed_pages-to-struct-zone-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-new-field-managed_pages-to-struct-zone-fix.patch

This patch was dropped because it was folded into mm-introduce-new-field-managed_pages-to-struct-zone.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-introduce-new-field-managed_pages-to-struct-zone-fix

small comment tweaks

Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    8 ++++----
 mm/page_alloc.c        |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/mmzone.h~mm-introduce-new-field-managed_pages-to-struct-zone-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-introduce-new-field-managed_pages-to-struct-zone-fix
+++ a/include/linux/mmzone.h
@@ -451,7 +451,7 @@ struct zone {
 
 	/*
 	 * spanned_pages is the total pages spanned by the zone, including
-	 * holes, which is calcualted as:
+	 * holes, which is calculated as:
 	 * 	spanned_pages = zone_end_pfn - zone_start_pfn;
 	 *
 	 * present_pages is physical pages existing within the zone, which
@@ -469,9 +469,9 @@ struct zone {
 	 * by page allocator and vm scanner to calculate all kinds of watermarks
 	 * and thresholds.
 	 *
-	 * Lock Rules:
+	 * Locking rules:
 	 *
-	 * zone_start_pfn, spanned_pages are protected by span_seqlock.
+	 * zone_start_pfn and spanned_pages are protected by span_seqlock.
 	 * It is a seqlock because it has to be read outside of zone->lock,
 	 * and it is done in the main allocator path.  But, it is written
 	 * quite infrequently.
@@ -480,7 +480,7 @@ struct zone {
 	 * frequently read in proximity to zone->lock.  It's good to
 	 * give them a chance of being in the same cacheline.
 	 *
-	 * Writing access to present_pages and managed_pages at runtime should
+	 * Write access to present_pages and managed_pages at runtime should
 	 * be protected by lock_memory_hotplug()/unlock_memory_hotplug().
 	 * Any reader who can't tolerant drift of present_pages and
 	 * managed_pages should hold memory hotplug lock to get a stable value.
diff -puN mm/page_alloc.c~mm-introduce-new-field-managed_pages-to-struct-zone-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-new-field-managed_pages-to-struct-zone-fix
+++ a/mm/page_alloc.c
@@ -738,7 +738,7 @@ static void __free_pages_ok(struct page 
  * Read access to zone->managed_pages is safe because it's unsigned long,
  * but we still need to serialize writers. Currently all callers of
  * __free_pages_bootmem() except put_page_bootmem() should only be used
- * at boot time. So for shorter boot time, we have shift the burden to
+ * at boot time. So for shorter boot time, we shift the burden to
  * put_page_bootmem() to serialize writers.
  */
 void __meminit __free_pages_bootmem(struct page *page, unsigned int order)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
tmpfs-support-seek_data-and-seek_hole-reprise.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix-fix.patch
mm-memoryc-remove-unused-code-from-do_wp_page-fix.patch

