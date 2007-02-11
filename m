From: akpm@linux-foundation.org
Subject: - uml-delete-unused-file.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:05 -0800
Message-ID: <200702112249.l1BMn5YN015693@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59812 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932688AbXBKWtH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: delete unused file
has been removed from the -mm tree.  Its filename was
     uml-delete-unused-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: delete unused file
From: Jeff Dike <jdike@addtoit.com>

It turns out that resource.c isn't needed.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/Makefile   |    2 +-
 arch/um/kernel/resource.c |   23 -----------------------
 2 files changed, 1 insertion(+), 24 deletions(-)

diff -puN arch/um/kernel/Makefile~uml-delete-unused-file arch/um/kernel/Makefile
--- a/arch/um/kernel/Makefile~uml-delete-unused-file
+++ a/arch/um/kernel/Makefile
@@ -7,7 +7,7 @@ extra-y := vmlinux.lds
 clean-files :=
 
 obj-y = config.o exec.o exitcode.o init_task.o irq.o ksyms.o mem.o \
-	physmem.o process.o ptrace.o reboot.o resource.o sigio.o \
+	physmem.o process.o ptrace.o reboot.o sigio.o \
 	signal.o smp.o syscall.o sysrq.o time.o tlb.o trap.o uaccess.o \
 	um_arch.o umid.o
 
diff -puN arch/um/kernel/resource.c~uml-delete-unused-file /dev/null
--- a/arch/um/kernel/resource.c
+++ /dev/null
@@ -1,23 +0,0 @@
-/* 
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#include "linux/pci.h"
-
-unsigned long resource_fixup(struct pci_dev * dev, struct resource * res,
-			     unsigned long start, unsigned long size)
-{
-	return start;
-}
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
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
