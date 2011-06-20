From: akpm@linux-foundation.org
Subject: + unicore32-exec-remove-redundant-set_fsuser_ds.patch added to -mm tree
Date: Mon, 20 Jun 2011 14:48:26 -0700
Message-ID: <201106202148.p5KLmQP8023371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175Ab1FTVtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 17:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minipli@googlemail.com, gxt@mprc.pku.edu.cn


The patch titled
     unicore32, exec: remove redundant set_fs(USER_DS)
has been added to the -mm tree.  Its filename is
     unicore32-exec-remove-redundant-set_fsuser_ds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unicore32, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>

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

origin.patch
linux-next.patch
alpha-exec-remove-redundant-set_fsuser_ds.patch
arm-exec-remove-redundant-set_fsuser_ds.patch
cris-exec-remove-redundant-set_fsuser_ds.patch
frv-exec-remove-redundant-set_fsuser_ds.patch
h8300-exec-remove-redundant-set_fsuser_ds.patch
ia64-exec-remove-redundant-set_fsuser_ds.patch
m32r-exec-remove-redundant-set_fsuser_ds.patch
m68k-exec-remove-redundant-set_fsuser_ds.patch
microblaze-exec-remove-redundant-set_fsuser_ds.patch
mips-exec-remove-redundant-addr_limit-assignment.patch
mn10300-exec-remove-redundant-set_fsuser_ds.patch
parisc-exec-remove-redundant-set_fsuser_ds.patch
ppc-exec-remove-redundant-set_fsuser_ds.patch
s390-exec-remove-redundant-set_fsuser_ds.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch
um-exec-remove-redundant-set_fsuser_ds.patch
unicore32-exec-remove-redundant-set_fsuser_ds.patch

