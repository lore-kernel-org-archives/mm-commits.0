From: akpm@linux-foundation.org
Subject: + dmi-log-system-bios-and-board-information.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:19:55 -0700
Message-ID: <201010042319.o94NJtDs021737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757384Ab0JDXUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:20:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     dmi: log system, BIOS, and board information
has been added to the -mm tree.  Its filename is
     dmi-log-system-bios-and-board-information.patch

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
Subject: dmi: log system, BIOS, and board information
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Put basic system information in the dmesg log.  There are lots of dmesg
logs on the web, and it would be useful if they contained this information
for debugging platform problems.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   35 +++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff -puN drivers/firmware/dmi_scan.c~dmi-log-system-bios-and-board-information drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi-log-system-bios-and-board-information
+++ a/drivers/firmware/dmi_scan.c
@@ -2,6 +2,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/ctype.h>
 #include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/bootmem.h>
@@ -361,6 +362,36 @@ static void __init dmi_decode(const stru
 	}
 }
 
+static const char * __init dmi_printable_system_info(int field)
+{
+	const char *info, *p;
+
+	info = dmi_get_system_info(field);
+	if (!info)
+		return NULL;
+
+	for (p = info; *p; p++)
+		if (!isprint(*p))
+			return "<...>";
+
+	return info;
+}
+
+static void __init dmi_dump_ids(void)
+{
+	const char *board;
+
+	printk(KERN_DEBUG "DMI: system: %s %s",
+	       dmi_printable_system_info(DMI_SYS_VENDOR),
+	       dmi_printable_system_info(DMI_PRODUCT_NAME));
+	board = dmi_printable_system_info(DMI_BOARD_NAME);
+	if (board)
+		printk(KERN_CONT " (%s board)", board);
+	printk(KERN_CONT ", BIOS: %s %s\n",
+	       dmi_printable_system_info(DMI_BIOS_VERSION),
+	       dmi_printable_system_info(DMI_BIOS_DATE));
+}
+
 static int __init dmi_present(const char __iomem *p)
 {
 	u8 buf[15];
@@ -381,8 +412,10 @@ static int __init dmi_present(const char
 			       buf[14] >> 4, buf[14] & 0xF);
 		else
 			printk(KERN_INFO "DMI present.\n");
-		if (dmi_walk_early(dmi_decode) == 0)
+		if (dmi_walk_early(dmi_decode) == 0) {
+			dmi_dump_ids();
 			return 0;
+		}
 	}
 	return 1;
 }
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
dmi-log-system-bios-and-board-information.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch

