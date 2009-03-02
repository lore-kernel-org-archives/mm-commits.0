From: akpm@linux-foundation.org
Subject: + lm85-add-vrm10-support-for-adt7468-chip.patch added to -mm tree
Date: Mon, 02 Mar 2009 15:06:42 -0800
Message-ID: <200903022306.n22N6gkD032169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754730AbZCBXLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 18:11:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, khali@linux-fr.org


The patch titled
     lm85: add VRM10 support for adt7468 chip
has been added to the -mm tree.  Its filename is
     lm85-add-vrm10-support-for-adt7468-chip.patch

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
Subject: lm85: add VRM10 support for adt7468 chip
From: "Darrick J. Wong" <djwong@us.ibm.com>

The adt7468 chip supports VRM10 sensors just like the adt7463; add a
missing check for it.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lm85.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/lm85.c~lm85-add-vrm10-support-for-adt7468-chip drivers/hwmon/lm85.c
--- a/drivers/hwmon/lm85.c~lm85-add-vrm10-support-for-adt7468-chip
+++ a/drivers/hwmon/lm85.c
@@ -410,7 +410,8 @@ static ssize_t show_vid_reg(struct devic
 	struct lm85_data *data = lm85_update_device(dev);
 	int vid;
 
-	if (data->type == adt7463 && (data->vid & 0x80)) {
+	if ((data->type == adt7463 || data->type == adt7468) &&
+	    (data->vid & 0x80)) {
 		/* 6-pin VID (VRM 10) */
 		vid = vid_from_reg(data->vid & 0x3f, data->vrm);
 	} else {
_

Patches currently in -mm which might be from djwong@us.ibm.com are

lm90-support-the-max6648-6692-chips.patch
lm90-support-the-max6648-6692-chips-fix.patch
lm85-fix-the-version-check-that-broke-adt7468-probing.patch
lm85-add-vrm10-support-for-adt7468-chip.patch

