From: akpm@linux-foundation.org
Subject: - dev_vdbg-available-with-dverbose_debug.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:11:11 -0700
Message-ID: <200707192011.l6JKBB8N020746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759813AbXGSUQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     dev_vdbg(), available with -DVERBOSE_DEBUG
has been removed from the -mm tree.  Its filename was
     dev_vdbg-available-with-dverbose_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dev_vdbg(), available with -DVERBOSE_DEBUG
From: David Brownell <david-b@pacbell.net>

This defines a dev_vdbg() call, which is enabled with -DVERBOSE_DEBUG. 
When enabled, dev_vdbg() acts just like dev_dbg().  When disabled, it is a
NOP ...  just like dev_dbg() without -DDEBUG.  The specific code was moved
out of a USB patch, but lots of drivers have similar support.

That is, code can now be written to use an additional level of debug
output, selected at compile time.  Many driver authors have found this
idiom to be very useful.  A typical usage model is for "normal" debug
messages to focus on fault paths and not be very "chatty", so that those
messages can be left on during normal operation without much of a
performance or syslog load.  On the other hand "verbose" messages would be
noisy enough that they wouldn't normally be enabled; they might even affect
timings enough to change system or driver behavior.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/driver.c |    7 -------
 include/linux/device.h    |   10 ++++++++++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff -puN drivers/usb/core/driver.c~dev_vdbg-available-with-dverbose_debug drivers/usb/core/driver.c
--- a/drivers/usb/core/driver.c~dev_vdbg-available-with-dverbose_debug
+++ a/drivers/usb/core/driver.c
@@ -29,13 +29,6 @@
 #include "hcd.h"
 #include "usb.h"
 
-#define VERBOSE_DEBUG	0
-
-#if VERBOSE_DEBUG
-#define dev_vdbg	dev_dbg
-#else
-#define dev_vdbg(dev, fmt, args...)	do { } while (0)
-#endif
 
 #ifdef CONFIG_HOTPLUG
 
diff -puN include/linux/device.h~dev_vdbg-available-with-dverbose_debug include/linux/device.h
--- a/include/linux/device.h~dev_vdbg-available-with-dverbose_debug
+++ a/include/linux/device.h
@@ -572,6 +572,16 @@ dev_dbg(struct device * dev, const char 
 }
 #endif
 
+#ifdef VERBOSE_DEBUG
+#define dev_vdbg	dev_dbg
+#else
+static inline int __attribute__ ((format (printf, 2, 3)))
+dev_vdbg(struct device * dev, const char * fmt, ...)
+{
+	return 0;
+}
+#endif
+
 #define dev_err(dev, format, arg...)		\
 	dev_printk(KERN_ERR , dev , format , ## arg)
 #define dev_info(dev, format, arg...)		\
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-leds.patch
git-mmc.patch
git-mtd.patch
git-backlight.patch
acpi-add-acpi_pm_device_sleep_state-helper-routine.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
