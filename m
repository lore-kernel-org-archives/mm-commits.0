From: akpm@osdl.org
Subject: + uml-style-fixes-in-startup-code.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:03:45 -0800
Message-ID: <200701250603.l0P63jCO007581@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48784 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965375AbXAYGDs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:03:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: style fixes in startup code
has been added to the -mm tree.  Its filename is
     uml-style-fixes-in-startup-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: style fixes in startup code
From: Jeff Dike <jdike@addtoit.com>

Some style fixes in startup.c.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/os-Linux/start_up.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/um/os-Linux/start_up.c~uml-style-fixes-in-startup-code arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-style-fixes-in-startup-code
+++ a/arch/um/os-Linux/start_up.c
@@ -95,7 +95,7 @@ static int start_ptraced_child(void **st
 		      status);
 
 	*stack_out = stack;
-	return(pid);
+	return pid;
 }
 
 /* When testing for SYSEMU support, if it is one of the broken versions, we
@@ -182,7 +182,7 @@ __uml_setup("nosysemu", nosysemu_cmd_par
 static void __init check_sysemu(void)
 {
 	void *stack;
- 	int pid, n, status, count=0;
+	int pid, n, status, count=0;
 
 	printf("Checking syscall emulation patch for ptrace...");
 	sysemu_supported = 0;
@@ -418,7 +418,7 @@ static inline void check_skas3_proc_mm(v
 {
 	printf("  - /proc/mm...");
 	if (os_access("/proc/mm", OS_ACC_W_OK) < 0) {
- 		proc_mm = 0;
+		proc_mm = 0;
 		printf("not found\n");
 	}
 	else {
@@ -445,7 +445,7 @@ int can_do_skas(void)
 #else
 int can_do_skas(void)
 {
-	return(0);
+	return 0;
 }
 #endif
 
@@ -493,11 +493,11 @@ int __init parse_iomem(char *str, int *a
 	iomem_regions = new;
 	iomem_size += new->size + UM_KERN_PAGE_SIZE;
 
-	return(0);
+	return 0;
  out_close:
 	os_close_file(fd);
  out:
-	return(1);
+	return 1;
 }
 
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

fix-uml-on-non-standard-vm-split-hosts.patch
uml-fix-mknod.patch
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
uml-add-per-device-queues-and-locks-to-ubd-driver.patch
uml-locking-fixes-in-the-ubd-driver.patch
uml-locking-comments-in-memory-and-tempfile-code.patch
uml-locking-comments-in-startup-code.patch
uml-style-fixes-in-startup-code.patch
uml-libc-dependent-code-should-call-libc-directly.patch
uml-fix-style-violations.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
