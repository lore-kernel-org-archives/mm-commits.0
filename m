From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 =?US-ASCII?Q?drivers-base-memoryc-cache-memory-blocks-in-xarray-to-acc?=
 =?US-ASCII?Q?elerate-lookup-fix.patch?= removed from -mm tree
Date: Wed, 03 Jun 2020 15:23:40 -0700
Message-ID: <20200603222340.4W4PyiIAz%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbgFCWXl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:23:41 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cheloha@linux.ibm.com, david@redhat.com, gregkh@linuxfoundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, nathanl@linux.ibm.com, rafael@kernel.org, ricklind@linux.vnet.ibm.com


The patch titled
     Subject: drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix
has been removed from the -mm tree.  Its filename was
     drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch

This patch was dropped because it was folded into drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix

document the locking

Link: http://lkml.kernel.org/r/bc21eec6-7251-4c91-2f57-9a0671f8d414@redhat.com
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rick Lindsley <ricklind@linux.vnet.ibm.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/base/memory.c~drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix
+++ a/drivers/base/memory.c
@@ -497,7 +497,11 @@ int __weak arch_get_memory_phys_device(u
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
@@ -508,6 +512,9 @@ static struct memory_block *find_memory_
 	return mem;
 }
 
+/*
+ * Called under device_hotplug_lock.
+ */
 struct memory_block *find_memory_block(struct mem_section *section)
 {
 	unsigned long block_id = base_memory_block_id(__section_nr(section));
@@ -761,6 +768,8 @@ void __init memory_dev_init(void)
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

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup.patch
powerpc-pseries-hotplug-memory-stop-checking-is_mem_section_removable.patch
mm-memory_hotplug-remove-is_mem_section_removable.patch
mm-memory_hotplug-set-node_start_pfn-of-hotadded-pgdat-to-0.patch
mm-memory_hotplug-handle-memblocks-only-with-config_arch_keep_memblock.patch
mm-memory_hotplug-introduce-add_memory_driver_managed.patch
kexec_file-dont-place-kexec-images-on-ioresource_mem_driver_managed.patch
device-dax-add-memory-via-add_memory_driver_managed.patch
