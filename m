From: akpm@linux-foundation.org
Subject: + uml-elf-locking-commentary.patch added to -mm tree
Date: Wed, 07 Feb 2007 15:20:53 -0800
Message-ID: <200702072320.l17NKr9T030938@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44860 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422776AbXBGXUz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 18:20:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: ELF locking commentary
has been added to the -mm tree.  Its filename is
     uml-elf-locking-commentary.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: ELF locking commentary
From: Jeff Dike <jdike@addtoit.com>

Comment the lack of locking of the elf data extracted from the ELF headers
passed to UML.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/elf_aux.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/um/os-Linux/elf_aux.c~uml-elf-locking-commentary arch/um/os-Linux/elf_aux.c
--- a/arch/um/os-Linux/elf_aux.c~uml-elf-locking-commentary
+++ a/arch/um/os-Linux/elf_aux.c
@@ -21,12 +21,11 @@ typedef Elf32_auxv_t elf_auxv_t;
 typedef Elf64_auxv_t elf_auxv_t;
 #endif
 
+/* These are initialized very early in boot and never changed */
 char * elf_aux_platform;
 long elf_aux_hwcap;
-
 unsigned long vsyscall_ehdr;
 unsigned long vsyscall_end;
-
 unsigned long __kernel_vsyscall;
 
 __init void scan_elf_aux( char **envp)
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
