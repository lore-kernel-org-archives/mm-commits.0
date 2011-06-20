From: akpm@linux-foundation.org
Subject: + h8300-exec-remove-redundant-set_fsuser_ds.patch added to -mm tree
Date: Mon, 20 Jun 2011 14:48:01 -0700
Message-ID: <201106202148.p5KLm1gx023306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab1FTVzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 17:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minipli@googlemail.com, ysato@users.sourceforge.jp


The patch titled
     h8300, exec: remove redundant set_fs(USER_DS)
has been added to the -mm tree.  Its filename is
     h8300-exec-remove-redundant-set_fsuser_ds.patch

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
Subject: h8300, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so those calls to
set_fs(USER_DS) are redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/processor.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/h8300/include/asm/processor.h~h8300-exec-remove-redundant-set_fsuser_ds arch/h8300/include/asm/processor.h
--- a/arch/h8300/include/asm/processor.h~h8300-exec-remove-redundant-set_fsuser_ds
+++ a/arch/h8300/include/asm/processor.h
@@ -81,7 +81,6 @@ struct thread_struct {
 #if defined(__H8300H__)
 #define start_thread(_regs, _pc, _usp)			        \
 do {							        \
-	set_fs(USER_DS);           /* reads from user space */  \
   	(_regs)->pc = (_pc);				        \
 	(_regs)->ccr = 0x00;	   /* clear all flags */        \
 	(_regs)->er5 = current->mm->start_data;	/* GOT base */  \
@@ -91,7 +90,6 @@ do {							        \
 #if defined(__H8300S__)
 #define start_thread(_regs, _pc, _usp)			        \
 do {							        \
-	set_fs(USER_DS);           /* reads from user space */  \
 	(_regs)->pc = (_pc);				        \
 	(_regs)->ccr = 0x00;	   /* clear kernel flag */      \
 	(_regs)->exr = 0x78;       /* enable all interrupts */  \
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

