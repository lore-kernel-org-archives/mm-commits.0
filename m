From: akpm@linux-foundation.org
Subject: + cleanup-arch-alpha-makefile.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:42:18 -0700
Message-ID: <200707310142.l6V1gIol008958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40859 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761710AbXGaBms (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:42:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     cleanup arch/alpha/Makefile
has been added to the -mm tree.  Its filename is
     cleanup-arch-alpha-makefile.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
remove-the-arm26-port.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
make-struct-sony_nc_ids-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
ppc-remove-apus-support.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
export-v4l2_int_device_unregister.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
mtd-onenand_simc-make-struct-info-static.patch
remove-fs-jffs2-ioctlc.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
fore200e_param_bs_queue-must-be-__devinit.patch
make-pktgencget_ipsec_sa-static-and-non-inline.patch
make-nf_ct_ipv6_skip_exthdr-static.patch
net-unix-af_unixc-make-code-static.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
parisc-extern-inline-static-inline.patch
cpqphp_ctrlc-remove-dead-code.patch
kernel-schedc-make-code-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
make-scsi_host_link_pm_policy-static.patch
drivers-scsi-scsi_errorc-should-include.patch
drivers-scsi-constantsc-make-2-functions-static.patch
git-unionfs.patch
drivers-usb-serial-sierrac-make-3-functions-static.patch
fix-gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-hosts.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
arch-i386-mm-discontigc-make-some-variables-static.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
acpi_ec_remove-fix-use-after-free.patch
acpi_battery_add-use-after-free.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-migratec-cleanups.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
