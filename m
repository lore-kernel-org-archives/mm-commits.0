From: akpm@linux-foundation.org
Subject: + sh64-kernel-remove-useless-variable-regs.patch added to -mm
 tree
Date: Tue, 30 Jul 2013 16:31:28 -0700
Message-ID: <51f84cd0.oWXiWtCOdkEMygIT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab3G3Xb3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 19:31:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lethal@linux-sh.org, gang.chen@asianux.com

Subject: + sh64-kernel-remove-useless-variable-regs.patch added to -mm tree
To: gang.chen@asianux.com,lethal@linux-sh.org
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 16:31:28 -0700


The patch titled
     Subject: sh64: kernel: remove useless variable 'regs'
has been added to the -mm tree.  Its filename is
     sh64-kernel-remove-useless-variable-regs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh64-kernel-remove-useless-variable-regs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh64-kernel-remove-useless-variable-regs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: sh64: kernel: remove useless variable 'regs'

Remove useless variable 'regs' to avoid the related warnings (warning is
treated as error).

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/process_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/kernel/process_64.c~sh64-kernel-remove-useless-variable-regs arch/sh/kernel/process_64.c
--- a/arch/sh/kernel/process_64.c~sh64-kernel-remove-useless-variable-regs
+++ a/arch/sh/kernel/process_64.c
@@ -374,7 +374,7 @@ asmlinkage void ret_from_kernel_thread(v
 int copy_thread(unsigned long clone_flags, unsigned long usp,
 		unsigned long arg, struct task_struct *p)
 {
-	struct pt_regs *childregs, *regs = current_pt_regs();
+	struct pt_regs *childregs;
 
 #ifdef CONFIG_SH_FPU
 	/* can't happen for a kernel thread */
_

Patches currently in -mm which might be from gang.chen@asianux.com are

sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch
mm-page_allocc-use-__paginginit-instead-of-__init.patch
kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch
linux-next.patch

