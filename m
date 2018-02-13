From: akpm@linux-foundation.org
Subject: +
 x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory.patch added to -mm tree
Date: Tue, 13 Feb 2018 13:50:05 -0800
Message-ID: <5a835d8d.e5DlCCSopQDdjgDP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59196 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965907AbeBMVuH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Feb 2018 16:50:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, bharata@linux.vnet.ibm.com, bhe@redhat.com, daniel.m.jordan@oracle.com, dan.j.williams@intel.com, gregkh@linuxfoundation.org, hpa@zytor.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, mingo@elte.hu, steven.sistare@oracle.com, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/mm/memory_hotplug: determine block size based on the end of boot memory
has been added to the -mm tree.  Its filename is
     x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: x86/mm/memory_hotplug: determine block size based on the end of boot memory

Memory sections are combined into "memory block" chunks.  These chunks are
the units upon which memory can be added and removed.

On x86, the new memory may be added after the end of the boot memory,
therefore, if block size does not align with end of boot memory, memory
hot-plugging/hot-removing can be broken.

Currently, whenever machine is boot with more than 64G the block size
unconditionally increased to 2G from the base 128M in order to reduce
number of memory devices in sysfs:
	/sys/devices/system/memory/memoryXXX

But, we must use the largest allowed block size that aligns to the next
address to be able to hotplug the next block of memory.

So, when memory is larger than 64G, we check the end address and find the
largest block size that is still power of two but smaller or equal to 2G.

Before, the fix:
Run qemu with:
-m 64G,slots=2,maxmem=66G -object memory-backend-ram,id=mem1,size=2G

(qemu) device_add pc-dimm,id=dimm1,memdev=mem1
Block size [0x80000000] unaligned hotplug range: start 0x1040000000,
							size 0x80000000
acpi PNP0C80:00: add_memory failed
acpi PNP0C80:00: acpi_memory_enable_device() error
acpi PNP0C80:00: Enumeration failure

With the fix memory is added successfully, as the block size is set to 1G,
and therefore aligns with start address 0x1040000000.

Link: http://lkml.kernel.org/r/20180213193159.14606-3-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/init_64.c~x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory
+++ a/arch/x86/mm/init_64.c
@@ -1326,14 +1326,39 @@ int kern_addr_valid(unsigned long addr)
 	return pfn_valid(pte_pfn(*pte));
 }
 
+/*
+ * Block size is the minimum quantum of memory which can be hot-plugged or
+ * hot-removed. It must be power of two, and must be equal or larger than
+ * MIN_MEMORY_BLOCK_SIZE.
+ */
+#define MAX_BLOCK_SIZE (2UL << 30)
+
+/* Amount of ram needed to start using large blocks */
+#define MEM_SIZE_FOR_LARGE_BLOCK (64UL << 30)
+
 static unsigned long probe_memory_block_size(void)
 {
-	unsigned long bz = MIN_MEMORY_BLOCK_SIZE;
+	unsigned long boot_mem_end = max_pfn << PAGE_SHIFT;
+	unsigned long bz;
+
+	/* If this is UV system, always set 2G block size */
+	if (is_uv_system()) {
+		bz = MAX_BLOCK_SIZE;
+		goto done;
+	}
 
-	/* if system is UV or has 64GB of RAM or more, use large blocks */
-	if (is_uv_system() || ((max_pfn << PAGE_SHIFT) >= (64UL << 30)))
-		bz = 2UL << 30; /* 2GB */
+	/* Use regular block if RAM is smaller than MEM_SIZE_FOR_LARGE_BLOCK */
+	if (boot_mem_end < MEM_SIZE_FOR_LARGE_BLOCK) {
+		bz = MIN_MEMORY_BLOCK_SIZE;
+		goto done;
+	}
 
+	/* Find the largest allowed block size that aligns to memory end */
+	for (bz = MAX_BLOCK_SIZE; bz > MIN_MEMORY_BLOCK_SIZE; bz >>= 1) {
+		if (IS_ALIGNED(boot_mem_end, bz))
+			break;
+	}
+done:
 	pr_info("x86/mm: Memory block size: %ldMB\n", bz >> 20);
 
 	return bz;
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-initialize-pages-on-demand-during-boot.patch
mm-initialize-pages-on-demand-during-boot-fix2.patch
mm-memory_hotplug-enforce-block-size-aligned-range-check.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory.patch
mm-uninitialized-struct-page-poisoning-sanity-checking.patch
mm-memory_hotplug-optimize-memory-hotplug.patch
sparc64-ng4-memset-32-bits-overflow.patch

