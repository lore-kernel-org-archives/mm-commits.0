From: akpm@linux-foundation.org
Subject: + rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch added to -mm tree
Date: Thu, 27 Aug 2009 14:10:38 -0700
Message-ID: <200908272110.n7RLAdGt016582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100AbZH0VQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 17:16:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, a.zummo@towertech.it, ben-linux@fluff.org, dbrownell@users.sourceforge.net, khali@linux-fr.org


The patch titled
     rtc: set wakeup capability for I2C and SPI RTC drivers
has been added to the -mm tree.  Its filename is
     rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

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
Subject: rtc: set wakeup capability for I2C and SPI RTC drivers
From: Anton Vorontsov <avorontsov@ru.mvista.com>

RTC core won't allow wakeup alarms to be set if RTC devices' parent (i.e. 
i2c_client or spi_device) isn't wakeup capable.

For I2C devices there is I2C_CLIENT_WAKE flag exists that we can pass via
board info, and if set, I2C core will initialize wakeup capability.  For
SPI devices there is no such flag at all.

I believe that it's not platform code responsibility to allow or disallow
wakeups, instead, drivers themselves should set the capability if a device
can trigger wakeups.

That's what drivers/base/power/sysfs.c says:

 * It is the responsibility of device drivers to enable (or disable)
 * wakeup signaling as part of changing device power states, respecting
 * the policy choices provided through the driver model.

I2C and SPI RTC devices send wakeup events via interrupt lines, so we
should set the wakeup capability if IRQ is routed.

Ideally we should also check irq for wakeup capability before setting
device's capability, i.e.

	if (can_irq_wake(irq))
		device_set_wakeup_capable(&client->dev, 1);

But there is no can_irq_wake() call exist, and it is not that trivial to
implement it for all interrupts controllers and complex/cascaded setups.

drivers/base/power/sysfs.c also covers these cases:

 * Devices may not be able to generate wakeup events from all power
 * states.  Also, the events may be ignored in some configurations;
 * for example, they might need help from other devices that aren't
 * active

So there is no guarantee that wakeup will actually work, and so I think
there is no point in being pedantic wrt checking IRQ wakeup capability.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1305.c |    2 ++
 drivers/rtc/rtc-ds1307.c |    2 ++
 drivers/rtc/rtc-ds1374.c |    2 ++
 3 files changed, 6 insertions(+)

diff -puN drivers/rtc/rtc-ds1305.c~rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers
+++ a/drivers/rtc/rtc-ds1305.c
@@ -780,6 +780,8 @@ static int __devinit ds1305_probe(struct
 					spi->irq, status);
 			goto fail1;
 		}
+
+		device_set_wakeup_capable(&spi->dev, 1);
 	}
 
 	/* export NVRAM */
diff -puN drivers/rtc/rtc-ds1307.c~rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers
+++ a/drivers/rtc/rtc-ds1307.c
@@ -881,6 +881,8 @@ read_rtc:
 				"unable to request IRQ!\n");
 			goto exit_irq;
 		}
+
+		device_set_wakeup_capable(&client->dev, 1);
 		set_bit(HAS_ALARM, &ds1307->flags);
 		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
 	}
diff -puN drivers/rtc/rtc-ds1374.c~rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers
+++ a/drivers/rtc/rtc-ds1374.c
@@ -383,6 +383,8 @@ static int ds1374_probe(struct i2c_clien
 			dev_err(&client->dev, "unable to request IRQ\n");
 			goto out_free;
 		}
+
+		device_set_wakeup_capable(&client->dev, 1);
 	}
 
 	ds1374->rtc = rtc_device_register(client->name, &client->dev,
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-m25p80-fix-null-pointer-dereference-bug.patch
sdhci-be-more-strict-with-get_min_clock-usage.patch
sdhci-of-fix-sd-clock-calculation.patch
sdhci-of-avoid-writing-reserved-bits-into-host-control-register.patch
sdhci-of-fix-high-speed-cards-recognition.patch
powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc.patch
sdhci-of-dont-hard-code-inverted-write-protect-quirk.patch
sdhci-of-cleanup-esdhcs-set_clock-a-little-bit.patch
powerpc-85xx-add-esdhc-support-for-mpc8536ds-boards.patch
spi-add-support-for-device-table-matching.patch
mtd-m25p80-convert-to-device-table-matching.patch
of-remove-stmm25p40-alias.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch
spi-prefix-modalias-with-spi.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

