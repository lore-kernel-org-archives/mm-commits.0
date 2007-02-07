From: akpm@linux-foundation.org
Subject: + uml-umid-tidying.patch added to -mm tree
Date: Wed, 07 Feb 2007 15:20:51 -0800
Message-ID: <200702072320.l17NKpXH030935@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44856 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161484AbXBGXUy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 18:20:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: umid tidying
has been added to the -mm tree.  Its filename is
     uml-umid-tidying.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: umid tidying
From: Jeff Dike <jdike@addtoit.com>

Add an error message when two umids are put on the command line.

umid.h is kind of pointless since it only declares one thing, and that
is already declared in os.h.

Commented the lack of locking of some data in os-Linux/umid.h.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_kern.c |    1 -
 arch/um/drivers/mconsole_user.c |    2 +-
 arch/um/include/umid.h          |   22 ----------------------
 arch/um/kernel/um_arch.c        |    1 -
 arch/um/kernel/umid.c           |    4 +++-
 arch/um/os-Linux/umid.c         |    3 ++-
 6 files changed, 6 insertions(+), 27 deletions(-)

diff -puN arch/um/drivers/mconsole_kern.c~uml-umid-tidying arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-umid-tidying
+++ a/arch/um/drivers/mconsole_kern.c
@@ -33,7 +33,6 @@
 #include "irq_user.h"
 #include "init.h"
 #include "os.h"
-#include "umid.h"
 #include "irq_kern.h"
 #include "choose-mode.h"
 
diff -puN arch/um/drivers/mconsole_user.c~uml-umid-tidying arch/um/drivers/mconsole_user.c
--- a/arch/um/drivers/mconsole_user.c~uml-umid-tidying
+++ a/arch/um/drivers/mconsole_user.c
@@ -16,7 +16,7 @@
 #include "user.h"
 #include "sysdep/ptrace.h"
 #include "mconsole.h"
-#include "umid.h"
+#include "os.h"
 #include "user_util.h"
 
 static struct mconsole_command commands[] = {
diff -puN arch/um/include/umid.h~uml-umid-tidying /dev/null
--- a/arch/um/include/umid.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * Copyright (C) 2001 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __UMID_H__
-#define __UMID_H__
-
-extern int umid_file_name(char *name, char *buf, int len);
-
-#endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/um_arch.c~uml-umid-tidying arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-umid-tidying
+++ a/arch/um/kernel/um_arch.c
@@ -30,7 +30,6 @@
 #include "kern.h"
 #include "mem_user.h"
 #include "mem.h"
-#include "umid.h"
 #include "initrd.h"
 #include "init.h"
 #include "os.h"
diff -puN arch/um/kernel/umid.c~uml-umid-tidying arch/um/kernel/umid.c
--- a/arch/um/kernel/umid.c~uml-umid-tidying
+++ a/arch/um/kernel/umid.c
@@ -16,8 +16,10 @@ static int __init set_umid_arg(char *nam
 {
 	int err;
 
-	if(umid_inited)
+	if(umid_inited){
+		printf("umid already set\n");
 		return 0;
+	}
 
 	*add = 0;
 	err = set_umid(name);
diff -puN arch/um/os-Linux/umid.c~uml-umid-tidying arch/um/os-Linux/umid.c
--- a/arch/um/os-Linux/umid.c~uml-umid-tidying
+++ a/arch/um/os-Linux/umid.c
@@ -18,7 +18,7 @@
 #define UMID_LEN 64
 
 /* Changed by set_umid, which is run early in boot */
-char umid[UMID_LEN] = { 0 };
+static char umid[UMID_LEN] = { 0 };
 
 /* Changed by set_uml_dir and make_uml_dir, which are run early in boot */
 static char *uml_dir = UML_DIR;
@@ -235,6 +235,7 @@ int __init set_umid(char *name)
 	return 0;
 }
 
+/* Changed in make_umid, which is called during early boot */
 static int umid_setup = 0;
 
 int __init make_umid(void)
_

Patches currently in -mm which might be from jdike@addtoit.com are

x86_64-32-bit-ptrace-mangles-sixth-system-call-argument.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs-fix.patch
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
uml-fix-apparent-config_64_bit-typo.patch
uml-irq-handler-tidying.patch
uml-sigio-locking-comment.patch
uml-sigio-formatting-fixes.patch
uml-umid-tidying.patch
uml-elf-locking-commentary.patch
uml-register-handling-formatting-fixes.patch
uml-aio-locking-and-tidying.patch
uml-fix-prototypes.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
