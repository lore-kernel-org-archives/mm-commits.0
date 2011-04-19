From: akpm@linux-foundation.org
Subject: [folded] drivers-leds-leds-pca9532c-add-gpio-capability-fix.patch removed from -mm tree
Date: Tue, 19 Apr 2011 16:11:43 -0700
Message-ID: <201104192311.p3JNBh8n031165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095Ab1DSXLr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 19:11:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, manabian@gmail.com, mm-commits@vger.kernel.org


The patch titled
     leds: fix pca9532 build when GPIOLIB is disabled
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-pca9532c-add-gpio-capability-fix.patch

This patch was dropped because it was folded into drivers-leds-leds-pca9532c-add-gpio-capability.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: fix pca9532 build when GPIOLIB is disabled
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build when GPIOLIB is not enabled:

drivers/leds/leds-pca9532.c:39: error: field 'gpio' has incomplete type

for: drivers-leds-leds-pca9532c-add-gpio-capability.patch

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Joachim Eastwood <manabian@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca9532.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/leds/leds-pca9532.c~drivers-leds-leds-pca9532c-add-gpio-capability-fix drivers/leds/leds-pca9532.c
--- a/drivers/leds/leds-pca9532.c~drivers-leds-leds-pca9532c-add-gpio-capability-fix
+++ a/drivers/leds/leds-pca9532.c
@@ -36,7 +36,9 @@ struct pca9532_data {
 	struct mutex update_lock;
 	struct input_dev *idev;
 	struct work_struct work;
+#ifdef CONFIG_LEDS_PCA9532_GPIO
 	struct gpio_chip gpio;
+#endif
 	u8 pwm[2];
 	u8 psc[2];
 };
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
drivers-staging-olpc_dcon-olpc_dcon_xo_1c-needs-delayh.patch
drivers-leds-leds-pca9532c-add-gpio-capability.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

