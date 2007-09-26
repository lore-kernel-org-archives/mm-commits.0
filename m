From: akpm@linux-foundation.org
Subject: + x86_64-vdso-linker-script-cleanup.patch added to -mm tree
Date: Wed, 26 Sep 2007 13:28:43 -0700
Message-ID: <200709262028.l8QKShPi002406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033AbXIZU2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 16:28:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de


The patch titled
     x86_64 vDSO linker script cleanup
has been added to the -mm tree.  Its filename is
     x86_64-vdso-linker-script-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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


diff -puN arch/x86_64/vdso/vdso.lds.S~x86_64-vdso-linker-script-cleanup arch/x86_64/vdso/vdso.lds.S
--- a/arch/x86_64/vdso/vdso.lds.S~x86_64-vdso-linker-script-cleanup
+++ a/arch/x86_64/vdso/vdso.lds.S
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

powerpc-vdso-install-unstripped-copies-on-disk.patch
powerpc-vdso-install-unstripped-copies-on-disk-update.patch
x86_64-vdso-linker-script-cleanup.patch
x86_64-vdso-put-vars-in-rodata.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
add-sys-module-name-notes.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
add-linux-elfcore-compath.patch
x86_64-use-linux-elfcore-compath.patch
powerpc-use-linux-elfcore-compath.patch
wait_task_zombie-remove-unneeded-child-signal-check.patch
wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting.patch
zap_other_threads-dont-optimize-thread_group_empty-case.patch
wait_task_zombie-dont-fight-with-non-existing-race-with-a-dying-ptracee.patch
__group_complete_signal-eliminate-unneeded-wakeup-of-group_exit_task.patch
wait_task_stopped-continued-remove-unneeded-p-signal-=-null-check.patch
add-mmf_dump_elf_headers.patch
pie-executable-randomization.patch
pie-executable-randomization-fix.patch
pie-executable-randomization-fix-2.patch
pie-executable-randomization-fix-3.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
exec-simplify-sighand-switching.patch
exec-simplify-the-new-sighand-allocation.patch
exec-consolidate-2-fast-paths.patch
exec-rt-sub-thread-can-livelock-and-monopolize-cpu-on-exec.patch
do_sigaction-dont-worry-about-signal_pending.patch
increase-at_vector_size-to-terminate-saved_auxv-properly.patch
fix-tsk-exit_state-usage-resend.patch
