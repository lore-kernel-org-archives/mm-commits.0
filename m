From: akpm@linux-foundation.org
Subject: - tuner-simplec-add-suport-for-secam-bg-with-fi1216mf.patch removed from -mm tree
Date: Tue, 22 May 2007 13:56:47 -0700
Message-ID: <200705222056.l4MKuktS009586@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761883AbXEVU5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 16:57:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: castet.matthieu@free.fr, mm-commits@vger.kernel.org


The patch titled
     tuner-simple.c add suport for SECAM-BG with FI1216MF
has been removed from the -mm tree.  Its filename was
     tuner-simplec-add-suport-for-secam-bg-with-fi1216mf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 7 insertions(+), 3 deletions(-)

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

git-dvb.patch
