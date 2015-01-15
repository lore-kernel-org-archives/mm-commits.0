From: akpm@linux-foundation.org
Subject: [obsolete]
 rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-fix.patch removed from -mm tree
Date: Thu, 15 Jan 2015 14:09:11 -0800
Message-ID: <54b83a87.m7worivgbDu0rJH0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbbAOWJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 17:09:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, arnd@arndb.de, arno@natisbad.org, broonie@kernel.org, galak@codeaurora.org, grant.likely@linaro.org, ijc+devicetree@hellion.org.uk, jason@lakedaemon.net, jgunthorpe@obsidianresearch.com, linus.walleij@linaro.org, linux@roeck-us.net, mark.rutland@arm.com, pawel.moll@arm.com, peter.huewe@infineon.com, rob@landley.net, robherring2@gmail.com, swarren@wwwdotorg.org, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-fix
has been removed from the -mm tree.  Its filename was
     rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-fix

fix abb5zes3_probe() error handling

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Arnaud Ebalard <arno@natisbad.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Peter Huewe <peter.huewe@infineon.com>
Cc: Rob Herring <robherring2@gmail.com>
Cc: Rob Landley <rob@landley.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab-b5ze-s3.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ab-b5ze-s3.c~rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-fix drivers/rtc/rtc-ab-b5ze-s3.c
--- a/drivers/rtc/rtc-ab-b5ze-s3.c~rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-fix
+++ a/drivers/rtc/rtc-ab-b5ze-s3.c
@@ -695,6 +695,7 @@ static int abb5zes3_probe(struct i2c_cli
 		} else {
 			dev_err(dev, "%s: irq %d unavailable (%d)\n",
 				__func__, client->irq, ret);
+			return ret;
 		}
 	}
 
@@ -704,7 +705,7 @@ static int abb5zes3_probe(struct i2c_cli
 	if (ret) {
 		dev_err(dev, "%s: unable to register RTC device (%d)\n",
 			__func__, ret);
-		device_init_wakeup(dev, false);
+		goto err;
 	}
 
 	/*
@@ -718,12 +719,17 @@ static int abb5zes3_probe(struct i2c_cli
 	/* Enable battery low detection interrupt if battery not already low */
 	if (!data->battery_low && data->irq) {
 		ret = _abb5zes3_rtc_battery_low_irq_enable(regmap, true);
-		if (ret)
+		if (ret) {
 			dev_err(dev, "%s: enabling battery low interrupt "
 				"generation failed (%d)\n", __func__, ret);
+			goto err;
+		}
 	}
 
 	return ret;
+err:
+	device_init_wakeup(dev, false);
+	return ret;
 }
 
 static int abb5zes3_remove(struct i2c_client *client)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
dax-add-dax_zero_page_range-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

