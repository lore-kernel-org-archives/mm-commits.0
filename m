From: akpm@linux-foundation.org
Subject: [folded-merged] mm-use-vm_unmapped_area-on-sparc64-architecture-fix-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:49:48 -0800
Message-ID: <20121211234948.EB930100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:47329 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2LKXtt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:49:49 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so6878yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:49:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Re: linux-next: build warning after merge of the final tree (akpm tree related)
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-on-sparc64-architecture-fix-fix.patch

This patch was dropped because it was folded into mm-use-vm_unmapped_area-on-sparc64-architecture.patch

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: Re: linux-next: build warning after merge of the final tree (akpm tree related)

On Fri, Nov 09, 2012 at 03:19:03PM +1100, Stephen Rothwell wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (arm defconfig)
> produced this warning:
>
> arch/arm/mm/mmap.c: In function 'arch_get_unmapped_area':
> arch/arm/mm/mmap.c:60:16: warning: unused variable 'start_addr' [-Wunused-variable]
>
> Introduced by commit "mm: use vm_unmapped_area() on arm architecture".

Sorry for the mistakes. The following changes should fix what's been reported so far.

commit 1c98949798ce7a1d4a910775623e1830cf88a92c
Author: Michel Lespinasse <walken@google.com>
Date:   Thu Nov 8 20:26:34 2012 -0800

    fix mm: use vm_unmapped_area() on sparc32 architecture

index a59bc637f9af..a20b5ab4c701 100644

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/sys_sparc_64.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/sparc/kernel/sys_sparc_64.c~mm-use-vm_unmapped_area-on-sparc64-architecture-fix-fix arch/sparc/kernel/sys_sparc_64.c
--- a/arch/sparc/kernel/sys_sparc_64.c~mm-use-vm_unmapped_area-on-sparc64-architecture-fix-fix
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -89,7 +89,6 @@ unsigned long arch_get_unmapped_area(str
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct * vma;
 	unsigned long task_size = TASK_SIZE;
-	unsigned long start_addr;
 	int do_color_align;
 	struct vm_unmapped_area_info info;
 
@@ -191,7 +190,7 @@ arch_get_unmapped_area_topdown(struct fi
 	info.length = len;
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
-	info.align_mask = do_colour_align ? (PAGE_MASK & shm_align_mask) : 0;
+	info.align_mask = do_color_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 
_

Patches currently in -mm which might be from walken@google.com are

mm-augment-vma-rbtree-with-rb_subtree_gap.patch
mm-check-rb_subtree_gap-correctness.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-vm_unmapped_area-lookup-function.patch
mm-use-vm_unmapped_area-on-x86_64-architecture.patch
mm-fix-cache-coloring-on-x86_64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch

