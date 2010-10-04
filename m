From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-on-m68k.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:41:55 -0700
Message-ID: <201010042341.o94NftkO022745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487Ab0JDXz0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:55:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     ptrace: cleanup arch_ptrace() on m68k
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-on-m68k.patch

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
Subject: ptrace: cleanup arch_ptrace() on m68k
From: Namhyung Kim <namhyung@gmail.com>

Use new 'regno', 'datap' variables in order to remove duplicated
expressions and unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/ptrace.c |   46 ++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff -puN arch/m68k/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-m68k arch/m68k/kernel/ptrace.c
--- a/arch/m68k/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-m68k
+++ a/arch/m68k/kernel/ptrace.c
@@ -161,51 +161,52 @@ long arch_ptrace(struct task_struct *chi
 {
 	unsigned long tmp;
 	int i, ret = 0;
+	int regno = addr >> 2; /* temporary hack. */
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR:
 		if (addr & 3)
 			goto out_eio;
-		addr >>= 2;	/* temporary hack. */
 
-		if (addr >= 0 && addr < 19) {
-			tmp = get_reg(child, addr);
-		} else if (addr >= 21 && addr < 49) {
-			tmp = child->thread.fp[addr - 21];
+		if (regno >= 0 && regno < 19) {
+			tmp = get_reg(child, regno);
+		} else if (regno >= 21 && regno < 49) {
+			tmp = child->thread.fp[regno - 21];
 			/* Convert internal fpu reg representation
 			 * into long double format
 			 */
-			if (FPU_IS_EMU && (addr < 45) && !(addr % 3))
+			if (FPU_IS_EMU && (regno < 45) && !(regno % 3))
 				tmp = ((tmp & 0xffff0000) << 15) |
 				      ((tmp & 0x0000ffff) << 16);
 		} else
 			goto out_eio;
-		ret = put_user(tmp, (unsigned long *)data);
+		ret = put_user(tmp, datap);
 		break;
 
-	case PTRACE_POKEUSR:	/* write the word at location addr in the USER area */
+	case PTRACE_POKEUSR:
+	/* write the word at location addr in the USER area */
 		if (addr & 3)
 			goto out_eio;
-		addr >>= 2;	/* temporary hack. */
 
-		if (addr == PT_SR) {
+		if (regno == PT_SR) {
 			data &= SR_MASK;
 			data |= get_reg(child, PT_SR) & ~SR_MASK;
 		}
-		if (addr >= 0 && addr < 19) {
-			if (put_reg(child, addr, data))
+		if (regno >= 0 && regno < 19) {
+			if (put_reg(child, regno, data))
 				goto out_eio;
-		} else if (addr >= 21 && addr < 48) {
+		} else if (regno >= 21 && regno < 48) {
 			/* Convert long double format
 			 * into internal fpu reg representation
 			 */
-			if (FPU_IS_EMU && (addr < 45) && !(addr % 3)) {
+			if (FPU_IS_EMU && (regno < 45) && !(regno % 3)) {
 				data <<= 15;
 				data = (data & 0xffff0000) |
 				       ((data & 0x0000ffff) >> 1);
 			}
-			child->thread.fp[addr - 21] = data;
+			child->thread.fp[regno - 21] = data;
 		} else
 			goto out_eio;
 		break;
@@ -213,16 +214,16 @@ long arch_ptrace(struct task_struct *chi
 	case PTRACE_GETREGS:	/* Get all gp regs from the child. */
 		for (i = 0; i < 19; i++) {
 			tmp = get_reg(child, i);
-			ret = put_user(tmp, (unsigned long *)data);
+			ret = put_user(tmp, datap);
 			if (ret)
 				break;
-			data += sizeof(unsigned long);
+			datap++;
 		}
 		break;
 
 	case PTRACE_SETREGS:	/* Set all gp regs in the child. */
 		for (i = 0; i < 19; i++) {
-			ret = get_user(tmp, (unsigned long *)data);
+			ret = get_user(tmp, datap);
 			if (ret)
 				break;
 			if (i == PT_SR) {
@@ -230,25 +231,24 @@ long arch_ptrace(struct task_struct *chi
 				tmp |= get_reg(child, PT_SR) & ~SR_MASK;
 			}
 			put_reg(child, i, tmp);
-			data += sizeof(unsigned long);
+			datap++;
 		}
 		break;
 
 	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
-		if (copy_to_user((void *)data, &child->thread.fp,
+		if (copy_to_user(datap, &child->thread.fp,
 				 sizeof(struct user_m68kfp_struct)))
 			ret = -EFAULT;
 		break;
 
 	case PTRACE_SETFPREGS:	/* Set the child FPU state. */
-		if (copy_from_user(&child->thread.fp, (void *)data,
+		if (copy_from_user(&child->thread.fp, datap,
 				   sizeof(struct user_m68kfp_struct)))
 			ret = -EFAULT;
 		break;
 
 	case PTRACE_GET_THREAD_AREA:
-		ret = put_user(task_thread_info(child)->tp_value,
-			       (unsigned long __user *)data);
+		ret = put_user(task_thread_info(child)->tp_value, datap);
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

