From: akpm@linux-foundation.org
Subject: + rtc-rp5c01-add-nvram-support.patch added to -mm tree
Date: Thu, 22 Jul 2010 14:11:02 -0700
Message-ID: <201007222111.o6MLB3fC012350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107Ab0GVVLn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Jul 2010 17:11:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, a.zummo@towertech.it, mcuos.com@gmail.com


The patch titled
     rtc: rp5c01: add NVRAM support
has been added to the -mm tree.  Its filename is
     rtc-rp5c01-add-nvram-support.patch

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
Subject: rtc: rp5c01: add NVRAM support
From: Geert Uytterhoeven <geert@linux-m68k.org>

The Ricoh RP5C01 RTC contains 26 x 4 bits of NVRAM.  Provide access to it
via a sysfs "nvram" attribute file.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rp5c01.c |   89 +++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff -puN drivers/rtc/rtc-rp5c01.c~rtc-rp5c01-add-nvram-support drivers/rtc/rtc-rp5c01.c
--- a/drivers/rtc/rtc-rp5c01.c~rtc-rp5c01-add-nvram-support
+++ a/drivers/rtc/rtc-rp5c01.c
@@ -63,6 +63,8 @@ enum {
 struct rp5c01_priv {
 	u32 __iomem *regs;
 	struct rtc_device *rtc;
+	spinlock_t lock;	/* against concurrent RTC/NVRAM access */
+	struct bin_attribute nvram_attr;
 };
 
 static inline unsigned int rp5c01_read(struct rp5c01_priv *priv,
@@ -92,6 +94,7 @@ static int rp5c01_read_time(struct devic
 {
 	struct rp5c01_priv *priv = dev_get_drvdata(dev);
 
+	spin_lock_irq(&priv->lock);
 	rp5c01_lock(priv);
 
 	tm->tm_sec  = rp5c01_read(priv, RP5C01_10_SECOND) * 10 +
@@ -111,6 +114,7 @@ static int rp5c01_read_time(struct devic
 		tm->tm_year += 100;
 
 	rp5c01_unlock(priv);
+	spin_unlock_irq(&priv->lock);
 
 	return rtc_valid_tm(tm);
 }
@@ -119,6 +123,7 @@ static int rp5c01_set_time(struct device
 {
 	struct rp5c01_priv *priv = dev_get_drvdata(dev);
 
+	spin_lock_irq(&priv->lock);
 	rp5c01_lock(priv);
 
 	rp5c01_write(priv, tm->tm_sec / 10, RP5C01_10_SECOND);
@@ -139,6 +144,7 @@ static int rp5c01_set_time(struct device
 	rp5c01_write(priv, tm->tm_year % 10, RP5C01_1_YEAR);
 
 	rp5c01_unlock(priv);
+	spin_unlock_irq(&priv->lock);
 	return 0;
 }
 
@@ -147,6 +153,72 @@ static const struct rtc_class_ops rp5c01
 	.set_time	= rp5c01_set_time,
 };
 
+
+/*
+ * The NVRAM is organized as 2 blocks of 13 nibbles of 4 bits.
+ * We provide access to them like AmigaOS does: the high nibble of each 8-bit
+ * byte is stored in BLOCK10, the low nibble in BLOCK11.
+ */
+
+static ssize_t rp5c01_nvram_read(struct file *filp, struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t pos, size_t size)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct rp5c01_priv *priv = dev_get_drvdata(dev);
+	ssize_t count;
+
+	spin_lock_irq(&priv->lock);
+
+	for (count = 0; size > 0 && pos < RP5C01_MODE; count++, size--) {
+		u8 data;
+
+		rp5c01_write(priv,
+			     RP5C01_MODE_TIMER_EN | RP5C01_MODE_RAM_BLOCK10,
+			     RP5C01_MODE);
+		data = rp5c01_read(priv, pos) << 4;
+		rp5c01_write(priv,
+			     RP5C01_MODE_TIMER_EN | RP5C01_MODE_RAM_BLOCK11,
+			     RP5C01_MODE);
+		data |= rp5c01_read(priv, pos++);
+		rp5c01_write(priv, RP5C01_MODE_TIMER_EN | RP5C01_MODE_MODE01,
+			     RP5C01_MODE);
+		*buf++ = data;
+	}
+
+	spin_unlock_irq(&priv->lock);
+	return count;
+}
+
+static ssize_t rp5c01_nvram_write(struct file *filp, struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buf, loff_t pos, size_t size)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct rp5c01_priv *priv = dev_get_drvdata(dev);
+	ssize_t count;
+
+	spin_lock_irq(&priv->lock);
+
+	for (count = 0; size > 0 && pos < RP5C01_MODE; count++, size--) {
+		u8 data = *buf++;
+
+		rp5c01_write(priv,
+			     RP5C01_MODE_TIMER_EN | RP5C01_MODE_RAM_BLOCK10,
+			     RP5C01_MODE);
+		rp5c01_write(priv, data >> 4, pos);
+		rp5c01_write(priv,
+			     RP5C01_MODE_TIMER_EN | RP5C01_MODE_RAM_BLOCK11,
+			     RP5C01_MODE);
+		rp5c01_write(priv, data & 0xf, pos++);
+		rp5c01_write(priv, RP5C01_MODE_TIMER_EN | RP5C01_MODE_MODE01,
+			     RP5C01_MODE);
+	}
+
+	spin_unlock_irq(&priv->lock);
+	return count;
+}
+
 static int __init rp5c01_rtc_probe(struct platform_device *dev)
 {
 	struct resource *res;
@@ -168,6 +240,15 @@ static int __init rp5c01_rtc_probe(struc
 		goto out_free_priv;
 	}
 
+	sysfs_bin_attr_init(&priv->nvram_attr);
+	priv->nvram_attr.attr.name = "nvram";
+	priv->nvram_attr.attr.mode = S_IRUGO | S_IWUSR;
+	priv->nvram_attr.read = rp5c01_nvram_read;
+	priv->nvram_attr.write = rp5c01_nvram_write;
+	priv->nvram_attr.size = RP5C01_MODE;
+
+	spin_lock_init(&priv->lock);
+
 	rtc = rtc_device_register("rtc-rp5c01", &dev->dev, &rp5c01_rtc_ops,
 				  THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -177,8 +258,15 @@ static int __init rp5c01_rtc_probe(struc
 
 	priv->rtc = rtc;
 	platform_set_drvdata(dev, priv);
+
+	error = sysfs_create_bin_file(&dev->dev.kobj, &priv->nvram_attr);
+	if (error)
+		goto out_unregister;
+
 	return 0;
 
+out_unregister:
+	rtc_device_unregister(rtc);
 out_unmap:
 	iounmap(priv->regs);
 out_free_priv:
@@ -190,6 +278,7 @@ static int __exit rp5c01_rtc_remove(stru
 {
 	struct rp5c01_priv *priv = platform_get_drvdata(dev);
 
+	sysfs_remove_bin_file(&dev->dev.kobj, &priv->nvram_attr);
 	rtc_device_unregister(priv->rtc);
 	iounmap(priv->regs);
 	kfree(priv);
_

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
alpha-h8300-m68k-remove-obsolete-asm-mdh-files.patch
kernel-range-remove-unused-definition-of-array_size.patch
rtc-rp5c01-add-nvram-support.patch

