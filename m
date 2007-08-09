From: akpm@linux-foundation.org
Subject: + x86_64-vdso-install-unstripped-copies-on-disk.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:48:53 -0700
Message-ID: <200708092148.l79Lmr5p021312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35048 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032AbXHIVtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:49:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de


The patch titled
     x86_64 vDSO: install unstripped copies on disk
has been added to the -mm tree.  Its filename is
     x86_64-vdso-install-unstripped-copies-on-disk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 vDSO: install unstripped copies on disk
From: Roland McGrath <roland@redhat.com>

This keeps an unstripped copy of the vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed
in $(MODLIB)/vdso/ by "make install".  These files can be useful when they
contain source-level debugging information.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Makefile      |    1 +
 arch/x86_64/vdso/Makefile |   20 ++++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/Makefile~x86_64-vdso-install-unstripped-copies-on-disk arch/x86_64/Makefile
--- a/arch/x86_64/Makefile~x86_64-vdso-install-unstripped-copies-on-disk
+++ a/arch/x86_64/Makefile
@@ -107,6 +107,7 @@ fdimage fdimage144 fdimage288 isoimage: 
 
 install:
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@ 
+	$(Q)$(MAKE) $(build)=arch/x86_64/vdso $@
 ifeq ($(CONFIG_IA32_EMULATION),y)
 	$(Q)$(MAKE) $(build)=arch/x86_64/ia32 $@
 endif
diff -puN arch/x86_64/vdso/Makefile~x86_64-vdso-install-unstripped-copies-on-disk arch/x86_64/vdso/Makefile
--- a/arch/x86_64/vdso/Makefile~x86_64-vdso-install-unstripped-copies-on-disk
+++ a/arch/x86_64/vdso/Makefile
@@ -13,7 +13,7 @@ vobjs := $(foreach F,$(vobjs-y),$(obj)/$
 
 $(obj)/vdso.o: $(obj)/vdso.so
 
-targets += vdso.so vdso.lds $(vobjs-y) vdso-syms.o
+targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y) vdso-syms.o
 
 # The DSO images are built using a special linker script.
 quiet_cmd_syscall = SYSCALL $@
@@ -25,14 +25,18 @@ export CPPFLAGS_vdso.lds += -P -C -U$(AR
 vdso-flags = -fPIC -shared -Wl,-soname=linux-vdso.so.1 \
 		 $(call ld-option, -Wl$(comma)--hash-style=sysv) \
 		-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
-SYSCFLAGS_vdso.so = $(vdso-flags)
+SYSCFLAGS_vdso.so.dbg = $(vdso-flags)
 
 $(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
 
-$(obj)/vdso.so: $(src)/vdso.lds $(vobjs) FORCE
+$(obj)/vdso.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,syscall)
 
-CFL := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64
 
 $(obj)/vclock_gettime.o: CFLAGS = $(CFL)
 $(obj)/vgetcpu.o: CFLAGS = $(CFL)
@@ -47,3 +51,11 @@ $(obj)/built-in.o: ld_flags += -R $(obj)
 SYSCFLAGS_vdso-syms.o = -r -d
 $(obj)/vdso-syms.o: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,syscall)
+
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $@.dbg $(MODLIB)/vdso/$@
+vdso.so:
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+install: vdso.so
_

Patches currently in -mm which might be from roland@redhat.com are

powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
x86_64-vdso-install-unstripped-copies-on-disk.patch
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
