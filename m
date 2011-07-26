From: akpm@linux-foundation.org
Subject: [merged] cris-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:14 -0700
Message-ID: <201107260753.p6Q7rH3V003216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888Ab1GZHxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:53:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, jesper.nilsson@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     cris-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so those calls to
set_fs(USER_DS) are redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/arch-v10/arch/processor.h |    1 -
 arch/cris/include/arch-v32/arch/processor.h |    1 -
 2 files changed, 2 deletions(-)

diff -puN arch/cris/include/arch-v10/arch/processor.h~cris-exec-remove-redundant-set_fsuser_ds arch/cris/include/arch-v10/arch/processor.h
--- a/arch/cris/include/arch-v10/arch/processor.h~cris-exec-remove-redundant-set_fsuser_ds
+++ a/arch/cris/include/arch-v10/arch/processor.h
@@ -53,7 +53,6 @@ struct thread_struct {
  */
 
 #define start_thread(regs, ip, usp) do { \
-	set_fs(USER_DS);      \
 	regs->irp = ip;       \
 	regs->dccr |= 1 << U_DCCR_BITNR; \
 	wrusp(usp);           \
diff -puN arch/cris/include/arch-v32/arch/processor.h~cris-exec-remove-redundant-set_fsuser_ds arch/cris/include/arch-v32/arch/processor.h
--- a/arch/cris/include/arch-v32/arch/processor.h~cris-exec-remove-redundant-set_fsuser_ds
+++ a/arch/cris/include/arch-v32/arch/processor.h
@@ -47,7 +47,6 @@ struct thread_struct {
  */
 #define start_thread(regs, ip, usp) \
 do { \
-	set_fs(USER_DS); \
 	regs->erp = ip; \
 	regs->ccs |= 1 << (U_CCS_BITNR + CCS_SHIFT); \
 	wrusp(usp); \
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

