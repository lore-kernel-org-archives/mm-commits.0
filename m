From: akpm@linux-foundation.org
Subject: + update-x86_64-vdso-install-unstripped-copies-on-disk.patch added to -mm tree
Date: Wed, 15 Aug 2007 15:34:09 -0700
Message-ID: <200708152234.l7FMY9C4018456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37030 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760763AbXHOWe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 18:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de


The patch titled
     update x86_64-vdso-install-unstripped-copies-on-disk
has been added to the -mm tree.  Its filename is
     update-x86_64-vdso-install-unstripped-copies-on-disk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

signalfd-fix-interaction-with-posix-timers.patch
signalfd-make-it-group-wide-fix-posix-timers-scheduling.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
powerpc-vdso-install-unstripped-copies-on-disk-update.patch
pass-g-to-assembler-under-config_debug_info.patch
pass-g-to-assembler-under-config_debug_info-powerpc-fix.patch
update-x86_64-mm-install-unstripped-copies-on-disk.patch
update-x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
update-x86_64-vdso-install-unstripped-copies-on-disk.patch
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
