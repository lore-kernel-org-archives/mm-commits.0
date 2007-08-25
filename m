From: akpm@linux-foundation.org
Subject: - update-x86_64-vdso-install-unstripped-copies-on-disk.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:19:32 -0700
Message-ID: <200708250519.l7P5JWl1032052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42242 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756151AbXHYFdJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:33:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     update x86_64-vdso-install-unstripped-copies-on-disk
has been removed from the -mm tree.  Its filename was
     update-x86_64-vdso-install-unstripped-copies-on-disk.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: update x86_64-vdso-install-unstripped-copies-on-disk
From: Roland McGrath <roland@redhat.com>

While integrating these with the Fedora kernel build, I worked out a few kinks.
This patch replaces x86_64-vdso-install-unstripped-copies-on-disk.patch
and expects x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
was applied first.


This keeps an unstripped copy of the vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed
in $(MODLIB)/vdso/ by "make install" (or you can explicitly use the
subtarget "make vdso_install").  These files can be useful when they
contain source-level debugging information.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Makefile      |    2 +-
 arch/x86_64/vdso/Makefile |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/Makefile~update-x86_64-vdso-install-unstripped-copies-on-disk arch/x86_64/Makefile
--- a/arch/x86_64/Makefile~update-x86_64-vdso-install-unstripped-copies-on-disk
+++ a/arch/x86_64/Makefile
@@ -110,13 +110,13 @@ fdimage fdimage144 fdimage288 isoimage: 
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@
 
 install: vdso_install
-	$(Q)$(MAKE) $(build)=arch/x86_64/vdso $@
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@ 
 
 vdso_install:
 ifeq ($(CONFIG_IA32_EMULATION),y)
 	$(Q)$(MAKE) $(build)=arch/x86_64/ia32 $@
 endif
+	$(Q)$(MAKE) $(build)=arch/x86_64/vdso $@
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
diff -puN arch/x86_64/vdso/Makefile~update-x86_64-vdso-install-unstripped-copies-on-disk arch/x86_64/vdso/Makefile
--- a/arch/x86_64/vdso/Makefile~update-x86_64-vdso-install-unstripped-copies-on-disk
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
