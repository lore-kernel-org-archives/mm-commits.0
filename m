From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-on-m68knommu.patch added to -mm tree
Date: Tue, 05 Oct 2010 13:20:06 -0700
Message-ID: <201010052020.o95KK6a5017660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753340Ab0JEUUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 16:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, gerg@uclinux.org


The patch titled
     ptrace: cleanup arch_ptrace() on m68knommu
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-on-m68knommu.patch

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
Subject: ptrace: cleanup arch_ptrace() on m68knommu
From: Namhyung Kim <namhyung@gmail.com>

Use new 'regno', 'datap' variables in order to remove duplicated
expressions and unnecessary castings.  Alse remove checking @addr less
than 0 because addr is now unsigned.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/kernel/ptrace.c |   54 ++++++++++++++-----------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff -puN arch/m68knommu/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-m68knommu arch/m68knommu/kernel/ptrace.c
--- a/arch/m68knommu/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-m68knommu
+++ a/arch/m68knommu/kernel/ptrace.c
@@ -115,6 +115,8 @@ long arch_ptrace(struct task_struct *chi
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	int regno = addr >> 2;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 		/* read the word at location addr in the USER area. */
@@ -122,53 +124,48 @@ long arch_ptrace(struct task_struct *chi
 			unsigned long tmp;
 			
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 ||
-			    addr > sizeof(struct user) - 3)
+			if ((addr & 3) || addr > sizeof(struct user) - 3)
 				break;
 			
 			tmp = 0;  /* Default return condition */
-			addr = addr >> 2; /* temporary hack. */
 			ret = -EIO;
-			if (addr < 19) {
-				tmp = get_reg(child, addr);
-				if (addr == PT_SR)
+			if (regno < 19) {
+				tmp = get_reg(child, regno);
+				if (regno == PT_SR)
 					tmp >>= 16;
-			} else if (addr >= 21 && addr < 49) {
-				tmp = child->thread.fp[addr - 21];
-			} else if (addr == 49) {
+			} else if (regno >= 21 && regno < 49) {
+				tmp = child->thread.fp[regno - 21];
+			} else if (regno == 49) {
 				tmp = child->mm->start_code;
-			} else if (addr == 50) {
+			} else if (regno == 50) {
 				tmp = child->mm->start_data;
-			} else if (addr == 51) {
+			} else if (regno == 51) {
 				tmp = child->mm->end_code;
 			} else
 				break;
-			ret = put_user(tmp,(unsigned long *) data);
+			ret = put_user(tmp, datap);
 			break;
 		}
 
 		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 ||
-			    addr > sizeof(struct user) - 3)
+			if ((addr & 3) || addr > sizeof(struct user) - 3)
 				break;
 
-			addr = addr >> 2; /* temporary hack. */
-			    
-			if (addr == PT_SR) {
+			if (regno == PT_SR) {
 				data &= SR_MASK;
 				data <<= 16;
 				data |= get_reg(child, PT_SR) & ~(SR_MASK << 16);
 			}
-			if (addr < 19) {
-				if (put_reg(child, addr, data))
+			if (regno < 19) {
+				if (put_reg(child, regno, data))
 					break;
 				ret = 0;
 				break;
 			}
-			if (addr >= 21 && addr < 48)
+			if (regno >= 21 && regno < 48)
 			{
-				child->thread.fp[addr - 21] = data;
+				child->thread.fp[regno - 21] = data;
 				ret = 0;
 			}
 			break;
@@ -180,11 +177,11 @@ long arch_ptrace(struct task_struct *chi
 			    tmp = get_reg(child, i);
 			    if (i == PT_SR)
 				tmp >>= 16;
-			    if (put_user(tmp, (unsigned long *) data)) {
+			    if (put_user(tmp, datap)) {
 				ret = -EFAULT;
 				break;
 			    }
-			    data += sizeof(unsigned long);
+			    datap++;
 			}
 			ret = 0;
 			break;
@@ -194,7 +191,7 @@ long arch_ptrace(struct task_struct *chi
 			int i;
 			unsigned long tmp;
 			for (i = 0; i < 19; i++) {
-			    if (get_user(tmp, (unsigned long *) data)) {
+			    if (get_user(tmp, datap)) {
 				ret = -EFAULT;
 				break;
 			    }
@@ -204,7 +201,7 @@ long arch_ptrace(struct task_struct *chi
 				tmp |= get_reg(child, PT_SR) & ~(SR_MASK << 16);
 			    }
 			    put_reg(child, i, tmp);
-			    data += sizeof(unsigned long);
+			    datap++;
 			}
 			ret = 0;
 			break;
@@ -213,7 +210,7 @@ long arch_ptrace(struct task_struct *chi
 #ifdef PTRACE_GETFPREGS
 		case PTRACE_GETFPREGS: { /* Get the child FPU state. */
 			ret = 0;
-			if (copy_to_user((void *)data, &child->thread.fp,
+			if (copy_to_user(datap, &child->thread.fp,
 					 sizeof(struct user_m68kfp_struct)))
 				ret = -EFAULT;
 			break;
@@ -223,7 +220,7 @@ long arch_ptrace(struct task_struct *chi
 #ifdef PTRACE_SETFPREGS
 		case PTRACE_SETFPREGS: { /* Set the child FPU state. */
 			ret = 0;
-			if (copy_from_user(&child->thread.fp, (void *)data,
+			if (copy_from_user(&child->thread.fp, datap,
 					   sizeof(struct user_m68kfp_struct)))
 				ret = -EFAULT;
 			break;
@@ -231,8 +228,7 @@ long arch_ptrace(struct task_struct *chi
 #endif
 
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
ptrace-cleanup-arch_ptrace-on-m68knommu.patch
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

