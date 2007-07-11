From: akpm@linux-foundation.org
Subject: + x86_64-put-allocated-elf-notes-in-read-only-data-segment.patch added to -mm tree
Date: Wed, 11 Jul 2007 16:48:31 -0700
Message-ID: <200707112348.l6BNmWXg027033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936017AbXGKXss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 19:48:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de


The patch titled
     x86_64: Put allocated ELF notes in read-only data segment
has been added to the -mm tree.  Its filename is
     x86_64-put-allocated-elf-notes-in-read-only-data-segment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: Put allocated ELF notes in read-only data segment
From: Roland McGrath <roland@redhat.com>

This changes the x86_64 linker script to use the asm-generic NOTES macro so
that ELF note sections with SHF_ALLOC set are linked into the kernel image
along with other read-only data.  The PT_NOTE also points to their location.

This paves the way for putting useful build-time information into ELF notes
that can be found easily later in a kernel memory dump.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/vmlinux.lds.S |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/vmlinux.lds.S~x86_64-put-allocated-elf-notes-in-read-only-data-segment arch/x86_64/kernel/vmlinux.lds.S
--- a/arch/x86_64/kernel/vmlinux.lds.S~x86_64-put-allocated-elf-notes-in-read-only-data-segment
+++ a/arch/x86_64/kernel/vmlinux.lds.S
@@ -48,7 +48,9 @@ SECTIONS
   __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) { *(__ex_table) }
   __stop___ex_table = .;
 
-  BUG_TABLE
+  NOTES :text :note
+
+  BUG_TABLE :text
 
   RODATA
 
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
