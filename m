From: akpm@linux-foundation.org
Subject: + fix-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch added to -mm tree
Date: Tue, 13 May 2008 09:32:49 -0700
Message-ID: <200805131632.m4DGWnjG021342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbYEMQdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 12:33:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, JRottmann@LiPPERT-AT.de, dilinger@debian.org, jordan.crouse@amd.com


The patch titled
     fix "lxfb: extend PLL table to support dotclocks below 25 MHz"
has been added to the -mm tree.  Its filename is
     fix-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch

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
Subject: fix "lxfb: extend PLL table to support dotclocks below 25 MHz"
From: Andrew Morton <akpm@linux-foundation.org>

Fix

commit 3888d4639e78802c4ec1086127124e890461b9e4
Author: Jens Rottmann <JRottmann@LiPPERT-AT.de>
Date:   Mon Apr 28 02:15:22 2008 -0700

    lxfb: extend PLL table to support dotclocks below 25 MHz
    
Signed-off-by: Jens Rottmann <JRottmann@LiPPERT-AT.de>
Acked-by: Andres Salomon <dilinger@debian.org>
Tested-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb_ops.c |   22 ----------------------
 1 file changed, 22 deletions(-)

diff -puN drivers/video/geode/lxfb_ops.c~fix-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~fix-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz
+++ a/drivers/video/geode/lxfb_ops.c
@@ -63,54 +63,32 @@ static const struct {
   { 0x00014284,  19688 },
   { 0x00011104,  20400 },
   { 0x00016363,  23625 },
-  { 0x00015303,  24380 },
   { 0x000031AC,  24923 },
   { 0x0000215D,  25175 },
   { 0x00001087,  27000 },
   { 0x0000216C,  28322 },
   { 0x0000218D,  28560 },
-  { 0x00010041,  29913 },
   { 0x000010C9,  31200 },
   { 0x00003147,  31500 },
-  { 0x000141A1,  32400 },
   { 0x000010A7,  33032 },
-  { 0x00012182,  33375 },
-  { 0x000141B1,  33750 },
   { 0x00002159,  35112 },
   { 0x00004249,  35500 },
   { 0x00000057,  36000 },
-  { 0x000141E1,  37125 },
   { 0x0000219A,  37889 },
   { 0x00002158,  39168 },
   { 0x00000045,  40000 },
-  { 0x000131A1,  40500 },
-  { 0x00010061,  42301 },
   { 0x00000089,  43163 },
-  { 0x00012151,  43875 },
   { 0x000010E7,  44900 },
   { 0x00002136,  45720 },
-  { 0x000152E1,  47250 },
-  { 0x00010071,  48000 },
   { 0x00003207,  49500 },
   { 0x00002187,  50000 },
-  { 0x00014291,  50625 },
-  { 0x00011101,  51188 },
-  { 0x00017481,  54563 },
   { 0x00004286,  56250 },
-  { 0x00014170,  57375 },
-  { 0x00016210,  58500 },
   { 0x000010E5,  60065 },
-  { 0x00013140,  62796 },
   { 0x00004214,  65000 },
-  { 0x00016250,  65250 },
   { 0x00001105,  68179 },
-  { 0x000141C0,  69600 },
-  { 0x00015220,  70160 },
-  { 0x00010050,  72000 },
   { 0x000031E4,  74250 },
   { 0x00003183,  75000 },
   { 0x00004284,  78750 },
-  { 0x00012130,  80052 },
   { 0x00001104,  81600 },
   { 0x00006363,  94500 },
   { 0x00005303,  97520 },
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off.patch
fix-hfsplus-oops-on-image-without-extents.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic.patch
atmel_lcdfb-fix-pixclok-divider-calculation.patch
memcg-fix-possible-panic-when-config_mm_owner=y.patch
drivers-char-synclink_gtc-dont-return-an-uninitialised-local.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
ia64-kvm-dont-delete-files-which-we-need.patch
fix-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-early_init_centaur-use-set_cpu_cap.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
audit_send_reply-fix-error-path-memory-leak.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
fix-gregkh-driver-core-read-dev_name-instead-of-bus_id.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
git-mmc.patch
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
revert-git-block.patch
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
git-v9fs.patch
revert-git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
git-orion-git-rejects.patch
ext4-is-busted-on-m68k.patch
common-implementation-of-iterative-div-mod-fix.patch
common-implementation-of-iterative-div-mod-checkpatch-fixes.patch
common-implementation-of-iterative-div-mod-fix-2.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
mm-verify-the-page-links-and-memory-model-fix.patch
mm-verify-the-page-links-and-memory-model-fix-fix.patch
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
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha-hack.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
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

