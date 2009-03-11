From: akpm@linux-foundation.org
Subject: [merged] lm85-add-vrm10-support-for-adt7468-chip.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:09:25 -0700
Message-ID: <200903111809.n2BI9PZH019936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509AbZCKSLJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:11:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     lm85: add VRM10 support for adt7468 chip
has been removed from the -mm tree.  Its filename was
     lm85-add-vrm10-support-for-adt7468-chip.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

