From: akpm@linux-foundation.org
Subject: + lcd-add-devm_lcd_device_registerunregister.patch added to -mm
 tree
Date: Fri, 24 May 2013 13:37:32 -0700
Message-ID: <519fcf8c.CANVICKYMssj8gKP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3EXUhd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 16:37:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, jg1.han@samsung.com

Subject: + lcd-add-devm_lcd_device_registerunregister.patch added to -mm tree
To: jg1.han@samsung.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 13:37:32 -0700


The patch titled
     Subject: lcd: add devm_lcd_device_{register,unregister}()
has been added to the -mm tree.  Its filename is
     lcd-add-devm_lcd_device_registerunregister.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: lcd: add devm_lcd_device_{register,unregister}()

These functions allow the driver core to automatically clean up any
allocation made by lcd drivers.  Thus it simplifies the error paths.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lcd.c |   70 ++++++++++++++++++++++++++++++++
 include/linux/lcd.h           |    5 ++
 2 files changed, 75 insertions(+)

diff -puN drivers/video/backlight/lcd.c~lcd-add-devm_lcd_device_registerunregister drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~lcd-add-devm_lcd_device_registerunregister
+++ a/drivers/video/backlight/lcd.c
@@ -260,6 +260,76 @@ void lcd_device_unregister(struct lcd_de
 }
 EXPORT_SYMBOL(lcd_device_unregister);
 
+static void devm_lcd_device_release(struct device *dev, void *res)
+{
+	struct lcd_device *lcd = *(struct lcd_device **)res;
+
+	lcd_device_unregister(lcd);
+}
+
+static int devm_lcd_device_match(struct device *dev, void *res, void *data)
+{
+	struct lcd_device **r = res;
+
+	return *r == data;
+}
+
+/**
+ * devm_lcd_device_register - resource managed lcd_device_register()
+ * @dev: the device to register
+ * @name: the name of the device
+ * @parent: a pointer to the parent device
+ * @devdata: an optional pointer to be stored for private driver use
+ * @ops: the lcd operations structure
+ *
+ * @return a struct lcd on success, or an ERR_PTR on error
+ *
+ * Managed lcd_device_register(). The lcd_device returned from this function
+ * are automatically freed on driver detach. See lcd_device_register()
+ * for more information.
+ */
+struct lcd_device *devm_lcd_device_register(struct device *dev,
+		const char *name, struct device *parent,
+		void *devdata, struct lcd_ops *ops)
+{
+	struct lcd_device **ptr, *lcd;
+
+	ptr = devres_alloc(devm_lcd_device_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	lcd = lcd_device_register(name, parent, devdata, ops);
+	if (!IS_ERR(lcd)) {
+		*ptr = lcd;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return lcd;
+}
+EXPORT_SYMBOL(devm_lcd_device_register);
+
+/**
+ * devm_lcd_device_unregister - resource managed lcd_device_unregister()
+ * @dev: the device to unregister
+ * @ld: the lcd device to unregister
+ *
+ * Deallocated a lcd allocated with devm_lcd_device_register(). Normally
+ * this function will not need to be called and the resource management
+ * code will ensure that the resource is freed.
+ */
+void devm_lcd_device_unregister(struct device *dev, struct lcd_device *ld)
+{
+	int rc;
+
+	rc = devres_release(dev, devm_lcd_device_release,
+				devm_lcd_device_match, ld);
+	WARN_ON(rc);
+}
+EXPORT_SYMBOL(devm_lcd_device_unregister);
+
+
 static void __exit lcd_class_exit(void)
 {
 	class_destroy(lcd_class);
diff -puN include/linux/lcd.h~lcd-add-devm_lcd_device_registerunregister include/linux/lcd.h
--- a/include/linux/lcd.h~lcd-add-devm_lcd_device_registerunregister
+++ a/include/linux/lcd.h
@@ -112,7 +112,12 @@ static inline void lcd_set_power(struct
 
 extern struct lcd_device *lcd_device_register(const char *name,
 	struct device *parent, void *devdata, struct lcd_ops *ops);
+extern struct lcd_device *devm_lcd_device_register(struct device *dev,
+	const char *name, struct device *parent,
+	void *devdata, struct lcd_ops *ops);
 extern void lcd_device_unregister(struct lcd_device *ld);
+extern void devm_lcd_device_unregister(struct device *dev,
+	struct lcd_device *ld);
 
 #define to_lcd_device(obj) container_of(obj, struct lcd_device, dev)
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
drivers-rtc-rtc-max8998c-check-for-pdata-presence-before-dereferencing.patch
backlight-atmel-pwm-bl-remove-unnecessary-platform_set_drvdata.patch
backlight-ep93xx-remove-unnecessary-platform_set_drvdata.patch
backlight-lp8788-remove-unnecessary-platform_set_drvdata.patch
backlight-pcf50633-remove-unnecessary-platform_set_drvdata.patch
backlight-add-devm_backlight_device_registerunregister.patch
lcd-add-devm_lcd_device_registerunregister.patch
rtc-rtc-88pm80x-remove-unnecessary-platform_set_drvdata.patch
drivers-rtc-rtc-v3020c-remove-redundant-goto.patch
drivers-rtc-interfacec-fix-checkpatch-errors.patch
drivers-rtc-rtc-at32ap700xc-fix-checkpatch-error.patch
drivers-rtc-rtc-at91rm9200c-include-linux-uaccessh.patch
drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch
drivers-rtc-rtc-davincic-fix-whitespace-warning.patch
drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch
drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch
drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch
drivers-rtc-rtc-ds3234c-fix-whitespace-issue.patch
drivers-rtc-rtc-fm3130c-fix-whitespace-related-issue.patch
drivers-rtc-rtc-m41t80c-fix-spacing-related-issue.patch
drivers-rtc-rtc-max6902c-remove-unwanted-spaces.patch
drivers-rtc-rtc-max77686c-remove-space-before-semicolon.patch
drivers-rtc-rtc-max8997c-remove-space-before-semicolon.patch
drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch
drivers-rtc-rtc-msm6242c-use-pr_warn.patch
drivers-rtc-rtc-mxcc-fix-checkpatch-error.patch
drivers-rtc-rtc-omapc-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch
drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch
drivers-rtc-rtc-rs5c313c-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch
drivers-rtc-rtc-v3020c-fix-spacing-issues.patch
drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch
drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch
rtc-rtc-88pm860x-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ab3100-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ab8500-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-at32ap700x-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-at91rm9200-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-at91sam9-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-au1xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-bfin-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-bq4802-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-coh901331-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-da9052-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-da9055-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-davinci-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-dm355evm-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ds1302-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ep93xx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-jz4740-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-lp8788-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-lpc32xx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ls1x-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-m48t59-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-max8925-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-max8998-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-mc13xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-msm6242-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-mxc-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-nuc900-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-pcap-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-pm8xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-s3c-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-sa1100-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-sh-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-spear-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-stmp3xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-twl-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-vr41xx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-vt8500-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-m48t86-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-puv3-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-rp5c01-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-tile-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch
rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch
rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot.patch
rtc-rtc-hid-sensor-time-add-support-for-milliseconds.patch

