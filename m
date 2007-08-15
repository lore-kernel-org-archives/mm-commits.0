From: akpm@linux-foundation.org
Subject: + update-x86_64-mm-install-unstripped-copies-on-disk.patch added to -mm tree
Date: Wed, 15 Aug 2007 15:26:48 -0700
Message-ID: <200708152226.l7FMQmCr018198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755537AbXHOW1K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 18:27:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, sam@ravnborg.org


The patch titled
     update x86_64-mm-install-unstripped-copies-on-disk
has been added to the -mm tree.  Its filename is
     update-x86_64-mm-install-unstripped-copies-on-disk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update x86_64-mm-install-unstripped-copies-on-disk
From: Roland McGrath <roland@redhat.com>

While integrating these with the Fedora kernel build, I worked out a few kinks.
This patch replaces i386-vdso-install-unstripped-copies-on-disk.patch and
i386-vdso-install-unstripped-copies-on-disk-fix.patch


This keeps an unstripped copy of the vDSO images built before they are
stripped and embedded in the kernel.  The unstripped copies get installed
in $(MODLIB)/vdso/ by "make install" (or you can explicitly use the
subtarget "make vdso_install").  These files can be useful when they
contain source-level debugging information.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Makefile        |    6 ++++--
 arch/i386/kernel/Makefile |    6 +++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN arch/i386/Makefile~update-x86_64-mm-install-unstripped-copies-on-disk arch/i386/Makefile
--- a/arch/i386/Makefile~update-x86_64-mm-install-unstripped-copies-on-disk
+++ a/arch/i386/Makefile
@@ -137,9 +137,11 @@ zdisk bzdisk: vmlinux
 fdimage fdimage144 fdimage288 isoimage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) $@
 
-install:
+install: vdso_install
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
-	$(Q)$(MAKE) $(build)=arch/i386/kernel $@
+
+vdso_install:
+	$(Q)$(MAKE) $(build)=arch/i386/kernel vdso_install
 
 archclean:
 	$(Q)$(MAKE) $(clean)=arch/i386/boot
diff -puN arch/i386/kernel/Makefile~update-x86_64-mm-install-unstripped-copies-on-disk arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~update-x86_64-mm-install-unstripped-copies-on-disk
+++ a/arch/i386/kernel/Makefile
@@ -72,7 +72,7 @@ SYSCFLAGS_vsyscall-int80.so.dbg		= $(vsy
 
 $(obj)/vsyscall-int80.so.dbg $(obj)/vsyscall-sysenter.so.dbg: \
 $(obj)/vsyscall-%.so.dbg: $(src)/vsyscall.lds \
-				  $(obj)/vsyscall-%.o $(obj)/vsyscall-note.o FORCE
+		      $(obj)/vsyscall-%.o $(obj)/vsyscall-note.o FORCE
 	$(call if_changed,syscall)
 
 $(obj)/%.so: OBJCOPYFLAGS := -S
@@ -83,13 +83,13 @@ vdsos := vdso-int80.so vdso-sysenter.so
 
 quiet_cmd_vdso_install = INSTALL $@
       cmd_vdso_install = cp $(@:vdso-%.so=$(obj)/vsyscall-%.so.dbg) \
-				    $(MODLIB)/vdso/$@
+			    $(MODLIB)/vdso/$@
 
 $(vdsos):
 	@mkdir -p $(MODLIB)/vdso
 	$(call cmd,vdso_install)
 
-install: $(vdsos)
+vdso_install: $(vdsos)
 
 # We also create a special relocatable object that should mirror the symbol
 # table and layout of the linked DSO.  With ld -R we can then refer to
_

Patches currently in -mm which might be from roland@redhat.com are

signalfd-fix-interaction-with-posix-timers.patch
signalfd-make-it-group-wide-fix-posix-timers-scheduling.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
powerpc-vdso-install-unstripped-copies-on-disk-update.patch
pass-g-to-assembler-under-config_debug_info.patch
pass-g-to-assembler-under-config_debug_info-powerpc-fix.patch
update-x86_64-mm-install-unstripped-copies-on-disk.patch
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
