From: akpm@linux-foundation.org
Subject: - slb-drop-kmem-cache-argument-from-constructor-fix.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:59:40 -0700
Message-ID: <200807252359.m6PNxem8006268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbYGZAAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 20:00:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, cl@linux-foundation.org, kniht@linux.vnet.ibm.com, mpm@selenic.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     slb-drop-kmem-cache-argument-from-constructor-fix
has been removed from the -mm tree.  Its filename was
     slb-drop-kmem-cache-argument-from-constructor-fix.patch

This patch was dropped because it was folded into slb-drop-kmem-cache-argument-from-constructor.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slb-drop-kmem-cache-argument-from-constructor-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~slb-drop-kmem-cache-argument-from-constructor-fix arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~slb-drop-kmem-cache-argument-from-constructor-fix
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -113,7 +113,7 @@ static inline pte_t *hugepte_offset(huge
 static int __hugepte_alloc(struct mm_struct *mm, hugepd_t *hpdp,
 			   unsigned long address, unsigned int psize)
 {
-	pte_t *new = kmem_cache_alloc(huge_pgtable_cache(psize),
+	pte_t *new = kmem_cache_zalloc(huge_pgtable_cache(psize),
 				      GFP_KERNEL|__GFP_REPEAT);
 
 	if (! new)
@@ -730,11 +730,6 @@ static int __init hugepage_setup_sz(char
 }
 __setup("hugepagesz=", hugepage_setup_sz);
 
-static void zero_ctor(void *addr)
-{
-	memset(addr, 0, HUGEPTE_TABLE_SIZE);
-}
-
 static int __init hugetlbpage_init(void)
 {
 	unsigned int psize;
@@ -756,7 +751,7 @@ static int __init hugetlbpage_init(void)
 						HUGEPTE_TABLE_SIZE(psize),
 						HUGEPTE_TABLE_SIZE(psize),
 						0,
-						zero_ctor);
+						NULL);
 			if (!huge_pgtable_cache(psize))
 				panic("hugetlbpage_init(): could not create %s"\
 				      "\n", HUGEPTE_CACHE_NAME(psize));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch
tpm-increase-size-of-internal-tpm-response-buffers.patch
memstick-allow-set_param-method-to-return-an-error-code.patch
memstick-use-fully-asynchronous-request-processing.patch
full-conversion-to-early_initcall-interface-remove-old-interface.patch
mm-introduce-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast.patch
mm-speculative-page-references.patch
slb-drop-kmem-cache-argument-from-constructor.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

