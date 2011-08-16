From: akpm@linux-foundation.org
Subject: [merged] s390-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:51:46 -0700
Message-ID: <201108161848.p7GImrcB015407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217Ab1HPSyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:54:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     s390-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so those calls to
set_fs(USER_DS) are redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/processor.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/s390/include/asm/processor.h~s390-exec-remove-redundant-set_fsuser_ds arch/s390/include/asm/processor.h
--- a/arch/s390/include/asm/processor.h~s390-exec-remove-redundant-set_fsuser_ds
+++ a/arch/s390/include/asm/processor.h
@@ -119,14 +119,12 @@ struct stack_frame {
  * Do necessary setup to start up a new thread.
  */
 #define start_thread(regs, new_psw, new_stackp) do {		\
-	set_fs(USER_DS);					\
 	regs->psw.mask	= psw_user_bits;			\
 	regs->psw.addr	= new_psw | PSW_ADDR_AMODE;		\
 	regs->gprs[15]	= new_stackp;				\
 } while (0)
 
 #define start_thread31(regs, new_psw, new_stackp) do {		\
-	set_fs(USER_DS);					\
 	regs->psw.mask	= psw_user32_bits;			\
 	regs->psw.addr	= new_psw | PSW_ADDR_AMODE;		\
 	regs->gprs[15]	= new_stackp;				\
_

Patches currently in -mm which might be from minipli@googlemail.com are

linux-next.patch
arm-exec-remove-redundant-set_fsuser_ds.patch
ia64-exec-remove-redundant-set_fsuser_ds.patch
unicore32-exec-remove-redundant-set_fsuser_ds.patch
parisc-exec-remove-redundant-set_fsuser_ds.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch

