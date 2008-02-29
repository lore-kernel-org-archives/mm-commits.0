From: akpm@linux-foundation.org
Subject: + mtd-nor-add-support-for-the-st-m29w400db-flash-chip.patch added to -mm tree
Date: Thu, 28 Feb 2008 22:52:01 -0800
Message-ID: <200802290652.m1T6q1Gq010116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635AbYB2GwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 01:52:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gordonfarquharson@gmail.com, dwmw2@infradead.org, tglx@linutronix.de


The patch titled
     mtd: nor: add support for the ST M29W400DB flash chip
has been added to the -mm tree.  Its filename is
     mtd-nor-add-support-for-the-st-m29w400db-flash-chip.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: nor: add support for the ST M29W400DB flash chip
From: "Gordon Farquharson" <gordonfarquharson@gmail.com>

Add support for the ST M29W400DB flash chip.  which is used on the GLAN Tank
NAS.

Signed-off-by: Gordon Farquharson <gordonfarquharson@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/jedec_probe.c |   42 ++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff -puN drivers/mtd/chips/jedec_probe.c~mtd-nor-add-support-for-the-st-m29w400db-flash-chip drivers/mtd/chips/jedec_probe.c
--- a/drivers/mtd/chips/jedec_probe.c~mtd-nor-add-support-for-the-st-m29w400db-flash-chip
+++ a/drivers/mtd/chips/jedec_probe.c
@@ -132,6 +132,8 @@
 #define M29F800AB	0x0058
 #define M29W800DT	0x00D7
 #define M29W800DB	0x005B
+#define M29W400DT	0x00EE
+#define M29W400DB	0x00EF
 #define M29W160DT	0x22C4
 #define M29W160DB	0x2249
 #define M29W040B	0x00E3
@@ -1426,7 +1428,7 @@ static const struct amd_flash_info jedec
 			ERASEINFO(0x08000,1),
 			ERASEINFO(0x10000,15),
 		}
-       }, {
+	}, {
 		.mfr_id		= MANUFACTURER_ST,	/* FIXME - CFI device? */
 		.dev_id		= M29W800DT,
 		.name		= "ST M29W800DT",
@@ -1456,6 +1458,36 @@ static const struct amd_flash_info jedec
 			ERASEINFO(0x08000,1),
 			ERASEINFO(0x10000,15)
 		}
+	},  {
+		.mfr_id         = MANUFACTURER_ST,
+		.dev_id         = M29W400DT,
+		.name           = "ST M29W400DT",
+		.devtypes       = CFI_DEVICETYPE_X16|CFI_DEVICETYPE_X8,
+		.uaddr          = MTD_UADDR_0x0AAA_0x0555,
+		.dev_size       = SIZE_512KiB,
+		.cmd_set        = P_ID_AMD_STD,
+		.nr_regions     = 4,
+		.regions        = {
+			ERASEINFO(0x04000,7),
+			ERASEINFO(0x02000,1),
+			ERASEINFO(0x08000,2),
+			ERASEINFO(0x10000,1)
+		}
+	}, {
+		.mfr_id         = MANUFACTURER_ST,
+		.dev_id         = M29W400DB,
+		.name           = "ST M29W400DB",
+		.devtypes       = CFI_DEVICETYPE_X16|CFI_DEVICETYPE_X8,
+		.uaddr          = MTD_UADDR_0x0AAA_0x0555,
+		.dev_size       = SIZE_512KiB,
+		.cmd_set        = P_ID_AMD_STD,
+		.nr_regions     = 4,
+		.regions        = {
+			ERASEINFO(0x04000,1),
+			ERASEINFO(0x02000,2),
+			ERASEINFO(0x08000,1),
+			ERASEINFO(0x10000,7)
+		}
 	}, {
 		.mfr_id		= MANUFACTURER_ST,	/* FIXME - CFI device? */
 		.dev_id		= M29W160DT,
@@ -1486,7 +1518,7 @@ static const struct amd_flash_info jedec
 			ERASEINFO(0x08000,1),
 			ERASEINFO(0x10000,31)
 		}
-        }, {
+	}, {
 		.mfr_id		= MANUFACTURER_ST,
 		.dev_id		= M29W040B,
 		.name		= "ST M29W040B",
@@ -1498,7 +1530,7 @@ static const struct amd_flash_info jedec
 		.regions	= {
 			ERASEINFO(0x10000,8),
 		}
-        }, {
+	}, {
 		.mfr_id		= MANUFACTURER_ST,
 		.dev_id		= M50FW040,
 		.name		= "ST M50FW040",
@@ -1510,7 +1542,7 @@ static const struct amd_flash_info jedec
 		.regions	= {
 			ERASEINFO(0x10000,8),
 		}
-        }, {
+	}, {
 		.mfr_id		= MANUFACTURER_ST,
 		.dev_id		= M50FW080,
 		.name		= "ST M50FW080",
@@ -1522,7 +1554,7 @@ static const struct amd_flash_info jedec
 		.regions	= {
 			ERASEINFO(0x10000,16),
 		}
-        }, {
+	}, {
 		.mfr_id		= MANUFACTURER_ST,
 		.dev_id		= M50FW016,
 		.name		= "ST M50FW016",
_

Patches currently in -mm which might be from gordonfarquharson@gmail.com are

mtd-nor-add-support-for-the-st-m29w400db-flash-chip.patch
fix-b43-driver-build-for-arm.patch

