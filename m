From: akpm@linux-foundation.org
Subject: + i386-put-allocated-elf-notes-in-read-only-data-segment.patch added to -mm tree
Date: Wed, 11 Jul 2007 16:48:27 -0700
Message-ID: <200707112348.l6BNmRcM027029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935362AbXGKXs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 19:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, ink@jurassic.park.msu.ru, paulus@samba.org, rth@twiddle.net, schwidefsky@de.ibm.com


The patch titled
     i386: Put allocated ELF notes in read-only data segment
has been added to the -mm tree.  Its filename is
     i386-put-allocated-elf-notes-in-read-only-data-segment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: Put allocated ELF notes in read-only data segment
From: Roland McGrath <roland@redhat.com>

This changes the i386 linker script and the asm-generic macro it uses so that
ELF note sections with SHF_ALLOC set are linked into the kernel image along
with other read-only data.  The PT_NOTE also points to their location.

This paves the way for putting useful build-time information into ELF notes
that can be found easily later in a kernel memory dump.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmlinux.lds.S    |    6 +++---
 include/asm-generic/vmlinux.lds.h |    6 +++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/vmlinux.lds.S~i386-put-allocated-elf-notes-in-read-only-data-segment arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~i386-put-allocated-elf-notes-in-read-only-data-segment
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -60,7 +60,9 @@ SECTIONS
   	__stop___ex_table = .;
   }
 
-  BUG_TABLE
+  NOTES :text :note
+
+  BUG_TABLE :text
 
   . = ALIGN(4);
   .tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {
@@ -210,6 +212,4 @@ SECTIONS
   STABS_DEBUG
 
   DWARF_DEBUG
-
-  NOTES
 }
diff -puN include/asm-generic/vmlinux.lds.h~i386-put-allocated-elf-notes-in-read-only-data-segment include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~i386-put-allocated-elf-notes-in-read-only-data-segment
+++ a/include/asm-generic/vmlinux.lds.h
@@ -246,7 +246,11 @@
 	}
 
 #define NOTES								\
-	.notes : { *(.note.*) } :note
+	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
+		VMLINUX_SYMBOL(__start_notes) = .;			\
+		*(.note.*)						\
+		VMLINUX_SYMBOL(__stop_notes) = .;			\
+	}
 
 #define INITCALLS							\
   	*(.initcall0.init)						\
_

Patches currently in -mm which might be from roland@redhat.com are

powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
make-alt-sysrq-p-display-the-debug-register-contents.patch
i386-vdso-install-unstripped-copies-on-disk.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
pie-randomization.patch
i386-put-allocated-elf-notes-in-read-only-data-segment.patch
x86_64-put-allocated-elf-notes-in-read-only-data-segment.patch
alpha-put-allocated-elf-notes-in-read-only-data-segment.patch
powerpc-put-allocated-elf-notes-in-read-only-data-segment.patch
s390-put-allocated-elf-notes-in-read-only-data-segment.patch
add-sys-kernel-notes.patch
use-build-id-ld-option.patch
