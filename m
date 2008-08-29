From: akpm@linux-foundation.org
Subject: + drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug.patch added to -mm tree
Date: Fri, 29 Aug 2008 12:48:14 -0700
Message-ID: <200808291948.m7TJmHgs001319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526AbYH2TtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Aug 2008 15:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aaron@merfinllc.com, mpm@selenic.com, stable@kernel.org, tytso@mit.edu


The patch titled
     drivers/char/random.c: fix a race which can lead to a bogus BUG()
has been added to the -mm tree.  Its filename is
     drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug.patch

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
Subject: drivers/char/random.c: fix a race which can lead to a bogus BUG()
From: Andrew Morton <akpm@linux-foundation.org>

Fix a bug reported by and diagnosed by Aaron Straus.

This is a regression intruduced into 2.6.26 by

    commit adc782dae6c4c0f6fb679a48a544cfbcd79ae3dc
    Author: Matt Mackall <mpm@selenic.com>
    Date:   Tue Apr 29 01:03:07 2008 -0700

        random: simplify and rename credit_entropy_store

credit_entropy_bits() does:

	spin_lock_irqsave(&r->lock, flags);
	...
	if (r->entropy_count > r->poolinfo->POOLBITS)
		r->entropy_count = r->poolinfo->POOLBITS;

so there is a time window in which this BUG_ON():

static size_t account(struct entropy_store *r, size_t nbytes, int min,
		      int reserved)
{
	unsigned long flags;

	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);

	/* Hold lock while accounting */
	spin_lock_irqsave(&r->lock, flags);

can trigger.

We could fix this by moving the assertion inside the lock, but it seems
safer and saner to revert to the old behaviour wherein
entropy_store.entropy_count at no time exceeds
entropy_store.poolinfo->POOLBITS.

Reported-by: Aaron Straus <aaron@merfinllc.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: <stable@kernel.org>		[2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/char/random.c~drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug drivers/char/random.c
--- a/drivers/char/random.c~drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug
+++ a/drivers/char/random.c
@@ -520,6 +520,7 @@ static void mix_pool_bytes(struct entrop
 static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
 	unsigned long flags;
+	int entropy_count;
 
 	if (!nbits)
 		return;
@@ -527,20 +528,20 @@ static void credit_entropy_bits(struct e
 	spin_lock_irqsave(&r->lock, flags);
 
 	DEBUG_ENT("added %d entropy credits to %s\n", nbits, r->name);
-	r->entropy_count += nbits;
-	if (r->entropy_count < 0) {
+	entropy_count = r->entropy_count;
+	entropy_count += nbits;
+	if (entropy_count < 0) {
 		DEBUG_ENT("negative entropy/overflow\n");
-		r->entropy_count = 0;
-	} else if (r->entropy_count > r->poolinfo->POOLBITS)
-		r->entropy_count = r->poolinfo->POOLBITS;
+		entropy_count = 0;
+	} else if (entropy_count > r->poolinfo->POOLBITS)
+		entropy_count = r->poolinfo->POOLBITS;
 
 	/* should we wake readers? */
-	if (r == &input_pool &&
-	    r->entropy_count >= random_read_wakeup_thresh) {
+	if (r == &input_pool && entropy_count >= random_read_wakeup_thresh) {
 		wake_up_interruptible(&random_read_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);
 	}
-
+	r->entropy_count = entropy_count;
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails-fix.patch
acer-wmi-remove-debugfs-entries-upon-unloading-cleanup.patch
linux-next.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically-cleanup.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-make-poll_idle-behave-more-like-the-other-idle-methods-checkpatch-fixes.patch
fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-checkpatch-fixes.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-fix.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers.patch
power-support-for-texas-instruments-bq27x00-battery-managers-fix.patch
drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry-checkpatch-fixes.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-xtensa.patch
drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
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
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
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

