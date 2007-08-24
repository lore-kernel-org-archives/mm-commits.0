From: akpm@linux-foundation.org
Subject: - x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk-update.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:32 -0700
Message-ID: <200708242058.l7OKwWpQ014312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36811 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762699AbXHXVIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64 ia32 vDSO: install unstripped copies on disk
has been removed from the -mm tree.  Its filename was
     x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 ia32 vDSO: install unstripped copies on disk
From: Roland McGrath <roland@redhat.com>

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Makefile      |    6 ++++--
 arch/x86_64/ia32/Makefile |    2 +-
 arch/x86_64/vdso/Makefile |    6 +++---
 3 files changed, 8 insertions(+), 6 deletions(-)

diff -puN arch/x86_64/Makefile~x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk-update arch/x86_64/Makefile
--- a/arch/x86_64/Makefile~x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk-update
+++ a/arch/x86_64/Makefile
@@ -109,12 +109,14 @@ bzdisk: vmlinux
 fdimage fdimage144 fdimage288 isoimage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@
 
-install:
+install: vdso_install
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@ 
-	$(Q)$(MAKE) $(build)=arch/x86_64/vdso $@
+
+vdso_install:
 ifeq ($(CONFIG_IA32_EMULATION),y)
 	$(Q)$(MAKE) $(build)=arch/x86_64/ia32 $@
 endif
+	$(Q)$(MAKE) $(build)=arch/x86_64/vdso $@
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
diff -puN arch/x86_64/ia32/Makefile~x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk-update arch/x86_64/ia32/Makefile
--- a/arch/x86_64/ia32/Makefile~x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk-update
+++ a/arch/x86_64/ia32/Makefile
@@ -49,4 +49,4 @@ $(vdsos):
 	@mkdir -p $(MODLIB)/vdso
 	$(call cmd,vdso_install)
 
-install: $(vdsos)
+vdso_install: $(vdsos)
diff -puN arch/x86_64/vdso/Makefile~x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk-update arch/x86_64/vdso/Makefile
--- a/arch/x86_64/vdso/Makefile~x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk-update
+++ a/arch/x86_64/vdso/Makefile
@@ -36,7 +36,7 @@ $(obj)/%.so: OBJCOPYFLAGS := -S
 $(obj)/%.so: $(obj)/%.so.dbg FORCE
 	$(call if_changed,objcopy)
 
-CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64
+CFL := $(PROFILING) -mcmodel=small -fPIC $(if $(CONFIG_DEBUG_INFO),-g,-g0) -O2 -fasynchronous-unwind-tables -m64
 
 $(obj)/vclock_gettime.o: CFLAGS = $(CFL)
 $(obj)/vgetcpu.o: CFLAGS = $(CFL)
@@ -53,9 +53,9 @@ $(obj)/vdso-syms.o: $(src)/vdso.lds $(vo
 	$(call if_changed,syscall)
 
 quiet_cmd_vdso_install = INSTALL $@
-      cmd_vdso_install = cp $@.dbg $(MODLIB)/vdso/$@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
 vdso.so:
 	@mkdir -p $(MODLIB)/vdso
 	$(call cmd,vdso_install)
 
-install: vdso.so
+vdso_install: vdso.so
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
setpgidchild-fails-if-the-child-was-forked-by-sub-thread.patch
sigqueue_free-fix-the-race-with-collect_signal.patch
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
pie-executable-randomization-fix-2.patch
pie-executable-randomization-fix-3.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
exec-simplify-sighand-switching.patch
exec-simplify-the-new-sighand-allocation.patch
exec-consolidate-2-fast-paths.patch
exec-rt-sub-thread-can-livelock-and-monopolize-cpu-on-exec.patch
do_sigaction-dont-worry-about-signal_pending.patch
fix-tsk-exit_state-usage-resend.patch
