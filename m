From: akpm@linux-foundation.org
Subject: - leds-driver-for-hp-harddisk-protection-led-fix.patch removed from -mm tree
Date: Wed, 22 Oct 2008 13:09:02 -0700
Message-ID: <200810222009.m9MK92aN013971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753088AbYJVUJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 16:09:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, burman.yan@gmail.com, eric.piel@tremplin-utc.net, pavel@suse.cz, rpurdie@rpsys.net, trenn@suse.de, mm-commits@vger.kernel.org


The patch titled
     leds-driver-for-hp-harddisk-protection-led-fix
has been removed from the -mm tree.  Its filename was
     leds-driver-for-hp-harddisk-protection-led-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
memcg-fix-page_cgroup-allocation-fix.patch
memcg-fix-page_cgroup-allocation-fix-2.patch
epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-fix-vfs-for-about-to-be-merged-ext3-patches.patch
git-tests-git-rejects.patch
revert-i7300_idle-driver-v155.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix-fix-2.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix.patch
ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch
devpts-fix-unused-function-warning.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
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

