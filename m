From: akpm@linux-foundation.org
Subject: + s390-put-allocated-elf-notes-in-read-only-data-segment.patch added to -mm tree
Date: Wed, 11 Jul 2007 16:48:37 -0700
Message-ID: <200707112348.l6BNmb9Y027045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173AbXGKXsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 19:48:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     s390: Put allocated ELF notes in read-only data segment
has been added to the -mm tree.  Its filename is
     s390-put-allocated-elf-notes-in-read-only-data-segment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s390: Put allocated ELF notes in read-only data segment
From: Roland McGrath <roland@redhat.com>

This changes the s390 linker script to use the asm-generic NOTES macro so that
ELF note sections with SHF_ALLOC set are linked into the kernel image along
with other read-only data.  The PT_NOTE also points to their location.

This paves the way for putting useful build-time information into ELF notes
that can be found easily later in a kernel memory dump.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/vmlinux.lds.S |    2 ++
 1 files changed, 2 insertions(+)

diff -puN arch/s390/kernel/vmlinux.lds.S~s390-put-allocated-elf-notes-in-read-only-data-segment arch/s390/kernel/vmlinux.lds.S
--- a/arch/s390/kernel/vmlinux.lds.S~s390-put-allocated-elf-notes-in-read-only-data-segment
+++ a/arch/s390/kernel/vmlinux.lds.S
@@ -45,6 +45,8 @@ SECTIONS
   __ex_table : { *(__ex_table) }
   __stop___ex_table = .;
 
+  NOTES
+
   BUG_TABLE
 
   .data : {			/* Data */
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
