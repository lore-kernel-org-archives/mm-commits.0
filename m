From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-and-friends-on-blackfin.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:41:45 -0700
Message-ID: <201010042341.o94NfjPM022718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755765Ab0JDXvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:51:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, vapier@gentoo.org


The patch titled
     ptrace: cleanup arch_ptrace() and friends on Blackfin
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-and-friends-on-blackfin.patch

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
Subject: ptrace: cleanup arch_ptrace() and friends on Blackfin
From: Namhyung Kim <namhyung@gmail.com>

Change signature of get/put_reg() according to the change of arch_ptrace()
and remove unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/ptrace.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN arch/blackfin/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-and-friends-on-blackfin arch/blackfin/kernel/ptrace.c
--- a/arch/blackfin/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-and-friends-on-blackfin
+++ a/arch/blackfin/kernel/ptrace.c
@@ -37,12 +37,13 @@
  * Get contents of register REGNO in task TASK.
  */
 static inline long
-get_reg(struct task_struct *task, long regno, unsigned long __user *datap)
+get_reg(struct task_struct *task, unsigned long regno,
+	unsigned long __user *datap)
 {
 	long tmp;
 	struct pt_regs *regs = task_pt_regs(task);
 
-	if (regno & 3 || regno > PT_LAST_PSEUDO || regno < 0)
+	if (regno & 3 || regno > PT_LAST_PSEUDO)
 		return -EIO;
 
 	switch (regno) {
@@ -73,11 +74,11 @@ get_reg(struct task_struct *task, long r
  * Write contents of register REGNO in task TASK.
  */
 static inline int
-put_reg(struct task_struct *task, long regno, unsigned long data)
+put_reg(struct task_struct *task, unsigned long regno, unsigned long data)
 {
 	struct pt_regs *regs = task_pt_regs(task);
 
-	if (regno & 3 || regno > PT_LAST_PSEUDO || regno < 0)
+	if (regno & 3 || regno > PT_LAST_PSEUDO)
 		return -EIO;
 
 	switch (regno) {
@@ -361,14 +362,14 @@ long arch_ptrace(struct task_struct *chi
 		return copy_regset_to_user(child, &user_bfin_native_view,
 					   REGSET_GENERAL,
 					   0, sizeof(struct pt_regs),
-					   (void __user *)data);
+					   datap);
 
 	case PTRACE_SETREGS:
 		pr_debug("ptrace: PTRACE_SETREGS\n");
 		return copy_regset_from_user(child, &user_bfin_native_view,
 					     REGSET_GENERAL,
 					     0, sizeof(struct pt_regs),
-					     (const void __user *)data);
+					     datap);
 
 	case_default:
 	default:
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
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch
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

