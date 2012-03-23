From: akpm@linux-foundation.org
Subject: [folded] backlight-add-driver-for-bachmanns-ot200-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:22:44 -0700
Message-ID: <20120323212244.BD491A0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:48055 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2CWVWr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:22:47 -0400
Received: by lbbgj3 with SMTP id gj3so187811lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:22:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, christian.gmeiner@gmail.com, dilinger@queued.net, lars@metafoo.de, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-add-driver-for-bachmanns-ot200-fix
has been removed from the -mm tree.  Its filename was
     backlight-add-driver-for-bachmanns-ot200-fix.patch

This patch was dropped because it was folded into backlight-add-driver-for-bachmanns-ot200.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-add-driver-for-bachmanns-ot200-fix

Cc: Andres Salomon <dilinger@queued.net>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ot200_bl.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/ot200_bl.c~backlight-add-driver-for-bachmanns-ot200-fix drivers/video/backlight/ot200_bl.c
--- a/drivers/video/backlight/ot200_bl.c~backlight-add-driver-for-bachmanns-ot200-fix
+++ a/drivers/video/backlight/ot200_bl.c
@@ -19,15 +19,15 @@
 static struct cs5535_mfgpt_timer *pwm_timer;
 
 /* this array defines the mapping of brightness in % to pwm frequency */
-static const  u8 dim_table[101] = {0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,
-				   2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4,
-				   4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 9, 9,
-				   10, 10, 11, 11, 12, 12, 13, 14, 15, 15, 16,
-				   17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28,
-				   30, 31, 33, 35, 37, 39, 41, 43, 45, 47, 50,
-				   53, 55, 58, 61, 65, 68, 72, 75, 79, 84, 88,
-				   93, 97, 103, 108, 114, 120, 126, 133, 140,
-				   147, 155, 163};
+static const u8 dim_table[101] = {0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,
+				  2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4,
+				  4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 9, 9,
+				  10, 10, 11, 11, 12, 12, 13, 14, 15, 15, 16,
+				  17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28,
+				  30, 31, 33, 35, 37, 39, 41, 43, 45, 47, 50,
+				  53, 55, 58, 61, 65, 68, 72, 75, 79, 84, 88,
+				  93, 97, 103, 108, 114, 120, 126, 133, 140,
+				  147, 155, 163};
 
 struct ot200_backlight_data {
 	int current_brightness;
@@ -51,7 +51,7 @@ static int ot200_backlight_update_status
 	/* enable or disable PWM timer */
 	if (brightness == 0)
 		cs5535_mfgpt_write(pwm_timer, MFGPT_REG_SETUP, 0);
-	else if (brightness != 0 && data->current_brightness == 0) {
+	else if (data->current_brightness == 0) {
 		cs5535_mfgpt_write(pwm_timer, MFGPT_REG_COUNTER, 0);
 		cs5535_mfgpt_write(pwm_timer, MFGPT_REG_SETUP,
 			MFGPT_SETUP_CNTEN);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch
backlight-add-driver-for-bachmanns-ot200.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch

