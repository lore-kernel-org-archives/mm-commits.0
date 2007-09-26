From: akpm@linux-foundation.org
Subject: + x86_64-vdso-put-vars-in-rodata.patch added to -mm tree
Date: Wed, 26 Sep 2007 13:28:48 -0700
Message-ID: <200709262028.l8QKSm0w002409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33363 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754130AbXIZU3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 16:29:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de


The patch titled
     x86_64 vDSO: put vars in .rodata
has been added to the -mm tree.  Its filename is
     x86_64-vdso-put-vars-in-rodata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 vDSO: put vars in .rodata
From: Roland McGrath <roland@redhat.com>

This adds a const to the definitions vvar.c makes, so that the vdso_*
variables go into .rodata instead of .data.  This is essentially a cosmetic
change, just giving the section headers in the vDSO file more pleasing flags. 
These variables are read-only from the perspective of the vDSO itself and user
mode, even though the contents of the DSO image were adjusted at boot.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/x86_64/vdso/vvar.c~x86_64-vdso-put-vars-in-rodata arch/x86_64/vdso/vvar.c
--- a/arch/x86_64/vdso/vvar.c~x86_64-vdso-put-vars-in-rodata
+++ a/arch/x86_64/vdso/vvar.c
@@ -8,5 +8,5 @@
 #include <asm/timex.h>
 #include <asm/vgtod.h>
 
-#define VEXTERN(x) typeof (__ ## x) *vdso_ ## x = (void *)VMAGIC;
+#define VEXTERN(x) typeof (__ ## x) *const vdso_ ## x = (void *)VMAGIC;
 #include "vextern.h"
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
