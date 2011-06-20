From: akpm@linux-foundation.org
Subject: + frv-exec-remove-redundant-set_fsuser_ds.patch added to -mm tree
Date: Mon, 20 Jun 2011 14:47:59 -0700
Message-ID: <201106202147.p5KLlxtT023294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755934Ab1FTVyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 17:54:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minipli@googlemail.com, dhowells@redhat.com


The patch titled
     frv, exec: remove redundant set_fs(USER_DS)
has been added to the -mm tree.  Its filename is
     frv-exec-remove-redundant-set_fsuser_ds.patch

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
Subject: frv, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so those calls to
set_fs(USER_DS) are redundant.

Also removed the dead code in flush_thread().

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/processor.h |    1 -
 arch/frv/kernel/process.c        |    5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/frv/include/asm/processor.h~frv-exec-remove-redundant-set_fsuser_ds arch/frv/include/asm/processor.h
--- a/arch/frv/include/asm/processor.h~frv-exec-remove-redundant-set_fsuser_ds
+++ a/arch/frv/include/asm/processor.h
@@ -97,7 +97,6 @@ extern struct task_struct *__kernel_curr
  */
 #define start_thread(_regs, _pc, _usp)			\
 do {							\
-	set_fs(USER_DS); /* reads from user space */	\
 	__frame = __kernel_frame0_ptr;			\
 	__frame->pc	= (_pc);			\
 	__frame->psr	&= ~PSR_S;			\
diff -puN arch/frv/kernel/process.c~frv-exec-remove-redundant-set_fsuser_ds arch/frv/kernel/process.c
--- a/arch/frv/kernel/process.c~frv-exec-remove-redundant-set_fsuser_ds
+++ a/arch/frv/kernel/process.c
@@ -143,10 +143,7 @@ void machine_power_off(void)
 
 void flush_thread(void)
 {
-#if 0 //ndef NO_FPU
-	unsigned long zero = 0;
-#endif
-	set_fs(USER_DS);
+	/* nothing */
 }
 
 inline unsigned long user_stack(const struct pt_regs *regs)
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

