From: akpm@linux-foundation.org
Subject: [withdrawn]
 drivers-base-memoryc-get-rid-of-find_memory_block.patch removed from -mm
 tree
Date: Tue, 14 Jan 2020 16:34:47 -0800
Message-ID: <20200115003447.zes7dNjjO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgAOAet (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 19:34:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pasha.tatashin@soleen.com, rafael@kernel.org


The patch titled
     Subject: drivers/base/memory.c: get rid of find_memory_block()
has been removed from the -mm tree.  Its filename was
     drivers-base-memoryc-get-rid-of-find_memory_block.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory.c: get rid of find_memory_block()

No longer needed, remove it.

Link: http://lkml.kernel.org/r/20200113113354.6341-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |   12 +-----------
 include/linux/memory.h |    1 -
 2 files changed, 1 insertion(+), 12 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memoryc-get-rid-of-find_memory_block
+++ a/drivers/base/memory.c
@@ -591,16 +591,6 @@ static struct memory_block *find_memory_
 	return mem;
 }
 
-/*
- * Called under device_hotplug_lock.
- */
-struct memory_block *find_memory_block(struct mem_section *section)
-{
-	unsigned long block_id = base_memory_block_id(__section_nr(section));
-
-	return find_memory_block_by_id(block_id);
-}
-
 static struct attribute *memory_memblk_attrs[] = {
 	&dev_attr_phys_index.attr,
 	&dev_attr_state.attr,
@@ -704,7 +694,7 @@ static void unregister_memory(struct mem
 
 	WARN_ON(radix_tree_delete(&memory_blocks, memory->dev.id) == NULL);
 
-	/* drop the ref. we got via find_memory_block() */
+	/* drop the ref. we got via find_memory_block_by_id() */
 	put_device(&memory->dev);
 	device_unregister(&memory->dev);
 }
--- a/include/linux/memory.h~drivers-base-memoryc-get-rid-of-find_memory_block
+++ a/include/linux/memory.h
@@ -115,7 +115,6 @@ void remove_memory_block_devices(unsigne
 extern void memory_dev_init(void);
 extern int memory_notify(unsigned long val, void *v);
 extern int memory_isolate_notify(unsigned long val, void *v);
-extern struct memory_block *find_memory_block(struct mem_section *);
 typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void *);
 extern int walk_memory_blocks(unsigned long start, unsigned long size,
 			      void *arg, walk_memory_blocks_func_t func);
_

Patches currently in -mm which might be from david@redhat.com are

mm-fix-uninitialized-memmaps-on-a-partially-populated-last-section.patch
fs-proc-pagec-allow-inspection-of-last-section-and-fix-end-detection.patch
mm-initialize-memmap-of-unavailable-memory-directly.patch
drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix-2.patch
mm-memory_hotplug-poison-memmap-in-remove_pfn_range_from_zone.patch
mm-memory_hotplug-we-always-have-a-zone-in-find_smallestbiggest_section_pfn.patch
mm-memory_hotplug-dont-check-for-all-holes-in-shrink_zone_span.patch
mm-memory_hotplug-drop-local-variables-in-shrink_zone_span.patch
mm-memory_hotplug-cleanup-__remove_pages.patch
mm-memory_hotplug-drop-valid_start-valid_end-from-test_pages_in_a_zone.patch
mm-memory_hotplug-pass-in-nid-to-online_pages.patch
mm-page_alloc-fix-and-rework-pfn-handling-in-memmap_init_zone.patch
mm-factor-out-next_present_section_nr.patch
mm-remove-the-memory-isolate-notifier.patch
mm-remove-count-parameter-from-has_unmovable_pages.patch
