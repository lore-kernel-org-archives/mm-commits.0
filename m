From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-on-um.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:42:17 -0700
Message-ID: <201010042342.o94NgHG9022790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757380Ab0JDXwg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:52:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, jdike@addtoit.com


The patch titled
     ptrace: cleanup arch_ptrace() on um
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-on-um.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: cleanup arch_ptrace() on um
From: Namhyung Kim <namhyung@gmail.com>

Remove unnecessary castings using void pointer and fix copy_to_user()
return value. Also add missing __user markup on the argument of
arch_ptrctl().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/ptrace.c     |   18 ++++++++----------
 arch/um/sys-x86_64/ptrace.c |    7 +++----
 2 files changed, 11 insertions(+), 14 deletions(-)

diff -puN arch/um/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-um arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-um
+++ a/arch/um/kernel/ptrace.c
@@ -47,6 +47,7 @@ long arch_ptrace(struct task_struct *chi
 {
 	int i, ret;
 	unsigned long __user *p = (void __user *)data;
+	void __user *vp = p;
 
 	switch (request) {
 	/* read word at location addr. */
@@ -108,24 +109,20 @@ long arch_ptrace(struct task_struct *chi
 #endif
 #ifdef PTRACE_GETFPREGS
 	case PTRACE_GETFPREGS: /* Get the child FPU state. */
-		ret = get_fpregs((struct user_i387_struct __user *) data,
-				 child);
+		ret = get_fpregs(vp, child);
 		break;
 #endif
 #ifdef PTRACE_SETFPREGS
 	case PTRACE_SETFPREGS: /* Set the child FPU state. */
-	        ret = set_fpregs((struct user_i387_struct __user *) data,
-				 child);
+		ret = set_fpregs(vp, child);
 		break;
 #endif
 	case PTRACE_GET_THREAD_AREA:
-		ret = ptrace_get_thread_area(child, addr,
-					     (struct user_desc __user *) data);
+		ret = ptrace_get_thread_area(child, addr, vp);
 		break;
 
 	case PTRACE_SET_THREAD_AREA:
-		ret = ptrace_set_thread_area(child, addr,
-					     (struct user_desc __user *) data);
+		ret = ptrace_set_thread_area(child, addr, datavp);
 		break;
 
 	case PTRACE_FAULTINFO: {
@@ -135,7 +132,8 @@ long arch_ptrace(struct task_struct *chi
 		 * On i386, ptrace_faultinfo is smaller!
 		 */
 		ret = copy_to_user(p, &child->thread.arch.faultinfo,
-				   sizeof(struct ptrace_faultinfo));
+				   sizeof(struct ptrace_faultinfo)) ?
+			-EIO : 0;
 		break;
 	}
 
@@ -159,7 +157,7 @@ long arch_ptrace(struct task_struct *chi
 #ifdef PTRACE_ARCH_PRCTL
 	case PTRACE_ARCH_PRCTL:
 		/* XXX Calls ptrace on the host - needs some SMP thinking */
-		ret = arch_prctl(child, data, (void *) addr);
+		ret = arch_prctl(child, data, (void __user *) addr);
 		break;
 #endif
 	default:
diff -puN arch/um/sys-x86_64/ptrace.c~ptrace-cleanup-arch_ptrace-on-um arch/um/sys-x86_64/ptrace.c
--- a/arch/um/sys-x86_64/ptrace.c~ptrace-cleanup-arch_ptrace-on-um
+++ a/arch/um/sys-x86_64/ptrace.c
@@ -179,15 +179,14 @@ long subarch_ptrace(struct task_struct *
 		    unsigned long addr, unsigned long data)
 {
 	int ret = -EIO;
+	void __user *datap = (void __user *) data;
 
 	switch (request) {
 	case PTRACE_GETFPXREGS: /* Get the child FPU state. */
-		ret = get_fpregs((struct user_i387_struct __user *) data,
-				 child);
+		ret = get_fpregs(datap, child);
 		break;
 	case PTRACE_SETFPXREGS: /* Set the child FPU state. */
-		ret = set_fpregs((struct user_i387_struct __user *) data,
-				 child);
+		ret = set_fpregs(datap, child);
 		break;
 	}
 
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch
vfs-remove-a-warning-on-open_fmode.patch
vfs-add-__fmode_exec.patch
mm-cleanup-gfp_zone-fix-sparse-warnings.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
ptrace-annotate-lock-context-change-on-exit_ptrace.patch
ptrace-change-signature-of-sys_ptrace-and-friends.patch
ptrace-cleanup-ptrace_request.patch
ptrace-change-signature-of-arch_ptrace.patch
ptrace-cleanup-arch_ptrace-on-x86.patch
ptrace-cleanup-arch_ptrace-on-arm.patch
ptrace-cleanup-arch_ptrace-on-avr32.patch
ptrace-cleanup-arch_ptrace-and-friends-on-blackfin.patch
ptrace-cleanup-arch_ptrace-on-cris.patch
ptrace-cleanup-arch_ptrace-on-frv.patch
ptrace-cleanup-arch_ptrace-on-h8300.patch
ptrace-cleanup-arch_ptrace-on-m32r.patch
ptrace-cleanup-arch_ptrace-on-m68k.patch
ptrace-cleanup-arch_ptrace-on-microblaze.patch
ptrace-cleanup-arch_ptrace-on-mips.patch
ptrace-cleanup-arch_ptrace-on-mn10300.patch
ptrace-cleanup-arch_ptrace-on-parisc.patch
ptrace-cleanup-arch_ptrace-on-powerpc.patch
ptrace-cleanup-arch_ptrace-on-score.patch
ptrace-cleanup-arch_ptrace-on-sh.patch
ptrace-cleanup-arch_ptrace-on-sparc.patch
ptrace-cleanup-arch_ptrace-on-tile.patch
ptrace-cleanup-arch_ptrace-on-um.patch
ptrace-cleanup-arch_ptrace-on-xtensa.patch
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

