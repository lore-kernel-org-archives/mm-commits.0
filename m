From: akpm@linux-foundation.org
Subject: + uml-remove-unused-variables-in-the-context-switcher.patch added to -mm tree
Date: Thu, 15 Nov 2007 16:13:47 -0800
Message-ID: <200711160013.lAG0DlbL023188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603AbXKPANv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 19:13:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magotari@gmail.com, jdike@linux.intel.com


The patch titled
     uml: remove unused variables in the context switcher
has been added to the -mm tree.  Its filename is
     uml-remove-unused-variables-in-the-context-switcher.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove unused variables in the context switcher
From: Karol Swietlicki <magotari@gmail.com>

This patch removes a variable which was not used in two functions.  Yet
another code cleanup, nothing really significant.

Please note that I could not test this on x86_64. I don't have the
hardware for it.

[ jdike - Bits of tidying around the affected code.  Also, it's fine on
x86_64 ]

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/process.c      |   19 ++++++++-----------
 arch/um/sys-i386/ptrace.c     |    6 +++---
 arch/um/sys-i386/tls.c        |    2 +-
 arch/um/sys-x86_64/syscalls.c |    2 +-
 4 files changed, 13 insertions(+), 16 deletions(-)

diff -puN arch/um/kernel/process.c~uml-remove-unused-variables-in-the-context-switcher arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-remove-unused-variables-in-the-context-switcher
+++ a/arch/um/kernel/process.c
@@ -81,12 +81,12 @@ static inline void set_current(struct ta
 		{ external_pid(task), task });
 }
 
-extern void arch_switch_to(struct task_struct *from, struct task_struct *to);
+extern void arch_switch_to(struct task_struct *to);
 
 void *_switch_to(void *prev, void *next, void *last)
 {
 	struct task_struct *from = prev;
-	struct task_struct *to= next;
+	struct task_struct *to = next;
 
 	to->thread.prev_sched = from;
 	set_current(to);
@@ -94,16 +94,15 @@ void *_switch_to(void *prev, void *next,
 	do {
 		current->thread.saved_task = NULL;
 
-		switch_threads(&from->thread.switch_buf,
-			       &to->thread.switch_buf);
+		switch_threads(&from->thread.switch_buf, &to->thread.switch_buf);
 
-		arch_switch_to(current->thread.prev_sched, current);
+		arch_switch_to(current);
 
 		if (current->thread.saved_task)
 			show_regs(&(current->thread.regs));
-		next= current->thread.saved_task;
-		prev= current;
-	} while(current->thread.saved_task);
+		next = current->thread.saved_task;
+		prev = current;
+	} while (current->thread.saved_task);
 
 	return current->thread.prev_sched;
 
@@ -161,8 +160,6 @@ void new_thread_handler(void)
 void fork_handler(void)
 {
 	force_flush_all();
-	if (current->thread.prev_sched == NULL)
-		panic("blech");
 
 	schedule_tail(current->thread.prev_sched);
 
@@ -171,7 +168,7 @@ void fork_handler(void)
 	 * arch_switch_to isn't needed. We could want to apply this to
 	 * improve performance. -bb
 	 */
-	arch_switch_to(current->thread.prev_sched, current);
+	arch_switch_to(current);
 
 	current->thread.prev_sched = NULL;
 
diff -puN arch/um/sys-i386/ptrace.c~uml-remove-unused-variables-in-the-context-switcher arch/um/sys-i386/ptrace.c
--- a/arch/um/sys-i386/ptrace.c~uml-remove-unused-variables-in-the-context-switcher
+++ a/arch/um/sys-i386/ptrace.c
@@ -8,11 +8,11 @@
 #include "asm/uaccess.h"
 #include "skas.h"
 
-extern int arch_switch_tls(struct task_struct *from, struct task_struct *to);
+extern int arch_switch_tls(struct task_struct *to);
 
-void arch_switch_to(struct task_struct *from, struct task_struct *to)
+void arch_switch_to(struct task_struct *to)
 {
-	int err = arch_switch_tls(from, to);
+	int err = arch_switch_tls(to);
 	if (!err)
 		return;
 
diff -puN arch/um/sys-i386/tls.c~uml-remove-unused-variables-in-the-context-switcher arch/um/sys-i386/tls.c
--- a/arch/um/sys-i386/tls.c~uml-remove-unused-variables-in-the-context-switcher
+++ a/arch/um/sys-i386/tls.c
@@ -172,7 +172,7 @@ void clear_flushed_tls(struct task_struc
  * SKAS patch.
  */
 
-int arch_switch_tls(struct task_struct *from, struct task_struct *to)
+int arch_switch_tls(struct task_struct *to)
 {
 	if (!host_supports_tls)
 		return 0;
diff -puN arch/um/sys-x86_64/syscalls.c~uml-remove-unused-variables-in-the-context-switcher arch/um/sys-x86_64/syscalls.c
--- a/arch/um/sys-x86_64/syscalls.c~uml-remove-unused-variables-in-the-context-switcher
+++ a/arch/um/sys-x86_64/syscalls.c
@@ -105,7 +105,7 @@ long sys_clone(unsigned long clone_flags
 	return ret;
 }
 
-void arch_switch_to(struct task_struct *from, struct task_struct *to)
+void arch_switch_to(struct task_struct *to)
 {
 	if ((to->thread.arch.fs == 0) || (to->mm == NULL))
 		return;
_

Patches currently in -mm which might be from magotari@gmail.com are

uml-remove-xmm-checking-on-x86.patch
uml-fix-urls-in-kconfig-and-help-strings.patch
uml-improve-detection-of-host-cmov.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes-fix.patch
uml-remove-now-unused-code.patch
uml-gprof-needs-to-depend-on-frame_pointer.patch
uml-remove-unused-variables-in-the-context-switcher.patch
uml-convert-functions-to-void.patch
