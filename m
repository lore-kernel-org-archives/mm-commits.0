From: akpm@linux-foundation.org
Subject: [merged] tosa_battery-fix-build-error.patch removed from -mm tree
Date: Mon, 03 May 2010 13:09:37 -0400
Message-ID: <201005032011.o43KB8lB019170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756660Ab0ECULz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 May 2010 16:11:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbaryshkov@gmail.com, cbou@mail.ru, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     tosa_battery: fix build error
has been removed from the -mm tree.  Its filename was
     tosa_battery-fix-build-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tosa_battery: fix build error
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

-ENOCHANGELOG

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/tosa_battery.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/power/tosa_battery.c~tosa_battery-fix-build-error drivers/power/tosa_battery.c
--- a/drivers/power/tosa_battery.c~tosa_battery-fix-build-error
+++ a/drivers/power/tosa_battery.c
@@ -61,7 +61,7 @@ static unsigned long tosa_read_bat(struc
 	mutex_lock(&bat_lock);
 	gpio_set_value(bat->gpio_bat, 1);
 	msleep(5);
-	value = wm97xx_read_aux_adc(bat->psy.dev->parent->driver_data,
+	value = wm97xx_read_aux_adc(dev_get_drvdata(bat->psy.dev->parent),
 			bat->adc_bat);
 	gpio_set_value(bat->gpio_bat, 0);
 	mutex_unlock(&bat_lock);
@@ -81,7 +81,7 @@ static unsigned long tosa_read_temp(stru
 	mutex_lock(&bat_lock);
 	gpio_set_value(bat->gpio_temp, 1);
 	msleep(5);
-	value = wm97xx_read_aux_adc(bat->psy.dev->parent->driver_data,
+	value = wm97xx_read_aux_adc(dev_get_drvdata(bat->psy.dev->parent),
 			bat->adc_temp);
 	gpio_set_value(bat->gpio_temp, 0);
 	mutex_unlock(&bat_lock);
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

linux-next.patch
gpiolib-introduce-chip-addition-removal-notifier.patch
of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
powerpc-mcu_mpc8349emitx-remove-of-gpio-handling-stuff.patch

