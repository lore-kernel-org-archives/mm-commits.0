From: akpm@linux-foundation.org
Subject: + at32ap700x_wdt-add-support-for-boot-status-and-add-fix-for-silicon-errata.patch added to -mm tree
Date: Fri, 02 Nov 2007 14:48:56 -0700
Message-ID: <200711022148.lA2LmuoU012546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52765 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754121AbXKBVtJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 17:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hcegtvedt@atmel.com, wim@iguana.be


The patch titled
     at32ap700x_wdt: add support for boot status and add fix for silicon errata
has been added to the -mm tree.  Its filename is
     at32ap700x_wdt-add-support-for-boot-status-and-add-fix-for-silicon-errata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: at32ap700x_wdt: add support for boot status and add fix for silicon errata
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

This patch enables the watchdog to read out the reset cause after a boot
and provide this to the user.

The driver will now also return -EIO if probed when booting from a watchdog
reset.  This is due to a silicon errata in the AT32AP700x devices.

Detailed description and work-arounds can be found in the errata section of the
datasheet avilable from
http://www.atmel.com/dyn/products/datasheets.asp?family_id=682

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/at32ap700x_wdt.c |   69 ++++++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 4 deletions(-)

diff -puN drivers/watchdog/at32ap700x_wdt.c~at32ap700x_wdt-add-support-for-boot-status-and-add-fix-for-silicon-errata drivers/watchdog/at32ap700x_wdt.c
--- a/drivers/watchdog/at32ap700x_wdt.c~at32ap700x_wdt-add-support-for-boot-status-and-add-fix-for-silicon-errata
+++ a/drivers/watchdog/at32ap700x_wdt.c
@@ -6,6 +6,19 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
+ *
+ *
+ * Errata: WDT Clear is blocked after WDT Reset
+ *
+ * A watchdog timer event will, after reset, block writes to the WDT_CLEAR
+ * register, preventing the program to clear the next Watchdog Timer Reset.
+ *
+ * If you still want to use the WDT after a WDT reset a small code can be
+ * insterted at the startup checking the AVR32_PM.rcause register for WDT reset
+ * and use a GPIO pin to reset the system. This method requires that one of the
+ * GPIO pins are available and connected externally to the RESET_N pin. After
+ * the GPIO pin has pulled down the reset line the GPIO will be reset and leave
+ * the pin tristated with pullup.
  */
 
 #include <linux/init.h>
@@ -44,6 +57,13 @@ MODULE_PARM_DESC(nowayout, "Watchdog can
 
 #define WDT_CLR			0x04
 
+#define WDT_RCAUSE		0x10
+#define WDT_RCAUSE_POR		   0
+#define WDT_RCAUSE_EXT		   2
+#define WDT_RCAUSE_WDT		   3
+#define WDT_RCAUSE_JTAG		   4
+#define WDT_RCAUSE_SERP		   5
+
 #define WDT_BIT(name)		(1 << WDT_##name)
 #define WDT_BF(name, value)	((value) << WDT_##name)
 
@@ -56,6 +76,7 @@ struct wdt_at32ap700x {
 	void __iomem		*regs;
 	spinlock_t		io_lock;
 	int			timeout;
+	int			boot_status;
 	unsigned long		users;
 	struct miscdevice	miscdev;
 };
@@ -126,7 +147,7 @@ static int at32_wdt_close(struct inode *
 		at32_wdt_stop();
 	} else {
 		dev_dbg(wdt->miscdev.parent,
-			"Unexpected close, not stopping watchdog!\n");
+			"unexpected close, not stopping watchdog!\n");
 		at32_wdt_pat();
 	}
 	clear_bit(1, &wdt->users);
@@ -154,6 +175,33 @@ static int at32_wdt_settimeout(int time)
 	return 0;
 }
 
+/*
+ * Get the watchdog status.
+ */
+static int at32_wdt_get_status(void)
+{
+	int rcause;
+	int status = 0;
+
+	rcause = wdt_readl(wdt, RCAUSE);
+
+	switch (rcause) {
+	case WDT_BIT(RCAUSE_EXT):
+		status = WDIOF_EXTERN1;
+		break;
+	case WDT_BIT(RCAUSE_WDT):
+		status = WDIOF_CARDRESET;
+		break;
+	case WDT_BIT(RCAUSE_POR):  /* fall through */
+	case WDT_BIT(RCAUSE_JTAG): /* fall through */
+	case WDT_BIT(RCAUSE_SERP): /* fall through */
+	default:
+		break;
+	}
+
+	return status;
+}
+
 static struct watchdog_info at32_wdt_info = {
 	.identity	= "at32ap700x watchdog",
 	.options	= WDIOF_SETTIMEOUT |
@@ -194,10 +242,12 @@ static int at32_wdt_ioctl(struct inode *
 	case WDIOC_GETTIMEOUT:
 		ret = put_user(wdt->timeout, p);
 		break;
-	case WDIOC_GETSTATUS: /* fall through */
-	case WDIOC_GETBOOTSTATUS:
+	case WDIOC_GETSTATUS:
 		ret = put_user(0, p);
 		break;
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(wdt->boot_status, p);
+		break;
 	case WDIOC_SETOPTIONS:
 		ret = get_user(time, p);
 		if (ret)
@@ -282,8 +332,19 @@ static int __init at32_wdt_probe(struct 
 		dev_dbg(&pdev->dev, "could not map I/O memory\n");
 		goto err_free;
 	}
+
 	spin_lock_init(&wdt->io_lock);
-	wdt->users = 0;
+	wdt->boot_status = at32_wdt_get_status();
+
+	/* Work-around for watchdog silicon errata. */
+	if (wdt->boot_status & WDIOF_CARDRESET) {
+		dev_info(&pdev->dev, "CPU must be reset with external "
+				"reset or POR due to silicon errata.\n");
+		ret = -EIO;
+		goto err_iounmap;
+	} else {
+		wdt->users = 0;
+	}
 	wdt->miscdev.minor = WATCHDOG_MINOR;
 	wdt->miscdev.name = "watchdog";
 	wdt->miscdev.fops = &at32_wdt_fops;
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

git-avr32.patch
git-mtd.patch
at32ap700x_wdt-add-support-for-boot-status-and-add-fix-for-silicon-errata.patch
