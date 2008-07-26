From: akpm@linux-foundation.org
Subject: - bootmem-move-node-allocation-macros-back-to-have_arch_bootmem_node.patch removed from -mm tree
Date: Fri, 25 Jul 2008 19:12:42 -0700
Message-ID: <200807260212.m6Q2CgD2010828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbYGZCM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 22:12:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     bootmem: Move node allocation macros back to !HAVE_ARCH_BOOTMEM_NODE
has been removed from the -mm tree.  Its filename was
     bootmem-move-node-allocation-macros-back-to-have_arch_bootmem_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: Move node allocation macros back to !HAVE_ARCH_BOOTMEM_NODE
From: Johannes Weiner <hannes@saeurebad.de>

These got unintentionally moved, put them back as x86 provides its own
versions.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN include/linux/bootmem.h~bootmem-move-node-allocation-macros-back-to-have_arch_bootmem_node include/linux/bootmem.h
--- a/include/linux/bootmem.h~bootmem-move-node-allocation-macros-back-to-have_arch_bootmem_node
+++ a/include/linux/bootmem.h
@@ -103,17 +103,16 @@ extern void *__alloc_bootmem_low_node(pg
 	__alloc_bootmem(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low_pages(x) \
 	__alloc_bootmem_low(x, PAGE_SIZE, 0)
-#endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
-
-extern int reserve_bootmem_generic(unsigned long addr, unsigned long size,
-				   int flags);
-
 #define alloc_bootmem_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low_pages_node(pgdat, x) \
 	__alloc_bootmem_low_node(pgdat, x, PAGE_SIZE, 0)
+#endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
+
+extern int reserve_bootmem_generic(unsigned long addr, unsigned long size,
+				   int flags);
 
 extern void *alloc_bootmem_section(unsigned long size,
 				   unsigned long section_nr);
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
alpha-use-generic-show_mem.patch
avr32-use-generic-show_mem.patch
blackfin-use-generic-show_mem.patch
xtensa-use-generic-show_mem.patch
x86-use-generic-show_mem.patch
um-use-generic-show_mem.patch
sparc64-use-generic-show_mem.patch
sh-use-generic-show_mem.patch
s390-use-generic-show_mem.patch
powerpc-use-generic-show_mem.patch
mn10300-use-generic-show_mem.patch
h8300-use-generic-show_mem.patch
mips-use-generic-show_mem.patch
m68knommu-use-generic-show_mem.patch
m68k-use-generic-show_mem.patch
m32r-use-generic-show_mem.patch
frv-use-generic-show_mem.patch
cris-use-generic-show_mem.patch
linux-next.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch

