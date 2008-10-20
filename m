From: akpm@linux-foundation.org
Subject: - drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:48 -0700
Message-ID: <200810202037.m9KKbm2g011718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753904AbYJTUos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:44:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bunk@stusta.de, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-bq4802.c: don't use BIN_2_BCD and BCD_2_BIN
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-bq4802.c: don't use BIN_2_BCD and BCD_2_BIN
From: Andrew Morton <akpm@linux-foundation.org>

These are going away.

Cc: Takashi Iwai <tiwai@suse.de>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bq4802.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/rtc/rtc-bq4802.c~drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin drivers/rtc/rtc-bq4802.c
--- a/drivers/rtc/rtc-bq4802.c~drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin
+++ a/drivers/rtc/rtc-bq4802.c
@@ -71,14 +71,14 @@ static int bq4802_read_time(struct devic
 
 	spin_unlock_irqrestore(&p->lock, flags);
 
-	BCD_TO_BIN(tm->tm_sec);
-	BCD_TO_BIN(tm->tm_min);
-	BCD_TO_BIN(tm->tm_hour);
-	BCD_TO_BIN(tm->tm_mday);
-	BCD_TO_BIN(tm->tm_mon);
-	BCD_TO_BIN(tm->tm_year);
-	BCD_TO_BIN(tm->tm_wday);
-	BCD_TO_BIN(century);
+	tm->tm_sec = bcd2bin(tm->tm_sec);
+	tm->tm_min = bcd2bin(tm->tm_min);
+	tm->tm_hour = bcd2bin(tm->tm_hour);
+	tm->tm_mday = bcd2bin(tm->tm_mday);
+	tm->tm_mon = bcd2bin(tm->tm_mon);
+	tm->tm_year = bcd2bin(tm->tm_year);
+	tm->tm_wday = bcd2bin(tm->tm_wday);
+	century = bcd2bin(century);
 
 	tm->tm_year += (century * 100);
 	tm->tm_year -= 1900;
@@ -106,13 +106,13 @@ static int bq4802_set_time(struct device
 	min = tm->tm_min;
 	sec = tm->tm_sec;
 
-	BIN_TO_BCD(sec);
-	BIN_TO_BCD(min);
-	BIN_TO_BCD(hrs);
-	BIN_TO_BCD(day);
-	BIN_TO_BCD(mon);
-	BIN_TO_BCD(yrs);
-	BIN_TO_BCD(century);
+	sec = bin2bcd(sec);
+	min = bin2bcd(min);
+	hrs = bin2bcd(hrs);
+	day = bin2bcd(day);
+	mon = bin2bcd(mon);
+	yrs = bin2bcd(yrs);
+	century = bin2bcd(century);
 
 	spin_lock_irqsave(&p->lock, flags);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-git-rejects.patch
revert-i7300_idle-driver-v155.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
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

