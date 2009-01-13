From: akpm@linux-foundation.org
Subject: + rtc-cumulative-style-fixes.patch added to -mm tree
Date: Mon, 12 Jan 2009 16:40:25 -0800
Message-ID: <200901130040.n0D0ePgC011877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbZAMAmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 19:42:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.zummo@towertech.it, andrew@sanpeople.com, ben@simtec.co.uk, dbrownell@users.sourceforge.net, dsaxena@plexity.net, gl@dsa-ac.de, iwamatsu@nigauri.org, kyle@mcmartin.ca, lethal@linux-sh.org, pmironchik@optifacio.net, raph@raphnet.net, rongkai.zhan@windriver.com, rpurdie@rpsys.net, scottwood@freescale.com, yoichi_yuasa@tripeaks.co.jp


The patch titled
     rtc: cumulative style fixes
has been added to the -mm tree.  Its filename is
     rtc-cumulative-style-fixes.patch

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
Subject: rtc: cumulative style fixes
From: Alessandro Zummo <a.zummo@towertech.it>

Address errors and warnings reported by checkpatch.pl.

Some rules listed at
http://groups.google.com/group/rtc-linux/web/checklist hav been enforced
too.

The are still a few drivers with issues which I'm planning to address
soon.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Raphael Assenat <raph@raphnet.net>
Cc: Deepak Saxena <dsaxena@plexity.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Cc: Mark Zhan <rongkai.zhan@windriver.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: G. Liakhovetski <gl@dsa-ac.de>
Cc: Andrew Victor <andrew@sanpeople.com>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Pavel Mironchik <pmironchik@optifacio.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/hctosys.c        |    8 ++---
 drivers/rtc/interface.c      |   17 ++++++------
 drivers/rtc/rtc-at91rm9200.c |    5 +--
 drivers/rtc/rtc-cmos.c       |   21 +++++++--------
 drivers/rtc/rtc-ds1302.c     |    1 
 drivers/rtc/rtc-ds1307.c     |    5 ++-
 drivers/rtc/rtc-ds1374.c     |   12 ++++----
 drivers/rtc/rtc-ep93xx.c     |    5 +--
 drivers/rtc/rtc-m48t59.c     |    4 +-
 drivers/rtc/rtc-m48t86.c     |   10 +++----
 drivers/rtc/rtc-omap.c       |    3 --
 drivers/rtc/rtc-parisc.c     |    5 +--
 drivers/rtc/rtc-pcf8563.c    |    6 ++--
 drivers/rtc/rtc-pcf8583.c    |    8 +++--
 drivers/rtc/rtc-pl031.c      |    7 ++---
 drivers/rtc/rtc-rs5c313.c    |   12 ++++----
 drivers/rtc/rtc-rs5c372.c    |   46 ++++++++++++++++++++++-----------
 drivers/rtc/rtc-s3c.c        |   26 +++++++++---------
 drivers/rtc/rtc-sa1100.c     |   14 +++++-----
 drivers/rtc/rtc-sh.c         |    1 
 drivers/rtc/rtc-sysfs.c      |    4 +-
 drivers/rtc/rtc-test.c       |   17 +++++++-----
 drivers/rtc/rtc-v3020.c      |   37 ++++++++++++--------------
 drivers/rtc/rtc-vr41xx.c     |   26 ++++++++++--------
 drivers/rtc/rtc-x1205.c      |   32 +++++++++++++---------
 25 files changed, 180 insertions(+), 152 deletions(-)

diff -puN drivers/rtc/hctosys.c~rtc-cumulative-style-fixes drivers/rtc/hctosys.c
--- a/drivers/rtc/hctosys.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/hctosys.c
@@ -29,7 +29,7 @@ static int __init rtc_hctosys(void)
 	struct rtc_device *rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
 
 	if (rtc == NULL) {
-		printk("%s: unable to open rtc device (%s)\n",
+		printk(KERN_ERR "%s: unable to open rtc device (%s)\n",
 			__FILE__, CONFIG_RTC_HCTOSYS_DEVICE);
 		return -ENODEV;
 	}
@@ -52,12 +52,10 @@ static int __init rtc_hctosys(void)
 				tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
 				tm.tm_hour, tm.tm_min, tm.tm_sec,
 				(unsigned int) tv.tv_sec);
-		}
-		else
+		} else
 			dev_err(rtc->dev.parent,
 				"hctosys: invalid date/time\n");
-	}
-	else
+	} else
 		dev_err(rtc->dev.parent,
 			"hctosys: unable to read the hardware clock\n");
 
diff -puN drivers/rtc/interface.c~rtc-cumulative-style-fixes drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/interface.c
@@ -95,8 +95,7 @@ int rtc_set_mmss(struct rtc_device *rtc,
 				err = rtc->ops->set_time(rtc->dev.parent,
 						&new);
 		}
-	}
-	else
+	} else
 		err = -EINVAL;
 
 	mutex_unlock(&rtc->ops_lock);
@@ -105,7 +104,8 @@ int rtc_set_mmss(struct rtc_device *rtc,
 }
 EXPORT_SYMBOL_GPL(rtc_set_mmss);
 
-static int rtc_read_alarm_internal(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
+static int rtc_read_alarm_internal(struct rtc_device *rtc,
+					struct rtc_wkalrm *alarm)
 {
 	int err;
 
@@ -202,10 +202,10 @@ int rtc_read_alarm(struct rtc_device *rt
 			return err;
 
 		/* note that tm_sec is a "don't care" value here: */
-	} while (   before.tm_min   != now.tm_min
-		 || before.tm_hour  != now.tm_hour
-		 || before.tm_mon   != now.tm_mon
-		 || before.tm_year  != now.tm_year);
+	} while (before.tm_min != now.tm_min
+		 || before.tm_hour != now.tm_hour
+		 || before.tm_mon != now.tm_mon
+		 || before.tm_year != now.tm_year);
 
 	/* Fill in the missing alarm fields using the timestamp; we
 	 * know there's at least one since alarm->time is invalid.
@@ -469,7 +469,8 @@ EXPORT_SYMBOL_GPL(rtc_irq_unregister);
  * Note that rtc_irq_set_freq() should previously have been used to
  * specify the desired frequency of periodic IRQ task->func() callbacks.
  */
-int rtc_irq_set_state(struct rtc_device *rtc, struct rtc_task *task, int enabled)
+int rtc_irq_set_state(struct rtc_device *rtc, struct rtc_task *task,
+			int enabled)
 {
 	int err = 0;
 	unsigned long flags;
diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-cumulative-style-fixes drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -27,13 +27,12 @@
 #include <linux/interrupt.h>
 #include <linux/ioctl.h>
 #include <linux/completion.h>
-
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <mach/at91_rtc.h>
 
 
-#define AT91_RTC_EPOCH		1900UL	/* just like arch/arm/common/rtctime.c */
+#define AT91_RTC_EPOCH 1900UL	/* just like arch/arm/common/rtctime.c */
 
 static DECLARE_COMPLETION(at91_rtc_updated);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
diff -puN drivers/rtc/rtc-cmos.c~rtc-cumulative-style-fixes drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-cmos.c
@@ -89,7 +89,7 @@ static inline int is_intr(u8 rtc_intr)
  * want to use HPET for anything except those IRQs though...
  */
 #ifdef CONFIG_HPET_EMULATE_RTC
-#include <asm/hpet.h>
+#include <linux/hpet.h>
 #else
 
 static inline int is_hpet_enabled(void)
@@ -476,23 +476,23 @@ static int cmos_procfs(struct device *de
 	valid = CMOS_READ(RTC_VALID);
 	spin_unlock_irq(&rtc_lock);
 
-	/* NOTE:  at least ICH6 reports battery status using a different
+	/* NOTE: at least ICH6 reports battery status using a different
 	 * (non-RTC) bit; and SQWE is ignored on many current systems.
 	 */
 	return seq_printf(seq,
 			"periodic_IRQ\t: %s\n"
 			"update_IRQ\t: %s\n"
 			"HPET_emulated\t: %s\n"
-			// "square_wave\t: %s\n"
-			// "BCD\t\t: %s\n"
+			/* "square_wave\t: %s\n"
+			 "BCD\t\t: %s\n" */
 			"DST_enable\t: %s\n"
 			"periodic_freq\t: %d\n"
 			"batt_status\t: %s\n",
 			(rtc_control & RTC_PIE) ? "yes" : "no",
 			(rtc_control & RTC_UIE) ? "yes" : "no",
 			is_hpet_enabled() ? "yes" : "no",
-			// (rtc_control & RTC_SQWE) ? "yes" : "no",
-			// (rtc_control & RTC_DM_BINARY) ? "no" : "yes",
+			/* (rtc_control & RTC_SQWE) ? "yes" : "no",
+			 (rtc_control & RTC_DM_BINARY) ? "no" : "yes", */
 			(rtc_control & RTC_DST_EN) ? "yes" : "no",
 			cmos->rtc->irq_freq,
 			(valid & RTC_VRT) ? "okay" : "dead");
@@ -646,9 +646,8 @@ static irqreturn_t cmos_interrupt(int ir
 		return IRQ_NONE;
 }
 
-#ifdef	CONFIG_PNP
+#ifdef CONFIG_PNP
 #define	INITSECTION
-
 #else
 #define	INITSECTION	__init
 #endif
@@ -689,7 +688,7 @@ cmos_do_probe(struct device *dev, struct
 	 * won't address 128 bytes.  Newer chips have multiple banks,
 	 * though they may not be listed in one I/O resource.
 	 */
-#if	defined(CONFIG_ATARI)
+#if defined(CONFIG_ATARI)
 	address_space = 64;
 #elif defined(__i386__) || defined(__x86_64__) || defined(__arm__) || defined(__sparc__)
 	address_space = 128;
@@ -1005,7 +1004,7 @@ static void rtc_wake_off(struct device *
 	acpi_disable_event(ACPI_EVENT_RTC, 0);
 }
 #else
-#define rtc_wake_setup()	do{}while(0)
+#define rtc_wake_setup()	do {} while (0)
 #define rtc_wake_on		NULL
 #define rtc_wake_off		NULL
 #endif
@@ -1066,7 +1065,7 @@ cmos_pnp_probe(struct pnp_dev *pnp, cons
 {
 	cmos_wake_setup(&pnp->dev);
 
-	if (pnp_port_start(pnp,0) == 0x70 && !pnp_irq_valid(pnp,0))
+	if (pnp_port_start(pnp, 0) == 0x70 && !pnp_irq_valid(pnp, 0))
 		/* Some machines contain a PNP entry for the RTC, but
 		 * don't define the IRQ. It should always be safe to
 		 * hardcode it in these cases
diff -puN drivers/rtc/rtc-ds1302.c~rtc-cumulative-style-fixes drivers/rtc/rtc-ds1302.c
--- a/drivers/rtc/rtc-ds1302.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-ds1302.c
@@ -17,7 +17,6 @@
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/bcd.h>
-#include <asm/rtc.h>
 
 #define DRV_NAME	"rtc-ds1302"
 #define DRV_VERSION	"0.1.0"
diff -puN drivers/rtc/rtc-ds1307.c~rtc-cumulative-style-fixes drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-ds1307.c
@@ -31,7 +31,7 @@ enum ds_type {
 	ds_1339,
 	ds_1340,
 	m41t00,
-	// rs5c372 too?  different address...
+	/* rs5c372 too?  different address... */
 };
 
 
@@ -540,7 +540,8 @@ static int __devinit ds1307_probe(struct
 			I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
-	if (!(ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL)))
+	ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL);
+	if (ds1307 == NULL)
 		return -ENOMEM;
 
 	ds1307->client = client;
diff -puN drivers/rtc/rtc-ds1374.c~rtc-cumulative-style-fixes drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-ds1374.c
@@ -63,7 +63,7 @@ struct ds1374 {
 static struct i2c_driver ds1374_driver;
 
 static int ds1374_read_rtc(struct i2c_client *client, u32 *time,
-                           int reg, int nbytes)
+				int reg, int nbytes)
 {
 	u8 buf[4];
 	int ret;
@@ -88,7 +88,7 @@ static int ds1374_read_rtc(struct i2c_cl
 }
 
 static int ds1374_write_rtc(struct i2c_client *client, u32 time,
-                            int reg, int nbytes)
+				int reg, int nbytes)
 {
 	u8 buf[4];
 	int i;
@@ -117,8 +117,8 @@ static int ds1374_check_rtc_status(struc
 
 	if (stat & DS1374_REG_SR_OSF)
 		dev_warn(&client->dev,
-		         "oscillator discontinuity flagged, "
-		         "time unreliable\n");
+			"oscillator discontinuity flagged, "
+			"time unreliable\n");
 
 	stat &= ~(DS1374_REG_SR_OSF | DS1374_REG_SR_AF);
 
@@ -383,7 +383,7 @@ static int ds1374_probe(struct i2c_clien
 
 	if (client->irq > 0) {
 		ret = request_irq(client->irq, ds1374_irq, 0,
-		                  "ds1374", client);
+					"ds1374", client);
 		if (ret) {
 			dev_err(&client->dev, "unable to request IRQ\n");
 			goto out_free;
@@ -391,7 +391,7 @@ static int ds1374_probe(struct i2c_clien
 	}
 
 	ds1374->rtc = rtc_device_register(client->name, &client->dev,
-	                                  &ds1374_rtc_ops, THIS_MODULE);
+					&ds1374_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ds1374->rtc)) {
 		ret = PTR_ERR(ds1374->rtc);
 		dev_err(&client->dev, "unable to register the class device\n");
diff -puN drivers/rtc/rtc-ep93xx.c~rtc-cumulative-style-fixes drivers/rtc/rtc-ep93xx.c
--- a/drivers/rtc/rtc-ep93xx.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-ep93xx.c
@@ -95,9 +95,8 @@ static int __devinit ep93xx_rtc_probe(st
 	struct rtc_device *rtc = rtc_device_register("ep93xx",
 				&dev->dev, &ep93xx_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(rtc)) {
+	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
-	}
 
 	platform_set_drvdata(dev, rtc);
 
@@ -111,7 +110,7 @@ static int __devexit ep93xx_rtc_remove(s
 {
 	struct rtc_device *rtc = platform_get_drvdata(dev);
 
- 	if (rtc)
+	if (rtc)
 		rtc_device_unregister(rtc);
 
 	platform_set_drvdata(dev, NULL);
diff -puN drivers/rtc/rtc-m48t59.c~rtc-cumulative-style-fixes drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-m48t59.c
@@ -504,8 +504,8 @@ out:
 		free_irq(m48t59->irq, &pdev->dev);
 	if (m48t59->ioaddr)
 		iounmap(m48t59->ioaddr);
-	if (m48t59)
-		kfree(m48t59);
+
+	kfree(m48t59);
 	return ret;
 }
 
diff -puN drivers/rtc/rtc-m48t86.c~rtc-cumulative-style-fixes drivers/rtc/rtc-m48t86.c
--- a/drivers/rtc/rtc-m48t86.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-m48t86.c
@@ -62,10 +62,10 @@ static int m48t86_rtc_read_time(struct d
 		tm->tm_wday	= ops->readbyte(M48T86_REG_DOW);
 	} else {
 		/* bcd mode */
-		tm->tm_sec	= bcd2bin(ops->readbyte(M48T86_REG_SEC));
-		tm->tm_min	= bcd2bin(ops->readbyte(M48T86_REG_MIN));
-		tm->tm_hour	= bcd2bin(ops->readbyte(M48T86_REG_HOUR) & 0x3F);
-		tm->tm_mday	= bcd2bin(ops->readbyte(M48T86_REG_DOM));
+		tm->tm_sec  = bcd2bin(ops->readbyte(M48T86_REG_SEC));
+		tm->tm_min  = bcd2bin(ops->readbyte(M48T86_REG_MIN));
+		tm->tm_hour = bcd2bin(ops->readbyte(M48T86_REG_HOUR) & 0x3F);
+		tm->tm_mday = bcd2bin(ops->readbyte(M48T86_REG_DOM));
 		/* tm_mon is 0-11 */
 		tm->tm_mon	= bcd2bin(ops->readbyte(M48T86_REG_MONTH)) - 1;
 		tm->tm_year	= bcd2bin(ops->readbyte(M48T86_REG_YEAR)) + 100;
@@ -168,7 +168,7 @@ static int __devexit m48t86_rtc_remove(s
 {
 	struct rtc_device *rtc = platform_get_drvdata(dev);
 
- 	if (rtc)
+	if (rtc)
 		rtc_device_unregister(rtc);
 
 	platform_set_drvdata(dev, NULL);
diff -puN drivers/rtc/rtc-omap.c~rtc-cumulative-style-fixes drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-omap.c
@@ -20,8 +20,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/platform_device.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
 
 
 /* The OMAP1 RTC is a year/month/day/hours/minutes/seconds BCD clock
diff -puN drivers/rtc/rtc-parisc.c~rtc-cumulative-style-fixes drivers/rtc/rtc-parisc.c
--- a/drivers/rtc/rtc-parisc.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-parisc.c
@@ -7,8 +7,7 @@
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/platform_device.h>
-
-#include <asm/rtc.h>
+#include <linux/rtc.h>
 
 /* as simple as can be, and no simpler. */
 struct parisc_rtc {
@@ -56,7 +55,7 @@ static int __devinit parisc_rtc_probe(st
 {
 	struct parisc_rtc *p;
 
-	p = kzalloc(sizeof (*p), GFP_KERNEL);
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
 
diff -puN drivers/rtc/rtc-pcf8563.c~rtc-cumulative-style-fixes drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -89,7 +89,8 @@ static int pcf8563_get_datetime(struct i
 			"low voltage detected, date/time is not reliable.\n");
 
 	dev_dbg(&client->dev,
-		"%s: raw data is st1=%02x, st2=%02x, sec=%02x, min=%02x, hr=%02x, "
+		"%s: raw data is st1=%02x, st2=%02x, "
+		"sec=%02x, min=%02x, hr=%02x, "
 		"mday=%02x, wday=%02x, mon=%02x, year=%02x\n",
 		__func__,
 		buf[0], buf[1], buf[2], buf[3],
@@ -171,8 +172,7 @@ static int pcf8563_set_datetime(struct i
 	return 0;
 }
 
-struct pcf8563_limit
-{
+struct pcf8563_limit {
 	unsigned char reg;
 	unsigned char mask;
 	unsigned char min;
diff -puN drivers/rtc/rtc-pcf8583.c~rtc-cumulative-style-fixes drivers/rtc/rtc-pcf8583.c
--- a/drivers/rtc/rtc-pcf8583.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-pcf8583.c
@@ -42,7 +42,7 @@ struct pcf8583 {
 
 static struct i2c_driver pcf8583_driver;
 
-#define get_ctrl(x)    ((struct pcf8583 *)i2c_get_clientdata(x))->ctrl
+#define get_ctrl(x)    (((struct pcf8583 *)i2c_get_clientdata(x))->ctrl)
 #define set_ctrl(x, v) get_ctrl(x) = v
 
 #define CMOS_YEAR	(64 + 128)
@@ -86,7 +86,8 @@ static int pcf8583_get_datetime(struct i
 	return ret == 2 ? 0 : -EIO;
 }
 
-static int pcf8583_set_datetime(struct i2c_client *client, struct rtc_time *dt, int datetoo)
+static int pcf8583_set_datetime(struct i2c_client *client, struct rtc_time *dt,
+					int datetoo)
 {
 	unsigned char buf[8];
 	int ret, len = 6;
@@ -188,7 +189,8 @@ static int pcf8583_rtc_read_time(struct 
 		printk(KERN_WARNING "RTC: resetting control %02x -> %02x\n",
 		       ctrl, new_ctrl);
 
-		if ((err = pcf8583_set_ctrl(client, &new_ctrl)) < 0)
+		err = pcf8583_set_ctrl(client, &new_ctrl);
+		if (err < 0)
 			return err;
 	}
 
diff -puN drivers/rtc/rtc-pl031.c~rtc-cumulative-style-fixes drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-pl031.c
@@ -181,8 +181,9 @@ err_req:
 
 static struct amba_id pl031_ids[] __initdata = {
 	{
-		 .id = 0x00041031,
-	 	.mask = 0x000fffff, },
+		.id = 0x00041031,
+		.mask = 0x000fffff,
+	},
 	{0, 0},
 };
 
@@ -208,6 +209,6 @@ static void __exit pl031_exit(void)
 module_init(pl031_init);
 module_exit(pl031_exit);
 
-MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net");
+MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net>");
 MODULE_DESCRIPTION("ARM AMBA PL031 RTC Driver");
 MODULE_LICENSE("GPL");
diff -puN drivers/rtc/rtc-rs5c313.c~rtc-cumulative-style-fixes drivers/rtc/rtc-rs5c313.c
--- a/drivers/rtc/rtc-rs5c313.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-rs5c313.c
@@ -45,7 +45,7 @@
 #include <linux/platform_device.h>
 #include <linux/bcd.h>
 #include <linux/delay.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #define DRV_NAME	"rs5c313"
 #define DRV_VERSION 	"1.13"
@@ -299,7 +299,7 @@ static int rs5c313_rtc_set_time(struct d
 	rs5c313_write_reg(RS5C313_ADDR_SEC10, (data >> 4));
 
 	data = bin2bcd(tm->tm_min);
-	rs5c313_write_reg(RS5C313_ADDR_MIN, data );
+	rs5c313_write_reg(RS5C313_ADDR_MIN, data);
 	rs5c313_write_reg(RS5C313_ADDR_MIN10, (data >> 4));
 
 	data = bin2bcd(tm->tm_hour);
@@ -308,7 +308,7 @@ static int rs5c313_rtc_set_time(struct d
 
 	data = bin2bcd(tm->tm_mday);
 	rs5c313_write_reg(RS5C313_ADDR_DAY, data);
-	rs5c313_write_reg(RS5C313_ADDR_DAY10, (data>> 4));
+	rs5c313_write_reg(RS5C313_ADDR_DAY10, (data >> 4));
 
 	data = bin2bcd(tm->tm_mon + 1);
 	rs5c313_write_reg(RS5C313_ADDR_MON, data);
@@ -379,7 +379,7 @@ static int rs5c313_rtc_probe(struct plat
 
 static int __devexit rs5c313_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata( pdev );
+	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
 	rtc_device_unregister(rtc);
 
@@ -392,7 +392,7 @@ static struct platform_driver rs5c313_rt
 		.owner  = THIS_MODULE,
 	},
 	.probe 	= rs5c313_rtc_probe,
-	.remove = __devexit_p( rs5c313_rtc_remove ),
+	.remove = __devexit_p(rs5c313_rtc_remove),
 };
 
 static int __init rs5c313_rtc_init(void)
@@ -411,7 +411,7 @@ static int __init rs5c313_rtc_init(void)
 
 static void __exit rs5c313_rtc_exit(void)
 {
-	platform_driver_unregister( &rs5c313_rtc_platform_driver );
+	platform_driver_unregister(&rs5c313_rtc_platform_driver);
 }
 
 module_init(rs5c313_rtc_init);
diff -puN drivers/rtc/rtc-rs5c372.c~rtc-cumulative-style-fixes drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -224,7 +224,8 @@ static int rs5c372_set_datetime(struct i
 	buf[5] = bin2bcd(tm->tm_mon + 1);
 	buf[6] = bin2bcd(tm->tm_year - 100);
 
-	if (i2c_smbus_write_i2c_block_data(client, addr, sizeof(buf), buf) < 0) {
+	if (i2c_smbus_write_i2c_block_data(client, addr,
+					sizeof(buf), buf) < 0) {
 		dev_err(&client->dev, "%s: write error\n", __func__);
 		return -EIO;
 	}
@@ -606,10 +607,9 @@ static int rs5c372_probe(struct i2c_clie
 		}
 	}
 
-	if (!(rs5c372 = kzalloc(sizeof(struct rs5c372), GFP_KERNEL))) {
-		err = -ENOMEM;
-		goto exit;
-	}
+	rs5c372 = kzalloc(sizeof(struct rs5c372), GFP_KERNEL);
+	if (rs5c372 == NULL)
+		return -ENOMEM;
 
 	rs5c372->client = client;
 	i2c_set_clientdata(client, rs5c372);
@@ -663,16 +663,32 @@ static int rs5c372_probe(struct i2c_clie
 		dev_warn(&client->dev, "clock needs to be set\n");
 
 	dev_info(&client->dev, "%s found, %s, driver version " DRV_VERSION "\n",
-			({ char *s; switch (rs5c372->type) {
-			case rtc_r2025sd:	s = "r2025sd"; break;
-			case rtc_rs5c372a:	s = "rs5c372a"; break;
-			case rtc_rs5c372b:	s = "rs5c372b"; break;
-			case rtc_rv5c386:	s = "rv5c386"; break;
-			case rtc_rv5c387a:	s = "rv5c387a"; break;
-			default:		s = "chip"; break;
-			}; s;}),
-			rs5c372->time24 ? "24hr" : "am/pm"
-			);
+		({
+			/* XXX move this mess to a separate func */
+			char *s;
+			switch (rs5c372->type) {
+			case rtc_r2025sd:
+				s = "r2025sd";
+				break;
+			case rtc_rs5c372a:
+				s = "rs5c372a";
+				break;
+			case rtc_rs5c372b:
+				s = "rs5c372b";
+				break;
+			case rtc_rv5c386:
+				s = "rv5c386";
+				break;
+			case rtc_rv5c387a:
+				s = "rv5c387a";
+				break;
+			default:
+				s = "chip";
+				break;
+			};
+		s; }),
+		rs5c372->time24 ? "24hr" : "am/pm"
+	);
 
 	/* REVISIT use client->irq to register alarm irq ... */
 
diff -puN drivers/rtc/rtc-s3c.c~rtc-cumulative-style-fixes drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-s3c.c
@@ -23,8 +23,8 @@
 #include <linux/log2.h>
 
 #include <mach/hardware.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <asm/irq.h>
 #include <plat/regs-rtc.h>
 
@@ -285,7 +285,7 @@ static int s3c_rtc_proc(struct device *d
 	unsigned int ticnt = readb(s3c_rtc_base + S3C2410_TICNT);
 
 	seq_printf(seq, "periodic_IRQ\t: %s\n",
-		     (ticnt & S3C2410_TICNT_ENABLE) ? "yes" : "no" );
+		     (ticnt & S3C2410_TICNT_ENABLE) ? "yes" : "no");
 	return 0;
 }
 
@@ -359,25 +359,28 @@ static void s3c_rtc_enable(struct platfo
 	} else {
 		/* re-enable the device, and check it is ok */
 
-		if ((readb(base+S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0){
+		if ((readb(base+S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0) {
 			dev_info(&pdev->dev, "rtc disabled, re-enabling\n");
 
 			tmp = readb(base + S3C2410_RTCCON);
-			writeb(tmp|S3C2410_RTCCON_RTCEN, base+S3C2410_RTCCON);
+			writeb(tmp | S3C2410_RTCCON_RTCEN,
+				base + S3C2410_RTCCON);
 		}
 
-		if ((readb(base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)){
+		if ((readb(base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)) {
 			dev_info(&pdev->dev, "removing RTCCON_CNTSEL\n");
 
 			tmp = readb(base + S3C2410_RTCCON);
-			writeb(tmp& ~S3C2410_RTCCON_CNTSEL, base+S3C2410_RTCCON);
+			writeb(tmp & ~S3C2410_RTCCON_CNTSEL,
+				base + S3C2410_RTCCON);
 		}
 
-		if ((readb(base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)){
+		if ((readb(base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)) {
 			dev_info(&pdev->dev, "removing RTCCON_CLKRST\n");
 
 			tmp = readb(base + S3C2410_RTCCON);
-			writeb(tmp & ~S3C2410_RTCCON_CLKRST, base+S3C2410_RTCCON);
+			writeb(tmp & ~S3C2410_RTCCON_CLKRST,
+				base + S3C2410_RTCCON);
 		}
 	}
 }
@@ -453,7 +456,7 @@ static int __devinit s3c_rtc_probe(struc
 
 	s3c_rtc_enable(pdev, 1);
 
- 	pr_debug("s3c2410_rtc: RTCCON=%02x\n",
+	pr_debug("s3c2410_rtc: RTCCON=%02x\n",
 		 readb(s3c_rtc_base + S3C2410_RTCCON));
 
 	s3c_rtc_setfreq(&pdev->dev, 1);
@@ -523,11 +526,8 @@ static struct platform_driver s3c2410_rt
 	},
 };
 
-static char __initdata banner[] = "S3C24XX RTC, (c) 2004,2006 Simtec Electronics\n";
-
 static int __init s3c_rtc_init(void)
 {
-	printk(banner);
 	return platform_driver_register(&s3c2410_rtc_driver);
 }
 
diff -puN drivers/rtc/rtc-sa1100.c~rtc-cumulative-style-fixes drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-sa1100.c
@@ -38,7 +38,7 @@
 #include <mach/pxa-regs.h>
 #endif
 
-#define RTC_DEF_DIVIDER		32768 - 1
+#define RTC_DEF_DIVIDER		(32768 - 1)
 #define RTC_DEF_TRIM		0
 
 static unsigned long rtc_freq = 1024;
@@ -60,7 +60,8 @@ static inline int rtc_periodic_alarm(str
  * Calculate the next alarm time given the requested alarm time mask
  * and the current time.
  */
-static void rtc_next_alarm_time(struct rtc_time *next, struct rtc_time *now, struct rtc_time *alrm)
+static void rtc_next_alarm_time(struct rtc_time *next, struct rtc_time *now,
+					struct rtc_time *alrm)
 {
 	unsigned long next_time;
 	unsigned long now_time;
@@ -177,7 +178,7 @@ static int sa1100_rtc_read_callback(stru
 		 * Here we compare (match - OSCR) 8 instead of 0 --
 		 * see comment in pxa_timer_interrupt() for explanation.
 		 */
-		while( (signed long)((osmr1 = OSMR1) - OSCR) <= 8 ) {
+		while ((signed long)((osmr1 = OSMR1) - OSCR) <= 8) {
 			data += 0x100;
 			OSSR = OSSR_M1;	/* clear match on timer 1 */
 			OSMR1 = osmr1 + period;
@@ -235,7 +236,7 @@ static void sa1100_rtc_release(struct de
 static int sa1100_rtc_ioctl(struct device *dev, unsigned int cmd,
 		unsigned long arg)
 {
-	switch(cmd) {
+	switch (cmd) {
 	case RTC_AIE_OFF:
 		spin_lock_irq(&sa1100_rtc_lock);
 		RTSR &= ~RTSR_ALE;
@@ -363,7 +364,8 @@ static int sa1100_rtc_probe(struct platf
 	 */
 	if (RTTR == 0) {
 		RTTR = RTC_DEF_DIVIDER + (RTC_DEF_TRIM << 16);
-		dev_warn(&pdev->dev, "warning: initializing default clock divider/trim value\n");
+		dev_warn(&pdev->dev, "warning: initializing default "
+					"clock divider/trim value\n");
 		/* The current RTC value probably doesn't make sense either */
 		RCNR = 0;
 	}
@@ -385,7 +387,7 @@ static int sa1100_rtc_remove(struct plat
 {
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
- 	if (rtc)
+	if (rtc)
 		rtc_device_unregister(rtc);
 
 	return 0;
diff -puN drivers/rtc/rtc-sh.c~rtc-cumulative-style-fixes drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-sh.c
@@ -25,7 +25,6 @@
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/log2.h>
-#include <asm/rtc.h>
 
 #define DRV_NAME	"sh-rtc"
 #define DRV_VERSION	"0.2.0"
diff -puN drivers/rtc/rtc-sysfs.c~rtc-cumulative-style-fixes drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-sysfs.c
@@ -162,9 +162,9 @@ rtc_sysfs_set_wakealarm(struct device *d
 		adjust = 1;
 	}
 	alarm = simple_strtoul(buf_ptr, NULL, 0);
-	if (adjust) {
+	if (adjust)
 		alarm += now;
-	}
+
 	if (alarm > now) {
 		/* Avoid accidentally clobbering active alarms; we can't
 		 * entirely prevent that here, without even the minimal
diff -puN drivers/rtc/rtc-test.c~rtc-cumulative-style-fixes drivers/rtc/rtc-test.c
--- a/drivers/rtc/rtc-test.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-test.c
@@ -13,7 +13,7 @@
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
 
-static struct platform_device *test0 = NULL, *test1 = NULL;
+static struct platform_device *test0, *test1;
 
 static int test_rtc_read_alarm(struct device *dev,
 	struct rtc_wkalrm *alrm)
@@ -154,23 +154,28 @@ static int __init test_init(void)
 {
 	int err;
 
-	if ((err = platform_driver_register(&test_driver)))
+	err = platform_driver_register(&test_driver);
+	if (err)
 		return err;
 
-	if ((test0 = platform_device_alloc("rtc-test", 0)) == NULL) {
+	test0 = platform_device_alloc("rtc-test", 0);
+	if (test0 == NULL) {
 		err = -ENOMEM;
 		goto exit_driver_unregister;
 	}
 
-	if ((test1 = platform_device_alloc("rtc-test", 1)) == NULL) {
+	test1 = platform_device_alloc("rtc-test", 1);
+	if (test1 == NULL) {
 		err = -ENOMEM;
 		goto exit_free_test0;
 	}
 
-	if ((err = platform_device_add(test0)))
+	err = platform_device_add(test0);
+	if (err)
 		goto exit_free_test1;
 
-	if ((err = platform_device_add(test1)))
+	err = platform_device_add(test1);
+	if (err)
 		goto exit_device_unregister;
 
 	return 0;
diff -puN drivers/rtc/rtc-v3020.c~rtc-cumulative-style-fixes drivers/rtc/rtc-v3020.c
--- a/drivers/rtc/rtc-v3020.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-v3020.c
@@ -27,8 +27,7 @@
 #include <linux/bcd.h>
 #include <linux/rtc-v3020.h>
 #include <linux/delay.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
 
 #undef DEBUG
 
@@ -63,7 +62,7 @@ static void v3020_set_reg(struct v3020 *
 
 static unsigned char v3020_get_reg(struct v3020 *chip, unsigned char address)
 {
-	unsigned int data=0;
+	unsigned int data = 0;
 	int i;
 
 	for (i = 0; i < 4; i++) {
@@ -107,14 +106,14 @@ static int v3020_read_time(struct device
 	dt->tm_year = bcd2bin(tmp)+100;
 
 #ifdef DEBUG
-	printk("\n%s : Read RTC values\n",__func__);
-	printk("tm_hour: %i\n",dt->tm_hour);
-	printk("tm_min : %i\n",dt->tm_min);
-	printk("tm_sec : %i\n",dt->tm_sec);
-	printk("tm_year: %i\n",dt->tm_year);
-	printk("tm_mon : %i\n",dt->tm_mon);
-	printk("tm_mday: %i\n",dt->tm_mday);
-	printk("tm_wday: %i\n",dt->tm_wday);
+	dev_dbg(dev, "\n%s : Read RTC values\n", __func__);
+	dev_dbg(dev, "tm_hour: %i\n", dt->tm_hour);
+	dev_dbg(dev, "tm_min : %i\n", dt->tm_min);
+	dev_dbg(dev, "tm_sec : %i\n", dt->tm_sec);
+	dev_dbg(dev, "tm_year: %i\n", dt->tm_year);
+	dev_dbg(dev, "tm_mon : %i\n", dt->tm_mon);
+	dev_dbg(dev, "tm_mday: %i\n", dt->tm_mday);
+	dev_dbg(dev, "tm_wday: %i\n", dt->tm_wday);
 #endif
 
 	return 0;
@@ -126,13 +125,13 @@ static int v3020_set_time(struct device 
 	struct v3020 *chip = dev_get_drvdata(dev);
 
 #ifdef DEBUG
-	printk("\n%s : Setting RTC values\n",__func__);
-	printk("tm_sec : %i\n",dt->tm_sec);
-	printk("tm_min : %i\n",dt->tm_min);
-	printk("tm_hour: %i\n",dt->tm_hour);
-	printk("tm_mday: %i\n",dt->tm_mday);
-	printk("tm_wday: %i\n",dt->tm_wday);
-	printk("tm_year: %i\n",dt->tm_year);
+	dev_dbg(dev, ("\n%s : Setting RTC values\n", __func__);
+	dev_dbg(dev, ("tm_sec : %i\n", dt->tm_sec);
+	dev_dbg(dev, ("tm_min : %i\n", dt->tm_min);
+	dev_dbg(dev, ("tm_hour: %i\n", dt->tm_hour);
+	dev_dbg(dev, ("tm_mday: %i\n", dt->tm_mday);
+	dev_dbg(dev, ("tm_wday: %i\n", dt->tm_wday);
+	dev_dbg(dev, ("tm_year: %i\n", dt->tm_year);
 #endif
 
 	/* Write all the values to ram... */
@@ -191,7 +190,7 @@ static int rtc_probe(struct platform_dev
 	/* Test chip by doing a write/read sequence
 	 * to the chip ram */
 	v3020_set_reg(chip, V3020_SECONDS, 0x33);
-	if(v3020_get_reg(chip, V3020_SECONDS) != 0x33) {
+	if (v3020_get_reg(chip, V3020_SECONDS) != 0x33) {
 		retval = -ENODEV;
 		goto err_io;
 	}
diff -puN drivers/rtc/rtc-vr41xx.c~rtc-cumulative-style-fixes drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -28,10 +28,10 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/log2.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 #include <asm/div64.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
 
 MODULE_AUTHOR("Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>");
 MODULE_DESCRIPTION("NEC VR4100 series RTC driver");
@@ -103,7 +103,7 @@ static inline unsigned long read_elapsed
 		second_mid = rtc1_read(ETIMEMREG);
 		second_high = rtc1_read(ETIMEHREG);
 	} while (first_low != second_low || first_mid != second_mid ||
-	         first_high != second_high);
+		first_high != second_high);
 
 	return (first_high << 17) | (first_mid << 1) | (first_low >> 15);
 }
@@ -153,8 +153,9 @@ static int vr41xx_rtc_set_time(struct de
 	unsigned long epoch_sec, current_sec;
 
 	epoch_sec = mktime(epoch, 1, 1, 0, 0, 0);
-	current_sec = mktime(time->tm_year + 1900, time->tm_mon + 1, time->tm_mday,
-	                     time->tm_hour, time->tm_min, time->tm_sec);
+	current_sec = mktime(time->tm_year + 1900, time->tm_mon + 1,
+				time->tm_mday, time->tm_hour,
+				time->tm_min, time->tm_sec);
 
 	write_elapsed_second(current_sec - epoch_sec);
 
@@ -185,8 +186,9 @@ static int vr41xx_rtc_set_alarm(struct d
 	unsigned long alarm_sec;
 	struct rtc_time *time = &wkalrm->time;
 
-	alarm_sec = mktime(time->tm_year + 1900, time->tm_mon + 1, time->tm_mday,
-	                   time->tm_hour, time->tm_min, time->tm_sec);
+	alarm_sec = mktime(time->tm_year + 1900, time->tm_mon + 1,
+				time->tm_mday, time->tm_hour,
+				time->tm_min, time->tm_sec);
 
 	spin_lock_irq(&rtc_lock);
 
@@ -238,7 +240,8 @@ static int vr41xx_rtc_irq_set_state(stru
 	return 0;
 }
 
-static int vr41xx_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+static int vr41xx_rtc_ioctl(struct device *dev, unsigned int cmd,
+				unsigned long arg)
 {
 	switch (cmd) {
 	case RTC_AIE_ON:
@@ -344,7 +347,8 @@ static int __devinit rtc_probe(struct pl
 		goto err_rtc1_iounmap;
 	}
 
-	rtc = rtc_device_register(rtc_name, &pdev->dev, &vr41xx_rtc_ops, THIS_MODULE);
+	rtc = rtc_device_register(rtc_name, &pdev->dev, &vr41xx_rtc_ops,
+					THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		retval = PTR_ERR(rtc);
 		goto err_iounmap_all;
@@ -369,7 +373,7 @@ static int __devinit rtc_probe(struct pl
 	}
 
 	retval = request_irq(aie_irq, elapsedtime_interrupt, IRQF_DISABLED,
-	                     "elapsed_time", pdev);
+				"elapsed_time", pdev);
 	if (retval < 0)
 		goto err_device_unregister;
 
@@ -378,7 +382,7 @@ static int __devinit rtc_probe(struct pl
 		goto err_free_irq;
 
 	retval = request_irq(pie_irq, rtclong1_interrupt, IRQF_DISABLED,
-		             "rtclong1", pdev);
+				"rtclong1", pdev);
 	if (retval < 0)
 		goto err_free_irq;
 
diff -puN drivers/rtc/rtc-x1205.c~rtc-cumulative-style-fixes drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~rtc-cumulative-style-fixes
+++ a/drivers/rtc/rtc-x1205.c
@@ -204,12 +204,14 @@ static int x1205_set_datetime(struct i2c
 			buf[i] |= 0x80;
 
 	/* this sequence is required to unlock the chip */
-	if ((xfer = i2c_master_send(client, wel, 3)) != 3) {
+	xfer = i2c_master_send(client, wel, 3);
+	if (xfer != 3) {
 		dev_err(&client->dev, "%s: wel - %d\n", __func__, xfer);
 		return -EIO;
 	}
 
-	if ((xfer = i2c_master_send(client, rwel, 3)) != 3) {
+	xfer = i2c_master_send(client, rwel, 3);
+	if (xfer != 3) {
 		dev_err(&client->dev, "%s: rwel - %d\n", __func__, xfer);
 		return -EIO;
 	}
@@ -267,7 +269,8 @@ static int x1205_set_datetime(struct i2c
 	}
 
 	/* disable further writes */
-	if ((xfer = i2c_master_send(client, diswe, 3)) != 3) {
+	xfer = i2c_master_send(client, diswe, 3);
+	if (xfer != 3) {
 		dev_err(&client->dev, "%s: diswe - %d\n", __func__, xfer);
 		return -EIO;
 	}
@@ -355,8 +358,7 @@ static int x1205_get_atrim(struct i2c_cl
 	return 0;
 }
 
-struct x1205_limit
-{
+struct x1205_limit {
 	unsigned char reg, mask, min, max;
 };
 
@@ -401,7 +403,8 @@ static int x1205_validate_client(struct 
 			{ client->addr, I2C_M_RD, 1, &buf },
 		};
 
-		if ((xfer = i2c_transfer(client->adapter, msgs, 2)) != 2) {
+		xfer = i2c_transfer(client->adapter, msgs, 2);
+		if (xfer != 2) {
 			dev_err(&client->dev,
 				"%s: could not read register %x\n",
 				__func__, probe_zero_pattern[i]);
@@ -411,7 +414,7 @@ static int x1205_validate_client(struct 
 
 		if ((buf & probe_zero_pattern[i+1]) != 0) {
 			dev_err(&client->dev,
-				"%s: register=%02x, zero pattern=%d, value=%x\n",
+				"%s: reg=%02x, zero pattern=%d, value=%x\n",
 				__func__, probe_zero_pattern[i], i, buf);
 
 			return -ENODEV;
@@ -429,7 +432,8 @@ static int x1205_validate_client(struct 
 			{ client->addr, I2C_M_RD, 1, &reg },
 		};
 
-		if ((xfer = i2c_transfer(client->adapter, msgs, 2)) != 2) {
+		xfer = i2c_transfer(client->adapter, msgs, 2);
+		if (xfer != 2) {
 			dev_err(&client->dev,
 				"%s: could not read register %x\n",
 				__func__, probe_limits_pattern[i].reg);
@@ -500,10 +504,12 @@ static int x1205_rtc_proc(struct device 
 {
 	int err, dtrim, atrim;
 
-	if ((err = x1205_get_dtrim(to_i2c_client(dev), &dtrim)) == 0)
+	err = x1205_get_dtrim(to_i2c_client(dev), &dtrim);
+	if (err == 0)
 		seq_printf(seq, "digital_trim\t: %d ppm\n", dtrim);
 
-	if ((err = x1205_get_atrim(to_i2c_client(dev), &atrim)) == 0)
+	err = x1205_get_atrim(to_i2c_client(dev), &atrim);
+	if (err == 0)
 		seq_printf(seq, "analog_trim\t: %d.%02d pF\n",
 			atrim / 1000, atrim % 1000);
 	return 0;
@@ -591,7 +597,8 @@ static int x1205_probe(struct i2c_client
 	i2c_set_clientdata(client, rtc);
 
 	/* Check for power failures and eventualy enable the osc */
-	if ((err = x1205_get_status(client, &sr)) == 0) {
+	err = x1205_get_status(client, &sr);
+	if (err == 0) {
 		if (sr & X1205_SR_RTCF) {
 			dev_err(&client->dev,
 				"power failure detected, "
@@ -599,8 +606,7 @@ static int x1205_probe(struct i2c_client
 			udelay(50);
 			x1205_fix_osc(client);
 		}
-	}
-	else
+	} else
 		dev_err(&client->dev, "couldn't read status\n");
 
 	err = x1205_sysfs_register(&client->dev);
_

Patches currently in -mm which might be from a.zummo@towertech.it are

rtc-pcf50633-rtc-driver.patch
rtc-cumulative-style-fixes.patch

