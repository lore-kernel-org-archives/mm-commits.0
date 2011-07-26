From: akpm@linux-foundation.org
Subject: [merged] microblaze-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:50 -0700
Message-ID: <201107260755.p6Q7trL7003502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab1GZH4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:56:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, monstr@monstr.eu, mm-commits@vger.kernel.org


The patch titled
     microblaze, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     microblaze-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: microblaze, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so this
set_fs(USER_DS) is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Tested-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/process.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/microblaze/kernel/process.c~microblaze-exec-remove-redundant-set_fsuser_ds arch/microblaze/kernel/process.c
--- a/arch/microblaze/kernel/process.c~microblaze-exec-remove-redundant-set_fsuser_ds
+++ a/arch/microblaze/kernel/process.c
@@ -237,7 +237,6 @@ unsigned long get_wchan(struct task_stru
 /* Set up a thread for executing a new program */
 void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long usp)
 {
-	set_fs(USER_DS);
 	regs->pc = pc;
 	regs->r1 = usp;
 	regs->pt_mode = 0;
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

