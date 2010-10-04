From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-on-mips.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:41:59 -0700
Message-ID: <201010042341.o94NfxG8022753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352Ab0JDXmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, ralf@linux-mips.org


The patch titled
     ptrace: cleanup arch_ptrace() on MIPS
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-on-mips.patch

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
Subject: ptrace: cleanup arch_ptrace() on MIPS
From: Namhyung Kim <namhyung@gmail.com>

Use new 'addrp', 'datavp' and 'datalp' variables in order to remove
unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/ptrace.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN arch/mips/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-mips arch/mips/kernel/ptrace.c
--- a/arch/mips/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-mips
+++ a/arch/mips/kernel/ptrace.c
@@ -259,6 +259,9 @@ long arch_ptrace(struct task_struct *chi
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	void __user *addrp = (void __user *) addr;
+	void __user *datavp = (void __user *) data;
+	unsigned long __user *datalp = (void __user *) data;
 
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
@@ -387,7 +390,7 @@ long arch_ptrace(struct task_struct *chi
 			ret = -EIO;
 			goto out;
 		}
-		ret = put_user(tmp, (unsigned long __user *) data);
+		ret = put_user(tmp, datalp);
 		break;
 	}
 
@@ -479,34 +482,31 @@ long arch_ptrace(struct task_struct *chi
 		}
 
 	case PTRACE_GETREGS:
-		ret = ptrace_getregs(child, (__s64 __user *) data);
+		ret = ptrace_getregs(child, datavp);
 		break;
 
 	case PTRACE_SETREGS:
-		ret = ptrace_setregs(child, (__s64 __user *) data);
+		ret = ptrace_setregs(child, datavp);
 		break;
 
 	case PTRACE_GETFPREGS:
-		ret = ptrace_getfpregs(child, (__u32 __user *) data);
+		ret = ptrace_getfpregs(child, datavp);
 		break;
 
 	case PTRACE_SETFPREGS:
-		ret = ptrace_setfpregs(child, (__u32 __user *) data);
+		ret = ptrace_setfpregs(child, datavp);
 		break;
 
 	case PTRACE_GET_THREAD_AREA:
-		ret = put_user(task_thread_info(child)->tp_value,
-				(unsigned long __user *) data);
+		ret = put_user(task_thread_info(child)->tp_value, datalp);
 		break;
 
 	case PTRACE_GET_WATCH_REGS:
-		ret = ptrace_get_watch_regs(child,
-					(struct pt_watch_regs __user *) addr);
+		ret = ptrace_get_watch_regs(child, addrp);
 		break;
 
 	case PTRACE_SET_WATCH_REGS:
-		ret = ptrace_set_watch_regs(child,
-					(struct pt_watch_regs __user *) addr);
+		ret = ptrace_set_watch_regs(child, addrp);
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

