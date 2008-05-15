From: akpm@linux-foundation.org
Subject: - selinux-dopey-hack.patch removed from -mm tree
Date: Wed, 14 May 2008 17:01:21 -0700
Message-ID: <200805150001.m4F01LP6028510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440AbYEOACC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 20:02:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jmorris@namei.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     selinux: dopey hack
has been removed from the -mm tree.  Its filename was
     selinux-dopey-hack.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: selinux: dopey hack
From: Andrew Morton <akpm@linux-foundation.org>

BUG: sleeping function called from invalid context at mm/slab.c:3052
in_atomic():1, irqs_disabled():0
3 locks held by S99local/2391:
 #0:  (&type->i_mutex_dir_key#4){--..}, at: [<c017973c>] do_lookup+0x72/0x146
 #1:  (&isec->lock){--..}, at: [<c01cc3e5>] inode_doinit_with_dentry+0x35/0x52f
 #2:  (policy_rwlock){..-?}, at: [<c01d7f89>] security_context_to_sid_core+0x5e/0x157
Pid: 2391, comm: S99local Not tainted 2.6.26-rc2 #1
 [<c011863c>] __might_sleep+0xde/0xe5
 [<c01706e5>] __kmalloc+0x52/0xd5
 [<c01d7d9f>] string_to_context_struct+0x2e/0x1ba
 [<c01d7fa3>] security_context_to_sid_core+0x78/0x157
 [<c01d80a5>] security_context_to_sid_default+0x10/0x12
 [<c01cc609>] inode_doinit_with_dentry+0x259/0x52f
 [<c01cc8f1>] selinux_d_instantiate+0x12/0x14
 [<c01c7f11>] security_d_instantiate+0x1c/0x1e
 [<c01828c4>] d_instantiate+0x55/0x5a
 [<c018376d>] d_splice_alias+0xc5/0xd5
 [<f8b8a063>] ext3_lookup+0x7b/0xa2 [ext3]
 [<c0179773>] do_lookup+0xa9/0x146
 [<c017b361>] __link_path_walk+0x75b/0xb54
 [<c013685b>] ? trace_hardirqs_off+0xb/0xd
 [<c01081a1>] ? native_sched_clock+0x8b/0x9f
 [<c017b7a3>] path_walk+0x49/0x96
 [<c017ba8e>] do_path_lookup+0x133/0x195
 [<c017aa60>] ? getname+0x60/0xb6
 [<c017c325>] __user_walk_fd+0x2f/0x43
 [<c01760ec>] vfs_stat_fd+0x19/0x40
 [<c01761c2>] vfs_stat+0x11/0x13
 [<c01761d8>] sys_stat64+0x14/0x28
 [<c014c088>] ? audit_syscall_entry+0x100/0x12a
 [<c014c35c>] ? audit_syscall_exit+0x2aa/0x2c5
 [<c01095aa>] ? do_syscall_trace+0x129/0x16f
 [<c0103992>] syscall_call+0x7/0xb

please don't merge this.

Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/ss/services.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/selinux/ss/services.c~selinux-dopey-hack security/selinux/ss/services.c
--- a/security/selinux/ss/services.c~selinux-dopey-hack
+++ a/security/selinux/ss/services.c
@@ -850,9 +850,9 @@ static int security_context_to_sid_core(
 	POLICY_RDLOCK;
 	rc = string_to_context_struct(&policydb, &sidtab,
 				      scontext, scontext_len,
-				      &context, def_sid, gfp_flags);
+				      &context, def_sid, GFP_ATOMIC);
 	if (rc == -EINVAL && force) {
-		context.str = kmalloc(scontext_len+1, gfp_flags);
+		context.str = kmalloc(scontext_len+1, GFP_ATOMIC);
 		if (!context.str) {
 			rc = -ENOMEM;
 			goto out;
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

