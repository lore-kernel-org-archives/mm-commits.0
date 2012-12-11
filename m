From: akpm@linux-foundation.org
Subject: [folded-merged] mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:49:42 -0800
Message-ID: <20121211234943.8EA16200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:55529 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2LKXtr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:49:47 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so1895wey.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:49:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-vm_unmapped_area-on-sparc64-architecture-fix
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch

This patch was dropped because it was folded into mm-use-vm_unmapped_area-on-sparc64-architecture.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-use-vm_unmapped_area-on-sparc64-architecture-fix

remove now-unused COLOUR_ALIGN_DOWN()

Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michel Lespinasse <walken@google.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/sys_sparc_64.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN arch/sparc/kernel/sys_sparc_64.c~mm-use-vm_unmapped_area-on-sparc64-architecture-fix arch/sparc/kernel/sys_sparc_64.c
--- a/arch/sparc/kernel/sys_sparc_64.c~mm-use-vm_unmapped_area-on-sparc64-architecture-fix
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -84,17 +84,6 @@ static inline unsigned long COLOUR_ALIGN
 	return base + off;
 }
 
-static inline unsigned long COLOUR_ALIGN_DOWN(unsigned long addr,
-					      unsigned long pgoff)
-{
-	unsigned long base = addr & ~(SHMLBA-1);
-	unsigned long off = (pgoff<<PAGE_SHIFT) & (SHMLBA-1);
-
-	if (base + off <= addr)
-		return base + off;
-	return base - off;
-}
-
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
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
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch

