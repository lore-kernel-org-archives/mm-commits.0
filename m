From: akpm@linux-foundation.org
Subject: - radeonfb-revert-fix-radeon-ddc-regression.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:16:11 -0700
Message-ID: <200810182316.m9INGBfL028764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503AbYJRXQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     radeonfb: revert "Fix radeon DDC regression"
has been removed from the -mm tree.  Its filename was
     radeonfb-revert-fix-radeon-ddc-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: revert "Fix radeon DDC regression"
From: Jean Delvare <khali@linux-fr.org>

The bug was in fb_ddc and was fixed by commit
b64d70825abbf706bbe80be1b11b09514b71f45e (fb_ddc: fix DDC lines quirk) so
the workaround in radeonfb can be removed now.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_i2c.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/video/aty/radeon_i2c.c~radeonfb-revert-fix-radeon-ddc-regression drivers/video/aty/radeon_i2c.c
--- a/drivers/video/aty/radeon_i2c.c~radeonfb-revert-fix-radeon-ddc-regression
+++ a/drivers/video/aty/radeon_i2c.c
@@ -139,12 +139,8 @@ void radeon_delete_i2c_busses(struct rad
 int radeon_probe_i2c_connector(struct radeonfb_info *rinfo, int conn,
 			       u8 **out_edid)
 {
-	u32 reg = rinfo->i2c[conn-1].ddc_reg;
 	u8 *edid;
 
-	OUTREG(reg, INREG(reg) &
-			~(VGA_DDC_DATA_OUTPUT | VGA_DDC_CLK_OUTPUT));
-
 	edid = fb_ddc_read(&rinfo->i2c[conn-1].adapter);
 
 	if (out_edid)
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
hwmon-pc87360-separate-alarm-files-define-some-constants.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-define-ldni_max-const.patch
hwmon-pc87360-separate-alarm-files-add-dev_dbg-help.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
hwmon-applesmc-specified-number-of-bytes-to-read-should-match-actual.patch
hwmon-applesmc-fix-the-wait-status-failed-c-=-8-problem.patch
hwmon-applesmc-prolong-status-wait.patch
hwmon-applesmc-allow-for-variable-alv0-and-alv1-package-length.patch
hwmon-applesmc-add-support-for-macbook-air.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
hwmon-applesmc-add-support-for-macbook-pro-4.patch
hwmon-applesmc-add-support-for-macbook-pro-3.patch
hwmon-applesmc-lighter-wait-mechanism-drastic-improvement.patch
i2c-use-bcd2bin-bin2bcd.patch
x86-sysfs-kill-owner-field-from-attribute.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch

