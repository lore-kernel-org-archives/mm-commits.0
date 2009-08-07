From: akpm@linux-foundation.org
Subject: [merged] input-more-i8042-reset-quirks-for-msi-wind-clone-netbooks.patch removed from -mm tree
Date: Fri, 07 Aug 2009 12:17:05 -0700
Message-ID: <200908071917.n77JH5UW000413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933090AbZHGTTo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2009 15:19:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan.i.li@intel.com, alan@lxorguk.ukuu.org.uk, dtor@mail.ru, mjg59@srcf.ucam.org, mm-commits@vger.kernel.org


The patch titled
     input: more i8042-reset quirks for MSI Wind-clone netbooks
has been removed from the -mm tree.  Its filename was
     input-more-i8042-reset-quirks-for-msi-wind-clone-netbooks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: more i8042-reset quirks for MSI Wind-clone netbooks
From: Yan Li <yan.i.li@intel.com>

When testing Moblin on various netbooks, we've got reports that many MSI
Wind clones need the i8042 reset quirks for the keyboard and/or touchpad's
proper function.

Signed-off-by: Yan Li <yan.i.li@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042-x86ia64io.h |   28 ++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN drivers/input/serio/i8042-x86ia64io.h~input-more-i8042-reset-quirks-for-msi-wind-clone-netbooks drivers/input/serio/i8042-x86ia64io.h
--- a/drivers/input/serio/i8042-x86ia64io.h~input-more-i8042-reset-quirks-for-msi-wind-clone-netbooks
+++ a/drivers/input/serio/i8042-x86ia64io.h
@@ -420,6 +420,34 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_BOARD_VENDOR, "LG Electronics Inc."),
 		},
 	},
+	{
+		.ident = "Acer Aspire One 150",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
+		},
+	},
+	{
+		.ident = "Advent 4211",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "DIXONSXP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Advent 4211"),
+		},
+	},
+	{
+		.ident = "Medion Akoya Mini E1210",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E1210"),
+		},
+	},
+	{
+		.ident = "Mivvy M310",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "VIOOO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N10"),
+		},
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from yan.i.li@intel.com are

input-more-i8042-reset-quirks-for-msi-wind-clone-netbooks.patch

