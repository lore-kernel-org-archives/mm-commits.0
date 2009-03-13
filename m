From: akpm@linux-foundation.org
Subject: + mtd-add-support-for-the-sst-39vf3201-flash-chip.patch added to -mm tree
Date: Fri, 13 Mar 2009 12:33:24 -0700
Message-ID: <200903131933.n2DJXOTj017180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798AbZCMTfS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 15:35:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yegorslists@googlemail.com, dwmw2@infradead.org


The patch titled
     mtd: add support for the SST 39VF3201 flash chip
has been added to the -mm tree.  Its filename is
     mtd-add-support-for-the-sst-39vf3201-flash-chip.patch

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
Subject: mtd: add support for the SST 39VF3201 flash chip
From: Yegor Yefremov <yegorslists@googlemail.com>

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/jedec_probe.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN drivers/mtd/chips/jedec_probe.c~mtd-add-support-for-the-sst-39vf3201-flash-chip drivers/mtd/chips/jedec_probe.c
--- a/drivers/mtd/chips/jedec_probe.c~mtd-add-support-for-the-sst-39vf3201-flash-chip
+++ a/drivers/mtd/chips/jedec_probe.c
@@ -159,6 +159,7 @@
 #define SST39LF800	0x2781
 #define SST39LF160	0x2782
 #define SST39VF1601	0x234b
+#define SST39VF3201	0x235b
 #define SST39LF512	0x00D4
 #define SST39LF010	0x00D5
 #define SST39LF020	0x00D6
@@ -1490,6 +1491,21 @@ static const struct amd_flash_info jedec
 			ERASEINFO(0x1000,256)
 		}
 	}, {
+		.mfr_id		= MANUFACTURER_SST,     /* should be CFI */
+		.dev_id		= SST39VF3201,
+		.name		= "SST 39VF3201",
+		.devtypes	= CFI_DEVICETYPE_X16,
+		.uaddr		= MTD_UADDR_0xAAAA_0x5555,
+		.dev_size	= SIZE_4MiB,
+		.cmd_set	= P_ID_AMD_STD,
+		.nr_regions	= 4,
+		.regions	= {
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256)
+		}
+	}, {
 		.mfr_id		= MANUFACTURER_SST,
 		.dev_id		= SST36VF3203,
 		.name		= "SST 36VF3203",
_

Patches currently in -mm which might be from yegorslists@googlemail.com are

mtd-add-support-for-the-sst-39vf3201-flash-chip.patch

