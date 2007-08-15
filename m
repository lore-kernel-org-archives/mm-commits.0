From: akpm@linux-foundation.org
Subject: + update-x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch added to -mm tree
Date: Wed, 15 Aug 2007 16:22:48 -0700
Message-ID: <200708152322.l7FNMm6Q020364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48192 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030264AbXHOXX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 19:23:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, sam@ravnborg.org


The patch titled
     update x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk
has been added to the -mm tree.  Its filename is
     update-x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk
From: Roland McGrath <roland@redhat.com>

While integrating these with the Fedora kernel build, I worked out a few kinks.
This patch replaces x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch


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

 arch/x86_64/Makefile      |    4 +++-
 arch/x86_64/ia32/Makefile |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/Makefile~update-x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk arch/x86_64/Makefile
--- a/arch/x86_64/Makefile~update-x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk
+++ a/arch/x86_64/Makefile
@@ -109,8 +109,10 @@ bzdisk: vmlinux
 fdimage fdimage144 fdimage288 isoimage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@
 
-install:
+install: vdso_install
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@ 
+
+vdso_install:
 ifeq ($(CONFIG_IA32_EMULATION),y)
 	$(Q)$(MAKE) $(build)=arch/x86_64/ia32 $@
 endif
diff -puN arch/x86_64/ia32/Makefile~update-x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk arch/x86_64/ia32/Makefile
--- a/arch/x86_64/ia32/Makefile~update-x86_64-mm-x86_64-ia32-vdso-install-unstripped-copies-on-disk
+++ a/arch/x86_64/ia32/Makefile
@@ -49,4 +49,4 @@ $(vdsos):
 	@mkdir -p $(MODLIB)/vdso
 	$(call cmd,vdso_install)
 
-install: $(vdsos)
+vdso_install: $(vdsos)
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
