From: akpm@linux-foundation.org
Subject: + dmi-log-board-system-and-bios-information-v2.patch added to -mm tree
Date: Tue, 05 Oct 2010 12:32:26 -0700
Message-ID: <201010051932.o95JWQjI015230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047Ab0JETcq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 15:32:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     dmi: log board, system, and BIOS information
has been added to the -mm tree.  Its filename is
     dmi-log-board-system-and-bios-information-v2.patch

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
Subject: dmi: log board, system, and BIOS information
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Put basic system information in the dmesg log.  There are lots of dmesg
logs on the web, and it would be useful if they contained this information
for debugging platform problems.  "BOARD/PRODUCT" format copied from
show_regs_common(), which is used in the oops path.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff -puN drivers/firmware/dmi_scan.c~dmi-log-board-system-and-bios-information-v2 drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi-log-board-system-and-bios-information-v2
+++ a/drivers/firmware/dmi_scan.c
@@ -2,6 +2,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/ctype.h>
 #include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/bootmem.h>
@@ -361,6 +362,33 @@ static void __init dmi_decode(const stru
 	}
 }
 
+static void __init print_filtered(const char *info)
+{
+	const char *p;
+
+	if (!info)
+		return;
+
+	for (p = info; *p; p++)
+		if (isprint(*p))
+			printk(KERN_CONT "%c", *p);
+		else
+			printk(KERN_CONT "\\x%02x", *p & 0xff);
+}
+
+static void __init dmi_dump_ids(void)
+{
+	printk(KERN_DEBUG "DMI: ");
+	print_filtered(dmi_get_system_info(DMI_BOARD_NAME));
+	printk(KERN_CONT "/");
+	print_filtered(dmi_get_system_info(DMI_PRODUCT_NAME));
+	printk(KERN_CONT ", BIOS ");
+	print_filtered(dmi_get_system_info(DMI_BIOS_VERSION));
+	printk(KERN_CONT " ");
+	print_filtered(dmi_get_system_info(DMI_BIOS_DATE));
+	printk(KERN_CONT "\n");
+}
+
 static int __init dmi_present(const char __iomem *p)
 {
 	u8 buf[15];
@@ -381,8 +409,10 @@ static int __init dmi_present(const char
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
dmi-log-board-system-and-bios-information-v2.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch

