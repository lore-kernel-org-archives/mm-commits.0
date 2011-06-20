From: akpm@linux-foundation.org
Subject: + cris-exec-remove-redundant-set_fsuser_ds.patch added to -mm tree
Date: Mon, 20 Jun 2011 14:47:57 -0700
Message-ID: <201106202147.p5KLlvIq023291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755471Ab1FTVsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 17:48:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minipli@googlemail.com, jesper.nilsson@axis.com


The patch titled
     cris, exec: remove redundant set_fs(USER_DS)
has been added to the -mm tree.  Its filename is
     cris-exec-remove-redundant-set_fsuser_ds.patch

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

