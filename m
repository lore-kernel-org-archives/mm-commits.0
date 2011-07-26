From: akpm@linux-foundation.org
Subject: [merged] alpha-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:00 -0700
Message-ID: <201107260753.p6Q7r3Zt003198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177Ab1GZHxo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:53:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     alpha-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so this
set_fs(USER_DS) is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/process.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/alpha/kernel/process.c~alpha-exec-remove-redundant-set_fsuser_ds arch/alpha/kernel/process.c
--- a/arch/alpha/kernel/process.c~alpha-exec-remove-redundant-set_fsuser_ds
+++ a/arch/alpha/kernel/process.c
@@ -200,7 +200,6 @@ show_regs(struct pt_regs *regs)
 void
 start_thread(struct pt_regs * regs, unsigned long pc, unsigned long sp)
 {
-	set_fs(USER_DS);
 	regs->pc = pc;
 	regs->ps = 8;
 	wrusp(sp);
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

