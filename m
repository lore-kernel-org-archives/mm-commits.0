From: akpm@linux-foundation.org
Subject: + leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch added to -mm tree
Date: Thu, 20 Jan 2011 15:12:28 -0800
Message-ID: <201101202312.p0KNCSt8008275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754715Ab1ATXNM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 18:13:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com, chammoru@gmail.com, q1.kim@samsung.com, rpurdie@rpsys.net


The patch titled
     leds-convert-bd2802-driver-to-dev_pm_ops-fix
has been added to the -mm tree.  Its filename is
     leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-convert-bd2802-driver-to-dev_pm_ops-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/leds/leds-bd2802.c:765: warning: 'bd2802_suspend' defined but not used
drivers/leds/leds-bd2802.c:775: warning: 'bd2802_resume' defined but not used

Cc: Kim Kyuwon <chammoru@gmail.com>
Cc: Kim Kyuwon <q1.kim@samsung.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-bd2802.c |   36 ++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff -puN drivers/leds/leds-bd2802.c~leds-convert-bd2802-driver-to-dev_pm_ops-fix drivers/leds/leds-bd2802.c
--- a/drivers/leds/leds-bd2802.c~leds-convert-bd2802-driver-to-dev_pm_ops-fix
+++ a/drivers/leds/leds-bd2802.c
@@ -319,20 +319,6 @@ static void bd2802_turn_off(struct bd280
 	bd2802_update_state(led, id, color, BD2802_OFF);
 }
 
-static void bd2802_restore_state(struct bd2802_led *led)
-{
-	int i;
-
-	for (i = 0; i < LED_NUM; i++) {
-		if (led->led[i].r)
-			bd2802_turn_on(led, i, RED, led->led[i].r);
-		if (led->led[i].g)
-			bd2802_turn_on(led, i, GREEN, led->led[i].g);
-		if (led->led[i].b)
-			bd2802_turn_on(led, i, BLUE, led->led[i].b);
-	}
-}
-
 #define BD2802_SET_REGISTER(reg_addr, reg_name)				\
 static ssize_t bd2802_store_reg##reg_addr(struct device *dev,		\
 	struct device_attribute *attr, const char *buf, size_t count)	\
@@ -761,6 +747,22 @@ static int __exit bd2802_remove(struct i
 	return 0;
 }
 
+#ifdef CONFIG_PM
+
+static void bd2802_restore_state(struct bd2802_led *led)
+{
+	int i;
+
+	for (i = 0; i < LED_NUM; i++) {
+		if (led->led[i].r)
+			bd2802_turn_on(led, i, RED, led->led[i].r);
+		if (led->led[i].g)
+			bd2802_turn_on(led, i, GREEN, led->led[i].g);
+		if (led->led[i].b)
+			bd2802_turn_on(led, i, BLUE, led->led[i].b);
+	}
+}
+
 static int bd2802_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -785,6 +787,10 @@ static int bd2802_resume(struct device *
 }
 
 static SIMPLE_DEV_PM_OPS(bd2802_pm, bd2802_suspend, bd2802_resume);
+#define BD2802_PM (&bd2802_pm)
+#else		/* CONFIG_PM */
+#define BD2802_PM NULL
+#endif
 
 static const struct i2c_device_id bd2802_id[] = {
 	{ "BD2802", 0 },
@@ -795,7 +801,7 @@ MODULE_DEVICE_TABLE(i2c, bd2802_id);
 static struct i2c_driver bd2802_i2c_driver = {
 	.driver	= {
 		.name	= "BD2802",
-		.pm	= &bd2802_pm,
+		.pm	= BD2802_PM,
 	},
 	.probe		= bd2802_probe,
 	.remove		= __exit_p(bd2802_remove),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-prevent-division-by-zero-during-user-requested-compaction.patch
fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio.patch
memcg-fix-used-bit-handling-at-uncharge-in-thp.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
sigma-firmware-loader-for-analog-devices-sigmastudio-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

