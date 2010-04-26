From: akpm@linux-foundation.org
Subject: + arch-avr32-fix-build-failure-caused-by-wrong-prototype.patch added to -mm tree
Date: Mon, 26 Apr 2010 15:22:09 -0700
Message-ID: <201004262222.o3QMM9oW023107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754641Ab0DZWW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 18:22:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterhuewe@gmx.de, hch@lst.de, hskinnemoen@atmel.com


The patch titled
     arch/avr32: fix build failure caused by wrong prototype
has been added to the -mm tree.  Its filename is
     arch-avr32-fix-build-failure-caused-by-wrong-prototype.patch

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
Subject: arch/avr32: fix build failure caused by wrong prototype
From: Peter Huewe <peterhuewe@gmx.de>

This patch fixes a build failure introduced by 1d8393171 ("avr32: use
generic ptrace_resume code") which had the static keyword as a leftover.

arch/avr32/kernel/ptrace.c:32: error: static declaration of `user_enable_single_step' follows non-static declaration
include/linux/ptrace.h:268: error: previous declaration of `user_enable_single_step' was here

References:
[1]http://kisskb.ellerman.id.au/kisskb/buildresult/2448162/

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/avr32/kernel/ptrace.c~arch-avr32-fix-build-failure-caused-by-wrong-prototype arch/avr32/kernel/ptrace.c
--- a/arch/avr32/kernel/ptrace.c~arch-avr32-fix-build-failure-caused-by-wrong-prototype
+++ a/arch/avr32/kernel/ptrace.c
@@ -28,7 +28,7 @@ static struct pt_regs *get_user_regs(str
 				  THREAD_SIZE - sizeof(struct pt_regs));
 }
 
-static void user_enable_single_step(struct task_struct *tsk)
+void user_enable_single_step(struct task_struct *tsk)
 {
 	pr_debug("user_enable_single_step: pid=%u, PC=0x%08lx, SR=0x%08lx\n",
 		 tsk->pid, task_pt_regs(tsk)->pc, task_pt_regs(tsk)->sr);
_

Patches currently in -mm which might be from peterhuewe@gmx.de are

arch-avr32-fix-build-failure-caused-by-wrong-prototype.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch

