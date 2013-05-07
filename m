From: akpm@linux-foundation.org
Subject: [merged] sparc32-make-show_stack-acquire-%fp-if-_ksp-is-not-specified.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:03 -0700
Message-ID: <20130507174703.A1B9E5A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:49168 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759177Ab3EGRrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:47:05 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so84987qen.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:47:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, bhelgaas@google.com, davem@davemloft.net, fengguang.wu@intel.com, heiko.carstens@de.ibm.com, jesper.nilsson@axis.com, sam@ravnborg.org, schwidefsky@de.ibm.com, vapier@gentoo.org, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc32: make show_stack() acquire %fp if @_ksp is not specified
has been removed from the -mm tree.  Its filename was
     sparc32-make-show_stack-acquire-%fp-if-_ksp-is-not-specified.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: sparc32: make show_stack() acquire %fp if @_ksp is not specified

show_stack(current or NULL, NULL) is used by arch-independent code to dump
backtrace of the current task; however, sparc32 show_stack() doesn't
implement it and wouldn't print any backtrace when NULL @_ksp is specfied.

Make show_stack() acquire and use %fp if @tsk is NULL or current and @_ksp
is NULL.  This makes %fp fetching in dump_stack() unnecessary.  Make it
use NULL for @_ksp instead.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/process_32.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN arch/sparc/kernel/process_32.c~sparc32-make-show_stack-acquire-%fp-if-_ksp-is-not-specified arch/sparc/kernel/process_32.c
--- a/arch/sparc/kernel/process_32.c~sparc32-make-show_stack-acquire-%fp-if-_ksp-is-not-specified
+++ a/arch/sparc/kernel/process_32.c
@@ -142,11 +142,13 @@ void show_stack(struct task_struct *tsk,
 	struct reg_window32 *rw;
 	int count = 0;
 
-	if (tsk != NULL)
-		task_base = (unsigned long) task_stack_page(tsk);
-	else
-		task_base = (unsigned long) current_thread_info();
+	if (!tsk)
+		tsk = current;
 
+	if (tsk == current && !_ksp)
+		__asm__ __volatile__("mov	%%fp, %0" : "=r" (_ksp));
+
+	task_base = (unsigned long) task_stack_page(tsk);
 	fp = (unsigned long) _ksp;
 	do {
 		/* Bogus frame pointer? */
@@ -164,11 +166,7 @@ void show_stack(struct task_struct *tsk,
 
 void dump_stack(void)
 {
-	unsigned long *ksp;
