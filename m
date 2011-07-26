From: akpm@linux-foundation.org
Subject: [merged] h8300-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:53:57 -0700
Message-ID: <201107260753.p6Q7r0ES003192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753178Ab1GZHxp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:53:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     h8300-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
arm-exec-remove-redundant-set_fsuser_ds.patch
ia64-exec-remove-redundant-set_fsuser_ds.patch
unicore32-exec-remove-redundant-set_fsuser_ds.patch
parisc-exec-remove-redundant-set_fsuser_ds.patch
s390-exec-remove-redundant-set_fsuser_ds.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch
frv-exec-remove-redundant-set_fsuser_ds.patch
mn10300-exec-remove-redundant-set_fsuser_ds.patch

