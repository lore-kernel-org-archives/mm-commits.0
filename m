From: akpm@linux-foundation.org
Subject: [merged] arch-avr32-fix-build-failure-caused-by-wrong-prototype.patch removed from -mm tree
Date: Wed, 28 Apr 2010 11:02:58 -0400
Message-ID: <201004281804.o3SI4V7b010968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756109Ab0D1SEx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:04:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterhuewe@gmx.de, hch@lst.de, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     arch/avr32: fix build failure caused by wrong prototype
has been removed from the -mm tree.  Its filename was
     arch-avr32-fix-build-failure-caused-by-wrong-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch

