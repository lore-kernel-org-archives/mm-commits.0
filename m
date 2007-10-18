From: akpm@linux-foundation.org
Subject: - x86_64-vdso-linker-script-cleanup.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:08:12 -0700
Message-ID: <200710180708.l9I78CZN031841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35426 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759833AbXJRHI2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:08:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64 vDSO linker script cleanup
has been removed from the -mm tree.  Its filename was
     x86_64-vdso-linker-script-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 vDSO linker script cleanup
From: Roland McGrath <roland@redhat.com>

I can't see the reason ".  = VDSO_PRELINK + 0x900;" was ever there in the
linker script for the x86_64 vDSO.  I can't find anything that depends on this
magic offset, or that should care at all about the particular location of of
the .data section (all from vvar.c) in the vDSO image.  If it is really
desireable to place .data at 0x900, then it should be after all the other
sections so they fill in the space up to 0x900.

This removes the 0x900 magic and cleans up the output sections generally in
the vDSO linker script.  This saves a few hundred bytes in the size of the
vDSO file, bringing it back well under 4kb total so that its vma only needs
one page.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/vdso/vdso.lds.S |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/vdso/vdso.lds.S~x86_64-vdso-linker-script-cleanup arch/x86_64/vdso/vdso.lds.S
--- a/arch/x86/vdso/vdso.lds.S~x86_64-vdso-linker-script-cleanup
+++ a/arch/x86/vdso/vdso.lds.S
@@ -26,13 +26,16 @@ SECTIONS
      is insufficient, ld -shared will barf.  Just increase it here.  */
   . = VDSO_PRELINK + VDSO_TEXT_OFFSET;
 
-  .text           : { *(.text) }		:text
-  .text.ptr       : { *(.text.ptr) }		:text
-  . = VDSO_PRELINK + 0x900;
-  .data           : { *(.data) }		:text
-  .bss            : { *(.bss) }			:text
+  .text           : { *(.text*) }		:text
+  .rodata         : { *(.rodata*) }		:text
+  .data		  : {
+	*(.data*)
+	*(.sdata*)
+	*(.bss*)
+	*(.dynbss*)
+  }						:text
 
-  .altinstructions : { *(.altinstructions) }			:text
+  .altinstructions : { *(.altinstructions) }		:text
   .altinstr_replacement  : { *(.altinstr_replacement) }	:text
 
   .note		  : { *(.note.*) }		:text :note
@@ -42,7 +45,6 @@ SECTIONS
   .useless        : {
   	*(.got.plt) *(.got)
 	*(.gnu.linkonce.d.*)
-	*(.dynbss)
 	*(.gnu.linkonce.b.*)
   }						:text
 }
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
x86_64-use-linux-elfcore-compath.patch
fix-tsk-exit_state-usage-resend.patch
