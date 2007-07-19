From: akpm@linux-foundation.org
Subject: - s390-put-allocated-elf-notes-in-read-only-data-segment.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:48 -0700
Message-ID: <200707192002.l6JK2m2U019787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56938 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761827AbXGSU0g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:26:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: Put allocated ELF notes in read-only data segment
has been removed from the -mm tree.  Its filename was
     s390-put-allocated-elf-notes-in-read-only-data-segment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+)

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

origin.patch
xen-disable-vdso-nosegneg-on-native-boot.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
