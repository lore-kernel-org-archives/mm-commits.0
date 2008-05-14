From: akpm@linux-foundation.org
Subject: + tty_check_change-avoid-taking-tasklist_lock-while-holding-tty-ctrl_lock.patch added to -mm tree
Date: Tue, 13 May 2008 18:49:27 -0700
Message-ID: <200805140149.m4E1nRdI010916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754062AbYENBtj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 21:49:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, marcin.slusarz@gmail.com


The patch titled
     tty_check_change(): avoid taking tasklist_lock while holding tty->ctrl_lock
has been added to the -mm tree.  Its filename is
     tty_check_change-avoid-taking-tasklist_lock-while-holding-tty-ctrl_lock.patch

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
Subject: tty_check_change(): avoid taking tasklist_lock while holding tty->ctrl_lock
From: Andrew Morton <akpm@linux-foundation.org>

May 11 09:42:27 [kernel] [ 1104.496819] rarian-sk-get-c[5630]: segfault at 0 ip 7f478556caf0 sp 7fff8e3fe338 error 4 in libc-2.6.1.so[7f47854f9000+136000]
May 11 10:59:48 [kernel] [ 2494.165792] 
May 11 10:59:48 [kernel] [ 2494.165794] =======================================================
May 11 10:59:48 [kernel] [ 2494.165801] [ INFO: possible circular locking dependency detected ]
May 11 10:59:48 [kernel] [ 2494.165805] 2.6.26-rc1-00007-g91b3a7a #217
May 11 10:59:48 [kernel] [ 2494.165807] -------------------------------------------------------
May 11 10:59:48 [kernel] [ 2494.165809] less/7053 is trying to acquire lock:
May 11 10:59:48 [kernel] [ 2494.165812]  (tasklist_lock){..??}, at: [<ffffffff80232e95>] is_current_pgrp_orphaned+0x15/0x50
May 11 10:59:48 [kernel] [ 2494.165821] 
May 11 10:59:48 [kernel] [ 2494.165822] but task is already holding lock:
May 11 10:59:48 [kernel] [ 2494.165824]  (&tty->ctrl_lock){....}, at: [<ffffffff803d5f31>] tty_check_change+0x61/0x110
May 11 10:59:48 [kernel] [ 2494.165831] 
May 11 10:59:48 [kernel] [ 2494.165832] which lock already depends on the new lock.
May 11 10:59:48 [kernel] [ 2494.165833] 
May 11 10:59:48 [kernel] [ 2494.165835] 
May 11 10:59:48 [kernel] [ 2494.165836] the existing dependency chain (in reverse order) is:
May 11 10:59:48 [kernel] [ 2494.165838] 
May 11 10:59:48 [kernel] [ 2494.165839] -> #2 (&tty->ctrl_lock){....}:
May 11 10:59:48 [kernel] [ 2494.165843]        [<ffffffff80253796>] __lock_acquire+0xf86/0x1080
May 11 10:59:48 [kernel] [ 2494.165851]        [<ffffffff80253922>] lock_acquire+0x92/0xc0
May 11 10:59:48 [kernel] [ 2494.165858]        [<ffffffff804deee0>] _spin_lock_irqsave+0x40/0x60
May 11 10:59:48 [kernel] [ 2494.165866]        [<ffffffff803d31b5>] __proc_set_tty+0x35/0xe0
May 11 10:59:48 [kernel] [ 2494.165873]        [<ffffffff803d76d4>] tty_ioctl+0xbf4/0xfe0
May 11 10:59:48 [kernel] [ 2494.165880]        [<ffffffff802a05e1>] vfs_ioctl+0x31/0x90
May 11 10:59:48 [kernel] [ 2494.165888]        [<ffffffff802a06b3>] do_vfs_ioctl+0x73/0x2d0
May 11 10:59:48 [kernel] [ 2494.165895]        [<ffffffff802a095a>] sys_ioctl+0x4a/0x80
May 11 10:59:48 [kernel] [ 2494.165902]        [<ffffffff8020b5ab>] system_call_after_swapgs+0x7b/0x80
May 11 10:59:48 [kernel] [ 2494.165910]        [<ffffffffffffffff>] 0xffffffffffffffff
May 11 10:59:48 [kernel] [ 2494.165924] 
May 11 10:59:48 [kernel] [ 2494.165925] -> #1 (&sighand->siglock){++..}:
May 11 10:59:48 [kernel] [ 2494.165929]        [<ffffffff80253796>] __lock_acquire+0xf86/0x1080
May 11 10:59:48 [kernel] [ 2494.165936]        [<ffffffff80253922>] lock_acquire+0x92/0xc0
May 11 10:59:48 [kernel] [ 2494.165943]        [<ffffffff804dec1f>] _spin_lock+0x2f/0x40
May 11 10:59:48 [kernel] [ 2494.165951]        [<ffffffff8022d5a3>] copy_process+0x973/0x1210
May 11 10:59:48 [kernel] [ 2494.165959]        [<ffffffff8022df12>] do_fork+0x82/0x2f0
May 11 10:59:48 [kernel] [ 2494.165967]        [<ffffffff8020bfe1>] kernel_thread+0x81/0xde
May 11 10:59:48 [kernel] [ 2494.165974]        [<ffffffff8020c048>] child_rip+0xa/0x12
May 11 10:59:48 [kernel] [ 2494.165981]        [<ffffffffffffffff>] 0xffffffffffffffff
May 11 10:59:48 [kernel] [ 2494.166038] 
May 11 10:59:48 [kernel] [ 2494.166039] -> #0 (tasklist_lock){..??}:
May 11 10:59:48 [kernel] [ 2494.166043]        [<ffffffff802535ab>] __lock_acquire+0xd9b/0x1080
May 11 10:59:48 [kernel] [ 2494.166050]        [<ffffffff80253922>] lock_acquire+0x92/0xc0
May 11 10:59:48 [kernel] [ 2494.166057]        [<ffffffff804dede2>] _read_lock+0x32/0x50
May 11 10:59:48 [kernel] [ 2494.166063]        [<ffffffff80232e95>] is_current_pgrp_orphaned+0x15/0x50
May 11 10:59:48 [kernel] [ 2494.166071]        [<ffffffff803d5f80>] tty_check_change+0xb0/0x110
May 11 10:59:48 [kernel] [ 2494.166078]        [<ffffffff803dac5f>] set_termios+0x1f/0x4c0
May 11 10:59:48 [kernel] [ 2494.166085]        [<ffffffff803db379>] tty_mode_ioctl+0x279/0x3e0
May 11 10:59:48 [kernel] [ 2494.166092]        [<ffffffff803db51d>] n_tty_ioctl+0x3d/0x260
May 11 10:59:48 [kernel] [ 2494.166100]        [<ffffffff803d6c34>] tty_ioctl+0x154/0xfe0
May 11 10:59:48 [kernel] [ 2494.166107]        [<ffffffff802a05e1>] vfs_ioctl+0x31/0x90
May 11 10:59:48 [kernel] [ 2494.166114]        [<ffffffff802a06b3>] do_vfs_ioctl+0x73/0x2d0
May 11 10:59:48 [kernel] [ 2494.166121]        [<ffffffff802a095a>] sys_ioctl+0x4a/0x80
May 11 10:59:48 [kernel] [ 2494.166128]        [<ffffffff8020b5ab>] system_call_after_swapgs+0x7b/0x80
May 11 10:59:48 [kernel] [ 2494.166135]        [<ffffffffffffffff>] 0xffffffffffffffff
May 11 10:59:48 [kernel] [ 2494.166142] 
May 11 10:59:48 [kernel] [ 2494.166143] other info that might help us debug this:
May 11 10:59:48 [kernel] [ 2494.166144] 
May 11 10:59:48 [kernel] [ 2494.166146] 1 lock held by less/7053:
May 11 10:59:48 [kernel] [ 2494.166148]  #0:  (&tty->ctrl_lock){....}, at: [<ffffffff803d5f31>] tty_check_change+0x61/0x110
May 11 10:59:48 [kernel] [ 2494.166155] 
May 11 10:59:48 [kernel] [ 2494.166156] stack backtrace:
May 11 10:59:48 [kernel] [ 2494.166159] Pid: 7053, comm: less Not tainted 2.6.26-rc1-00007-g91b3a7a #217
May 11 10:59:48 [kernel] [ 2494.166161] 
May 11 10:59:48 [kernel] [ 2494.166162] Call Trace:
May 11 10:59:48 [kernel] [ 2494.166168]  [<ffffffff80251223>] print_circular_bug_tail+0x83/0x90
May 11 10:59:48 [kernel] [ 2494.166172]  [<ffffffff80250889>] ? print_circular_bug_entry+0x49/0x60
May 11 10:59:48 [kernel] [ 2494.166178]  [<ffffffff802535ab>] __lock_acquire+0xd9b/0x1080
May 11 10:59:48 [kernel] [ 2494.166184]  [<ffffffff80232e95>] ? is_current_pgrp_orphaned+0x15/0x50
May 11 10:59:48 [kernel] [ 2494.166189]  [<ffffffff80253922>] lock_acquire+0x92/0xc0
May 11 10:59:48 [kernel] [ 2494.166206]  [<ffffffff803d5f80>] tty_check_change+0xb0/0x110
May 11 10:59:48 [kernel] [ 2494.166211]  [<ffffffff803dac5f>] set_termios+0x1f/0x4c0
May 11 10:59:48 [kernel] [ 2494.166216]  [<ffffffff803d3423>] ? tty_ldisc_try+0x23/0x60
May 11 10:59:48 [kernel] [ 2494.166220]  [<ffffffff803d3444>] ? tty_ldisc_try+0x44/0x60
May 11 10:59:48 [kernel] [ 2494.166224]  [<ffffffff804df2c5>] ? _spin_unlock_irqrestore+0x65/0x80
May 11 10:59:48 [kernel] [ 2494.166230]  [<ffffffff803db379>] tty_mode_ioctl+0x279/0x3e0
May 11 10:59:48 [kernel] [ 2494.166234]  [<ffffffff803d3444>] ? tty_ldisc_try+0x44/0x60
May 11 10:59:48 [kernel] [ 2494.166239]  [<ffffffff803db51d>] n_tty_ioctl+0x3d/0x260
May 11 10:59:48 [kernel] [ 2494.166244]  [<ffffffff803d6c34>] tty_ioctl+0x154/0xfe0
May 11 10:59:48 [kernel] [ 2494.166249]  [<ffffffff80252baa>] ? __lock_acquire+0x39a/0x1080
May 11 10:59:48 [kernel] [ 2494.166256]  [<ffffffff80252baa>] ? __lock_acquire+0x39a/0x1080
May 11 10:59:48 [kernel] [ 2494.166263]  [<ffffffff80252baa>] ? __lock_acquire+0x39a/0x1080
May 11 10:59:48 [kernel] [ 2494.166269]  [<ffffffff802a05e1>] vfs_ioctl+0x31/0x90
May 11 10:59:48 [kernel] [ 2494.166274]  [<ffffffff802a06b3>] do_vfs_ioctl+0x73/0x2d0
May 11 10:59:48 [kernel] [ 2494.166280]  [<ffffffff802a095a>] sys_ioctl+0x4a/0x80
May 11 10:59:48 [kernel] [ 2494.166286]  [<ffffffff8020b5ab>] system_call_after_swapgs+0x7b/0x80
May 11 10:59:48 [kernel] [ 2494.166292] 

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/char/tty_io.c~tty_check_change-avoid-taking-tasklist_lock-while-holding-tty-ctrl_lock drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty_check_change-avoid-taking-tasklist_lock-while-holding-tty-ctrl_lock
+++ a/drivers/char/tty_io.c
@@ -1215,10 +1215,11 @@ int tty_check_change(struct tty_struct *
 
 	if (!tty->pgrp) {
 		printk(KERN_WARNING "tty_check_change: tty->pgrp == NULL!\n");
-		goto out;
+		goto out_unlock;
 	}
 	if (task_pgrp(current) == tty->pgrp)
-		goto out;
+		goto out_unlock;
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	if (is_ignored(SIGTTOU))
 		goto out;
 	if (is_current_pgrp_orphaned()) {
@@ -1229,6 +1230,8 @@ int tty_check_change(struct tty_struct *
 	set_thread_flag(TIF_SIGPENDING);
 	ret = -ERESTARTSYS;
 out:
+	return ret;
+out_unlock:
 	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
ia64-kvm-dont-delete-files-which-we-need.patch
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
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
git-mmc.patch
mmc-sd-host-driver-for-ricoh-bay1controllers-fix.patch
mmc-sd-host-driver-for-ricoh-bay1controllers-fix-2.patch
git-ubifs.patch
git-net.patch
git-net-git-rejects.patch
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
rndis-switch-to-seq_files-checkpatch-fixes.patch
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
mprotect-prevent-alteration-of-the-pat-bits-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
tty_check_change-avoid-taking-tasklist_lock-while-holding-tty-ctrl_lock.patch
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

