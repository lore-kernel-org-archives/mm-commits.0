From: akpm@linux-foundation.org
Subject: [folded] leds-add-output-inversion-option-to-backlight-trigger-fix.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:17:22 -0800
Message-ID: <201101130017.p0D0HNZh011982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756428Ab1AMASC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:18:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jkrzyszt@tis.icnet.pl, lethal@linux-sh.org, richard.purdie@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     leds-add-output-inversion-option-to-backlight-trigger-fix
has been removed from the -mm tree.  Its filename was
     leds-add-output-inversion-option-to-backlight-trigger-fix.patch

This patch was dropped because it was folded into leds-add-output-inversion-option-to-backlight-trigger.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-add-output-inversion-option-to-backlight-trigger-fix
From: Andrew Morton <akpm@linux-foundation.org>

make output match input, tighten input checking

Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-backlight.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/leds/ledtrig-backlight.c~leds-add-output-inversion-option-to-backlight-trigger-fix drivers/leds/ledtrig-backlight.c
--- a/drivers/leds/ledtrig-backlight.c~leds-add-output-inversion-option-to-backlight-trigger-fix
+++ a/drivers/leds/ledtrig-backlight.c
@@ -65,7 +65,7 @@ static ssize_t bl_trig_invert_show(struc
 	struct led_classdev *led = dev_get_drvdata(dev);
 	struct bl_trig_notifier *n = led->trigger_data;
 
-	return sprintf(buf, "%s\n", n->invert ? "yes" : "no");
+	return sprintf(buf, "%u\n", n->invert);
 }
 
 static ssize_t bl_trig_invert_store(struct device *dev,
@@ -73,16 +73,17 @@ static ssize_t bl_trig_invert_store(stru
 {
 	struct led_classdev *led = dev_get_drvdata(dev);
 	struct bl_trig_notifier *n = led->trigger_data;
-	unsigned invert;
+	unsigned long invert;
 	int ret;
 
-	ret = sscanf(buf, "%u", &invert);
-	if (ret < 1) {
-		dev_err(dev, "invalid value\n");
+	ret = strict_strtoul(buf, 10, &invert);
+	if (ret < 0)
+		return ret;
+
+	if (invert > 1)
 		return -EINVAL;
-	}
 
-	n->invert = !!invert;
+	n->invert = invert;
 
 	/* After inverting, we need to update the LED. */
 	if ((n->old_status == BLANK) ^ n->invert)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
leds-add-output-inversion-option-to-backlight-trigger.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning-fix.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch
kptr_restrict-for-hiding-kernel-pointers-v7-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
gpio-ml_ioh_gpio-ml7213-gpio-driver-fix.patch
drivers-telephony-ixjc-fix-warning.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
scatterlist-new-helper-functions-fix.patch
aio-remove-unused-aio_run_iocbs-checkpatch-fixes.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
fs-ext4-inodec-use-pr_warn_ratelimited.patch

