From: akpm@linux-foundation.org
Subject: + mm-fix-cache-coloring-on-x86_64-architecture.patch added to -mm tree
Date: Tue, 06 Nov 2012 14:39:23 -0800
Message-ID: <20121106223924.3BE2C200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:55965 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab2KFWj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 17:39:27 -0500
Received: by mail-ee0-f74.google.com with SMTP id b57so67741eek.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 14:39:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de


The patch titled
     Subject: mm: fix cache coloring on x86_64 architecture
has been added to the -mm tree.  Its filename is
     mm-fix-cache-coloring-on-x86_64-architecture.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: fix cache coloring on x86_64 architecture

Fix the x86-64 cache alignment code to take pgoff into account.  Use the
x86 and MIPS cache alignment code as the basis for a generic cache
alignment function.

The old x86 code will always align the mmap to aliasing boundaries,
even if the program mmaps the file with a non-zero pgoff.

If program A mmaps the file with pgoff 0, and program B mmaps the file
with pgoff 1.  The old code would align the mmaps, resulting in misaligned
pages:

A:  0123
B:  123

After this patch, they are aligned so the pages line up:

A: 0123
B:  123

Proposed by Rik van Riel.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/sys_x86_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/sys_x86_64.c~mm-fix-cache-coloring-on-x86_64-architecture arch/x86/kernel/sys_x86_64.c
--- a/arch/x86/kernel/sys_x86_64.c~mm-fix-cache-coloring-on-x86_64-architecture
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -136,7 +136,7 @@ arch_get_unmapped_area(struct file *filp
 	info.low_limit = begin;
 	info.high_limit = end;
 	info.align_mask = filp ? get_align_mask() : 0;
-	info.align_offset = 0;
+	info.align_offset = pgoff << PAGE_SHIFT;
 	return vm_unmapped_area(&info);
 }
 
@@ -175,7 +175,7 @@ arch_get_unmapped_area_topdown(struct fi
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
 	info.align_mask = filp ? get_align_mask() : 0;
-	info.align_offset = 0;
+	info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 	if (!(addr & ~PAGE_MASK))
 		return addr;
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-add-anon_vma_lock-to-validate_mm.patch
mm-augment-vma-rbtree-with-rb_subtree_gap.patch
mm-check-rb_subtree_gap-correctness.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-on-x86_64-architecture.patch
mm-fix-cache-coloring-on-x86_64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch

