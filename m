From: akpm@linux-foundation.org
Subject: [merged] sh64-kernel-use-usp-instead-of-fn.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:36:58 -0800
Message-ID: <5283e2ea.wpei5lGiqdC3jJK4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3KMUg7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:36:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lethal@linux-sh.org, gang.chen@asianux.com

Subject: [merged] sh64-kernel-use-usp-instead-of-fn.patch removed from -mm tree
To: gang.chen@asianux.com,lethal@linux-sh.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:36:58 -0800


The patch titled
     Subject: sh64: kernel: use 'usp' instead of 'fn'
has been removed from the -mm tree.  Its filename was
     sh64-kernel-use-usp-instead-of-fn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: sh64: kernel: use 'usp' instead of 'fn'

'fn' is not defined, according to the implementation copy_thread() in
'sh32', need use 'usp' instead of.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/process_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/kernel/process_64.c~sh64-kernel-use-usp-instead-of-fn arch/sh/kernel/process_64.c
--- a/arch/sh/kernel/process_64.c~sh64-kernel-use-usp-instead-of-fn
+++ a/arch/sh/kernel/process_64.c
@@ -393,7 +393,7 @@ int copy_thread(unsigned long clone_flag
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		memset(childregs, 0, sizeof(struct pt_regs));
 		childregs->regs[2] = (unsigned long)arg;
-		childregs->regs[3] = (unsigned long)fn;
+		childregs->regs[3] = (unsigned long)usp;
 		childregs->sr = (1 << 30); /* not user_mode */
 		childregs->sr |= SR_FD; /* Invalidate FPU flag */
 		p->thread.pc = (unsigned long) ret_from_kernel_thread;
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str.patch
linux-next.patch

