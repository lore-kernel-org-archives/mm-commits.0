From: akpm@linux-foundation.org
Subject: + via-rhine-set-avoid_d3-for-broken-bioses.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:25:06 -0800
Message-ID: <200703070125.l271P6ov015461@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42035 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161142AbXCGBZK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:25:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rl@hellgate.ch


The patch titled
     via-rhine: set avoid_D3 for broken BIOSes
has been added to the -mm tree.  Its filename is
     via-rhine-set-avoid_d3-for-broken-bioses.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: via-rhine: set avoid_D3 for broken BIOSes
From: Roger Luethi <rl@hellgate.ch>

This patch sets avoid_D3 for BIOSes known to be broken.  Said BIOSes fail
at PXE boot if the chip is in power state D3.

Signed-off-by: Roger Luethi <rl@hellgate.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/via-rhine.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff -puN drivers/net/via-rhine.c~via-rhine-set-avoid_d3-for-broken-bioses drivers/net/via-rhine.c
--- a/drivers/net/via-rhine.c~via-rhine-set-avoid_d3-for-broken-bioses
+++ a/drivers/net/via-rhine.c
@@ -30,8 +30,8 @@
 */
 
 #define DRV_NAME	"via-rhine"
-#define DRV_VERSION	"1.4.2"
-#define DRV_RELDATE	"Sept-11-2006"
+#define DRV_VERSION	"1.4.3"
+#define DRV_RELDATE	"2007-03-06"
 
 
 /* A few user-configurable values.
@@ -105,6 +105,7 @@ static const int multicast_filter_limit 
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
+#include <linux/dmi.h>
 
 /* These identify the driver base version and may not be removed. */
 static char version[] __devinitdata =
@@ -1995,6 +1996,23 @@ static struct pci_driver rhine_driver = 
 	.shutdown =	rhine_shutdown,
 };
 
+static struct dmi_system_id __initdata rhine_dmi_table[] = {
+	{
+		.ident = "EPIA-M",
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "Award Software International, Inc."),
+			DMI_MATCH(DMI_BIOS_VERSION, "6.00 PG"),
+		},
+	},
+	{
+		.ident = "KV7",
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
+			DMI_MATCH(DMI_BIOS_VERSION, "6.00 PG"),
+		},
+	},
+	{ NULL }
+};
 
 static int __init rhine_init(void)
 {
@@ -2002,6 +2020,16 @@ static int __init rhine_init(void)
 #ifdef MODULE
 	printk(version);
 #endif
+	if (dmi_check_system(rhine_dmi_table)) {
+		/* these BIOSes fail at PXE boot if chip is in D3 */
+		avoid_D3 = 1;
+		printk(KERN_WARNING "%s: Broken BIOS detected, avoid_D3 "
+				    "enabled.\n",
+		       DRV_NAME);
+	}
+	else if (avoid_D3)
+		printk(KERN_INFO "%s: avoid_D3 set.\n", DRV_NAME);
+
 	return pci_register_driver(&rhine_driver);
 }
 
_

Patches currently in -mm which might be from rl@hellgate.ch are

via-rhine-set-avoid_d3-for-broken-bioses.patch
