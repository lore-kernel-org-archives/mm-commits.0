From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-on-h8300.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:41:51 -0700
Message-ID: <201010042341.o94NfpQ2022737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757380Ab0JDXwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, ysato@users.sourceforge.jp


The patch titled
     ptrace: cleanup arch_ptrace() on h8300
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-on-h8300.patch

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
Subject: ptrace: cleanup arch_ptrace() on h8300
From: Namhyung Kim <namhyung@gmail.com>

Use new 'regno', 'datap' variables in order to remove duplicated
expressions and unnecessary castings. Alse remove checking @addr
less than 0 because addr is now unsigned.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/ptrace.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN arch/h8300/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-h8300 arch/h8300/kernel/ptrace.c
--- a/arch/h8300/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-h8300
+++ a/arch/h8300/kernel/ptrace.c
@@ -54,24 +54,25 @@ long arch_ptrace(struct task_struct *chi
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	int regno = addr >> 2;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
 		case PTRACE_PEEKUSR: {
 			unsigned long tmp = 0;
 			
-			if ((addr & 3) || addr < 0 || addr >= sizeof(struct user)) {
+			if ((addr & 3) || addr >= sizeof(struct user)) {
 				ret = -EIO;
 				break ;
 			}
 			
 		        ret = 0;  /* Default return condition */
-			addr = addr >> 2; /* temporary hack. */
 
-			if (addr < H8300_REGS_NO)
-				tmp = h8300_get_reg(child, addr);
+			if (regno < H8300_REGS_NO)
+				tmp = h8300_get_reg(child, regno);
 			else {
-				switch(addr) {
+				switch (regno) {
 				case 49:
 					tmp = child->mm->start_code;
 					break ;
@@ -89,24 +90,23 @@ long arch_ptrace(struct task_struct *chi
 				}
 			}
 			if (!ret)
-				ret = put_user(tmp,(unsigned long *) data);
+				ret = put_user(tmp, datap);
 			break ;
 		}
 
       /* when I and D space are separate, this will have to be fixed. */
 		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
-			if ((addr & 3) || addr < 0 || addr >= sizeof(struct user)) {
+			if ((addr & 3) || addr >= sizeof(struct user)) {
 				ret = -EIO;
 				break ;
 			}
-			addr = addr >> 2; /* temporary hack. */
 			    
-			if (addr == PT_ORIG_ER0) {
+			if (regno == PT_ORIG_ER0) {
 				ret = -EIO;
 				break ;
 			}
-			if (addr < H8300_REGS_NO) {
-				ret = h8300_put_reg(child, addr, data);
+			if (regno < H8300_REGS_NO) {
+				ret = h8300_put_reg(child, regno, data);
 				break ;
 			}
 			ret = -EIO;
@@ -117,11 +117,11 @@ long arch_ptrace(struct task_struct *chi
 			unsigned long tmp;
 			for (i = 0; i < H8300_REGS_NO; i++) {
 			    tmp = h8300_get_reg(child, i);
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
@@ -131,12 +131,12 @@ long arch_ptrace(struct task_struct *chi
 			int i;
 			unsigned long tmp;
 			for (i = 0; i < H8300_REGS_NO; i++) {
-			    if (get_user(tmp, (unsigned long *) data)) {
+			    if (get_user(tmp, datap)) {
 				ret = -EFAULT;
 				break;
 			    }
 			    h8300_put_reg(child, i, tmp);
-			    data += sizeof(unsigned long);
+			    datap++;
 			}
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

