From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-on-cris.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:41:47 -0700
Message-ID: <201010042341.o94NflRx022725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460Ab0JDXyr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:54:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     ptrace: cleanup arch_ptrace() on cris
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-on-cris.patch

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
Subject: ptrace: cleanup arch_ptrace() on cris
From: Namhyung Kim <namhyung@gmail.com>

Use new 'regno' variable in order to remove redandunt expression and
remove checking @addr less than 0 because @addr is now unsigned.  Also
update 'datap' on PTRACE_GET/SETREGS to fix a bug on arch-v10.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/ptrace.c |   17 ++++++++---------
 arch/cris/arch-v32/kernel/ptrace.c |   13 ++++++-------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff -puN arch/cris/arch-v10/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-cris arch/cris/arch-v10/kernel/ptrace.c
--- a/arch/cris/arch-v10/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-cris
+++ a/arch/cris/arch-v10/kernel/ptrace.c
@@ -80,6 +80,7 @@ long arch_ptrace(struct task_struct *chi
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	unsigned int regno = addr >> 2;
 	unsigned long __user *datap = (unsigned long __user *)data;
 
 	switch (request) {
@@ -94,10 +95,10 @@ long arch_ptrace(struct task_struct *chi
 			unsigned long tmp;
 
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || regno > PT_MAX)
 				break;
 
-			tmp = get_reg(child, addr >> 2);
+			tmp = get_reg(child, regno);
 			ret = put_user(tmp, datap);
 			break;
 		}
@@ -111,19 +112,17 @@ long arch_ptrace(struct task_struct *chi
  		/* Write the word at location address in the USER area. */
 		case PTRACE_POKEUSR:
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || regno > PT_MAX)
 				break;
 
-			addr >>= 2;
-
-			if (addr == PT_DCCR) {
+			if (regno == PT_DCCR) {
 				/* don't allow the tracing process to change stuff like
 				 * interrupt enable, kernel/user bit, dma enables etc.
 				 */
 				data &= DCCR_MASK;
 				data |= get_reg(child, PT_DCCR) & ~DCCR_MASK;
 			}
-			if (put_reg(child, addr, data))
+			if (put_reg(child, regno, data))
 				break;
 			ret = 0;
 			break;
@@ -142,7 +141,7 @@ long arch_ptrace(struct task_struct *chi
 					break;
 				}
 				
-				data += sizeof(unsigned long);
+				datap++;
 			}
 
 			break;
@@ -166,7 +165,7 @@ long arch_ptrace(struct task_struct *chi
 				}
 				
 				put_reg(child, i, tmp);
-				data += sizeof(unsigned long);
+				datap++;
 			}
 			
 			break;
diff -puN arch/cris/arch-v32/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-cris arch/cris/arch-v32/kernel/ptrace.c
--- a/arch/cris/arch-v32/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-cris
+++ a/arch/cris/arch-v32/kernel/ptrace.c
@@ -130,6 +130,7 @@ long arch_ptrace(struct task_struct *chi
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	unsigned int regno = addr >> 2;
 	unsigned long __user *datap = (unsigned long __user *)data;
 
 	switch (request) {
@@ -164,10 +165,10 @@ long arch_ptrace(struct task_struct *chi
 			unsigned long tmp;
 
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || regno > PT_MAX)
 				break;
 
-			tmp = get_reg(child, addr >> 2);
+			tmp = get_reg(child, regno);
 			ret = put_user(tmp, datap);
 			break;
 		}
@@ -181,19 +182,17 @@ long arch_ptrace(struct task_struct *chi
 		/* Write the word at location address in the USER area. */
 		case PTRACE_POKEUSR:
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || regno > PT_MAX)
 				break;
 
-			addr >>= 2;
-
-			if (addr == PT_CCS) {
+			if (regno == PT_CCS) {
 				/* don't allow the tracing process to change stuff like
 				 * interrupt enable, kernel/user bit, dma enables etc.
 				 */
 				data &= CCS_MASK;
 				data |= get_reg(child, PT_CCS) & ~CCS_MASK;
 			}
-			if (put_reg(child, addr, data))
+			if (put_reg(child, regno, data))
 				break;
 			ret = 0;
 			break;
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

