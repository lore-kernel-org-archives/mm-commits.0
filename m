From: akpm@linux-foundation.org
Subject: - mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs.patch removed from -mm tree
Date: Fri, 18 Jul 2008 16:24:23 -0700
Message-ID: <200807182324.m6INONCf004191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757623AbYGRX2L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 19:28:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, galak@kernel.crashing.org, jochen@scram.de, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     mpc8xxx_wdt: add support for MPC8xx watchdogs
has been removed from the -mm tree.  Its filename was
     mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mpc8xxx_wdt: add support for MPC8xx watchdogs
From: Anton Vorontsov <avorontsov@ru.mvista.com>

The mpc8xxx_wdt driver is using two registers: SWSRR to push magic
numbers, and SWCRR to control the watchdog.  Both registers are available
on the MPC8xx, and seem to have the same offsets and semantics as in
MPC83xx/MPC86xx watchdogs.  The only difference is prescale value.  So
this driver simply works on the MPC8xx CPUs.

One quirk is needed for the MPC8xx, though.  It has small prescale value
and slow CPU, so the watchdog resets board prior to the driver has time to
load.  To solve this we should split initialization in two steps: start
ping the watchdog early, and register the watchdog userspace interface
later.

MPC823 seem to be the first CPU in MPC8xx line, so we use fsl,mpc823-wdt
compatible matching.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Tested-by: Jochen Friedrich <jochen@scram.de>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Kconfig       |    3 +-
 drivers/watchdog/mpc8xxx_wdt.c |   44 +++++++++++++++++++++++--------
 2 files changed, 35 insertions(+), 12 deletions(-)

diff -puN drivers/watchdog/Kconfig~mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig~mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs
+++ a/drivers/watchdog/Kconfig
@@ -697,10 +697,11 @@ config 8xx_WDT
 
 config 8xxx_WDT
 	tristate "MPC8xxx Platform Watchdog Timer"
-	depends on PPC_83xx || PPC_86xx
+	depends on PPC_8xx || PPC_83xx || PPC_86xx
 	help
 	  This driver is for a SoC level watchdog that exists on some
 	  Freescale PowerPC processors. So far this driver supports:
+	  - MPC8xx watchdogs
 	  - MPC83xx watchdogs
 	  - MPC86xx watchdogs
 
diff -puN drivers/watchdog/mpc8xxx_wdt.c~mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs drivers/watchdog/mpc8xxx_wdt.c
--- a/drivers/watchdog/mpc8xxx_wdt.c~mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs
+++ a/drivers/watchdog/mpc8xxx_wdt.c
@@ -1,5 +1,5 @@
 /*
- * mpc8xxx_wdt.c - MPC83xx/MPC86xx watchdog userspace interface
+ * mpc8xxx_wdt.c - MPC8xx/MPC83xx/MPC86xx watchdog userspace interface
  *
  * Authors: Dave Updegraff <dave@cray.org>
  * 	    Kumar Gala <galak@kernel.crashing.org>
@@ -207,13 +207,6 @@ static int __devinit mpc8xxx_wdt_probe(s
 		goto err_unmap;
 	}
 
-	ret = misc_register(&mpc8xxx_wdt_miscdev);
-	if (ret) {
-		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
-		goto err_unmap;
-	}
-
 	/* Calculate the timeout in seconds */
 	if (prescale)
 		timeout_sec = (timeout * wdt_type->prescaler) / freq;
@@ -234,6 +227,7 @@ static int __devinit mpc8xxx_wdt_probe(s
 	return 0;
 err_unmap:
 	iounmap(wd_base);
+	wd_base = NULL;
 	return ret;
 }
 
@@ -261,6 +255,12 @@ static const struct of_device_id mpc8xxx
 			.hw_enabled = true,
 		},
 	},
+	{
+		.compatible = "fsl,mpc823-wdt",
+		.data = &(struct mpc8xxx_wdt_type) {
+			.prescaler = 0x800,
+		},
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, mpc8xxx_wdt_match);
@@ -275,20 +275,42 @@ static struct of_platform_driver mpc8xxx
 	},
 };
 
+/*
+ * We do wdt initialization in two steps: arch_initcall probes the wdt
+ * very early to start pinging the watchdog (misc devices are not yet
+ * available), and later module_init() just registers the misc device.
+ */
+static int __init mpc8xxx_wdt_init_late(void)
+{
+	int ret;
+
+	if (!wd_base)
+		return -ENODEV;
+
+	ret = misc_register(&mpc8xxx_wdt_miscdev);
+	if (ret) {
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+			WATCHDOG_MINOR, ret);
+		return ret;
+	}
+	return 0;
+}
+module_init(mpc8xxx_wdt_init_late);
+
 static int __init mpc8xxx_wdt_init(void)
 {
 	return of_register_platform_driver(&mpc8xxx_wdt_driver);
 }
+arch_initcall(mpc8xxx_wdt_init);
 
 static void __exit mpc8xxx_wdt_exit(void)
 {
 	of_unregister_platform_driver(&mpc8xxx_wdt_driver);
 }
