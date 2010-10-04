From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-on-xtensa.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:42:20 -0700
Message-ID: <201010042342.o94NgKaw022793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392Ab0JDXvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:51:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, chris@zankel.net


The patch titled
     ptrace: cleanup arch_ptrace() on xtensa
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-on-xtensa.patch

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
Subject: ptrace: cleanup arch_ptrace() on xtensa
From: Namhyung Kim <namhyung@gmail.com>

Use new 'datap' variable in order to remove unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/ptrace.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN arch/xtensa/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-xtensa arch/xtensa/kernel/ptrace.c
--- a/arch/xtensa/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-xtensa
+++ a/arch/xtensa/kernel/ptrace.c
@@ -260,6 +260,7 @@ long arch_ptrace(struct task_struct *chi
 		 unsigned long addr, unsigned long data)
 {
 	int ret = -EPERM;
+	void __user *datap = (void __user *) data;
 
 	switch (request) {
 	case PTRACE_PEEKTEXT:	/* read word at location addr. */
@@ -268,7 +269,7 @@ long arch_ptrace(struct task_struct *chi
 		break;
 
 	case PTRACE_PEEKUSR:	/* read register specified by addr. */
-		ret = ptrace_peekusr(child, addr, (void __user *) data);
+		ret = ptrace_peekusr(child, addr, datap);
 		break;
 
 	case PTRACE_POKETEXT:	/* write the word at location addr. */
@@ -281,19 +282,19 @@ long arch_ptrace(struct task_struct *chi
 		break;
 
 	case PTRACE_GETREGS:
-		ret = ptrace_getregs(child, (void __user *) data);
+		ret = ptrace_getregs(child, datap);
 		break;
 
 	case PTRACE_SETREGS:
-		ret = ptrace_setregs(child, (void __user *) data);
+		ret = ptrace_setregs(child, datap);
 		break;
 
 	case PTRACE_GETXTREGS:
-		ret = ptrace_getxregs(child, (void __user *) data);
+		ret = ptrace_getxregs(child, datap);
 		break;
 
 	case PTRACE_SETXTREGS:
-		ret = ptrace_setxregs(child, (void __user *) data);
+		ret = ptrace_setxregs(child, datap);
 		break;
 
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

