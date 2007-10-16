From: akpm@linux-foundation.org
Subject: - cleanup-arch-alpha-makefile.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:27 -0700
Message-ID: <200710162036.l9GKaRn6015182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46308 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935950AbXJPVgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     cleanup arch/alpha/Makefile
has been removed from the -mm tree.  Its filename was
     cleanup-arch-alpha-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cleanup arch/alpha/Makefile
From: Adrian Bunk <bunk@stusta.de>

- binutils 2.7 is far below the current minimum supported version,
  and there's therefore no longer a need for an extra test

- since even gcc 3.2 already supports all options used we can use them
  unconditionally

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Makefile |   79 +++++++-----------------------------------
 1 file changed, 14 insertions(+), 65 deletions(-)

diff -puN arch/alpha/Makefile~cleanup-arch-alpha-makefile arch/alpha/Makefile
--- a/arch/alpha/Makefile~cleanup-arch-alpha-makefile
+++ a/arch/alpha/Makefile
@@ -12,73 +12,22 @@ NM := $(NM) -B
 
 LDFLAGS_vmlinux	:= -static -N #-relax
 CHECKFLAGS	+= -D__alpha__ -m64
-cflags-y	:= -pipe -mno-fp-regs -ffixed-8
+cflags-y	:= -pipe -mno-fp-regs -ffixed-8 -msmall-data
 
-# Determine if we can use the BWX instructions with GAS.
-old_gas := $(shell if $(AS) --version 2>&1 | grep 'version 2.7' > /dev/null; then echo y; else echo n; fi)
+cpuflags-$(CONFIG_ALPHA_EV67)		:= -mcpu=ev67
+cpuflags-$(CONFIG_ALPHA_EV6)		:= -mcpu=ev6
+cpuflags-$(CONFIG_ALPHA_POLARIS)	:= -mcpu=pca56
+cpuflags-$(CONFIG_ALPHA_SX164)		:= -mcpu=pca56
+cpuflags-$(CONFIG_ALPHA_EV56)		:= -mcpu=ev56
+cpuflags-$(CONFIG_ALPHA_EV5)		:= -mcpu=ev5
+cpuflags-$(CONFIG_ALPHA_EV4)		:= -mcpu=ev4
+# If GENERIC, make sure to turn off any instruction set extensions that
+# the host compiler might have on by default.  Given that EV4 and EV5
+# have the same instruction set, prefer EV5 because an EV5 schedule is
+# more likely to keep an EV4 processor busy than vice-versa.
+cpuflags-$(CONFIG_ALPHA_GENERIC)	:= -mcpu=ev5
 
-ifeq ($(old_gas),y)
-$(error The assembler '$(AS)' does not support the BWX instruction)
-endif
-
-# Determine if GCC understands the -mcpu= option.
-have_mcpu        := $(call cc-option-yn, -mcpu=ev5)
-have_mcpu_pca56  := $(call cc-option-yn, -mcpu=pca56)
-have_mcpu_ev6    := $(call cc-option-yn, -mcpu=ev6)
-have_mcpu_ev67   := $(call cc-option-yn, -mcpu=ev67)
-have_msmall_data := $(call cc-option-yn, -msmall-data)
-
-cflags-$(have_msmall_data) += -msmall-data
-
-# Turn on the proper cpu optimizations.
-ifeq ($(have_mcpu),y)
-  mcpu_done := n
-  # If GENERIC, make sure to turn off any instruction set extensions that
-  # the host compiler might have on by default.  Given that EV4 and EV5
-  # have the same instruction set, prefer EV5 because an EV5 schedule is
-  # more likely to keep an EV4 processor busy than vice-versa.
-  ifeq ($(CONFIG_ALPHA_GENERIC),y)
-    mcpu := ev5
-    mcpu_done := y
-  endif
-  ifeq ($(mcpu_done)$(CONFIG_ALPHA_SX164)$(have_mcpu_pca56),nyy)
-    mcpu := pca56
-    mcpu_done := y
-  endif
-  ifeq ($(mcpu_done)$(CONFIG_ALPHA_POLARIS)$(have_mcpu_pca56),nyy)
-    mcpu := pca56
-    mcpu_done := y
-  endif
-  ifeq ($(mcpu_done)$(CONFIG_ALPHA_EV4),ny)
-    mcpu := ev4
-    mcpu_done := y
-  endif
-  ifeq ($(mcpu_done)$(CONFIG_ALPHA_EV56),ny)
-    mcpu := ev56
-    mcpu_done := y
-  endif
-  ifeq ($(mcpu_done)$(CONFIG_ALPHA_EV5),ny)
-    mcpu := ev5
-    mcpu_done := y
-  endif
-  ifeq ($(mcpu_done)$(CONFIG_ALPHA_EV67)$(have_mcpu_ev67),nyy)
-    mcpu := ev67
-    mcpu_done := y
-  endif
-  ifeq ($(mcpu_done)$(CONFIG_ALPHA_EV6),ny)
-    ifeq ($(have_mcpu_ev6),y)
-      mcpu := ev6
-    else
-      ifeq ($(have_mcpu_pca56),y)
-        mcpu := pca56
-      else
-        mcpu=ev56
-      endif
-    endif
-    mcpu_done := y
-  endif
-  cflags-$(mcpu_done) += -mcpu=$(mcpu)
-endif
+cflags-y				+= $(cpuflags-y)
 
 
 # For TSUNAMI, we must have the assembler not emulate our instructions.
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-kvm.patch
remove-fs-jffs2-ioctlc.patch
parisc-extern-inline-static-inline.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-ipwireless_cs.patch
maps2-add-proc-kpagemap-interface.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
unicode-diacritics-support-s390-fix.patch
script-to-check-for-undefined-kconfig-symbols.patch
drivers-block-ccissc-fix-check-after-use.patch
dontdiff-update-based-on-gitignore-updates.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
