From: akpm@linux-foundation.org
Subject: - uml-style-fixes-in-startup-code.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:23 -0800
Message-ID: <200702112249.l1BMnNSS015743@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59852 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932701AbXBKWtZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: style fixes in startup code
has been removed from the -mm tree.  Its filename was
     uml-style-fixes-in-startup-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: style fixes in startup code
From: Jeff Dike <jdike@addtoit.com>

Some style fixes in startup.c.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
