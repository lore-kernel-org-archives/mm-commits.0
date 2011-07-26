From: akpm@linux-foundation.org
Subject: [merged] mips-exec-remove-redundant-addr_limit-assignment.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:53 -0700
Message-ID: <201107260755.p6Q7tuoe003507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753303Ab1GZH4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:56:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips, exec: remove redundant addr_limit assignment
has been removed from the -mm tree.  Its filename was
     mips-exec-remove-redundant-addr_limit-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips, exec: remove redundant addr_limit assignment
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() via set_fs(USER_DS)
so this assignment is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/process.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/mips/kernel/process.c~mips-exec-remove-redundant-addr_limit-assignment arch/mips/kernel/process.c
--- a/arch/mips/kernel/process.c~mips-exec-remove-redundant-addr_limit-assignment
+++ a/arch/mips/kernel/process.c
@@ -103,7 +103,6 @@ void start_thread(struct pt_regs * regs,
 		__init_dsp();
 	regs->cp0_epc = pc;
 	regs->regs[29] = sp;
-	current_thread_info()->addr_limit = USER_DS;
 }
 
 void exit_thread(void)
_

Patches currently in -mm which might be from minipli@googlemail.com are

origin.patch
linux-next.patch
arm-exec-remove-redundant-set_fsuser_ds.patch
ia64-exec-remove-redundant-set_fsuser_ds.patch
unicore32-exec-remove-redundant-set_fsuser_ds.patch
parisc-exec-remove-redundant-set_fsuser_ds.patch
s390-exec-remove-redundant-set_fsuser_ds.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch
frv-exec-remove-redundant-set_fsuser_ds.patch
mn10300-exec-remove-redundant-set_fsuser_ds.patch

