From: akpm@linux-foundation.org
Subject: [merged] frv-exec-remove-redundant-set_fsuser_ds.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:27:46 -0700
Message-ID: <201107271926.p6RJQX02003127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab1G0T0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:26:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv, exec: remove redundant set_fs(USER_DS)
has been removed from the -mm tree.  Its filename was
     frv-exec-remove-redundant-set_fsuser_ds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so those calls to
set_fs(USER_DS) are redundant.

Also removed the dead code in flush_thread().

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: David Howells <dhowells@redhat.com>
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
arm-exec-remove-redundant-set_fsuser_ds.patch
ia64-exec-remove-redundant-set_fsuser_ds.patch
unicore32-exec-remove-redundant-set_fsuser_ds.patch
parisc-exec-remove-redundant-set_fsuser_ds.patch
s390-exec-remove-redundant-set_fsuser_ds.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch

