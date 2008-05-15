From: akpm@linux-foundation.org
Subject: - drivers-uwb-i1480-dfu-usbc-fix-size_t-confusion.patch removed from -mm tree
Date: Thu, 15 May 2008 12:39:16 -0700
Message-ID: <200805151939.m4FJdG1r006946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbYEOTjU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 15:39:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/uwb/i1480/dfu/usb.c: fix size_t confusion
has been removed from the -mm tree.  Its filename was
     drivers-uwb-i1480-dfu-usbc-fix-size_t-confusion.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/uwb/i1480/dfu/usb.c: fix size_t confusion
From: Andrew Morton <akpm@linux-foundation.org>

drivers/uwb/i1480/dfu/usb.c: In function 'i1480_usb_probe':
drivers/uwb/i1480/dfu/usb.c:425: warning: assignment from incompatible pointer type

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/uwb/i1480/dfu/i1480-dfu.h |    2 +-
 drivers/uwb/i1480/dfu/usb.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/uwb/i1480/dfu/i1480-dfu.h~drivers-uwb-i1480-dfu-usbc-fix-size_t-confusion drivers/uwb/i1480/dfu/i1480-dfu.h
--- a/drivers/uwb/i1480/dfu/i1480-dfu.h~drivers-uwb-i1480-dfu-usbc-fix-size_t-confusion
+++ a/drivers/uwb/i1480/dfu/i1480-dfu.h
@@ -116,7 +116,7 @@ struct i1480 {
 
 	int (*write)(struct i1480 *, u32 addr, const void *, size_t);
 	// read from addr into i1480->cmd_buf
-	int (*read)(struct i1480 *, u32 addr, size_t);
+	size_t (*read)(struct i1480 *, u32 addr, size_t);
 	int (*rc_setup)(struct i1480 *);
 	void (*rc_release)(struct i1480 *);
 	int (*wait_init_done)(struct i1480 *);
diff -puN drivers/uwb/i1480/dfu/usb.c~drivers-uwb-i1480-dfu-usbc-fix-size_t-confusion drivers/uwb/i1480/dfu/usb.c
--- a/drivers/uwb/i1480/dfu/usb.c~drivers-uwb-i1480-dfu-usbc-fix-size_t-confusion
+++ a/drivers/uwb/i1480/dfu/usb.c
@@ -161,7 +161,7 @@ int i1480_usb_write(struct i1480* i1480,
  *       memory address and size passed back in the @neh structure.
  */
 static
-ssize_t i1480_usb_read(struct i1480* i1480, u32 addr, size_t size)
+size_t i1480_usb_read(struct i1480* i1480, u32 addr, size_t size)
 {
 	ssize_t result = 0, bytes = 0;
 	size_t itr, read_size = i1480->buf_size;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
tty_check_change-avoid-taking-tasklist_lock-while-holding-tty-ctrl_lock.patch
net-irda-irnet-irnet_irdac-needs-unalignedh.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
git-x86-fixup.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
audit_send_reply-fix-error-path-memory-leak.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
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
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
uwb-fix-scscanf-warning.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
drivers-uwb-i1480-dfu-macc-fix-min-warning.patch
drivers-uwb-i1480-dfu-usbc-fix-size_t-confusion.patch
drivers-uwb-whcic-needs-dma-mappingh.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
wireless-fix-iwlwifi-unify-init-driver-flow.patch
git-xtensa.patch
git-orion-git-rejects.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
colibri-fix-support-for-dm9000-ethernet-device.patch
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

