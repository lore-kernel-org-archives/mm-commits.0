From: akpm@linux-foundation.org
Subject: - clean-up-elf-note-generation.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:40:21 -0700
Message-ID: <200704252040.l3PKeLFq012406@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993177AbXDYU5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:57:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ebiederm@xmission.com, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     Clean up ELF note generation
has been removed from the -mm tree.  Its filename was
     clean-up-elf-note-generation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up ELF note generation
From: Jeremy Fitzhardinge <jeremy@goop.org>

Three cleanups:

1: ELF notes are never mapped, so there's no need to have any access
   flags in their phdr.

2: When generating them from asm, tell the assembler to use a SHT_NOTE
   section type.  There doesn't seem to be a way to do this from C.

3: Use ANSI rather than traditional cpp behaviour to stringify the
   macro argument.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmlinux.lds.S    |    2 +-
 include/asm-generic/vmlinux.lds.h |    2 +-
 include/linux/elfnote.h           |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/vmlinux.lds.S~clean-up-elf-note-generation arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~clean-up-elf-note-generation
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -31,7 +31,7 @@ _proxy_pda = 1;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
 	data PT_LOAD FLAGS(7);	/* RWE */
-	note PT_NOTE FLAGS(4);	/* R__ */
+	note PT_NOTE FLAGS(0);	/* ___ */
 }
 SECTIONS
 {
diff -puN include/asm-generic/vmlinux.lds.h~clean-up-elf-note-generation include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~clean-up-elf-note-generation
+++ a/include/asm-generic/vmlinux.lds.h
@@ -230,7 +230,7 @@
 	}
 
 #define NOTES								\
-		.notes : { *(.note.*) } :note
+	.notes : { *(.note.*) } :note
 
 #define INITCALLS							\
   	*(.initcall0.init)						\
diff -puN include/linux/elfnote.h~clean-up-elf-note-generation include/linux/elfnote.h
--- a/include/linux/elfnote.h~clean-up-elf-note-generation
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

add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
add-touch_all_softlockup_watchdogs.patch
