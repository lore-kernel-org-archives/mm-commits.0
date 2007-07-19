From: akpm@linux-foundation.org
Subject: - powerpc-put-allocated-elf-notes-in-read-only-data-segment.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:46 -0700
Message-ID: <200707192002.l6JK2k6e019784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47902 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759965AbXGSU0b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:26:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: Put allocated ELF notes in read-only data segment
has been removed from the -mm tree.  Its filename was
     powerpc-put-allocated-elf-notes-in-read-only-data-segment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: Put allocated ELF notes in read-only data segment
From: Roland McGrath <roland@redhat.com>

This changes the powerpc linker script to use the asm-generic NOTES macro so
that ELF note sections with SHF_ALLOC set are linked into the kernel image
along with other read-only data.  The PT_NOTE also points to their location.

This paves the way for putting useful build-time information into ELF notes
that can be found easily later in a kernel memory dump.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vmlinux.lds.S |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/powerpc/kernel/vmlinux.lds.S~powerpc-put-allocated-elf-notes-in-read-only-data-segment arch/powerpc/kernel/vmlinux.lds.S
--- a/arch/powerpc/kernel/vmlinux.lds.S~powerpc-put-allocated-elf-notes-in-read-only-data-segment
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -63,6 +63,8 @@ SECTIONS
 		__stop___ex_table = .;
 	}
 
+	NOTES
+
 	BUG_TABLE
 
 /*
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
