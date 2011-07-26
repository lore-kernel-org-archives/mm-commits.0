From: akpm@linux-foundation.org
Subject: [merged] m32r-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:03 -0700
Message-ID: <201107260753.p6Q7r61M003207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111Ab1GZHx6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:53:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     m32r-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so this
set_fs(USER_DS) is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/asm/processor.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/m32r/include/asm/processor.h~m32r-exec-remove-redundant-set_fsuser_ds arch/m32r/include/asm/processor.h
--- a/arch/m32r/include/asm/processor.h~m32r-exec-remove-redundant-set_fsuser_ds
+++ a/arch/m32r/include/asm/processor.h
@@ -106,7 +106,6 @@ struct thread_struct {
 
 #define start_thread(regs, new_pc, new_spu) 				\
 	do {								\
-		set_fs(USER_DS); 					\
 		regs->psw = (regs->psw | USERPS_BPSW) & 0x0000FFFFUL;	\
 		regs->bpc = new_pc;					\
 		regs->spu = new_spu;					\
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

