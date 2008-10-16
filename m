From: akpm@linux-foundation.org
Subject: + leds-driver-for-hp-harddisk-protection-led-fix.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:55:23 -0700
Message-ID: <200810162255.m9GMtNgv001736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754950AbYJPWzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, burman.yan@gmail.com, eric.piel@tremplin-utc.net, pavel@suse.cz, rpurdie@rpsys.net, trenn@suse.de


The patch titled
     leds-driver-for-hp-harddisk-protection-led-fix
has been added to the -mm tree.  Its filename is
     leds-driver-for-hp-harddisk-protection-led-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-driver-for-hp-harddisk-protection-led-fix
From: Andrew Morton <akpm@linux-foundation.org>

- fix comment typo

- use standard suspend/resume ifdef avoidance trick

Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Yan Burman <burman.yan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-hp-disk.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/leds/leds-hp-disk.c~leds-driver-for-hp-harddisk-protection-led-fix drivers/leds/leds-hp-disk.c
--- a/drivers/leds/leds-hp-disk.c~leds-driver-for-hp-harddisk-protection-led-fix
+++ a/drivers/leds/leds-hp-disk.c
@@ -49,7 +49,7 @@ static struct acpi_hpled adev;
 
 static acpi_status hpled_acpi_write(acpi_handle handle, int reg)
 {
-	unsigned long ret; /* Not used when writting */
+	unsigned long ret; /* Not used when writing */
 	union acpi_object in_obj[1];
 	struct acpi_object_list args = { 1, in_obj };
 
@@ -83,6 +83,9 @@ static int hpled_resume(struct acpi_devi
 	led_classdev_resume(&hpled_led);
 	return 0;
 }
+#else
+#define hpled_suspend NULL
+#define hpled_resume NULL
 #endif
 
 static int hpled_add(struct acpi_device *device)
@@ -119,10 +122,8 @@ static struct acpi_driver leds_hp_driver
 	.ops = {
 		.add     = hpled_add,
 		.remove  = hpled_remove,
-#ifdef CONFIG_PM
 		.suspend = hpled_suspend,
 		.resume  = hpled_resume,
-#endif
 	}
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
make-taint-bit-reliable-v3.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday.patch
allow-recursion-in-binfmt_script-and-binfmt_misc.patch
autofs4-track-uid-and-gid-of-last-mount-requester.patch
autofs4-add-miscellaneous-device-for-ioctls.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip.patch
viafb-accelc-accelh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-hwc-hwh.patch
viafb-viafbdevc-viafbdevh.patch
fbdev-kconfig-update.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-new-driver-ds2431-chip.patch
gru-driver-minor-updates.patch
mm-remove-the-might_sleep-from-lock_page.patch
git-tests-git-rejects.patch
git-acpi.patch
git-acpi-git-rejects.patch
revert-i7300_idle-driver-v155.patch
git-vfs-git-rejects.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
dvb-input-data-pointer-of-cx24116_writeregn-should-be-const-checkpatch-fixes.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
drivers-scsi-sdh-use-inlined-c-functions-not-macros.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-vmallocc-revert-git-tip-change.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
revert-mm-vmallocc-revert-git-tip-change.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
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

