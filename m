From: akpm@linux-foundation.org
Subject: + i386-arch-x86-math-emu-reg_ld_strc-fix-warning.patch added to -mm tree
Date: Tue, 18 Mar 2008 18:54:45 -0700
Message-ID: <200803190204.m2J24TVI026639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756887AbYCSTh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     i386: arch/x86/math-emu/reg_ld_str.c: fix warning
has been added to the -mm tree.  Its filename is
     i386-arch-x86-math-emu-reg_ld_strc-fix-warning.patch

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
Subject: i386: arch/x86/math-emu/reg_ld_str.c: fix warning
From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/math-emu/reg_ld_str.c: In function 'FPU_store_double':
arch/x86/math-emu/reg_ld_str.c:380: warning: 'l[0]' may be used uninitialized in this function
arch/x86/math-emu/reg_ld_str.c:380: warning: 'l[1]' may be used uninitialized in this function

I can't actually spot the bug here.  There's one obvious place, but fixing
that didn't shut the warning up.

Probably a -mm-only patch until someone works out what's going on.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/math-emu/reg_ld_str.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN arch/x86/math-emu/reg_ld_str.c~i386-arch-x86-math-emu-reg_ld_strc-fix-warning arch/x86/math-emu/reg_ld_str.c
--- a/arch/x86/math-emu/reg_ld_str.c~i386-arch-x86-math-emu-reg_ld_strc-fix-warning
+++ a/arch/x86/math-emu/reg_ld_str.c
@@ -383,15 +383,15 @@ int FPU_store_double(FPU_REG *st0_ptr, u
 	int exp;
 	FPU_REG tmp;
 
+	l[0] = 0;
+	l[1] = 0;
 	if (st0_tag == TAG_Valid) {
 		reg_copy(st0_ptr, &tmp);
 		exp = exponent(&tmp);
 
 		if (exp < DOUBLE_Emin) {	/* It may be a denormal */
 			addexponent(&tmp, -DOUBLE_Emin + 52);	/* largest exp to be 51 */
-
-		      denormal_arg:
-
+denormal_arg:
 			if ((precision_loss = FPU_round_to_int(&tmp, st0_tag))) {
 #ifdef PECULIAR_486
 				/* Did it round to a non-denormal ? */
@@ -477,8 +477,7 @@ int FPU_store_double(FPU_REG *st0_ptr, u
 
 				/* This is a special case: see sec 16.2.5.1 of the 80486 book */
 				/* Overflow to infinity */
-				l[0] = 0x00000000;	/* Set to */
-				l[1] = 0x7ff00000;	/* + INF */
+				l[1] = 0x7ff00000;	/* Set to + INF */
 			} else {
 				if (precision_loss) {
 					if (increment)
@@ -492,8 +491,6 @@ int FPU_store_double(FPU_REG *st0_ptr, u
 		}
 	} else if (st0_tag == TAG_Zero) {
 		/* Number is zero */
-		l[0] = 0;
-		l[1] = 0;
 	} else if (st0_tag == TAG_Special) {
 		st0_tag = FPU_Special(st0_ptr);
 		if (st0_tag == TW_Denormal) {
@@ -508,7 +505,6 @@ int FPU_store_double(FPU_REG *st0_ptr, u
 			reg_copy(st0_ptr, &tmp);
 			goto denormal_arg;
 		} else if (st0_tag == TW_Infinity) {
-			l[0] = 0;
 			l[1] = 0x7ff00000;
 		} else if (st0_tag == TW_NaN) {
 			/* Is it really a NaN ? */
@@ -532,7 +528,6 @@ int FPU_store_double(FPU_REG *st0_ptr, u
 				EXCEPTION(EX_Invalid);
 				if (!(control_word & CW_Invalid))
 					return 0;
-				l[0] = 0;
 				l[1] = 0xfff80000;
 			}
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
zisofs-fix-readpage-outside-i_size-fix.patch
lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
i386-arch-x86-math-emu-fpu_entryc-warning-fix.patch
git-kgdb-light.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
cifs-suppress-warning.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
git-drm.patch
git-drm-git-rejects.patch
git-drm-drivers-char-drm-ati_pcigartc-fix-printk-warning.patch
git-dvb.patch
git-dvb-drivers-media-video-bt8xx-bttv-cardsc-fix-warnings.patch
drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hrt.patch
arch-ia64-kernel-use-time_-macros-checkpatch-fixes.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-kvm.patch
kvm-warning-fix.patch
git-leds.patch
devres-implement-pcim_iomap_regions_request_all-fix.patch
devres-implement-pcim_iomap_regions_request_all-fix-fix.patch
git-net.patch
git-net-drivers-net-wireless-rt2x00-rt2x00devc-remove-dead-code-fix-warning.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
wan-new-ppp-code-for-generic-hdlc-checkpatch-fixes.patch
drivers-net-arcnet-arcnetc-use-time_-macros-checkpatch-fixes.patch
drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros-checkpatch-fixes.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
revert-sched-make-sure-jiffies-is-up-to-date-before-calling-__update_rq_clock.patch
git-sh.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
git-scsi-rc-fixes-fixup.patch
scsi-aic94xx-cleanups.patch
scsi-fix-section-mismatch-in-aic94xx-fix.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
ipsc-fix-build-warning.patch
drivers-scsi-initioc-suppress-compile-warning.patch
drivers-scsi-hptiopc-fix-build-warning.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-watchdog.patch
git-semaphore-git-rejects.patch
x86-fix-aperture-vs-suspend-problem.patch
revert-pcie-utilize-pcie-transaction-pending-bit.patch
revert-clocksource-make-clocksource-watchdog-cycle-through-online-cpus.patch
netpoll-zap_completion_queue-adjust-skb-users-counter.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lib-swiotlbc-cleanups.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
add-warn_on_secs-macro-simplification-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ext4-is-broken.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys-hack.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
i386-arch-x86-math-emu-reg_ld_strc-fix-warning.patch
i386-arch-x86-math-emu-reg_ld_strc-fix-warning.patch

