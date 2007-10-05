From: akpm@linux-foundation.org
Subject: - powerpc-vdso-install-unstripped-copies-on-disk.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:27 -0700
Message-ID: <200710051956.l95JuRih022353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49213 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761117AbXJET4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:56:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, benh@kernel.crashing.org, paulus@samba.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     powerpc vDSO: install unstripped copies on disk
has been removed from the -mm tree.  Its filename was
     powerpc-vdso-install-unstripped-copies-on-disk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc vDSO: install unstripped copies on disk
From: Roland McGrath <roland@redhat.com>

This keeps an unstripped copy of the vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed in
$(MODLIB)/vdso/ by "make install".  These files can be useful when they
contain source-level debugging information.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Makefile               |    8 +++++++-
 arch/powerpc/kernel/vdso32/Makefile |   20 +++++++++++++++++---
 arch/powerpc/kernel/vdso64/Makefile |   19 ++++++++++++++++---
 3 files changed, 40 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/Makefile~powerpc-vdso-install-unstripped-copies-on-disk arch/powerpc/Makefile
--- a/arch/powerpc/Makefile~powerpc-vdso-install-unstripped-copies-on-disk
+++ a/arch/powerpc/Makefile
@@ -162,9 +162,15 @@ define archhelp
   @echo '  *_defconfig     - Select default config from arch/$(ARCH)/configs'
 endef
 
-install:
+install: vdso_install
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
 
+vdso_install:
+ifeq ($(CONFIG_PPC64),y)
+	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso64 $@
+endif
+	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso32 $@
+
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 
diff -puN arch/powerpc/kernel/vdso32/Makefile~powerpc-vdso-install-unstripped-copies-on-disk arch/powerpc/kernel/vdso32/Makefile
--- a/arch/powerpc/kernel/vdso32/Makefile~powerpc-vdso-install-unstripped-copies-on-disk
+++ a/arch/powerpc/kernel/vdso32/Makefile
@@ -9,11 +9,11 @@ ifeq ($(CONFIG_PPC32),y)
 CROSS32CC := $(CC)
 endif
 
-targets := $(obj-vdso32) vdso32.so
+targets := $(obj-vdso32) vdso32.so vdso32.so.dbg
 obj-vdso32 := $(addprefix $(obj)/, $(obj-vdso32))
 
 
-EXTRA_CFLAGS := -shared -s -fno-common -fno-builtin
+EXTRA_CFLAGS := -shared -fno-common -fno-builtin
 EXTRA_CFLAGS += -nostdlib -Wl,-soname=linux-vdso32.so.1 \
 		$(call ld-option, -Wl$(comma)--hash-style=sysv)
 EXTRA_AFLAGS := -D__VDSO32__ -s
@@ -26,9 +26,14 @@ CPPFLAGS_vdso32.lds += -P -C -Upowerpc
 $(obj)/vdso32_wrapper.o : $(obj)/vdso32.so
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso32.so: $(src)/vdso32.lds $(obj-vdso32)
+$(obj)/vdso32.so.dbg: $(src)/vdso32.lds $(obj-vdso32)
 	$(call if_changed,vdso32ld)
 
+# strip rule for the .so file
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
 # assembly rules for the .S files
 $(obj-vdso32): %.o: %.S
 	$(call if_changed_dep,vdso32as)
@@ -39,3 +44,12 @@ quiet_cmd_vdso32ld = VDSO32L $@
 quiet_cmd_vdso32as = VDSO32A $@
       cmd_vdso32as = $(CROSS32CC) $(a_flags) -c -o $@ $<
 
+# install commands for the unstripped file
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
+
+vdso32.so: $(obj)/vdso32.so.dbg
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+vdso_install: vdso32.so
diff -puN arch/powerpc/kernel/vdso64/Makefile~powerpc-vdso-install-unstripped-copies-on-disk arch/powerpc/kernel/vdso64/Makefile
--- a/arch/powerpc/kernel/vdso64/Makefile~powerpc-vdso-install-unstripped-copies-on-disk
+++ a/arch/powerpc/kernel/vdso64/Makefile
@@ -4,10 +4,10 @@ obj-vdso64 = sigtramp.o gettimeofday.o d
 
 # Build rules
 
-targets := $(obj-vdso64) vdso64.so
+targets := $(obj-vdso64) vdso64.so vdso64.so.dbg
 obj-vdso64 := $(addprefix $(obj)/, $(obj-vdso64))
 
-EXTRA_CFLAGS := -shared -s -fno-common -fno-builtin
+EXTRA_CFLAGS := -shared -fno-common -fno-builtin
 EXTRA_CFLAGS += -nostdlib -Wl,-soname=linux-vdso64.so.1 \
 		$(call ld-option, -Wl$(comma)--hash-style=sysv)
 EXTRA_AFLAGS := -D__VDSO64__ -s
@@ -20,9 +20,14 @@ CPPFLAGS_vdso64.lds += -P -C -U$(ARCH)
 $(obj)/vdso64_wrapper.o : $(obj)/vdso64.so
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso64.so: $(src)/vdso64.lds $(obj-vdso64)
+$(obj)/vdso64.so.dbg: $(src)/vdso64.lds $(obj-vdso64)
 	$(call if_changed,vdso64ld)
 
+# strip rule for the .so file
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
 # assembly rules for the .S files
 $(obj-vdso64): %.o: %.S
 	$(call if_changed_dep,vdso64as)
@@ -33,4 +38,12 @@ quiet_cmd_vdso64ld = VDSO64L $@
 quiet_cmd_vdso64as = VDSO64A $@
       cmd_vdso64as = $(CC) $(a_flags) -c -o $@ $<
 
+# install commands for the unstripped file
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
+
+vdso64.so: $(obj)/vdso64.so.dbg
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
 
+vdso_install: vdso64.so
_

Patches currently in -mm which might be from roland@redhat.com are

git-powerpc.patch
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
