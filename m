From: akpm@linux-foundation.org
Subject: + rtc-cmos-exports-nvram-in-sysfs.patch added to -mm tree
Date: Fri, 09 Nov 2007 17:28:45 -0800
Message-ID: <200711100128.lAA1Sje6009149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60624 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753623AbXKJB3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 20:29:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, bjorn.helgaas@hp.com, dbrownell@users.sourceforge.net


The patch titled
     rtc-cmos: export nvram in sysfs
has been added to the -mm tree.  Its filename is
     rtc-cmos-exports-nvram-in-sysfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc-cmos: export nvram in sysfs
From: David Brownell <david-b@pacbell.net>

This makes rtc-cmos export its NVRAM, like several other RTC drivers.

It still works within the limits of the current CMOS_READ/CMOS_WRITE calls,
which don't understand how to access multiple register banks.  The primary
impact of that limitation is that Linux can't access the uppermost 128
bytes of NVRAM on many systems.

Note that this isn't aiming to be a drop-in replacement for the legacy
/dev/nvram support.  (Presumably that has real users, and isn't just
getting carried forward automatically?) Userspace handles more work:

 - When userspace code updates NVRAM, that will need to include
   updating any platform-specific checksums that may apply.

 - No /proc/driver/nvram file will parse and display NVRAM data
   according to whichever boot firmware your board expects.

Also minor pnp-related updates: update a comment, remove dead code.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |  129 +++++++++++++++++++++++++++++++++++----
 1 file changed, 117 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-exports-nvram-in-sysfs drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-exports-nvram-in-sysfs
+++ a/drivers/rtc/rtc-cmos.c
@@ -393,6 +393,80 @@ static const struct rtc_class_ops cmos_r
 
 /*----------------------------------------------------------------*/
 
+/*
+ * All these chips have at least 64 bytes of address space, shared by
+ * RTC registers and NVRAM.  Most of those bytes of NVRAM are used
+ * by boot firmware.  Modern chips have 128 or 256 bytes.
+ */
+
+#define NVRAM_OFFSET	(RTC_REG_D + 1)
+
+static ssize_t
+cmos_nvram_read(struct kobject *kobj, struct bin_attribute *attr,
+		char *buf, loff_t off, size_t count)
+{
+	int	retval;
+
+	if (unlikely(off >= attr->size))
+		return 0;
+	if ((off + count) > attr->size)
+		count = attr->size - off;
+
+	spin_lock_irq(&rtc_lock);
+	for (retval = 0, off += NVRAM_OFFSET; count--; retval++, off++)
+		*buf++ = CMOS_READ(off);
+	spin_unlock_irq(&rtc_lock);
+
+	return retval;
+}
+
+static ssize_t
+cmos_nvram_write(struct kobject *kobj, struct bin_attribute *attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct cmos_rtc	*cmos;
+	int		retval;
+
+	cmos = dev_get_drvdata(container_of(kobj, struct device, kobj));
+	if (unlikely(off >= attr->size))
+		return -EFBIG;
+	if ((off + count) > attr->size)
+		count = attr->size - off;
+
+	/* NOTE:  on at least PCs and Ataris, the boot firmware uses a
+	 * checksum on part of the NVRAM data.  That's currently ignored
+	 * here.  If userspace is smart enough to know what fields of
+	 * NVRAM to update, updating checksums is also part of its job.
+	 */
+	spin_lock_irq(&rtc_lock);
+	for (retval = 0, off += NVRAM_OFFSET; count--; retval++, off++) {
+		/* don't trash RTC registers */
+		if (off == cmos->day_alrm
+				|| off == cmos->mon_alrm
+				|| off == cmos->century)
+			buf++;
+		else
+			CMOS_WRITE(*buf++, off);
+	}
+	spin_unlock_irq(&rtc_lock);
+
+	return retval;
+}
+
+static struct bin_attribute nvram = {
+	.attr = {
+		.name	= "nvram",
+		.mode	= S_IRUGO | S_IWUSR,
+		.owner	= THIS_MODULE,
+	},
+
+	.read	= cmos_nvram_read,
+	.write	= cmos_nvram_write,
+	/* size gets set up later */
+};
+
+/*----------------------------------------------------------------*/
+
 static struct cmos_rtc	cmos_rtc;
 
 static irqreturn_t cmos_interrupt(int irq, void *p)
@@ -412,11 +486,9 @@ static irqreturn_t cmos_interrupt(int ir
 }
 
 #ifdef	CONFIG_PNP
-#define	is_pnp()	1
 #define	INITSECTION
 
 #else
-#define	is_pnp()	0
 #define	INITSECTION	__init
 #endif
 
@@ -426,6 +498,7 @@ cmos_do_probe(struct device *dev, struct
 	struct cmos_rtc_board_info	*info = dev->platform_data;
 	int				retval = 0;
 	unsigned char			rtc_control;
+	unsigned			address_space;
 
 	/* there can be only one ... */
 	if (cmos_rtc.dev)
@@ -450,15 +523,36 @@ cmos_do_probe(struct device *dev, struct
 	cmos_rtc.irq = rtc_irq;
 	cmos_rtc.iomem = ports;
 
+	/* Heuristic to deduce NVRAM size ... do what the legacy NVRAM
+	 * driver did, but don't reject unknown configs.   Old hardware
+	 * won't address 128 bytes, and for now we ignore the way newer
+	 * chips can address 256 bytes (using two more i/o ports).
+	 */
+#if	defined(CONFIG_ATARI)
+	address_space = 64;
+#elif defined(__i386__) || defined(__x86_64__) || defined(__arm__)
+	address_space = 128;
+#else
+#warning Assuming 128 bytes of RTC+NVRAM address space, not 64 bytes.
+	address_space = 128;
+#endif
+
 	/* For ACPI systems extension info comes from the FADT.  On others,
 	 * board specific setup provides it as appropriate.  Systems where
 	 * the alarm IRQ isn't automatically a wakeup IRQ (like ACPI, and
 	 * some almost-clones) can provide hooks to make that behave.
+	 *
+	 * Note that ACPI doesn't preclude putting these registers into
+	 * "extended" areas of the chip, including some that we won't yet
+	 * expect CMOS_READ and friends to handle.
 	 */
 	if (info) {
-		cmos_rtc.day_alrm = info->rtc_day_alarm;
-		cmos_rtc.mon_alrm = info->rtc_mon_alarm;
-		cmos_rtc.century = info->rtc_century;
+		if (info->rtc_day_alarm && info->rtc_day_alarm < 128)
+			cmos_rtc.day_alrm = info->rtc_day_alarm;
+		if (info->rtc_mon_alarm && info->rtc_mon_alarm < 128)
+			cmos_rtc.mon_alrm = info->rtc_mon_alarm;
+		if (info->rtc_century && info->rtc_century < 128)
+			cmos_rtc.century = info->rtc_century;
 
 		if (info->wake_on && info->wake_off) {
 			cmos_rtc.wake_on = info->wake_on;
@@ -518,10 +612,13 @@ cmos_do_probe(struct device *dev, struct
 		goto cleanup1;
 	}
 
-	/* REVISIT optionally make 50 or 114 bytes NVRAM available,
-	 * like rtc-ds1553, rtc-ds1742 ... this will often include
-	 * registers for century, and day/month alarm.
-	 */
+	/* export at least the first block of NVRAM */
+	nvram.size = address_space - NVRAM_OFFSET;
+	retval = sysfs_create_bin_file(&dev->kobj, &nvram);
+	if (retval < 0) {
+		dev_dbg(dev, "can't create nvram file? %d\n", retval);
+		goto cleanup2;
+	}
 
 	pr_info("%s: alarms up to one %s%s\n",
 			cmos_rtc.rtc->dev.bus_id,
@@ -536,6 +633,9 @@ cmos_do_probe(struct device *dev, struct
 
 	return 0;
 
+cleanup2:
+	if (is_valid_irq(rtc_irq))
+		free_irq(rtc_irq, cmos_rtc.rtc);
 cleanup1:
 	cmos_rtc.dev = NULL;
 	rtc_device_unregister(cmos_rtc.rtc);
@@ -563,6 +663,8 @@ static void __exit cmos_do_remove(struct
 
 	cmos_do_shutdown();
 
+	sysfs_remove_bin_file(&dev->kobj, &nvram);
+
 	if (is_valid_irq(cmos->irq))
 		free_irq(cmos->irq, cmos->rtc);
 
@@ -659,9 +761,12 @@ static int cmos_resume(struct device *de
 
 /*----------------------------------------------------------------*/
 
-/* The "CMOS" RTC normally lives on the platform_bus.  On ACPI systems,
- * the device node will always be created as a PNPACPI device.  Plus
- * pre-ACPI PCs probably list it in the PNPBIOS tables.
+/* On non-x86 systems, a "CMOS" RTC lives most naturally on platform_bus.
+ * ACPI systems always list these as PNPACPI devices, and pre-ACPI PCs
+ * probably list them in similar PNPBIOS tables; so PNP is more common.
+ *
+ * We don't use legacy "poke at the hardware" probing.  Ancient PCs that
+ * predate even PNPBIOS should set up platform_bus devices.
  */
 
 #ifdef	CONFIG_PNP
_

Patches currently in -mm which might be from david-b@pacbell.net are

rtc_hctosys-expects-rtcs-in-utc-doc.patch
rtcs-handle-nvram-better.patch
rtc-ds1307-exports-nvram.patch
rtc-tweak-driver-documentation-for-rtc-periodic.patch
spi-fix-double-free-on-spi_unregister_master.patch
spi-fix-error-paths-on-txx9spi_probe.patch
atmel_serial-build-warnings-begone.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
git-arm-master.patch
usb-s3c2410_udc-minor-irq-handler-cleanups.patch
rtc-release-correct-region-in-error-path.patch
rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
tle62x0-driver-stops-ignoring-read-errors.patch
rtc-convert-mutex-to-bitfield.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-at25-driver-is-for-eeprom-not-flash.patch
spi-use-mutex-not-semaphore.patch
blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch
blackfin-spi-driver-use-void-__iomem-for-regs_base.patch
blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch
blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
