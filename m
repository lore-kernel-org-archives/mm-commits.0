From: akpm@linux-foundation.org
Subject: [folded] leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch removed from -mm tree
Date: Tue, 22 Mar 2011 15:55:04 -0700
Message-ID: <201103222255.p2MMt49m032506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284Ab1CVWzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 18:55:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com, chammoru@gmail.com, q1.kim@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds-convert-bd2802-driver-to-dev_pm_ops-fix
has been removed from the -mm tree.  Its filename was
     leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch

This patch was dropped because it was folded into leds-convert-bd2802-driver-to-dev_pm_ops.patch

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

origin.patch
include-asm-generic-unistdh-fix-syncfs-syscall-number.patch
leds-convert-bd2802-driver-to-dev_pm_ops.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix.patch

