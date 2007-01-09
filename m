From: akpm@osdl.org
Subject: + uml-delete-unused-file.patch added to -mm tree
Date: Tue, 09 Jan 2007 12:57:49 -0800
Message-ID: <200701092057.l09KvnNh015072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43447 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440AbXAIU55 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:57:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: delete unused file
has been added to the -mm tree.  Its filename is
     uml-delete-unused-file.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: delete unused file
From: Jeff Dike <jdike@addtoit.com>

It turns out that resource.c isn't needed.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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
