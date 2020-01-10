From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerat?=
 =?US-ASCII?Q?e-lookup-fix-2.patch?= added to -mm tree
Date: Fri, 10 Jan 2020 13:14:14 -0800
Message-ID: <20200110211414.R3DcTenHh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbgAJVOQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jan 2020 16:14:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cheloha@linux.ibm.com, david@redhat.com, gregkh@linuxfoundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, nathanl@linux.ibm.com, rafael@kernel.org, ricklind@linux.vnet.ibm.com


The patch titled
     Link: http://lkml.kernel.org/r/bc21eec6-7251-4c91-2f57-9a0671f8d414@redhat.com
has been added to the -mm tree.  Its filename is
     drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix-2.patch

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
Link: http://lkml.kernel.org/r/bc21eec6-7251-4c91-2f57-9a0671f8d414@redhat.com

document the locking

Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Rick Lindsley <ricklind@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/base/memory.c~drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix-2
+++ a/drivers/base/memory.c
@@ -577,7 +577,11 @@ int __weak arch_get_memory_phys_device(u
 	return 0;
 }
 
-/* A reference for the returned memory block device is acquired. */
+/*
+ * A reference for the returned memory block device is acquired.
+ *
+ * Called under device_hotplug_lock.
+ */
 static struct memory_block *find_memory_block_by_id(unsigned long block_id)
 {
 	struct memory_block *mem;
@@ -588,6 +592,9 @@ static struct memory_block *find_memory_
 	return mem;
 }
 
+/*
+ * Called under device_hotplug_lock.
+ */
 struct memory_block *find_memory_block(struct mem_section *section)
 {
 	unsigned long block_id = base_memory_block_id(__section_nr(section));
@@ -847,6 +854,8 @@ void __init memory_dev_init(void)
  *
  * In case func() returns an error, walking is aborted and the error is
  * returned.
+ *
+ * Called under device_hotplug_lock.
  */
 int walk_memory_blocks(unsigned long start, unsigned long size,
 		       void *arg, walk_memory_blocks_func_t func)
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
