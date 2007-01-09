From: akpm@osdl.org
Subject: + uml-remove-unused-variable-and-function.patch added to -mm tree
Date: Tue, 09 Jan 2007 12:57:53 -0800
Message-ID: <200701092057.l09Kvrms015079@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43458 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932441AbXAIU6B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:58:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: remove unused variable and function
has been added to the -mm tree.  Its filename is
     uml-remove-unused-variable-and-function.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove unused variable and function
From: Jeff Dike <jdike@addtoit.com>

syscall_index and next_syscall_index turn out not to be used.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch
