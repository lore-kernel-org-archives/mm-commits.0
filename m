From: akpm@linux-foundation.org
Subject: + powerpc-vdso-install-unstripped-copies-on-disk-update.patch added to -mm tree
Date: Wed, 15 Aug 2007 15:23:38 -0700
Message-ID: <200708152223.l7FMNcbS018052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936208AbXHOWYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 18:24:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, benh@kernel.crashing.org, paulus@samba.org, sam@ravnborg.org


The patch titled
     powerpc-vdso-install-unstripped-copies-on-disk update
has been added to the -mm tree.  Its filename is
     powerpc-vdso-install-unstripped-copies-on-disk-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -166,12 +166,14 @@ define archhelp
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
@@ -221,3 +223,4 @@ checkbin:
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

signalfd-fix-interaction-with-posix-timers.patch
signalfd-make-it-group-wide-fix-posix-timers-scheduling.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
powerpc-vdso-install-unstripped-copies-on-disk-update.patch
pass-g-to-assembler-under-config_debug_info.patch
pass-g-to-assembler-under-config_debug_info-powerpc-fix.patch
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
add-mmf_dump_elf_headers.patch
pie-executable-randomization.patch
