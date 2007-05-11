From: akpm@linux-foundation.org
Subject: + x86-use-elfnoteh-to-generate-vsyscall-notes.patch added to -mm tree
Date: Fri, 11 May 2007 12:23:20 -0700
Message-ID: <200705111923.l4BJNKsj024404@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966530AbXEKTYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, akpm@linux-foundation.com, ebiederm@xmission.com, jeremy@xensource.com, roland@redhat.com


The patch titled
     x86: use elfnote.h to generate vsyscall notes.
has been added to the -mm tree.  Its filename is
     x86-use-elfnoteh-to-generate-vsyscall-notes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: use elfnote.h to generate vsyscall notes.
From: Jeremy Fitzhardinge <jeremy@goop.org>

Use existing elfnote.h to generate vsyscall notes, rather than doing it
locally.  Changes elfnote.h a bit to suite, since this is the first asm user,
and it wasn't quite right.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vsyscall-note.S |   23 ++++++-----------------
 arch/x86_64/vdso/vdso-note.S     |    4 ++--
 include/linux/elfnote.h          |   18 +++++++++++++-----
 3 files changed, 21 insertions(+), 24 deletions(-)

diff -puN arch/i386/kernel/vsyscall-note.S~x86-use-elfnoteh-to-generate-vsyscall-notes arch/i386/kernel/vsyscall-note.S
--- a/arch/i386/kernel/vsyscall-note.S~x86-use-elfnoteh-to-generate-vsyscall-notes
+++ a/arch/i386/kernel/vsyscall-note.S
@@ -3,23 +3,12 @@
  * Here we can supply some information useful to userland.
  */
 
-#include <linux/uts.h>
 #include <linux/version.h>
+#include <linux/elfnote.h>
 
-#define ASM_ELF_NOTE_BEGIN(name, flags, vendor, type)			      \
-	.section name, flags;						      \
-	.balign 4;							      \
-	.long 1f - 0f;		/* name length */			      \
-	.long 3f - 2f;		/* data length */			      \
-	.long type;		/* note type */				      \
-0:	.asciz vendor;		/* vendor name */			      \
-1:	.balign 4;							      \
-2:
-
-#define ASM_ELF_NOTE_END						      \
-3:	.balign 4;		/* pad out section */			      \
-	.previous
-
-	ASM_ELF_NOTE_BEGIN(".note.kernel-version", "a", UTS_SYSNAME, 0)
+/* Ideally this would use UTS_NAME, but using a quoted string here
+   doesn't work. Remember to change this when changing the
+   kernel's name. */
+ELFNOTE_START(Linux, 0, "a")
 	.long LINUX_VERSION_CODE
-	ASM_ELF_NOTE_END
+ELFNOTE_END
diff -puN arch/x86_64/vdso/vdso-note.S~x86-use-elfnoteh-to-generate-vsyscall-notes arch/x86_64/vdso/vdso-note.S
--- a/arch/x86_64/vdso/vdso-note.S~x86-use-elfnoteh-to-generate-vsyscall-notes
+++ a/arch/x86_64/vdso/vdso-note.S
@@ -8,5 +8,5 @@
 #include <linux/elfnote.h>
 
 	/* Supply version information to coredumps */
-	ELFNOTE(kernelversion, 0, .long, LINUX_VERSION_CODE)
-	ELFNOTE(os, 0, .asciz, UTS_SYSNAME)
+	ELFNOTE(kernelversion, 0, .long LINUX_VERSION_CODE)
+	ELFNOTE(os, 0, .asciz UTS_SYSNAME)
diff -puN include/linux/elfnote.h~x86-use-elfnoteh-to-generate-vsyscall-notes include/linux/elfnote.h
--- a/include/linux/elfnote.h~x86-use-elfnoteh-to-generate-vsyscall-notes
+++ a/include/linux/elfnote.h
@@ -38,17 +38,25 @@
  * e.g. ELFNOTE(XYZCo, 42, .asciz, "forty-two")
  *      ELFNOTE(XYZCo, 12, .long, 0xdeadbeef)
  */
-#define ELFNOTE(name, type, desctype, descdata)	\
-.pushsection .note.name, "",@note	;	\
+#define ELFNOTE_START(name, type, flags)	\
+.pushsection .note.name, flags,@note	;	\
   .align 4				;	\
   .long 2f - 1f		/* namesz */	;	\
-  .long 4f - 3f		/* descsz */	;	\
+  .long 4484f - 3f	/* descsz */	;	\
   .long type				;	\
 1:.asciz #name				;	\
 2:.align 4				;	\
-3:desctype descdata			;	\
-4:.align 4				;	\
+3:
+
+#define ELFNOTE_END				\
+4484:.align 4				;	\
 .popsection				;
+
+#define ELFNOTE(name, type, desc)		\
+	ELFNOTE_START(name, type, "")		\
+		desc			;	\
+	ELFNOTE_END
+
 #else	/* !__ASSEMBLER__ */
 #include <linux/elf.h>
 /*
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
loop_probe-fix-return-value.patch
x86-use-elfnoteh-to-generate-vsyscall-notes.patch
i386-move-common-parts-of-smp-into-their-own-file.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
add-kstrndup.patch
add-argv_split.patch
split-usermodehelper-setup-from-execution.patch
add-common-orderly_poweroff.patch
tidy-up-usermode-helper-waiting-a-bit.patch
lguest-the-guest-code.patch
