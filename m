From: akpm@linux-foundation.org
Subject: [merged] mm-fix-cache-coloring-on-x86_64-architecture.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:59:25 -0800
Message-ID: <20121212195926.ADF4A200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:56772 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab2LLT7a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:59:30 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so64292eaa.2
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:59:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix cache coloring on x86_64 architecture
has been removed from the -mm tree.  Its filename was
     mm-fix-cache-coloring-on-x86_64-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-protect-against-concurrent-vma-expansion.patch
linux-next.patch
lib-rbtree_testc-fix-uninitialized-variable-warning.patch
random32-rename-random32-to-prandom.patch
prandom-introduce-prandom_bytes-and-prandom_bytes_state.patch
bnx2x-use-prandom_bytes.patch
mtd-nandsim-use-prandom_bytes.patch
ubifs-use-prandom_bytes.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch

