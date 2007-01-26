From: akpm@osdl.org
Subject: + acpi-updates-rtc-cmos-device-platform_data.patch added to -mm tree
Date: Thu, 25 Jan 2007 21:49:10 -0800
Message-ID: <200701260549.l0Q5nA2L008678@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46827 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030781AbXAZFtR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 00:49:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, bjorn.helgaas@hp.com, dbrownell@users.sourceforge.net, len.brown@intel.com


The patch titled
     ACPI: updates rtc-cmos device platform_data
has been added to the -mm tree.  Its filename is
     acpi-updates-rtc-cmos-device-platform_data.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: updates rtc-cmos device platform_data
From: David Brownell <david-b@pacbell.net>

Update ACPI to export its RTC extension information through platform_data
to the PNPACPI or platform bus device node used on the system being set up.

This will need to be updated later to provide a firmware hook to handle
system suspend with an alarm pending.

Len notes that "Eventually we may bundle ACPI/PNP/PNPACPI..." but if/when
that happens, ACPI can simplify this without my help.

And until it does, the separate patch creating a platform_device (on all
X86_PC systems, even without ACPI) will be needed.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Len Brown <len.brown@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/glue.c |   89 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff -puN drivers/acpi/glue.c~acpi-updates-rtc-cmos-device-platform_data drivers/acpi/glue.c
--- a/drivers/acpi/glue.c~acpi-updates-rtc-cmos-device-platform_data
+++ a/drivers/acpi/glue.c
@@ -241,3 +241,92 @@ static int __init init_acpi_device_notif
 }
 
 arch_initcall(init_acpi_device_notify);
+
+
+#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE)
+
+/* Every ACPI platform has a mc146818 compatible "cmos rtc".  Here we find
+ * its device node and pass extra config data.  This helps its driver use
+ * capabilities that the now-obsolete mc146818 didn't have, and informs it
+ * that this board's RTC is wakeup-capable (per ACPI spec).
+ */
+#include <linux/mc146818rtc.h>
+
+static struct cmos_rtc_board_info rtc_info;
+
+
+#ifdef CONFIG_PNPACPI
+
+/* PNP devices are registered in a subsys_initcall();
+ * ACPI specifies the PNP IDs to use.
+ */
+#include <linux/pnp.h>
+
+static int __init pnp_match(struct device *dev, void *data)
+{
+	static const char *ids[] = { "PNP0b00", "PNP0b01", "PNP0b02", };
+	struct pnp_dev *pnp = to_pnp_dev(dev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ids); i++) {
+		if (compare_pnp_id(pnp->id, ids[i]) != 0)
+			return 1;
+	}
+	return 0;
+}
+
+static struct device *__init get_rtc_dev(void)
+{
+	return bus_find_device(&pnp_bus_type, NULL, NULL, pnp_match);
+}
+
+#else
+
+/* We expect non-PNPACPI platforms to register an RTC device, usually
+ * at or near arch_initcall().  That also helps for example PCs that
+ * aren't configured with ACPI (where this code wouldn't run, but the
+ * RTC would still be available).  The device name matches the driver;
+ * that's how the platform bus works.
+ */
+#include <linux/platform_device.h>
+
+static int __init platform_match(struct device *dev, void *data)
+{
+	struct platform_device	*pdev;
+
+	pdev = container_of(dev, struct platform_device, dev);
+	return strcmp(pdev->name, "rtc_cmos") == 0;
+}
+
+static struct device *__init get_rtc_dev(void)
+{
+	return bus_find_device(&platform_bus_type, NULL, NULL, platform_match);
+}
+
+#endif
+
+static int __init acpi_rtc_init(void)
+{
+	struct device *dev = get_rtc_dev();
+
+	if (dev) {
+		rtc_info.rtc_day_alarm = acpi_gbl_FADT->day_alrm;
+		rtc_info.rtc_mon_alarm = acpi_gbl_FADT->mon_alrm;
+		rtc_info.rtc_century = acpi_gbl_FADT->century;
+
+		/* NOTE:  acpi_gbl_FADT->rtcs4 is NOT currently useful */
+
+		dev->platform_data = &rtc_info;
+
+		/* RTC always wakes from S1/S2/S3, and often S4/STD */
+		device_init_wakeup(dev, 1);
+
+		put_device(dev);
+	} else
+		pr_debug("ACPI: RTC unavailable?\n");
+	return 0;
+}
+/* do this between RTC subsys_initcall() and rtc_cmos driver_initcall() */
+fs_initcall(acpi_rtc_init);
+
+#endif
_

Patches currently in -mm which might be from david-b@pacbell.net are

rtc-sh-act-on-rtc_wkalrmenabled-when-setting-an-alarm.patch
acpi-updates-rtc-cmos-device-platform_data.patch
git-dvb.patch
git-mmc.patch
8250-make-probing-for-txen-bug-a-config-option.patch
pnp-export-pnp_bus_type.patch
rtc-framework-driver-for-cmos-rtcs.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
spi-controller-driver-for-omap-microwire-update.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
