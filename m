From: akpm@linux-foundation.org
Subject: - rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch removed from -mm tree
Date: Thu, 04 Sep 2008 12:56:26 -0700
Message-ID: <200809041956.m84JuQAr027878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754100AbYIDT4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 15:56:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, a.zummo@towertech.it, davem@davemloft.net, rongkai.zhan@windriver.com, mm-commits@vger.kernel.org


The patch titled
     rtc-m48t59: add support for M48T02 and M48T59 chips
has been removed from the -mm tree.  Its filename was
     rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-m48t59: add support for M48T02 and M48T59 chips
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add support for two compatible RTC:
- M48T08 which does not have alarm part,
- M48T08 which does not have alarm part and has
  only 2KB of NVRAM

These types covers all Mostek's RTC used in Sun UltraSparc workstations.

Tested on Sun Ultra60 with M48T59 RTC.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Mark Zhan <rongkai.zhan@windriver.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig        |    7 +++--
 drivers/rtc/rtc-m48t59.c   |   47 +++++++++++++++++++++++++++++------
 include/linux/rtc/m48t59.h |   45 ++++++++++++++++++---------------
 3 files changed, 69 insertions(+), 30 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev
+++ a/drivers/rtc/Kconfig
@@ -415,10 +415,13 @@ config RTC_DRV_M48T86
 	  will be called rtc-m48t86.
 
 config RTC_DRV_M48T59
-	tristate "ST M48T59"
+	tristate "ST M48T59/M48T08/M48T02"
 	help
 	  If you say Y here you will get support for the
-	  ST M48T59 RTC chip.
+	  ST M48T59 RTC chip and compatible ST M48T08 and M48T02.
+
+	  These chips are usually found in Sun SPARC and UltraSPARC
+	  workstations.
 
 	  This driver can also be built as a module, if so, the module
 	  will be called "rtc-m48t59".
diff -puN drivers/rtc/rtc-m48t59.c~rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev
+++ a/drivers/rtc/rtc-m48t59.c
@@ -24,8 +24,9 @@
 #define NO_IRQ	(-1)
 #endif
 
-#define M48T59_READ(reg)	pdata->read_byte(dev, reg)
-#define M48T59_WRITE(val, reg)	pdata->write_byte(dev, reg, val)
+#define M48T59_READ(reg) (pdata->read_byte(dev, pdata->offset + reg))
+#define M48T59_WRITE(val, reg) \
+	(pdata->write_byte(dev, pdata->offset + reg, val))
 
 #define M48T59_SET_BITS(mask, reg)	\
 	M48T59_WRITE((M48T59_READ(reg) | (mask)), (reg))
@@ -309,6 +310,11 @@ static const struct rtc_class_ops m48t59
 	.proc		= m48t59_rtc_proc,
 };
 
+static const struct rtc_class_ops m48t02_rtc_ops = {
+	.read_time	= m48t59_rtc_read_time,
+	.set_time	= m48t59_rtc_set_time,
+};
+
 static ssize_t m48t59_nvram_read(struct kobject *kobj,
 				struct bin_attribute *bin_attr,
 				char *buf, loff_t pos, size_t size)
@@ -320,7 +326,7 @@ static ssize_t m48t59_nvram_read(struct 
 	ssize_t cnt = 0;
 	unsigned long flags;
 
-	for (; size > 0 && pos < M48T59_NVRAM_SIZE; cnt++, size--) {
+	for (; size > 0 && pos < pdata->offset; cnt++, size--) {
 		spin_lock_irqsave(&m48t59->lock, flags);
 		*buf++ = M48T59_READ(cnt);
 		spin_unlock_irqrestore(&m48t59->lock, flags);
@@ -340,7 +346,7 @@ static ssize_t m48t59_nvram_write(struct
 	ssize_t cnt = 0;
 	unsigned long flags;
 
-	for (; size > 0 && pos < M48T59_NVRAM_SIZE; cnt++, size--) {
+	for (; size > 0 && pos < pdata->offset; cnt++, size--) {
 		spin_lock_irqsave(&m48t59->lock, flags);
 		M48T59_WRITE(*buf++, cnt);
 		spin_unlock_irqrestore(&m48t59->lock, flags);
@@ -357,7 +363,6 @@ static struct bin_attribute m48t59_nvram
 	},
 	.read = m48t59_nvram_read,
 	.write = m48t59_nvram_write,
-	.size = M48T59_NVRAM_SIZE,
 };
 
 static int __devinit m48t59_rtc_probe(struct platform_device *pdev)
@@ -366,6 +371,8 @@ static int __devinit m48t59_rtc_probe(st
 	struct m48t59_private *m48t59 = NULL;
 	struct resource *res;
 	int ret = -ENOMEM;
+	char *name;
+	const struct rtc_class_ops *ops;
 
 	/* This chip could be memory-mapped or I/O-mapped */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -390,6 +397,8 @@ static int __devinit m48t59_rtc_probe(st
 			/* Ensure we only kmalloc platform data once */
 			pdev->dev.platform_data = pdata;
 		}
+		if (!pdata->type)
+			pdata->type = M48T59RTC_TYPE_M48T59;
 
 		/* Try to use the generic memory read/write ops */
 		if (!pdata->write_byte)
@@ -419,14 +428,36 @@ static int __devinit m48t59_rtc_probe(st
 		if (ret)
 			goto out;
 	}
+	switch (pdata->type) {
+	case M48T59RTC_TYPE_M48T59:
+		name = "m48t59";
+		ops = &m48t59_rtc_ops;
+		pdata->offset = 0x1ff0;
+		break;
+	case M48T59RTC_TYPE_M48T02:
+		name = "m48t02";
+		ops = &m48t02_rtc_ops;
+		pdata->offset = 0x7f0;
+		break;
+	case M48T59RTC_TYPE_M48T08:
+		name = "m48t08";
+		ops = &m48t02_rtc_ops;
+		pdata->offset = 0x1ff0;
+		break;
+	default:
+		dev_err(&pdev->dev, "Unknown RTC type\n");
+		ret = -ENODEV;
+		goto out;
+	}
 
-	m48t59->rtc = rtc_device_register("m48t59", &pdev->dev,
-				&m48t59_rtc_ops, THIS_MODULE);
+	m48t59->rtc = rtc_device_register(name, &pdev->dev, ops, THIS_MODULE);
 	if (IS_ERR(m48t59->rtc)) {
 		ret = PTR_ERR(m48t59->rtc);
 		goto out;
 	}
 
+	m48t59_nvram_attr.size = pdata->offset;
+
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &m48t59_nvram_attr);
 	if (ret)
 		goto out;
@@ -489,5 +520,5 @@ module_init(m48t59_rtc_init);
 module_exit(m48t59_rtc_exit);
 
 MODULE_AUTHOR("Mark Zhan <rongkai.zhan@windriver.com>");
-MODULE_DESCRIPTION("M48T59 RTC driver");
+MODULE_DESCRIPTION("M48T59/M48T02/M48T08 RTC driver");
 MODULE_LICENSE("GPL");
diff -puN include/linux/rtc/m48t59.h~rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev include/linux/rtc/m48t59.h
--- a/include/linux/rtc/m48t59.h~rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev
+++ a/include/linux/rtc/m48t59.h
@@ -18,40 +18,45 @@
 /*
  * M48T59 Register Offset
  */
-#define M48T59_YEAR		0x1fff
-#define M48T59_MONTH		0x1ffe
-#define M48T59_MDAY		0x1ffd	/* Day of Month */
-#define M48T59_WDAY		0x1ffc	/* Day of Week */
+#define M48T59_YEAR		0xf
+#define M48T59_MONTH		0xe
+#define M48T59_MDAY		0xd	/* Day of Month */
+#define M48T59_WDAY		0xc	/* Day of Week */
 #define M48T59_WDAY_CB			0x20	/* Century Bit */
 #define M48T59_WDAY_CEB			0x10	/* Century Enable Bit */
-#define M48T59_HOUR		0x1ffb
-#define M48T59_MIN		0x1ffa
-#define M48T59_SEC		0x1ff9
-#define M48T59_CNTL		0x1ff8
+#define M48T59_HOUR		0xb
+#define M48T59_MIN		0xa
+#define M48T59_SEC		0x9
+#define M48T59_CNTL		0x8
 #define M48T59_CNTL_READ		0x40
 #define M48T59_CNTL_WRITE		0x80
-#define M48T59_WATCHDOG		0x1ff7
-#define M48T59_INTR		0x1ff6
+#define M48T59_WATCHDOG		0x7
+#define M48T59_INTR		0x6
 #define M48T59_INTR_AFE			0x80	/* Alarm Interrupt Enable */
 #define M48T59_INTR_ABE			0x20
-#define M48T59_ALARM_DATE	0x1ff5
-#define M48T59_ALARM_HOUR	0x1ff4
-#define M48T59_ALARM_MIN	0x1ff3
-#define M48T59_ALARM_SEC	0x1ff2
-#define M48T59_UNUSED		0x1ff1
-#define M48T59_FLAGS		0x1ff0
+#define M48T59_ALARM_DATE	0x5
+#define M48T59_ALARM_HOUR	0x4
+#define M48T59_ALARM_MIN	0x3
+#define M48T59_ALARM_SEC	0x2
+#define M48T59_UNUSED		0x1
+#define M48T59_FLAGS		0x0
 #define M48T59_FLAGS_WDT		0x80	/* watchdog timer expired */
 #define M48T59_FLAGS_AF			0x40	/* alarm */
 #define M48T59_FLAGS_BF			0x10	/* low battery */
 
-#define M48T59_NVRAM_SIZE	0x1ff0
+#define M48T59RTC_TYPE_M48T59	0 /* to keep compatibility */
+#define M48T59RTC_TYPE_M48T02	1
+#define M48T59RTC_TYPE_M48T08	2
 
 struct m48t59_plat_data {
-	/* The method to access M48T59 registers,
-	 * NOTE: The 'ofs' should be 0x00~0x1fff
-	 */
+	/* The method to access M48T59 registers */
 	void (*write_byte)(struct device *dev, u32 ofs, u8 val);
 	unsigned char (*read_byte)(struct device *dev, u32 ofs);
+
+	int type; /* RTC model */
+
+	/* offset to RTC registers, automatically set according to the type */
+	unsigned int offset;
 };
 
 #endif /* _LINUX_RTC_M48T59_H_ */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
fb-metronome-printk-format-warning.patch
x86-delay-early-cpu-initialization-until-cpuid-is-done.patch
x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
viafb-accelc-accelh-update.patch
viafb-viafbdevc-update.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch
neofb-kill-some-redundant-code.patch
vga16fb-remove-open_lock-mutex.patch
neofb-remove-open_lock-mutex.patch
cirrusfb-remove-information-about-memory-size-during-mode-change.patch
cirrusfb-simplify-clock-calculation.patch
cirrusfb-remove-24-bpp-mode.patch
cirrusfb-drop-device-pointers-from-cirrusfb_info.patch
tdfxfb-do-not-make-changes-to-default-tdfx_fix.patch
intelfb-support-945gme-as-used-in-asus-eee-901.patch
cirrusfb-use-modedb-and-add-mode_option-parameter-2nd-rev.patch

