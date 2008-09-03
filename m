From: akpm@linux-foundation.org
Subject: - linux-next-avoid-tty-oops.patch removed from -mm tree
Date: Wed, 03 Sep 2008 08:50:39 -0700
Message-ID: <200809031550.m83FodRk022913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbYICPut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 11:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     linux-next: avoid tty oops
has been removed from the -mm tree.  Its filename was
     linux-next-avoid-tty-oops.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next: avoid tty oops
From: Andrew Morton <akpm@linux-foundation.org>

BUG: unable to handle kernel NULL pointer dereference at 0000000c
IP: [<c02afc15>] n_tty_set_termios+0x15/0x340
*pde = 00000000 
Oops: 0000 [#1] SMP 
last sysfs file: 
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in:

Pid: 1, comm: swapper Tainted: G        W (2.6.27-rc5-mm1 #2)
EIP: 0060:[<c02afc15>] EFLAGS: 00010282 CPU: 0
EIP is at n_tty_set_termios+0x15/0x340
EAX: f709cdd0 EBX: f709cdd0 ECX: f64cd468 EDX: 00000000
ESI: 00000000 EDI: f60ee000 EBP: f702fdf4 ESP: f702fde8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=f702e000 task=f702d210 task.ti=f702e000)
Stack: f709cdd0 f709cdd0 f60ee000 f702fe04 c02b0299 f7095070 f709cdd0 f702fe18 
       c02b3493 f7095070 f709cdd0 00000000 f702fe3c c02ae9b5 f7095070 f702fe60 
       00000000 fffffff4 f7095070 00000000 00500001 f702fe70 c02aedeb f707d078 
Call Trace:
 [<c02b0299>] ? n_tty_open+0x49/0xa0
 [<c02b3493>] ? tty_ldisc_setup+0x23/0x80
 [<c02ae9b5>] ? tty_init_dev+0x85/0x150
 [<c02aedeb>] ? tty_open+0x36b/0x440
 [<c01940fa>] ? chrdev_open+0x9a/0x190
 [<c018fded>] ? __dentry_open+0xad/0x230
 [<c0190d90>] ? nameidata_to_filp+0x50/0x60
 [<c0194060>] ? chrdev_open+0x0/0x190
 [<c019c41a>] ? do_filp_open+0x19a/0x700
 [<c01158a9>] ? cpa_fill_pool+0x99/0x120
 [<c01a4706>] ? alloc_fd+0x26/0xf0
 [<c01a47af>] ? alloc_fd+0xcf/0xf0
 [<c03e159d>] ? _spin_unlock+0x1d/0x20
 [<c018fc0b>] ? do_sys_open+0x4b/0xd0
 [<c0126e5b>] ? printk+0x1b/0x20
 [<c018fcf9>] ? sys_open+0x29/0x40
 [<c01011b7>] ? init_post+0x47/0x140
 [<c0103fff>] ? kernel_thread_helper+0x7/0x18
 =======================

tty->termios is NULL.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN drivers/char/n_tty.c~linux-next-avoid-tty-oops drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~linux-next-avoid-tty-oops
+++ a/drivers/char/n_tty.c
@@ -1039,20 +1039,8 @@ int is_ignored(int sig)
 
 static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
-	int canon_change;
 	BUG_ON(!tty);
 
-	canon_change = (old->c_lflag ^ tty->termios->c_lflag) & ICANON;
-	if (canon_change) {
-		memset(&tty->read_flags, 0, sizeof tty->read_flags);
-		tty->canon_head = tty->read_tail;
-		tty->canon_data = 0;
-		tty->erasing = 0;
-	}
-
-	if (canon_change && !L_ICANON(tty) && tty->read_cnt)
-		wake_up_interruptible(&tty->read_wait);
-
 	tty->icanon = (L_ICANON(tty) != 0);
 	if (test_bit(TTY_HW_COOK_IN, &tty->flags)) {
 		tty->raw = 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
linux-next-avoid-tty-oops.patch
git-acpi.patch
acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically-cleanup.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix-fix.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-make-poll_idle-behave-more-like-the-other-idle-methods-checkpatch-fixes.patch
git-alsa-tiwai.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
git-powerpc.patch
fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
git-drm.patch
fs-dlm-configc-choose-better-identifiers.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
git-kvm.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix.patch
git-mtd.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-checkpatch-fixes.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-fix.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
git-battery.patch
git-pci-next.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32.patch
git-xtensa.patch
modules-remove-stop_machine-during-module-load-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-media-video-cafe_ccicc-needs-mmh.patch
e1000e-prevent-corruption-of-eeprom-nvm.patch
drivers-net-mlx4-allocc-needs-mmh.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
fix-a-race-condtion-of-oops_in_progress-fix.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
gru-driver-minor-updates-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
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

