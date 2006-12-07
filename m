From: akpm@osdl.org
Subject: - mm-arch-do_page_fault-vs-in_atomic.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:45 -0800
Message-ID: <200612072256.kB7MujJN029230@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50513 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163560AbWLGW4w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:56:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: arch do_page_fault() vs in_atomic()
has been removed from the -mm tree.  Its filename was
     mm-arch-do_page_fault-vs-in_atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: arch do_page_fault() vs in_atomic()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

In light of the recent pagefault and filemap_copy_from_user work I've gone
through all the arch pagefault handlers to make sure the inc_preempt_count()
'feature' works as expected.

Several sections of code (including the new filemap_copy_from_user) rely on
the fact that faults do not take locks under increased preempt count.

arch/x86_64 - good
arch/powerpc - good
arch/cris - fixed
arch/i386 - good
arch/parisc - fixed
arch/sh - good
arch/sparc - good
arch/s390 - good
arch/m68k - fixed
arch/ppc - good
arch/alpha - fixed
arch/mips - good
arch/sparc64 - good
arch/ia64 - good
arch/arm - fixed
arch/um - good
arch/avr32 - good
arch/h8300 - NA
arch/m32r - good
arch/v850 - good
arch/frv - fixed
arch/m68knommu - NA
arch/arm26 - fixed
arch/sh64 - fixed
arch/xtensa - good

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/alpha/mm/fault.c  |    2 +-
 arch/arm/mm/fault.c    |    2 +-
 arch/arm26/mm/fault.c  |    2 +-
 arch/cris/mm/fault.c   |    2 +-
 arch/frv/mm/fault.c    |    2 +-
 arch/m68k/mm/fault.c   |    2 +-
 arch/parisc/mm/fault.c |    2 +-
 arch/sh64/mm/fault.c   |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/alpha/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic arch/alpha/mm/fault.c
--- a/arch/alpha/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic
+++ a/arch/alpha/mm/fault.c
@@ -108,7 +108,7 @@ do_page_fault(unsigned long address, uns
 
 	/* If we're in an interrupt context, or have no user context,
 	   we must not take the fault.  */
-	if (!mm || in_interrupt())
+	if (!mm || in_atomic())
 		goto no_context;
 
 #ifdef CONFIG_ALPHA_LARGE_VMALLOC
diff -puN arch/arm/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic arch/arm/mm/fault.c
--- a/arch/arm/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic
+++ a/arch/arm/mm/fault.c
@@ -230,7 +230,7 @@ do_page_fault(unsigned long addr, unsign
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..
 	 */
-	if (in_interrupt() || !mm)
+	if (in_atomic() || !mm)
 		goto no_context;
 
 	/*
diff -puN arch/arm26/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic arch/arm26/mm/fault.c
--- a/arch/arm26/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic
+++ a/arch/arm26/mm/fault.c
@@ -215,7 +215,7 @@ int do_page_fault(unsigned long addr, un
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..
 	 */
-	if (in_interrupt() || !mm)
+	if (in_atomic() || !mm)
 		goto no_context;
 
 	down_read(&mm->mmap_sem);
diff -puN arch/cris/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic arch/cris/mm/fault.c
--- a/arch/cris/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic
+++ a/arch/cris/mm/fault.c
@@ -232,7 +232,7 @@ do_page_fault(unsigned long address, str
 	 * context, we must not take the fault..
 	 */
 
-	if (in_interrupt() || !mm)
+	if (in_atomic() || !mm)
 		goto no_context;
 
 	down_read(&mm->mmap_sem);
diff -puN arch/frv/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic arch/frv/mm/fault.c
--- a/arch/frv/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic
+++ a/arch/frv/mm/fault.c
@@ -78,7 +78,7 @@ asmlinkage void do_page_fault(int datamm
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..
 	 */
-	if (in_interrupt() || !mm)
+	if (in_atomic() || !mm)
 		goto no_context;
 
 	down_read(&mm->mmap_sem);
diff -puN arch/m68k/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic arch/m68k/mm/fault.c
--- a/arch/m68k/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic
+++ a/arch/m68k/mm/fault.c
@@ -99,7 +99,7 @@ int do_page_fault(struct pt_regs *regs, 
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..
 	 */
-	if (in_interrupt() || !mm)
+	if (in_atomic() || !mm)
 		goto no_context;
 
 	down_read(&mm->mmap_sem);
diff -puN arch/parisc/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic arch/parisc/mm/fault.c
--- a/arch/parisc/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic
+++ a/arch/parisc/mm/fault.c
@@ -152,7 +152,7 @@ void do_page_fault(struct pt_regs *regs,
 	const struct exception_table_entry *fix;
 	unsigned long acc_type;
 
-	if (in_interrupt() || !mm)
+	if (in_atomic() || !mm)
 		goto no_context;
 
 	down_read(&mm->mmap_sem);
diff -puN arch/sh64/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic arch/sh64/mm/fault.c
--- a/arch/sh64/mm/fault.c~mm-arch-do_page_fault-vs-in_atomic
+++ a/arch/sh64/mm/fault.c
@@ -154,7 +154,7 @@ asmlinkage void do_page_fault(struct pt_
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..
 	 */
-	if (in_interrupt() || !mm)
+	if (in_atomic() || !mm)
 		goto no_context;
 
 	/* TLB misses upon some cache flushes get done under cli() */
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
tty-signal-tty-locking-3270-fix.patch
do_task_stat-dont-take-tty_mutex.patch
do_acct_process-dont-take-tty_mutex.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
bdev-fix-bd_part_count-leak.patch
lockdep-annotate-nfsd4-recover-code.patch

