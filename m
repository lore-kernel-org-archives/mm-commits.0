From: akpm@linux-foundation.org
Subject: - uml-host-vdso-fix.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:07:04 -0800
Message-ID: <200703020507.l225745R000850@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42358 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422755AbXCBFHG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: host VDSO fix
has been removed from the -mm tree.  Its filename was
     uml-host-vdso-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: host VDSO fix
From: Jeff Dike <jdike@addtoit.com>

This fixes a problem seen by a number of people running UML on newer host
kernels.  init would hang with an infinite segfault loop.

It turns out that the host kernel was providing a AT_SYSINFO_EHDR of
0xffffe000, which faked UML into believing that the host VDSO page could be
reused.  However, AT_SYSINFO pointed into the middle of the address space, and
was unmapped as a result.  Because UML was providing AT_SYSINFO_EHDR and
AT_SYSINFO to its own processes, these would branch to nowhere when trying to
use the VDSO.

The fix is to also check the location of AT_SYSINFO when deciding whether to
use the host's VDSO.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/elf_aux.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/um/os-Linux/elf_aux.c~uml-host-vdso-fix arch/um/os-Linux/elf_aux.c
--- a/arch/um/os-Linux/elf_aux.c~uml-host-vdso-fix
+++ a/arch/um/os-Linux/elf_aux.c
@@ -39,6 +39,9 @@ __init void scan_elf_aux( char **envp)
 		switch ( auxv->a_type ) {
 			case AT_SYSINFO:
 				__kernel_vsyscall = auxv->a_un.a_val;
+				/* See if the page is under TASK_SIZE */
+				if (__kernel_vsyscall < (unsigned long) envp)
+					__kernel_vsyscall = 0;
 				break;
 			case AT_SYSINFO_EHDR:
 				vsyscall_ehdr = auxv->a_un.a_val;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
