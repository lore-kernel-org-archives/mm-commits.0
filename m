From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 14 May 2008 14:21:02 -0700
Message-ID: <200805142121.m4ELL2Q7021528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311AbYENVVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 17:21:05 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4ELL2FE020377
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2008 14:21:03 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/common/tuners/Kconfig |   64 --------------------------
 drivers/media/video/pvrusb2/Kconfig |    4 -
 drivers/usb/gadget/serial.c         |    8 ---
 3 files changed, 76 deletions(-)

diff -puN drivers/media/common/tuners/Kconfig~linux-next-git-rejects drivers/media/common/tuners/Kconfig
--- a/drivers/media/common/tuners/Kconfig~linux-next-git-rejects
+++ a/drivers/media/common/tuners/Kconfig
@@ -22,11 +22,7 @@ config MEDIA_TUNER
 	default VIDEO_MEDIA && I2C
 	depends on VIDEO_MEDIA && I2C
 	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMIZE && HOTPLUG
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMIZE && HOTPLUG
-=======
 	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMIZE
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	select MEDIA_TUNER_MT20XX if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_TEA5761 if !MEDIA_TUNER_CUSTOMIZE
@@ -50,10 +46,6 @@ if MEDIA_TUNER_CUSTOMIZE
 
 config MEDIA_TUNER_SIMPLE
 	tristate "Simple tuner support"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	select MEDIA_TUNER_TDA9887
 	default m if MEDIA_TUNER_CUSTOMIZE
 	help
@@ -61,10 +53,6 @@ config MEDIA_TUNER_SIMPLE
 
 config MEDIA_TUNER_TDA8290
 	tristate "TDA 8290/8295 + 8275(a)/18271 tuner combo"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	select MEDIA_TUNER_TDA827X
 	select MEDIA_TUNER_TDA18271
 	default m if MEDIA_TUNER_CUSTOMIZE
@@ -73,30 +61,18 @@ config MEDIA_TUNER_TDA8290
 
 config MEDIA_TUNER_TDA827X
 	tristate "Philips TDA827X silicon tuner"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A DVB-T silicon tuner module. Say Y when you want to support this tuner.
 
 config MEDIA_TUNER_TDA18271
 	tristate "NXP TDA18271 silicon tuner"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A silicon tuner module. Say Y when you want to support this tuner.
 
 config MEDIA_TUNER_TDA9887
 	tristate "TDA 9885/6/7 analog IF demodulator"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	default m if MEDIA_TUNER_CUSTOMIZE
 	help
 	  Say Y here to include support for Philips TDA9885/6/7
@@ -104,10 +80,6 @@ config MEDIA_TUNER_TDA9887
 
 config MEDIA_TUNER_TEA5761
 	tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	depends on EXPERIMENTAL
 	default m if MEDIA_TUNER_CUSTOMIZE
 	help
@@ -115,70 +87,42 @@ config MEDIA_TUNER_TEA5761
 
 config MEDIA_TUNER_TEA5767
 	tristate "TEA 5767 radio tuner"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	default m if MEDIA_TUNER_CUSTOMIZE
 	help
 	  Say Y here to include support for the Philips TEA5767 radio tuner.
 
 config MEDIA_TUNER_MT20XX
 	tristate "Microtune 2032 / 2050 tuners"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	default m if MEDIA_TUNER_CUSTOMIZE
 	help
 	  Say Y here to include support for the MT2032 / MT2050 tuner.
 
 config MEDIA_TUNER_MT2060
 	tristate "Microtune MT2060 silicon IF tuner"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A driver for the silicon IF tuner MT2060 from Microtune.
 
 config MEDIA_TUNER_MT2266
 	tristate "Microtune MT2266 silicon tuner"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A driver for the silicon baseband tuner MT2266 from Microtune.
 
 config MEDIA_TUNER_MT2131
 	tristate "Microtune MT2131 silicon tuner"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A driver for the silicon baseband tuner MT2131 from Microtune.
 
 config MEDIA_TUNER_QT1010
 	tristate "Quantek QT1010 silicon tuner"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A driver for the silicon tuner QT1010 from Quantek.
 
 config MEDIA_TUNER_XC2028
 	tristate "XCeive xc2028/xc3028 tuners"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	depends on HOTPLUG
 	select FW_LOADER
 	default m if MEDIA_TUNER_CUSTOMIZE
@@ -187,10 +131,6 @@ config MEDIA_TUNER_XC2028
 
 config MEDIA_TUNER_XC5000
 	tristate "Xceive XC5000 silicon tuner"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	depends on HOTPLUG
 	select FW_LOADER
 	default m if DVB_FE_CUSTOMISE
@@ -201,11 +141,7 @@ config MEDIA_TUNER_XC5000
 
 config MEDIA_TUNER_MXL5005S
 	tristate "MaxLinear MSL5005S silicon tuner"
-<<<<<<< HEAD:drivers/media/common/tuners/Kconfig
-	depends on VIDEO_MEDIA && I2C
-=======
 	depends on I2C
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/Kconfig
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A driver for the silicon tuner MXL5005S from MaxLinear.
diff -puN drivers/media/video/pvrusb2/Kconfig~linux-next-git-rejects drivers/media/video/pvrusb2/Kconfig
--- a/drivers/media/video/pvrusb2/Kconfig~linux-next-git-rejects
+++ a/drivers/media/video/pvrusb2/Kconfig
@@ -1,10 +1,6 @@
 config VIDEO_PVRUSB2
 	tristate "Hauppauge WinTV-PVR USB2 support"
 	depends on VIDEO_V4L2 && I2C
-<<<<<<< HEAD:drivers/media/video/pvrusb2/Kconfig
-	depends on VIDEO_MEDIA	# Avoids pvrusb = Y / DVB = M
-=======
->>>>>>> FETCH_HEAD:drivers/media/video/pvrusb2/Kconfig
 	depends on HOTPLUG	# due to FW_LOADER
 	select FW_LOADER
 	select VIDEO_TUNER
diff -puN drivers/usb/gadget/serial.c~linux-next-git-rejects drivers/usb/gadget/serial.c
--- a/drivers/usb/gadget/serial.c~linux-next-git-rejects
+++ a/drivers/usb/gadget/serial.c
@@ -1608,19 +1608,11 @@ static int gs_setup(struct usb_gadget *g
 
 	switch (ctrl->bRequestType & USB_TYPE_MASK) {
 	case USB_TYPE_STANDARD:
-<<<<<<< HEAD:drivers/usb/gadget/serial.c
-		ret = gs_setup_standard(gadget, ctrl);
-		break;
-
-	case USB_TYPE_CLASS:
-		ret = gs_setup_class(gadget, ctrl);
-=======
 		ret = gs_setup_standard(gadget,ctrl);
 		break;
 
 	case USB_TYPE_CLASS:
 		ret = gs_setup_class(gadget,ctrl);
->>>>>>> FETCH_HEAD:drivers/usb/gadget/serial.c
 		break;
 
 	default:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
audit_send_reply-fix-error-path-memory-leak.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
mmc-sd-host-driver-for-ricoh-bay1controllers-fix.patch
mmc-sd-host-driver-for-ricoh-bay1controllers-fix-2.patch
git-ubifs.patch
hysdn-no-longer-broken-on-smp.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
drivers-net-tokenring-3c359c-squish-a-warning.patch
drivers-net-tokenring-olympicc-fix-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
selinux-dopey-hack.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
git-unionfs.patch
git-unionfs-fixup.patch
unionfs-broke.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
uwb-fix-scscanf-warning.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
drivers-uwb-i1480-dfu-macc-fix-min-warning.patch
drivers-uwb-i1480-dfu-usbc-fix-size_t-confusion.patch
drivers-uwb-whcic-needs-dma-mappingh.patch
rndis-switch-to-seq_files-checkpatch-fixes.patch
git-v9fs.patch
revert-git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
wireless-fix-iwlwifi-unify-init-driver-flow.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
git-orion-git-rejects.patch
mprotect-prevent-alteration-of-the-pat-bits-checkpatch-fixes.patch
tty_check_change-avoid-taking-tasklist_lock-while-holding-tty-ctrl_lock.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha-hack.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_flush_sem-to-mutex-fix.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
reiser4.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

