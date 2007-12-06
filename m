From: akpm@linux-foundation.org
Subject: + uml-remove-duplicate-config-symbol-and-unused-file-and-variables.patch added to -mm tree
Date: Thu, 06 Dec 2007 11:47:28 -0800
Message-ID: <200712061947.lB6JlSUK008662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35360 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754240AbXLFTrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Dec 2007 14:47:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magotari@gmail.com, jdike@linux.intel.com


The patch titled
     uml: remove duplicate config symbol and unused file and variables
has been added to the -mm tree.  Its filename is
     uml-remove-duplicate-config-symbol-and-unused-file-and-variables.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove duplicate config symbol and unused file and variables
From: Karol Swietlicki <magotari@gmail.com>

Fix the repetition of the NET symbol.  It was once in UML specific options and
once in networking.  I removed the first occurrence, as it makes more sense to
me to keep it only in networking.

It also removes a mostly empty file which is not used anymore and some
unused variables.

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig                 |   17 -----------------
 arch/um/Makefile-tt             |    5 -----
 arch/um/drivers/mconsole_kern.c |    3 ---
 arch/um/kernel/process.c        |    4 ++--
 4 files changed, 2 insertions(+), 27 deletions(-)

diff -puN arch/um/Kconfig~uml-remove-duplicate-config-symbol-and-unused-file-and-variables arch/um/Kconfig
--- a/arch/um/Kconfig~uml-remove-duplicate-config-symbol-and-unused-file-and-variables
+++ a/arch/um/Kconfig
@@ -95,23 +95,6 @@ config LD_SCRIPT_DYN
 	default y
 	depends on !LD_SCRIPT_STATIC
 
-config NET
-	bool "Networking support"
-	help
-	  Unless you really know what you are doing, you should say Y here.
-	  The reason is that some programs need kernel networking support even
-	  when running on a stand-alone machine that isn't connected to any
-	  other computer. If you are upgrading from an older kernel, you
-	  should consider updating your networking tools too because changes
-	  in the kernel and the tools often go hand in hand. The tools are
-	  contained in the package net-tools, the location and version number
-	  of which are given in <file:Documentation/Changes>.
-
-	  For a general introduction to Linux networking, it is highly
-	  recommended to read the NET-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-
 source "fs/Kconfig.binfmt"
 
 config HOSTFS
diff -puN arch/um/Makefile-tt~uml-remove-duplicate-config-symbol-and-unused-file-and-variables /dev/null
--- a/arch/um/Makefile-tt
+++ /dev/null
@@ -1,5 +0,0 @@
-# 
-# Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
-# Licensed under the GPL
-#
-
diff -puN arch/um/drivers/mconsole_kern.c~uml-remove-duplicate-config-symbol-and-unused-file-and-variables arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-remove-duplicate-config-symbol-and-unused-file-and-variables
+++ a/arch/um/drivers/mconsole_kern.c
@@ -741,7 +741,6 @@ void mconsole_stack(struct mc_request *r
 {
 	char *ptr = req->request.data;
 	int pid_requested= -1;
-	struct task_struct *from = NULL;
 	struct task_struct *to = NULL;
 
 	/*
@@ -763,8 +762,6 @@ void mconsole_stack(struct mc_request *r
 		return;
 	}
 
-	from = current;
-
 	to = find_task_by_pid(pid_requested);
 	if ((to == NULL) || (pid_requested == 0)) {
 		mconsole_reply(req, "Couldn't find that pid", 1, 0);
diff -puN arch/um/kernel/process.c~uml-remove-duplicate-config-symbol-and-unused-file-and-variables arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-remove-duplicate-config-symbol-and-unused-file-and-variables
+++ a/arch/um/kernel/process.c
@@ -30,7 +30,7 @@
  */
 struct cpu_task cpu_tasks[NR_CPUS] = { [0 ... NR_CPUS - 1] = { -1, NULL } };
 
-static inline int external_pid(struct task_struct *task)
+static inline int external_pid(void)
 {
 	/* FIXME: Need to look up userspace_pid by cpu */
 	return userspace_pid[0];
@@ -78,7 +78,7 @@ int kernel_thread(int (*fn)(void *), voi
 static inline void set_current(struct task_struct *task)
 {
 	cpu_tasks[task_thread_info(task)->cpu] = ((struct cpu_task)
-		{ external_pid(task), task });
+		{ external_pid(), task });
 }
 
 extern void arch_switch_to(struct task_struct *to);
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
uml-remove-duplicate-config-symbol-and-unused-file-and-variables.patch
uml-fix-mconsole-stop.patch
