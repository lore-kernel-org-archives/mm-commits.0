From: akpm@linux-foundation.org
Subject: [folded-merged] mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:48:27 -0800
Message-ID: <20121211234827.EDEAC100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:61389 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2LKXs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:48:29 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so6759vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:48:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, sfr@canb.auug.org.au, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch

This patch was dropped because it was folded into mm-use-vm_unmapped_area-on-sparc32-architecture.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix

remove now-unused COLOUR_ALIGN()

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michel Lespinasse <walken@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/sys_sparc_32.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/sparc/kernel/sys_sparc_32.c~mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix arch/sparc/kernel/sys_sparc_32.c
--- a/arch/sparc/kernel/sys_sparc_32.c~mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix
+++ a/arch/sparc/kernel/sys_sparc_32.c
@@ -34,8 +34,6 @@ asmlinkage unsigned long sys_getpagesize
 	return PAGE_SIZE; /* Possibly older binaries want 8192 on sun4's? */
 }
 
-#define COLOUR_ALIGN(addr)      (((addr)+SHMLBA-1)&~(SHMLBA-1))
-
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	struct vm_unmapped_area_info info;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-introduce-mm_find_pmd.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch
mm-check-rb_subtree_gap-correctness.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-vm_unmapped_area-lookup-function.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch

