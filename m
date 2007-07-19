From: akpm@linux-foundation.org
Subject: - x86_64-put-allocated-elf-notes-in-read-only-data-segment.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:42 -0700
Message-ID: <200707192002.l6JK2g9L019777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48595 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761548AbXGSUSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: Put allocated ELF notes in read-only data segment
has been removed from the -mm tree.  Its filename was
     x86_64-put-allocated-elf-notes-in-read-only-data-segment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 3 insertions(+), 1 deletion(-)

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

origin.patch
xen-disable-vdso-nosegneg-on-native-boot.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
