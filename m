From: akpm@linux-foundation.org
Subject: + mm-remove-the-memory-isolate-notifier.patch added to -mm
 tree
Date: Mon, 13 Jan 2020 14:05:22 -0800
Message-ID: <20200113220522.uUmmS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728746AbgAMWFY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 17:05:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rafael@kernel.org, pasha.tatashin@soleen.com, osalvador@suse.de, mpe@ellerman.id.au, mhocko@suse.com, kernelfans@gmail.com, gregkh@linuxfoundation.org, dan.j.williams@intel.com, cai@lca.pw, anshuman.khandual@arm.com, david@redhat.com


The patch titled
     Subject: mm: remove the memory isolate notifier
has been added to the -mm tree.  Its filename is
     mm-remove-the-memory-isolate-notifier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-the-memory-isolate-notifier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-the-memory-isolate-notifier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: remove the memory isolate notifier

Luckily, we have no users left, so we can get rid of it.  Cleanup
set_migratetype_isolate() a little bit.

Link: http://lkml.kernel.org/r/20191114131911.11783-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qian Cai <cai@lca.pw>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |   19 -------------------
 include/linux/memory.h |   27 ---------------------------
 mm/page_isolation.c    |   38 ++++----------------------------------
 3 files changed, 4 insertions(+), 80 deletions(-)

--- a/drivers/base/memory.c~mm-remove-the-memory-isolate-notifier
+++ a/drivers/base/memory.c
@@ -78,20 +78,6 @@ void unregister_memory_notifier(struct n
 }
 EXPORT_SYMBOL(unregister_memory_notifier);
 
-static ATOMIC_NOTIFIER_HEAD(memory_isolate_chain);
-
-int register_memory_isolate_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&memory_isolate_chain, nb);
-}
-EXPORT_SYMBOL(register_memory_isolate_notifier);
-
-void unregister_memory_isolate_notifier(struct notifier_block *nb)
-{
-	atomic_notifier_chain_unregister(&memory_isolate_chain, nb);
-}
-EXPORT_SYMBOL(unregister_memory_isolate_notifier);
-
 static void memory_block_release(struct device *dev)
 {
 	struct memory_block *mem = to_memory_block(dev);
@@ -183,11 +169,6 @@ int memory_notify(unsigned long val, voi
 	return blocking_notifier_call_chain(&memory_chain, val, v);
 }
 
-int memory_isolate_notify(unsigned long val, void *v)
-{
-	return atomic_notifier_call_chain(&memory_isolate_chain, val, v);
-}
-
 /*
  * The probe routines leave the pages uninitialized, just as the bootmem code
  * does. Make sure we do not access them, but instead use only information from
--- a/include/linux/memory.h~mm-remove-the-memory-isolate-notifier
+++ a/include/linux/memory.h
@@ -55,19 +55,6 @@ struct memory_notify {
 	int status_change_nid;
 };
 
-/*
- * During pageblock isolation, count the number of pages within the
- * range [start_pfn, start_pfn + nr_pages) which are owned by code
- * in the notifier chain.
- */
-#define MEM_ISOLATE_COUNT	(1<<0)
-
-struct memory_isolate_notify {
-	unsigned long start_pfn;	/* Start of range to check */
-	unsigned int nr_pages;		/* # pages in range to check */
-	unsigned int pages_found;	/* # pages owned found by callbacks */
-};
-
 struct notifier_block;
 struct mem_section;
 
@@ -94,27 +81,13 @@ static inline int memory_notify(unsigned
 {
 	return 0;
 }
-static inline int register_memory_isolate_notifier(struct notifier_block *nb)
-{
-	return 0;
-}
-static inline void unregister_memory_isolate_notifier(struct notifier_block *nb)
-{
-}
-static inline int memory_isolate_notify(unsigned long val, void *v)
-{
-	return 0;
-}
 #else
 extern int register_memory_notifier(struct notifier_block *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
-extern int register_memory_isolate_notifier(struct notifier_block *nb);
-extern void unregister_memory_isolate_notifier(struct notifier_block *nb);
 int create_memory_block_devices(unsigned long start, unsigned long size);
 void remove_memory_block_devices(unsigned long start, unsigned long size);
 extern void memory_dev_init(void);
 extern int memory_notify(unsigned long val, void *v);
-extern int memory_isolate_notify(unsigned long val, void *v);
 extern struct memory_block *find_memory_block(struct mem_section *);
 typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void *);
 extern int walk_memory_blocks(unsigned long start, unsigned long size,
--- a/mm/page_isolation.c~mm-remove-the-memory-isolate-notifier
+++ a/mm/page_isolation.c
@@ -18,9 +18,7 @@
 static int set_migratetype_isolate(struct page *page, int migratetype, int isol_flags)
 {
 	struct zone *zone;
-	unsigned long flags, pfn;
-	struct memory_isolate_notify arg;
-	int notifier_ret;
+	unsigned long flags;
 	int ret = -EBUSY;
 
 	zone = page_zone(page);
@@ -35,41 +33,11 @@ static int set_migratetype_isolate(struc
 	if (is_migrate_isolate_page(page))
 		goto out;
 
-	pfn = page_to_pfn(page);
-	arg.start_pfn = pfn;
-	arg.nr_pages = pageblock_nr_pages;
-	arg.pages_found = 0;
-
-	/*
-	 * It may be possible to isolate a pageblock even if the
-	 * migratetype is not MIGRATE_MOVABLE. The memory isolation
-	 * notifier chain is used by balloon drivers to return the
-	 * number of pages in a range that are held by the balloon
-	 * driver to shrink memory. If all the pages are accounted for
-	 * by balloons, are free, or on the LRU, isolation can continue.
-	 * Later, for example, when memory hotplug notifier runs, these
-	 * pages reported as "can be isolated" should be isolated(freed)
-	 * by the balloon driver through the memory notifier chain.
-	 */
-	notifier_ret = memory_isolate_notify(MEM_ISOLATE_COUNT, &arg);
-	notifier_ret = notifier_to_errno(notifier_ret);
-	if (notifier_ret)
-		goto out;
 	/*
 	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
 	 * We just check MOVABLE pages.
 	 */
-	if (!has_unmovable_pages(zone, page, arg.pages_found, migratetype,
-				 isol_flags))
-		ret = 0;
-
-	/*
-	 * immobile means "not-on-lru" pages. If immobile is larger than
-	 * removable-by-driver pages reported by notifier, we'll fail.
-	 */
-
-out:
-	if (!ret) {
+	if (!has_unmovable_pages(zone, page, 0, migratetype, isol_flags)) {
 		unsigned long nr_pages;
 		int mt = get_pageblock_migratetype(page);
 
@@ -79,8 +47,10 @@ out:
 									NULL);
 
 		__mod_zone_freepage_state(zone, -nr_pages, mt);
+		ret = 0;
 	}
 
+out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 	if (!ret)
 		drain_all_pages(zone);
_

Patches currently in -mm which might be from david@redhat.com are

mm-fix-uninitialized-memmaps-on-a-partially-populated-last-section.patch
fs-proc-pagec-allow-inspection-of-last-section-and-fix-end-detection.patch
mm-initialize-memmap-of-unavailable-memory-directly.patch
mm-memory_hotplug-dont-free-usage-map-when-removing-a-re-added-early-section.patch
drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix-2.patch
mm-memory_hotplug-poison-memmap-in-remove_pfn_range_from_zone.patch
mm-memory_hotplug-we-always-have-a-zone-in-find_smallestbiggest_section_pfn.patch
mm-memory_hotplug-dont-check-for-all-holes-in-shrink_zone_span.patch
mm-memory_hotplug-drop-local-variables-in-shrink_zone_span.patch
mm-memory_hotplug-cleanup-__remove_pages.patch
mm-memory_hotplug-drop-valid_start-valid_end-from-test_pages_in_a_zone.patch
mm-page_alloc-fix-and-rework-pfn-handling-in-memmap_init_zone.patch
mm-factor-out-next_present_section_nr.patch
mm-remove-the-memory-isolate-notifier.patch
mm-remove-count-parameter-from-has_unmovable_pages.patch
