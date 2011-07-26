From: akpm@linux-foundation.org
Subject: [merged] um-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:20 -0700
Message-ID: <201107260753.p6Q7rNYr003223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126Ab1GZHyC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     um-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so this
set_fs(USER_DS) is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/exec.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/um/kernel/exec.c~um-exec-remove-redundant-set_fsuser_ds arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~um-exec-remove-redundant-set_fsuser_ds
+++ a/arch/um/kernel/exec.c
@@ -38,7 +38,6 @@ void flush_thread(void)
 
 void start_thread(struct pt_regs *regs, unsigned long eip, unsigned long esp)
 {
-	set_fs(USER_DS);
 	PT_REGS_IP(regs) = eip;
 	PT_REGS_SP(regs) = esp;
 }
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

