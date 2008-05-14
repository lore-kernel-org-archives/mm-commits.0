From: akpm@linux-foundation.org
Subject: - rndis-switch-to-seq_files-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 14 May 2008 16:24:13 -0700
Message-ID: <200805142324.m4ENODlT026890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884AbYENXYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 19:24:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, david-b@pacbell.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     rndis-switch-to-seq_files-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     rndis-switch-to-seq_files-checkpatch-fixes.patch

This patch was dropped because it was folded into rndis-switch-to-seq_files.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rndis-switch-to-seq_files-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: space prohibited between function name and open parenthesis '('
#29: FILE: drivers/usb/gadget/rndis.c:1300:
+static int rndis_proc_show (struct seq_file *m, void *v)

WARNING: space prohibited between function name and open parenthesis '('
#37: FILE: drivers/usb/gadget/rndis.c:1304:
+	seq_printf (m,

WARNING: space prohibited between function name and open parenthesis '('
#63: FILE: drivers/usb/gadget/rndis.c:1330:
+static ssize_t rndis_proc_write (struct file *file, const char __user *buffer,

WARNING: space prohibited between function name and open parenthesis '('
#97: FILE: drivers/usb/gadget/rndis.c:1406:
+				= proc_create_data (name, 0660, NULL,

total: 0 errors, 4 warnings, 94 lines checked

./patches/rndis-switch-to-seq_files.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/rndis.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/usb/gadget/rndis.c~rndis-switch-to-seq_files-checkpatch-fixes drivers/usb/gadget/rndis.c
--- a/drivers/usb/gadget/rndis.c~rndis-switch-to-seq_files-checkpatch-fixes
+++ a/drivers/usb/gadget/rndis.c
@@ -1297,11 +1297,11 @@ int rndis_rm_hdr(struct sk_buff *skb)
 
 #ifdef	CONFIG_USB_GADGET_DEBUG_FILES
 
-static int rndis_proc_show (struct seq_file *m, void *v)
+static int rndis_proc_show(struct seq_file *m, void *v)
 {
 	rndis_params *param = m->private;
 
-	seq_printf (m,
+	seq_printf(m,
 			 "Config Nr. %d\n"
 			 "used      : %s\n"
 			 "state     : %s\n"
@@ -1327,7 +1327,7 @@ static int rndis_proc_show (struct seq_f
 	return 0;
 }
 
-static ssize_t rndis_proc_write (struct file *file, const char __user *buffer,
+static ssize_t rndis_proc_write(struct file *file, const char __user *buffer,
 		size_t count, loff_t *ppos)
 {
 	rndis_params *p = PDE(file->f_path.dentry->d_inode)->data;
@@ -1403,7 +1403,7 @@ int __init rndis_init (void)
 
 		sprintf (name, NAME_TEMPLATE, i);
 		if (!(rndis_connect_state [i]
-				= proc_create_data (name, 0660, NULL,
+				= proc_create_data(name, 0660, NULL,
 					&rndis_proc_fops,
 					(void *)(rndis_per_dev_params + i))))
 		{
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
selinux-dopey-hack.patch
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
rndis-switch-to-seq_files.patch
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
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
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

