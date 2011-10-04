From: akpm@google.com
Subject: [merged] lis3-fix-regression-of-hp-driveguard-with-8bit-chip.patch removed from -mm tree
Date: Tue, 04 Oct 2011 12:29:42 -0700
Message-ID: <201110041929.p94JThCU019323@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:32920 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab1JDT3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 15:29:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tiwai@suse.de, eric.piel@tremplin-utc.net, samu.p.onkalo@nokia.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lis3: fix regression of HP DriveGuard with 8bit chip
has been removed from the -mm tree.  Its filename was
     lis3-fix-regression-of-hp-driveguard-with-8bit-chip.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Takashi Iwai <tiwai@suse.de>
Subject: lis3: fix regression of HP DriveGuard with 8bit chip

Commit 2a7fade7e03 ("hwmon: lis3: Power on corrections") caused a
regression on HP laptops with 8bit chip.  Writing CTRL2_BOOT_8B bit seems
clearing the BIOS setup, and no proper interrupt for DriveGuard will be
triggered any more.

Since the init code there is basically only for embedded devices, put a
pdata check so that the problematic initialization will be skipped for
hp_accel stuff.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/misc/lis3lv02d/lis3lv02d.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/misc/lis3lv02d/lis3lv02d.c~lis3-fix-regression-of-hp-driveguard-with-8bit-chip drivers/misc/lis3lv02d/lis3lv02d.c
--- a/drivers/misc/lis3lv02d/lis3lv02d.c~lis3-fix-regression-of-hp-driveguard-with-8bit-chip
+++ a/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -375,12 +375,14 @@ void lis3lv02d_poweron(struct lis3lv02d 
 	 *      both have been read. So the value read will always be correct.
 	 * Set BOOT bit to refresh factory tuning values.
 	 */
-	lis3->read(lis3, CTRL_REG2, &reg);
-	if (lis3->whoami ==  WAI_12B)
-		reg |= CTRL2_BDU | CTRL2_BOOT;
-	else
-		reg |= CTRL2_BOOT_8B;
-	lis3->write(lis3, CTRL_REG2, reg);
+	if (lis3->pdata) {
+		lis3->read(lis3, CTRL_REG2, &reg);
+		if (lis3->whoami ==  WAI_12B)
+			reg |= CTRL2_BDU | CTRL2_BOOT;
+		else
+			reg |= CTRL2_BOOT_8B;
+		lis3->write(lis3, CTRL_REG2, reg);
+	}
 
 	/* LIS3 power on delay is quite long */
 	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch
hp_accel-add-a-new-pnp-id.patch
hp_accel-add-axis-mapping-for-hp-probook-elitebook.patch

