From: akpm@linux-foundation.org
Subject: + ptrace-cleanup-arch_ptrace-on-tile.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:42:15 -0700
Message-ID: <201010042342.o94NgFAd022787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755853Ab0JDXvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:51:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, cmetcalf@tilera.com


The patch titled
     ptrace: cleanup arch_ptrace() on tile
has been added to the -mm tree.  Its filename is
     ptrace-cleanup-arch_ptrace-on-tile.patch

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
Subject: ptrace: cleanup arch_ptrace() on tile
From: Namhyung Kim <namhyung@gmail.com>

Remove checking @addr less than 0 because @addr is now unsigned.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/ptrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/tile/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-tile arch/tile/kernel/ptrace.c
--- a/arch/tile/kernel/ptrace.c~ptrace-cleanup-arch_ptrace-on-tile
+++ a/arch/tile/kernel/ptrace.c
@@ -85,7 +85,7 @@ long arch_ptrace(struct task_struct *chi
 	case PTRACE_PEEKUSR:  /* Read register from pt_regs. */
 		if (addr & (sizeof(data)-1))
 			break;
-		if (addr < 0 || addr >= PTREGS_SIZE)
+		if (addr >= PTREGS_SIZE)
 			break;
 		tmp = getreg(child, addr);   /* Read register */
 		ret = put_user(tmp, datap);
@@ -94,7 +94,7 @@ long arch_ptrace(struct task_struct *chi
 	case PTRACE_POKEUSR:  /* Write register in pt_regs. */
 		if (addr & (sizeof(data)-1))
 			break;
-		if (addr < 0 || addr >= PTREGS_SIZE)
+		if (addr >= PTREGS_SIZE)
 			break;
 		putreg(child, addr, data);   /* Write register */
 		ret = 0;
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

