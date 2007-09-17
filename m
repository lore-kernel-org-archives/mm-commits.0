From: akpm@linux-foundation.org
Subject: - pass-g-to-assembler-under-config_debug_info.patch removed from -mm tree
Date: Mon, 17 Sep 2007 03:15:55 -0700
Message-ID: <200709171015.l8HAFuHe007045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44992 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbXIQKQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Sep 2007 06:16:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, linux-arch@vger.kernel.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Pass -g to assembler under CONFIG_DEBUG_INFO
has been removed from the -mm tree.  Its filename was
     pass-g-to-assembler-under-config_debug_info.patch

This patch was dropped because Sam changed the Makefile a lot

------------------------------------------------------
Subject: Pass -g to assembler under CONFIG_DEBUG_INFO
From: Roland McGrath <roland@redhat.com>

The assembler for a while now supports -gdwarf to generate source line info
just like the C compiler does.  Source-level assembly debugging sounds like an
oxymoron, but it is handy to be able to see the right source file and read its
comments rather than just the disassembly.  This patch enables -gdwarf for
assembly files when CONFIG_DEBUG_INFO=y and the assembler supports the option.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    1 +
 1 files changed, 1 insertion(+)

diff -puN Makefile~pass-g-to-assembler-under-config_debug_info Makefile
--- a/Makefile~pass-g-to-assembler-under-config_debug_info
+++ a/Makefile
@@ -499,6 +499,7 @@ endif
 
 ifdef CONFIG_DEBUG_INFO
 CFLAGS		+= -g
+AFLAGS		+= $(call as-option, -gdwarf2)
 endif
 
 # Force gcc to behave correct even for buggy distributions
_

Patches currently in -mm which might be from roland@redhat.com are

powerpc-vdso-install-unstripped-copies-on-disk.patch
powerpc-vdso-install-unstripped-copies-on-disk-update.patch
pass-g-to-assembler-under-config_debug_info.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
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
fix-tsk-exit_state-usage-resend.patch
