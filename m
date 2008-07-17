From: akpm@linux-foundation.org
Subject: + mtd-jedec_probe-fix-sst-16-bit-chip-detection.patch added to -mm tree
Date: Wed, 16 Jul 2008 17:13:32 -0700
Message-ID: <200807170013.m6H0DWJ0021037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287AbYGQANv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 20:13:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, stable@kernel.org


The patch titled
     mtd: jedec_probe: fix SST 16-bit chip detection
has been added to the -mm tree.  Its filename is
     mtd-jedec_probe-fix-sst-16-bit-chip-detection.patch

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
Subject: mtd: jedec_probe: fix SST 16-bit chip detection
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The unlock_addr rework in kernel 2.6.25 breaks 16-bit SST chips.  SST
39LF160 and SST 39VF1601 are both 16-bit only chip (do not have BYTE# pin)
and new uaddr value is not correct for them.  Add MTD_UADDR_0xAAAA_0x5555
for those chips.  Tested with SST 39VF1601 chip.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: <stable@kernel.org> [2.6.25.x, 2.6.26.x, subject to dwmw2 ack]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/jedec_probe.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/mtd/chips/jedec_probe.c~mtd-jedec_probe-fix-sst-16-bit-chip-detection drivers/mtd/chips/jedec_probe.c
--- a/drivers/mtd/chips/jedec_probe.c~mtd-jedec_probe-fix-sst-16-bit-chip-detection
+++ a/drivers/mtd/chips/jedec_probe.c
@@ -200,6 +200,7 @@ enum uaddr {
 	MTD_UADDR_0x0555_0x0AAA,
 	MTD_UADDR_0x5555_0x2AAA,
 	MTD_UADDR_0x0AAA_0x0555,
+	MTD_UADDR_0xAAAA_0x5555,
 	MTD_UADDR_DONT_CARE,		/* Requires an arbitrary address */
 	MTD_UADDR_UNNECESSARY,		/* Does not require any address */
 };
@@ -247,6 +248,11 @@ static const struct unlock_addr  unlock_
 		.addr2 = 0x0555
 	},
 
+	[MTD_UADDR_0xAAAA_0x5555] = {
+		.addr1 = 0xaaaa,
+		.addr2 = 0x5555
+	},
+
 	[MTD_UADDR_DONT_CARE] = {
 		.addr1 = 0x0000,      /* Doesn't matter which address */
 		.addr2 = 0x0000       /* is used - must be last entry */
@@ -1461,8 +1467,8 @@ static const struct amd_flash_info jedec
 		.mfr_id		= MANUFACTURER_SST,     /* should be CFI */
 		.dev_id		= SST39LF160,
 		.name		= "SST 39LF160",
-		.devtypes	= CFI_DEVICETYPE_X16|CFI_DEVICETYPE_X8,
-		.uaddr		= MTD_UADDR_0x5555_0x2AAA,	/* ???? */
+		.devtypes	= CFI_DEVICETYPE_X16,
+		.uaddr		= MTD_UADDR_0xAAAA_0x5555,
 		.dev_size	= SIZE_2MiB,
 		.cmd_set	= P_ID_AMD_STD,
 		.nr_regions	= 2,
@@ -1474,8 +1480,8 @@ static const struct amd_flash_info jedec
 		.mfr_id		= MANUFACTURER_SST,     /* should be CFI */
 		.dev_id		= SST39VF1601,
 		.name		= "SST 39VF1601",
-		.devtypes	= CFI_DEVICETYPE_X16|CFI_DEVICETYPE_X8,
-		.uaddr		= MTD_UADDR_0x5555_0x2AAA,	/* ???? */
+		.devtypes	= CFI_DEVICETYPE_X16,
+		.uaddr		= MTD_UADDR_0xAAAA_0x5555,
 		.dev_size	= SIZE_2MiB,
 		.cmd_set	= P_ID_AMD_STD,
 		.nr_regions	= 2,
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
linux-next.patch
mtd-jedec_probe-fix-sst-16-bit-chip-detection.patch

