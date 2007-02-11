From: akpm@linux-foundation.org
Subject: - uml-elf-locking-commentary.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:39 -0800
Message-ID: <200702112249.l1BMndAh015772@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59900 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702AbXBKWtm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: ELF locking commentary
has been removed from the -mm tree.  Its filename was
     uml-elf-locking-commentary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 2 deletions(-)

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

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
