From: akpm@linux-foundation.org
Subject: + xen-paravirt_ops-clean-up-elf-note-generation.patch added to -mm tree
Date: Wed, 21 Feb 2007 18:53:11 -0800
Message-ID: <200702220253.l1M2rBVB002437@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34542 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbXBVCxO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:53:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ebiederm@xmission.com, jeremy@xensource.com


The patch titled
     From: Jeremy Fitzhardinge <jeremy@goop.org>
has been added to the -mm tree.  Its filename is
     xen-paravirt_ops-clean-up-elf-note-generation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386.patch
xen-paravirt_ops-clean-up-elf-note-generation.patch
xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt_ops-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-some-generic-early-printk-boot-console-fixups.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
