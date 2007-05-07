From: akpm@linux-foundation.org
Subject: + tuner-simplec-add-suport-for-secam-bg-with-fi1216mf.patch added to -mm tree
Date: Mon, 07 May 2007 15:03:09 -0700
Message-ID: <200705072203.l47M39SO006503@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966522AbXEGWDN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 18:03:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: castet.matthieu@free.fr


The patch titled
     tuner-simple.c add suport for SECAM-BG with FI1216MF
has been added to the -mm tree.  Its filename is
     tuner-simplec-add-suport-for-secam-bg-with-fi1216mf.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tuner-simple.c add suport for SECAM-BG with FI1216MF
From: matthieu castet <castet.matthieu@free.fr>

allow to use SECAM-BG with the FI1216MF tuner.

The selection is done with the secam=B module argument.
The default behaviour should be the same as before.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/tuner-simple.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/media/video/tuner-simple.c~tuner-simplec-add-suport-for-secam-bg-with-fi1216mf drivers/media/video/tuner-simple.c
--- a/drivers/media/video/tuner-simple.c~tuner-simplec-add-suport-for-secam-bg-with-fi1216mf
+++ a/drivers/media/video/tuner-simple.c
@@ -205,9 +205,13 @@ static void default_set_tv_freq(struct i
 		/* 0x01 -> ??? no change ??? */
 		/* 0x02 -> PAL BDGHI / SECAM L */
 		/* 0x04 -> ??? PAL others / SECAM others ??? */
-		cb &= ~0x02;
-		if (t->std & V4L2_STD_SECAM)
-			cb |= 0x02;
+		cb &= ~0x03;
+		if (t->std & V4L2_STD_SECAM_L) //also valid for V4L2_STD_SECAM
+			cb |= PHILIPS_MF_SET_PAL_L;
+		else if (t->std & V4L2_STD_SECAM_LC)
+			cb |= PHILIPS_MF_SET_PAL_L2;
+		else /* V4L2_STD_B|V4L2_STD_GH */
+			cb |= PHILIPS_MF_SET_BG;
 		break;
 
 	case TUNER_TEMIC_4046FM5:
_

Patches currently in -mm which might be from castet.matthieu@free.fr are

tuner-simplec-add-suport-for-secam-bg-with-fi1216mf.patch
pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi.patch
pnp-workaround-hp-bios-defect-that-leaves-smcf010-device-partly-enabled.patch
smsc-ircc2-tidy-up-module-parameter-checking.patch
smsc-ircc2-add-pnp-support.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
