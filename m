From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-on-x86.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:41:38 -0700
Message-ID: <201010042341.o94NfcTo022704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757002Ab0JDXmZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:42:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     ptrace: cleanup arch_ptrace() on x86
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-on-x86.patch

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
Subject: ptrace: cleanup arch_ptrace() on x86
From: Namhyung Kim <namhyung@gmail.com>

Remove checking @addr less than 0 because @addr is now unsigned and
use new udescp variable in order to remove unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ptrace.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-x86 arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-x86
+++ a/arch/x86/kernel/ptrace.c
@@ -806,6 +806,7 @@ long arch_ptrace(struct task_struct *chi
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
+	struct user_desc __user *udescp = (struct user_desc __user *)data;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
@@ -813,8 +814,7 @@ long arch_ptrace(struct task_struct *chi
 		unsigned long tmp;
 
 		ret = -EIO;
-		if ((addr & (sizeof(data) - 1)) || addr < 0 ||
-		    addr >= sizeof(struct user))
+		if ((addr & (sizeof(data) - 1)) || addr >= sizeof(struct user))
 			break;
 
 		tmp = 0;  /* Default return condition */
@@ -831,8 +831,7 @@ long arch_ptrace(struct task_struct *chi
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 		ret = -EIO;
-		if ((addr & (sizeof(data) - 1)) || addr < 0 ||
-		    addr >= sizeof(struct user))
+		if ((addr & (sizeof(data) - 1)) || addr >= sizeof(struct user))
 			break;
 
 		if (addr < sizeof(struct user_regs_struct))
@@ -891,15 +890,13 @@ long arch_ptrace(struct task_struct *chi
 	case PTRACE_GET_THREAD_AREA:
 		if ((int) addr < 0)
 			return -EIO;
-		ret = do_get_thread_area(child, addr,
-					 (struct user_desc __user *) data);
+		ret = do_get_thread_area(child, addr, udescp);
 		break;
 
 	case PTRACE_SET_THREAD_AREA:
 		if ((int) addr < 0)
 			return -EIO;
-		ret = do_set_thread_area(child, addr,
-					 (struct user_desc __user *) data, 0);
+		ret = do_set_thread_area(child, addr, udescp, 0);
 		break;
 #endif
 
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

