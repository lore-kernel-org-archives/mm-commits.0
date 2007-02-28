From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-clean-up-elf-note-generation.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:16:08 -0800
Message-ID: <200702282316.l1SNG8I5030038@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47169 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbXB1XQO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:16:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ebiederm@xmission.com, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     From: Jeremy Fitzhardinge <jeremy@goop.org>
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-clean-up-elf-note-generation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: From: Jeremy Fitzhardinge <jeremy@goop.org>


Three cleanups:

1: ELF notes are never mapped, so there's no need to have any access
flags in their phdr.

2: When generating them from asm, tell the assembler to use a SHT_NOTE
section type.  There doesn't seem to be a way to do this from C.

3: Use ANSI rather than traditional cpp behaviour to stringify the
macro argument.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>

===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmlinux.lds.S    |    2 +-
 include/asm-generic/vmlinux.lds.h |    2 +-
 include/linux/elfnote.h           |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/vmlinux.lds.S~xen-paravirt_ops-clean-up-elf-note-generation arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~xen-paravirt_ops-clean-up-elf-note-generation
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -31,7 +31,7 @@ _proxy_pda = 0;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
 	data PT_LOAD FLAGS(7);	/* RWE */
-	note PT_NOTE FLAGS(4);	/* R__ */
+	note PT_NOTE FLAGS(0);	/* ___ */
 }
 SECTIONS
 {
diff -puN include/asm-generic/vmlinux.lds.h~xen-paravirt_ops-clean-up-elf-note-generation include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~xen-paravirt_ops-clean-up-elf-note-generation
+++ a/include/asm-generic/vmlinux.lds.h
@@ -208,7 +208,7 @@
 	}
 
 #define NOTES								\
-		.notes : { *(.note.*) } :note
+	.notes : { *(.note.*) } :note
 
 #define INITCALLS							\
   	*(.initcall0.init)						\
diff -puN include/linux/elfnote.h~xen-paravirt_ops-clean-up-elf-note-generation include/linux/elfnote.h
--- a/include/linux/elfnote.h~xen-paravirt_ops-clean-up-elf-note-generation
+++ a/include/linux/elfnote.h
@@ -39,12 +39,12 @@
  *      ELFNOTE(XYZCo, 12, .long, 0xdeadbeef)
  */
 #define ELFNOTE(name, type, desctype, descdata)	\
-.pushsection .note.name			;	\
+.pushsection .note.name, "",@note	;	\
   .align 4				;	\
   .long 2f - 1f		/* namesz */	;	\
   .long 4f - 3f		/* descsz */	;	\
   .long type				;	\
-1:.asciz "name"				;	\
+1:.asciz #name				;	\
 2:.align 4				;	\
 3:desctype descdata			;	\
 4:.align 4				;	\
_

Patches currently in -mm which might be from jeremy@goop.org are

make-hvc_consolec-compile-on-non-powerpc-remove-no_irq.patch
xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386.patch
xen-paravirt_ops-clean-up-elf-note-generation.patch
xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt_ops-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-some-generic-early-printk-boot-console-fixups.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
