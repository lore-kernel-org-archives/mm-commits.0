From: akpm@linux-foundation.org
Subject: - uml-get-rid-of-syscall-counters.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:37:45 -0800
Message-ID: <200802052237.m15MbQEw012851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762395AbYBEWld (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: get rid of syscall counters
has been removed from the -mm tree.  Its filename was
     uml-get-rid-of-syscall-counters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: get rid of syscall counters
From: Jeff Dike <jdike@addtoit.com>

Get rid of some syscall counters which haven't been useful in ages.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/kern_util.h        |    1 -
 arch/um/kernel/skas/syscall.c      |    3 ---
 arch/um/kernel/syscall.c           |    3 ---
 include/asm-um/processor-generic.h |    2 --
 4 files changed, 9 deletions(-)

diff -puN arch/um/include/kern_util.h~uml-get-rid-of-syscall-counters arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-get-rid-of-syscall-counters
+++ a/arch/um/include/kern_util.h
@@ -13,7 +13,6 @@ extern int uml_exitcode;
 
 extern int ncpus;
 extern int kmalloc_ok;
-extern int nsyscalls;
 
 #define UML_ROUND_UP(addr) \
 	((((unsigned long) addr) + PAGE_SIZE - 1) & PAGE_MASK)
diff -puN arch/um/kernel/skas/syscall.c~uml-get-rid-of-syscall-counters arch/um/kernel/skas/syscall.c
--- a/arch/um/kernel/skas/syscall.c~uml-get-rid-of-syscall-counters
+++ a/arch/um/kernel/skas/syscall.c
@@ -17,9 +17,6 @@ void handle_syscall(struct uml_pt_regs *
 
 	syscall_trace(r, 0);
 
-	current->thread.nsyscalls++;
-	nsyscalls++;
-
 	/*
 	 * This should go in the declaration of syscall, but when I do that,
 	 * strace -f -c bash -c 'ls ; ls' breaks, sometimes not tracing
diff -puN arch/um/kernel/syscall.c~uml-get-rid-of-syscall-counters arch/um/kernel/syscall.c
--- a/arch/um/kernel/syscall.c~uml-get-rid-of-syscall-counters
+++ a/arch/um/kernel/syscall.c
@@ -13,9 +13,6 @@
 #include "asm/uaccess.h"
 #include "asm/unistd.h"
 
-/*  Unlocked, I don't care if this is a bit off */
-int nsyscalls = 0;
-
 long sys_fork(void)
 {
 	long ret;
diff -puN include/asm-um/processor-generic.h~uml-get-rid-of-syscall-counters include/asm-um/processor-generic.h
--- a/include/asm-um/processor-generic.h~uml-get-rid-of-syscall-counters
+++ a/include/asm-um/processor-generic.h
@@ -27,7 +27,6 @@ struct thread_struct {
 	 * as of 2.6.11).
 	 */
 	int forking;
-	int nsyscalls;
 	struct pt_regs regs;
 	int singlestep_syscall;
 	void *fault_addr;
@@ -59,7 +58,6 @@ struct thread_struct {
 #define INIT_THREAD \
 { \
 	.forking		= 0, \
-	.nsyscalls		= 0, \
 	.regs		   	= EMPTY_REGS,	\
 	.fault_addr		= NULL, \
 	.prev_sched		= NULL, \
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
