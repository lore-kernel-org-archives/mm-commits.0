From: akpm@linux-foundation.org
Subject: [folded] hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 11:53:04 -0800
Message-ID: <201003051953.o25Jr4Hp024270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755810Ab0CETx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 14:53:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hjk@linutronix.de, khali@linux-fr.org, sfking@fdwdc.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     hwmon-driver-for-ti-tmp102-temperature-sensor-fix
has been removed from the -mm tree.  Its filename was
     hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch

This patch was dropped because it was folded into hwmon-driver-for-ti-tmp102-temperature-sensor.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon-driver-for-ti-tmp102-temperature-sensor-fix
From: Andrew Morton <akpm@linux-foundation.org>

Use conventional array-walk loop.

Cc: Hans J. Koch <hjk@linutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Steven King <sfking@fdwdc.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/tmp102.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/hwmon/tmp102.c~hwmon-driver-for-ti-tmp102-temperature-sensor-fix drivers/hwmon/tmp102.c
--- a/drivers/hwmon/tmp102.c~hwmon-driver-for-ti-tmp102-temperature-sensor-fix
+++ a/drivers/hwmon/tmp102.c
@@ -91,13 +91,14 @@ static struct tmp102 *tmp102_update_devi
 
 	mutex_lock(&tmp102->lock);
 	if (time_after(jiffies, tmp102->last_update + HZ / 4)) {
-		int i = 0;
-		do {
+		int i;
+
+		for (i = 0; i < ARRAY_SIZE(tmp102->temp); i++) {
 			int status = tmp102_read_reg(client, tmp102_reg[i]);
 			if (status > -1)
 				tmp102->temp[i] = tmp102_reg_to_mC(status);
 
-		} while (++i < ARRAY_SIZE(tmp102->temp));
+		}
 		tmp102->last_update = jiffies;
 	}
 	mutex_unlock(&tmp102->lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-net.patch
bitops-add-temporary-for_each_bit.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
gpio-cs5535-gpio-fix-input-direction.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
pps-linuxpps-clients-support-v3-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

