From: akpm@linux-foundation.org
Subject: [merged] alpha-forward-declare-struct-pt_regs-in-processorh.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:16:03 -0700
Message-ID: <55355073.XZK4nsEtIZihUEm5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbbDTTJm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:09:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: forward declare struct pt_regs in processor.h
has been removed from the -mm tree.  Its filename was
     alpha-forward-declare-struct-pt_regs-in-processorh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: alpha: forward declare struct pt_regs in processor.h

Removal of exec domains uncovered this new warning.  processor.h re-used
struct pt_regs from personality.h which is now gone.

./arch/alpha/include/asm/processor.h:47:33: warning: 'struct pt_regs' declared inside parameter list [enabled by default]

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/processor.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/alpha/include/asm/processor.h~alpha-forward-declare-struct-pt_regs-in-processorh arch/alpha/include/asm/processor.h
--- a/arch/alpha/include/asm/processor.h~alpha-forward-declare-struct-pt_regs-in-processorh
+++ a/arch/alpha/include/asm/processor.h
@@ -44,6 +44,7 @@ struct task_struct;
 extern unsigned long thread_saved_pc(struct task_struct *);
 
 /* Do necessary setup to start up a newly executed thread.  */
+struct pt_regs;
 extern void start_thread(struct pt_regs *, unsigned long, unsigned long);
 
 /* Free all resources held by a thread. */
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
linux-next.patch

