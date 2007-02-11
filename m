From: akpm@linux-foundation.org
Subject: - uml-remove-unused-variable-and-function.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:07 -0800
Message-ID: <200702112249.l1BMn7HW015696@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59815 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691AbXBKWtJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: remove unused variable and function
has been removed from the -mm tree.  Its filename was
     uml-remove-unused-variable-and-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: remove unused variable and function
From: Jeff Dike <jdike@addtoit.com>

syscall_index and next_syscall_index turn out not to be used.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/kern_util.h |    1 -
 arch/um/kernel/syscall.c    |   16 ----------------
 2 files changed, 17 deletions(-)

diff -puN arch/um/include/kern_util.h~uml-remove-unused-variable-and-function arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-remove-unused-variable-and-function
+++ a/arch/um/include/kern_util.h
@@ -61,7 +61,6 @@ extern int set_signals(int enable);
 extern void force_sigbus(void);
 extern int pid_to_processor_id(int pid);
 extern void deliver_signals(void *t);
-extern int next_syscall_index(int max);
 extern int next_trap_index(int max);
 extern void default_idle(void);
 extern void finish_fork(void);
diff -puN arch/um/kernel/syscall.c~uml-remove-unused-variable-and-function arch/um/kernel/syscall.c
--- a/arch/um/kernel/syscall.c~uml-remove-unused-variable-and-function
+++ a/arch/um/kernel/syscall.c
@@ -149,22 +149,6 @@ long sys_olduname(struct oldold_utsname 
 	return error;
 }
 
-DEFINE_SPINLOCK(syscall_lock);
-
-static int syscall_index = 0;
-
-int next_syscall_index(int limit)
-{
-	int ret;
-
-	spin_lock(&syscall_lock);
-	ret = syscall_index;
-	if(++syscall_index == limit)
-		syscall_index = 0;
-	spin_unlock(&syscall_lock);
-	return(ret);
-}
-
 int kernel_execve(const char *filename, char *const argv[], char *const envp[])
 {
 	mm_segment_t fs;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
