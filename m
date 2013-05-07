From: akpm@linux-foundation.org
Subject: [merged] dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-formats-into-a-buffer.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:10 -0700
Message-ID: <20130507174710.9C4DB31C284@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:46464 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab3EGRrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:47:12 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so85067qec.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:47:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, bhelgaas@google.com, davem@davemloft.net, fengguang.wu@intel.com, heiko.carstens@de.ibm.com, jesper.nilsson@axis.com, sam@ravnborg.org, schwidefsky@de.ibm.com, vapier@gentoo.org, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dmi: morph dmi_dump_ids() into dmi_format_ids() which formats into a buffer
has been removed from the -mm tree.  Its filename was
     dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-formats-into-a-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: dmi: morph dmi_dump_ids() into dmi_format_ids() which formats into a buffer

We're gonna use DMI identification for other purposes too.  Morph
dmi_dump_ids() which is used to print DMI identification as a debug
message during boot into dmi_format_ids() which formats the same
information sans the leading "DMI:" tag into a string buffer.

dmi_present() is updated to format the information into dmi_ids_string[]
using the new function and print it with "DMI:" prefix.  dmi_ids_string[]
will be used for another purpose by a future patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   44 ++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-formats-into-a-buffer drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-formats-into-a-buffer
+++ a/drivers/firmware/dmi_scan.c
@@ -22,6 +22,9 @@ static u16 __initdata dmi_ver;
  */
 static int dmi_initialized;
 
+/* DMI system identification string used during boot */
+static char dmi_ids_string[128] __initdata;
+
 static const char * __init dmi_string_nosave(const struct dmi_header *dm, u8 s)
 {
 	const u8 *bp = ((u8 *) dm) + dm->length;
@@ -376,38 +379,44 @@ static void __init dmi_decode(const stru
 	}
 }
 
-static void __init print_filtered(const char *info)
+static int __init print_filtered(char *buf, size_t len, const char *info)
 {
+	int c = 0;
 	const char *p;
 
 	if (!info)
-		return;
+		return c;
 
 	for (p = info; *p; p++)
 		if (isprint(*p))
-			printk(KERN_CONT "%c", *p);
+			c += scnprintf(buf + c, len - c, "%c", *p);
 		else
-			printk(KERN_CONT "\\x%02x", *p & 0xff);
+			c += scnprintf(buf + c, len - c, "\\x%02x", *p & 0xff);
+	return c;
 }
 
-static void __init dmi_dump_ids(void)
+static void __init dmi_format_ids(char *buf, size_t len)
 {
+	int c = 0;
 	const char *board;	/* Board Name is optional */
 
-	printk(KERN_DEBUG "DMI: ");
-	print_filtered(dmi_get_system_info(DMI_SYS_VENDOR));
-	printk(KERN_CONT " ");
-	print_filtered(dmi_get_system_info(DMI_PRODUCT_NAME));
+	c += print_filtered(buf + c, len - c,
+			    dmi_get_system_info(DMI_SYS_VENDOR));
+	c += scnprintf(buf + c, len - c, " ");
+	c += print_filtered(buf + c, len - c,
+			    dmi_get_system_info(DMI_PRODUCT_NAME));
+
 	board = dmi_get_system_info(DMI_BOARD_NAME);
 	if (board) {
-		printk(KERN_CONT "/");
-		print_filtered(board);
+		c += scnprintf(buf + c, len - c, "/");
+		c += print_filtered(buf + c, len - c, board);
 	}
-	printk(KERN_CONT ", BIOS ");
-	print_filtered(dmi_get_system_info(DMI_BIOS_VERSION));
-	printk(KERN_CONT " ");
-	print_filtered(dmi_get_system_info(DMI_BIOS_DATE));
-	printk(KERN_CONT "\n");
+	c += scnprintf(buf + c, len - c, ", BIOS ");
+	c += print_filtered(buf + c, len - c,
+			    dmi_get_system_info(DMI_BIOS_VERSION));
+	c += scnprintf(buf + c, len - c, " ");
+	c += print_filtered(buf + c, len - c,
+			    dmi_get_system_info(DMI_BIOS_DATE));
 }
 
 static int __init dmi_present(const char __iomem *p)
@@ -431,7 +440,8 @@ static int __init dmi_present(const char
 				pr_info("Legacy DMI %d.%d present.\n",
 				       dmi_ver >> 8, dmi_ver & 0xFF);
 			}
-			dmi_dump_ids();
+			dmi_format_ids(dmi_ids_string, sizeof(dmi_ids_string));
+			printk(KERN_DEBUG "DMI: %s\n", dmi_ids_string);
 			return 0;
 		}
 	}
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch

