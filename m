From: akpm@linux-foundation.org
Subject: - pass-g-to-assembler-under-config_debug_info-powerpc-fix.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:12:19 -0700
Message-ID: <200708201912.l7KJCJnC018343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40508 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760867AbXHTTVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, benh@kernel.crashing.org, paulus@samba.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     powerfc fix for assembler -g
has been removed from the -mm tree.  Its filename was
     pass-g-to-assembler-under-config_debug_info-powerpc-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerfc fix for assembler -g
From: Roland McGrath <roland@redhat.com>

ppc64 does the unusual thing of using #include on a compiler-generated
assembly file (lparmap.s) from an assembly source file (head_64.S).  This
runs afoul of my recent patch to pass -gdwarf2 to the assembler under
CONFIG_DEBUG_INFO.  This patch avoids the problem by disabling DWARF
generation (-g0) when producing lparmap.s.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/Makefile |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/powerpc/kernel/Makefile~pass-g-to-assembler-under-config_debug_info-powerpc-fix arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~pass-g-to-assembler-under-config_debug_info-powerpc-fix
+++ a/arch/powerpc/kernel/Makefile
@@ -81,6 +81,7 @@ obj-y				+= iomap.o
 endif
 
 ifeq ($(CONFIG_PPC_ISERIES),y)
+CFLAGS_lparmap.s		+= -g0
 extra-y += lparmap.s
 $(obj)/head_64.o:	$(obj)/lparmap.s
 AFLAGS_head_64.o += -I$(obj)
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
signalfd-fix-interaction-with-posix-timers.patch
signalfd-make-it-group-wide-fix-posix-timers-scheduling.patch
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
add-mmf_dump_elf_headers.patch
pie-executable-randomization.patch
pie-executable-randomization-fix.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
