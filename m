From: akpm@linux-foundation.org
Subject: [merged]
 x86-mm-probe-memory-block-size-for-generic-x86-64bit.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:43:10 -0700
Message-ID: <5390c84e.fQDaV6XgzZ9TrwH/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFETnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:43:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, yinghai@kernel.org

Subject: [merged] x86-mm-probe-memory-block-size-for-generic-x86-64bit.patch removed from -mm tree
To: yinghai@kernel.org,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:43:10 -0700


The patch titled
     Subject: x86, mm: probe memory block size for generic x86 64bit
has been removed from the -mm tree.  Its filename was
     x86-mm-probe-memory-block-size-for-generic-x86-64bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

