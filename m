From: akpm@linux-foundation.org
Subject: [merged] unicore32-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Thu, 17 Nov 2011 12:21:27 -0800
Message-ID: <201111172021.pAHKLRnU018387@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:33946 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1KQUVb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 15:21:31 -0500
Received: by eyg5 with SMTP id 5so48436eyg.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 12:21:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, gxt@mprc.pku.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: unicore32, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     unicore32-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mathias Krause <minipli@googlemail.com>
Subject: unicore32, exec: remove redundant set_fs(USER_DS)

The address limit is already set in flush_old_exec() so this
set_fs(USER_DS) is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/include/asm/processor.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/unicore32/include/asm/processor.h~unicore32-exec-remove-redundant-set_fsuser_ds arch/unicore32/include/asm/processor.h
--- a/arch/unicore32/include/asm/processor.h~unicore32-exec-remove-redundant-set_fsuser_ds
+++ a/arch/unicore32/include/asm/processor.h
@@ -53,7 +53,6 @@ struct thread_struct {
 #define start_thread(regs, pc, sp)					\
 ({									\
 	unsigned long *stack = (unsigned long *)sp;			\
-	set_fs(USER_DS);						\
 	memset(regs->uregs, 0, sizeof(regs->uregs));			\
 	regs->UCreg_asr = USER_MODE;					\
 	regs->UCreg_pc = pc & ~1;	/* pc */                        \
_

Patches currently in -mm which might be from minipli@googlemail.com are

linux-next.patch
arm-exec-remove-redundant-set_fsuser_ds.patch
ia64-exec-remove-redundant-set_fsuser_ds.patch
parisc-exec-remove-redundant-set_fsuser_ds.patch

