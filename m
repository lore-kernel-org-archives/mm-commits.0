From: akpm@linux-foundation.org
Subject: - powerpc-vdso-install-unstripped-copies-on-disk-update.patch removed from -mm tree
Date: Tue, 02 Oct 2007 13:28:29 -0700
Message-ID: <200710022028.l92KSTWG020637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41150 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbXJBU2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 16:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, benh@kernel.crashing.org, paulus@samba.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     powerpc-vdso-install-unstripped-copies-on-disk update
has been removed from the -mm tree.  Its filename was
     powerpc-vdso-install-unstripped-copies-on-disk-update.patch

This patch was dropped because it was folded into powerpc-vdso-install-unstripped-copies-on-disk.patch

------------------------------------------------------
Subject: powerpc-vdso-install-unstripped-copies-on-disk update
From: Roland McGrath <roland@redhat.com>

While integrating these with the Fedora kernel build, I worked out a few kinks.
This patch replaces powerpc-vdso-install-unstripped-copies-on-disk.patch

This keeps an unstripped copy of the vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed
in $(MODLIB)/vdso/ by "make install" (or you can explicitly use the
subtarget "make vdso_install").  These files can be useful when they
contain source-level debugging information.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Makefile               |    9 ++++++---
 arch/powerpc/kernel/vdso32/Makefile |    4 ++--
 arch/powerpc/kernel/vdso64/Makefile |    4 ++--
 3 files changed, 10 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/Makefile~powerpc-vdso-install-unstripped-copies-on-disk-update arch/powerpc/Makefile
--- a/arch/powerpc/Makefile~powerpc-vdso-install-unstripped-copies-on-disk-update
+++ a/arch/powerpc/Makefile
@@ -162,12 +162,14 @@ define archhelp
   @echo '  *_defconfig     - Select default config from arch/$(ARCH)/configs'
 endef
 
-install:
+install: vdso_install
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
+
+vdso_install:
 ifeq ($(CONFIG_PPC64),y)
-	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso64 install
+	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso64 $@
 endif
-	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso32 install
+	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso32 $@
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
@@ -206,3 +208,4 @@ checkbin:
 	fi
 
 CLEAN_FILES += $(TOUT)
+
diff -puN arch/powerpc/kernel/vdso32/Makefile~powerpc-vdso-install-unstripped-copies-on-disk-update arch/powerpc/kernel/vdso32/Makefile
--- a/arch/powerpc/kernel/vdso32/Makefile~powerpc-vdso-install-unstripped-copies-on-disk-update
+++ a/arch/powerpc/kernel/vdso32/Makefile
@@ -46,10 +46,10 @@ quiet_cmd_vdso32as = VDSO32A $@
 
 # install commands for the unstripped file
 quiet_cmd_vdso_install = INSTALL $@
-      cmd_vdso_install = cp $@.dbg $(MODLIB)/vdso/$@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
 
 vdso32.so: $(obj)/vdso32.so.dbg
 	@mkdir -p $(MODLIB)/vdso
 	$(call cmd,vdso_install)
 
-install: vdso32.so
+vdso_install: vdso32.so
diff -puN arch/powerpc/kernel/vdso64/Makefile~powerpc-vdso-install-unstripped-copies-on-disk-update arch/powerpc/kernel/vdso64/Makefile
--- a/arch/powerpc/kernel/vdso64/Makefile~powerpc-vdso-install-unstripped-copies-on-disk-update
+++ a/arch/powerpc/kernel/vdso64/Makefile
@@ -40,10 +40,10 @@ quiet_cmd_vdso64as = VDSO64A $@
 
 # install commands for the unstripped file
 quiet_cmd_vdso_install = INSTALL $@
-      cmd_vdso_install = cp $@.dbg $(MODLIB)/vdso/$@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
 
 vdso64.so: $(obj)/vdso64.so.dbg
 	@mkdir -p $(MODLIB)/vdso
 	$(call cmd,vdso_install)
 
-install: vdso64.so
+vdso_install: vdso64.so
_

Patches currently in -mm which might be from roland@redhat.com are

powerpc-vdso-install-unstripped-copies-on-disk.patch
powerpc-vdso-install-unstripped-copies-on-disk-update.patch
powerpc-ptrace-check_full_regs.patch
git-powerpc-galak.patch
git-kbuild.patch
x86_64-vdso-linker-script-cleanup.patch
x86_64-vdso-put-vars-in-rodata.patch
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
