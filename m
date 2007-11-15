From: akpm@linux-foundation.org
Subject: - rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:12 -0800
Message-ID: <200711152110.lAFLACY5015535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57876 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932687AbXKOVSD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:18:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, a.zummo@towertech.it, david-b@pacbell.net, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     rtc: fall back to requesting only the ports we actually use
has been removed from the -mm tree.  Its filename was
     rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: fall back to requesting only the ports we actually use
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Firmware like PNPBIOS or ACPI can report the address space consumed by the
RTC.  The actual space consumed may be less than the size (RTC_IO_EXTENT)
assumed by the RTC driver.

The PNP core doesn't request resources yet, but I'd like to make it do so. 
If/when it does, the RTC_IO_EXTENT request may fail, which prevents the RTC
driver from loading.

Since we only use the RTC index and data registers at RTC_PORT(0) and
RTC_PORT(1), we can fall back to requesting just enough space for those.

If the PNP core requests resources, this results in typical I/O port usage
like this:

    0070-0073 : 00:06		<-- PNP device 00:06 responds to 70-73
      0070-0071 : rtc		<-- RTC driver uses only 70-71

instead of the current:

    0070-0077 : rtc		<-- RTC_IO_EXTENT == 8

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c          |   36 ++++++++++++++++++++++++++++------
 include/linux/mc146818rtc.h |    3 ++
 2 files changed, 33 insertions(+), 6 deletions(-)

diff -puN drivers/char/rtc.c~rtc-fallback-to-requesting-only-the-ports-we-actually-use drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-fallback-to-requesting-only-the-ports-we-actually-use
+++ a/drivers/char/rtc.c
@@ -918,12 +918,29 @@ static const struct file_operations rtc_
 };
 #endif
 
+static resource_size_t rtc_size;
+
+static struct resource * __init rtc_request_region(resource_size_t size)
+{
+	struct resource *r;
+
+	if (RTC_IOMAPPED)
+		r = request_region(RTC_PORT(0), size, "rtc");
+	else
+		r = request_mem_region(RTC_PORT(0), size, "rtc");
+
+	if (r)
+		rtc_size = size;
+
+	return r;
+}
+
 static void rtc_release_region(void)
 {
 	if (RTC_IOMAPPED)
-		release_region(RTC_PORT(0), RTC_IO_EXTENT);
+		release_region(RTC_PORT(0), rtc_size);
 	else
-		release_mem_region(RTC_PORT(0), RTC_IO_EXTENT);
+		release_mem_region(RTC_PORT(0), rtc_size);
 }
 
 static int __init rtc_init(void)
@@ -976,10 +993,17 @@ found:
 	}
 no_irq:
 #else
-	if (RTC_IOMAPPED)
-		r = request_region(RTC_PORT(0), RTC_IO_EXTENT, "rtc");
-	else
-		r = request_mem_region(RTC_PORT(0), RTC_IO_EXTENT, "rtc");
+	r = rtc_request_region(RTC_IO_EXTENT);
+
+	/*
+	 * If we've already requested a smaller range (for example, because
+	 * PNPBIOS or ACPI told us how the device is configured), the request
+	 * above might fail because it's too big.
+	 *
+	 * If so, request just the range we actually use.
+	 */
+	if (!r)
+		r = rtc_request_region(RTC_IO_EXTENT_USED);
 	if (!r) {
 #ifdef RTC_IRQ
 		rtc_has_irq = 0;
diff -puN include/linux/mc146818rtc.h~rtc-fallback-to-requesting-only-the-ports-we-actually-use include/linux/mc146818rtc.h
--- a/include/linux/mc146818rtc.h~rtc-fallback-to-requesting-only-the-ports-we-actually-use
+++ a/include/linux/mc146818rtc.h
@@ -109,8 +109,11 @@ struct cmos_rtc_board_info {
 #ifndef ARCH_RTC_LOCATION	/* Override by <asm/mc146818rtc.h>? */
 
 #define RTC_IO_EXTENT	0x8
+#define RTC_IO_EXTENT_USED	0x2
 #define RTC_IOMAPPED	1	/* Default to I/O mapping. */
 
+#else
+#define RTC_IO_EXTENT_USED      RTC_IO_EXTENT
 #endif /* ARCH_RTC_LOCATION */
 
 #endif /* _MC146818RTC_H */
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
serial-keep-the-dtr-setting-for-serial-console.patch
rtc-cmos-exports-nvram-in-sysfs.patch
pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
dont-touch-fs_struct-in-drivers.patch
