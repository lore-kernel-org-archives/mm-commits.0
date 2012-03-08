From: akpm@linux-foundation.org
Subject: [merged] arm-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:41 -0800
Message-ID: <20120308191741.60607A06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35115 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758086Ab2CHTRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:42 -0500
Received: by mail-ee0-f74.google.com with SMTP id c41so30194eek.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arm, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     arm-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mathias Krause <minipli@googlemail.com>
Subject: arm, exec: remove redundant set_fs(USER_DS)

The address limit is already set in flush_old_exec() so this
set_fs(USER_DS) is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/processor.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/arm/include/asm/processor.h~arm-exec-remove-redundant-set_fsuser_ds arch/arm/include/asm/processor.h
--- a/arch/arm/include/asm/processor.h~arm-exec-remove-redundant-set_fsuser_ds
+++ a/arch/arm/include/asm/processor.h
@@ -56,7 +56,6 @@ struct thread_struct {
 #define start_thread(regs,pc,sp)					\
 ({									\
 	unsigned long *stack = (unsigned long *)sp;			\
-	set_fs(USER_DS);						\
 	memset(regs->uregs, 0, sizeof(regs->uregs));			\
 	if (current->personality & ADDR_LIMIT_32BIT)			\
 		regs->ARM_cpsr = USR_MODE;				\
_

Patches currently in -mm which might be from minipli@googlemail.com are

linux-next.patch

