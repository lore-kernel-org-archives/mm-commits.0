From: akpm@linux-foundation.org
Subject: + x86-mm-probe-memory-block-size-for-generic-x86-64bit.patch
 added to -mm tree
Date: Mon, 21 Apr 2014 13:19:12 -0700
Message-ID: <53557d40.dT8TZvt5D9WYh1Dm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaDUUTN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 16:19:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, yinghai@kernel.org

Subject: + x86-mm-probe-memory-block-size-for-generic-x86-64bit.patch added to -mm tree
To: yinghai@kernel.org,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 13:19:12 -0700


The patch titled
     Subject: x86, mm: probe memory block size for generic x86 64bit
has been added to the -mm tree.  Its filename is
     x86-mm-probe-memory-block-size-for-generic-x86-64bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-probe-memory-block-size-for-generic-x86-64bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-probe-memory-block-size-for-generic-x86-64bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: x86, mm: probe memory block size for generic x86 64bit

On system with 2TiB ram, current x86_64 have 128M as section size, and one
memory_block only include one section.  So will have 16400 entries under
/sys/devices/system/memory/.

Current code try to use block id to find block pointer in /sys
for any section, and reuse that block pointer. that finding will take some time
even after

| commit 7c243c7168dcc1bc2081fc0494923cd7cc808fb6
| Author: Russ Anderson <rja@sgi.com>
| Date:   Mon Apr 29 15:07:59 2013 -0700
|    mm: speedup in __early_pfn_to_nid

that will skip the search in that case during booting up.

So solution could be increase block size just like SGI UV system did. 
(harded code to 2g).

This patch is trying to probe the block size to make it match mmio remap
size.  for example, Intel Nehalem later system will have memory range [0,
TOML), [4g, TOMH].  If the memory hole is 2g and total is 128g, TOM will
be 2g, and TOM2 will be 130g.

We could use 2g as block size instead of default 128M.  That will reduce
number of entries in /sys/devices/system/memory/

On system 6TiB system will reduce boot time by 35 seconds.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/init_64.c~x86-mm-probe-memory-block-size-for-generic-x86-64bit arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-mm-probe-memory-block-size-for-generic-x86-64bit
+++ a/arch/x86/mm/init_64.c
@@ -1230,17 +1230,43 @@ const char *arch_vma_name(struct vm_area
 	return NULL;
 }
 
-#ifdef CONFIG_X86_UV
-unsigned long memory_block_size_bytes(void)
+static unsigned long probe_memory_block_size(void)
 {
+	/* start from 2g */
+	unsigned long bz = 1UL<<31;
+
+#ifdef CONFIG_X86_UV
 	if (is_uv_system()) {
 		printk(KERN_INFO "UV: memory block size 2GB\n");
 		return 2UL * 1024 * 1024 * 1024;
 	}
-	return MIN_MEMORY_BLOCK_SIZE;
-}
 #endif
 
+	/* less than 64g installed */
+	if ((max_pfn << PAGE_SHIFT) < (16UL << 32))
+		return MIN_MEMORY_BLOCK_SIZE;
+
+	/* get the tail size */
+	while (bz > MIN_MEMORY_BLOCK_SIZE) {
+		if (!((max_pfn << PAGE_SHIFT) & (bz - 1)))
+			break;
+		bz >>= 1;
+	}
+
+	printk(KERN_DEBUG "memory block size : %ldMB\n", bz >> 20);
+
+	return bz;
+}
+
+static unsigned long memory_block_size_probed;
+unsigned long memory_block_size_bytes(void)
+{
+	if (!memory_block_size_probed)
+		memory_block_size_probed = probe_memory_block_size();
+
+	return memory_block_size_probed;
+}
+
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 /*
  * Initialise the sparsemem vmemmap using huge-pages at the PMD level.
_

Patches currently in -mm which might be from yinghai@kernel.org are

x86-mm-probe-memory-block-size-for-generic-x86-64bit.patch
x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch
x86-enable-dma-cma-with-swiotlb.patch
intel-iommu-integrate-dma-cma.patch
memblock-introduce-memblock_alloc_range.patch
cma-add-placement-specifier-for-cma=-kernel-parameter.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch

