From: akpm@linux-foundation.org
Subject: [merged]
 memory-hotplug-update-documentation-to-hide-information-about-sections-and-remove-end_phys_index.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:49:27 -0700
Message-ID: <5390c9c7.dvH7FmmWwhvbZuqa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaFETt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, zhong@linux.vnet.ibm.com

Subject: [merged] memory-hotplug-update-documentation-to-hide-information-about-sections-and-remove-end_phys_index.patch removed from -mm tree
To: zhong@linux.vnet.ibm.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:27 -0700


The patch titled
     Subject: memory-hotplug: update documentation to hide information about SECTIONS and remove end_phys_index
has been removed from the -mm tree.  Its filename was
     memory-hotplug-update-documentation-to-hide-information-about-sections-and-remove-end_phys_index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zhong <zhong@linux.vnet.ibm.com>
Subject: memory-hotplug: update documentation to hide information about SECTIONS and remove end_phys_index

Seems we all agree that information about SECTION, e.g.  section size,
sections per memory block should be kept as kernel internals, and not
exposed to userspace.

This patch updates Documentation/memory-hotplug.txt to refer to memory
blocks instead of memory sections where appropriate and added a paragraph
to explain that memory blocks are made of memory sections.  The
documentation update is mostly provided by Nathan.

Also, as end_phys_index in code is actually not the end section id, but
the end memory block id, which should always be the same as phys_index. 
So it is removed here.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-hotplug.txt |  125 ++++++++++++++---------------
 drivers/base/memory.c            |   12 --
 2 files changed, 61 insertions(+), 76 deletions(-)

diff -puN Documentation/memory-hotplug.txt~memory-hotplug-update-documentation-to-hide-information-about-sections-and-remove-end_phys_index Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~memory-hotplug-update-documentation-to-hide-information-about-sections-and-remove-end_phys_index
+++ a/Documentation/memory-hotplug.txt
@@ -88,16 +88,21 @@ phase by hand.
 
 1.3. Unit of Memory online/offline operation
 ------------
-Memory hotplug uses SPARSEMEM memory model. SPARSEMEM divides the whole memory
-into chunks of the same size. The chunk is called a "section". The size of
-a section is architecture dependent. For example, power uses 16MiB, ia64 uses
-1GiB. The unit of online/offline operation is "one section". (see Section 3.)
+Memory hotplug uses SPARSEMEM memory model which allows memory to be divided
+into chunks of the same size. These chunks are called "sections". The size of
+a memory section is architecture dependent. For example, power uses 16MiB, ia64
+uses 1GiB.
+
+Memory sections are combined into chunks referred to as "memory blocks". The
+size of a memory block is architecture dependent and represents the logical
+unit upon which memory online/offline operations are to be performed. The
+default size of a memory block is the same as memory section size unless an
+architecture specifies otherwise. (see Section 3.)
 
-To determine the size of sections, please read this file:
+To determine the size (in bytes) of a memory block please read this file:
 
 /sys/devices/system/memory/block_size_bytes
 
-This file shows the size of sections in byte.
 
 -----------------------
 2. Kernel Configuration
@@ -123,42 +128,35 @@ config options.
     (CONFIG_ACPI_CONTAINER).
     This option can be kernel module too.
 
+
 --------------------------------
-4 sysfs files for memory hotplug
+3 sysfs files for memory hotplug
 --------------------------------
-All sections have their device information in sysfs.  Each section is part of
-a memory block under /sys/devices/system/memory as
+All memory blocks have their device information in sysfs.  Each memory block
+is described under /sys/devices/system/memory as
 
 /sys/devices/system/memory/memoryXXX
-(XXX is the section id.)
+(XXX is the memory block id.)
 
-Now, XXX is defined as (start_address_of_section / section_size) of the first
-section contained in the memory block.  The files 'phys_index' and
-'end_phys_index' under each directory report the beginning and end section id's
-for the memory block covered by the sysfs directory.  It is expected that all
+For the memory block covered by the sysfs directory.  It is expected that all
 memory sections in this range are present and no memory holes exist in the
 range. Currently there is no way to determine if there is a memory hole, but
 the existence of one should not affect the hotplug capabilities of the memory
 block.
 
-For example, assume 1GiB section size. A device for a memory starting at
+For example, assume 1GiB memory block size. A device for a memory starting at
 0x100000000 is /sys/device/system/memory/memory4
 (0x100000000 / 1Gib = 4)
 This device covers address range [0x100000000 ... 0x140000000)
 
-Under each section, you can see 4 or 5 files, the end_phys_index file being
-a recent addition and not present on older kernels.
+Under each memory block, you can see 4 files:
 
-/sys/devices/system/memory/memoryXXX/start_phys_index
-/sys/devices/system/memory/memoryXXX/end_phys_index
+/sys/devices/system/memory/memoryXXX/phys_index
 /sys/devices/system/memory/memoryXXX/phys_device
 /sys/devices/system/memory/memoryXXX/state
 /sys/devices/system/memory/memoryXXX/removable
 
-'phys_index'      : read-only and contains section id of the first section
-		    in the memory block, same as XXX.
-'end_phys_index'  : read-only and contains section id of the last section
-		    in the memory block.
+'phys_index'      : read-only and contains memory block id, same as XXX.
 'state'           : read-write
                     at read:  contains online/offline state of memory.
                     at write: user can specify "online_kernel",
@@ -185,6 +183,7 @@ For example:
 A backlink will also be created:
 /sys/devices/system/memory/memory9/node0 -> ../../node/node0
 
+
 --------------------------------
 4. Physical memory hot-add phase
 --------------------------------
@@ -227,11 +226,10 @@ You can tell the physical address of new
 
 % echo start_address_of_new_memory > /sys/devices/system/memory/probe
 
-Then, [start_address_of_new_memory, start_address_of_new_memory + section_size)
-memory range is hot-added. In this case, hotplug script is not called (in
-current implementation). You'll have to online memory by yourself.
-Please see "How to online memory" in this text.
-
+Then, [start_address_of_new_memory, start_address_of_new_memory +
+memory_block_size] memory range is hot-added. In this case, hotplug script is
+not called (in current implementation). You'll have to online memory by
+yourself.  Please see "How to online memory" in this text.
 
 
 ------------------------------
@@ -240,36 +238,36 @@ Please see "How to online memory" in thi
 
 5.1. State of memory
 ------------
-To see (online/offline) state of memory section, read 'state' file.
+To see (online/offline) state of a memory block, read 'state' file.
 
 % cat /sys/device/system/memory/memoryXXX/state
 
 
-If the memory section is online, you'll read "online".
-If the memory section is offline, you'll read "offline".
+If the memory block is online, you'll read "online".
+If the memory block is offline, you'll read "offline".
 
 
 5.2. How to online memory
 ------------
 Even if the memory is hot-added, it is not at ready-to-use state.
-For using newly added memory, you have to "online" the memory section.
+For using newly added memory, you have to "online" the memory block.
 
-For onlining, you have to write "online" to the section's state file as:
+For onlining, you have to write "online" to the memory block's state file as:
 
 % echo online > /sys/devices/system/memory/memoryXXX/state
 
-This onlining will not change the ZONE type of the target memory section,
-If the memory section is in ZONE_NORMAL, you can change it to ZONE_MOVABLE:
+This onlining will not change the ZONE type of the target memory block,
+If the memory block is in ZONE_NORMAL, you can change it to ZONE_MOVABLE:
 
 % echo online_movable > /sys/devices/system/memory/memoryXXX/state
-(NOTE: current limit: this memory section must be adjacent to ZONE_MOVABLE)
+(NOTE: current limit: this memory block must be adjacent to ZONE_MOVABLE)
 
-And if the memory section is in ZONE_MOVABLE, you can change it to ZONE_NORMAL:
+And if the memory block is in ZONE_MOVABLE, you can change it to ZONE_NORMAL:
 
 % echo online_kernel > /sys/devices/system/memory/memoryXXX/state
-(NOTE: current limit: this memory section must be adjacent to ZONE_NORMAL)
+(NOTE: current limit: this memory block must be adjacent to ZONE_NORMAL)
 
-After this, section memoryXXX's state will be 'online' and the amount of
+After this, memory block XXX's state will be 'online' and the amount of
 available memory will be increased.
 
 Currently, newly added memory is added as ZONE_NORMAL (for powerpc, ZONE_DMA).
@@ -284,22 +282,22 @@ This may be changed in future.
 6.1 Memory offline and ZONE_MOVABLE
 ------------
 Memory offlining is more complicated than memory online. Because memory offline
-has to make the whole memory section be unused, memory offline can fail if
-the section includes memory which cannot be freed.
+has to make the whole memory block be unused, memory offline can fail if
+the memory block includes memory which cannot be freed.
 
 In general, memory offline can use 2 techniques.
 
-(1) reclaim and free all memory in the section.
-(2) migrate all pages in the section.
+(1) reclaim and free all memory in the memory block.
+(2) migrate all pages in the memory block.
 
 In the current implementation, Linux's memory offline uses method (2), freeing
-all  pages in the section by page migration. But not all pages are
+all  pages in the memory block by page migration. But not all pages are
 migratable. Under current Linux, migratable pages are anonymous pages and
-page caches. For offlining a section by migration, the kernel has to guarantee
-that the section contains only migratable pages.
+page caches. For offlining a memory block by migration, the kernel has to
+guarantee that the memory block contains only migratable pages.
 
-Now, a boot option for making a section which consists of migratable pages is
-supported. By specifying "kernelcore=" or "movablecore=" boot option, you can
+Now, a boot option for making a memory block which consists of migratable pages
+is supported. By specifying "kernelcore=" or "movablecore=" boot option, you can
 create ZONE_MOVABLE...a zone which is just used for movable pages.
 (See also Documentation/kernel-parameters.txt)
 
@@ -315,28 +313,27 @@ creates ZONE_MOVABLE as following.
   Size of memory for movable pages (for offline) is ZZZZ.
 
 
-Note) Unfortunately, there is no information to show which section belongs
+Note: Unfortunately, there is no information to show which memory block belongs
 to ZONE_MOVABLE. This is TBD.
 
 
 6.2. How to offline memory
 ------------
-You can offline a section by using the same sysfs interface that was used in
-memory onlining.
+You can offline a memory block by using the same sysfs interface that was used
+in memory onlining.
 
 % echo offline > /sys/devices/system/memory/memoryXXX/state
 
-If offline succeeds, the state of the memory section is changed to be "offline".
+If offline succeeds, the state of the memory block is changed to be "offline".
 If it fails, some error core (like -EBUSY) will be returned by the kernel.
-Even if a section does not belong to ZONE_MOVABLE, you can try to offline it.
-If it doesn't contain 'unmovable' memory, you'll get success.
+Even if a memory block does not belong to ZONE_MOVABLE, you can try to offline
+it.  If it doesn't contain 'unmovable' memory, you'll get success.
 
-A section under ZONE_MOVABLE is considered to be able to be offlined easily.
-But under some busy state, it may return -EBUSY. Even if a memory section
-cannot be offlined due to -EBUSY, you can retry offlining it and may be able to
-offline it (or not).
-(For example, a page is referred to by some kernel internal call and released
- soon.)
+A memory block under ZONE_MOVABLE is considered to be able to be offlined
+easily.  But under some busy state, it may return -EBUSY. Even if a memory
+block cannot be offlined due to -EBUSY, you can retry offlining it and may be
+able to offline it (or not). (For example, a page is referred to by some kernel
+internal call and released soon.)
 
 Consideration:
 Memory hotplug's design direction is to make the possibility of memory offlining
@@ -373,11 +370,11 @@ MEMORY_GOING_OFFLINE
   Generated to begin the process of offlining memory. Allocations are no
   longer possible from the memory but some of the memory to be offlined
   is still in use. The callback can be used to free memory known to a
-  subsystem from the indicated memory section.
+  subsystem from the indicated memory block.
 
 MEMORY_CANCEL_OFFLINE
   Generated if MEMORY_GOING_OFFLINE fails. Memory is available again from
-  the section that we attempted to offline.
+  the memory block that we attempted to offline.
 
 MEMORY_OFFLINE
   Generated after offlining memory is complete.
@@ -413,8 +410,8 @@ node if necessary.
 --------------
   - allowing memory hot-add to ZONE_MOVABLE. maybe we need some switch like
     sysctl or new control file.
-  - showing memory section and physical device relationship.
-  - showing memory section is under ZONE_MOVABLE or not
+  - showing memory block and physical device relationship.
+  - showing memory block is under ZONE_MOVABLE or not
   - test and make it better memory offlining.
   - support HugeTLB page migration and offlining.
   - memmap removing at memory offline.
diff -puN drivers/base/memory.c~memory-hotplug-update-documentation-to-hide-information-about-sections-and-remove-end_phys_index drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-update-documentation-to-hide-information-about-sections-and-remove-end_phys_index
+++ a/drivers/base/memory.c
@@ -118,16 +118,6 @@ static ssize_t show_mem_start_phys_index
 	return sprintf(buf, "%08lx\n", phys_index);
 }
 
-static ssize_t show_mem_end_phys_index(struct device *dev,
-			struct device_attribute *attr, char *buf)
-{
-	struct memory_block *mem = to_memory_block(dev);
-	unsigned long phys_index;
-
-	phys_index = mem->end_section_nr / sections_per_block;
-	return sprintf(buf, "%08lx\n", phys_index);
-}
-
 /*
  * Show whether the section of memory is likely to be hot-removable
  */
@@ -384,7 +374,6 @@ static ssize_t show_phys_device(struct d
 }
 
 static DEVICE_ATTR(phys_index, 0444, show_mem_start_phys_index, NULL);
-static DEVICE_ATTR(end_phys_index, 0444, show_mem_end_phys_index, NULL);
 static DEVICE_ATTR(state, 0644, show_mem_state, store_mem_state);
 static DEVICE_ATTR(phys_device, 0444, show_phys_device, NULL);
 static DEVICE_ATTR(removable, 0444, show_mem_removable, NULL);
@@ -529,7 +518,6 @@ struct memory_block *find_memory_block(s
 
 static struct attribute *memory_memblk_attrs[] = {
 	&dev_attr_phys_index.attr,
-	&dev_attr_end_phys_index.attr,
 	&dev_attr_state.attr,
 	&dev_attr_phys_device.attr,
 	&dev_attr_removable.attr,
_

Patches currently in -mm which might be from zhong@linux.vnet.ibm.com are

origin.patch
linux-next.patch

