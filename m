From: akpm@linux-foundation.org
Subject: + mca-add-integrated-device-bus-matching-update.patch added to -mm tree
Date: Wed, 09 May 2007 10:23:28 -0700
Message-ID: <200705091723.l49HNSrK029022@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755570AbXEIRYA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 13:24:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: James.Bottomley@SteelEye.com


The patch titled
     mca: add integrated device bus matching (update)
has been added to the -mm tree.  Its filename is
     mca-add-integrated-device-bus-matching-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mca: add integrated device bus matching (update)
From: James Bottomley <James.Bottomley@SteelEye.com>

The first patch was partial.  There's no way to specify attaching *only* to an
integrated function.  This update allows this.

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mca/mca-bus.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/mca/mca-bus.c~mca-add-integrated-device-bus-matching-update drivers/mca/mca-bus.c
--- a/drivers/mca/mca-bus.c~mca-add-integrated-device-bus-matching-update
+++ a/drivers/mca/mca-bus.c
@@ -48,15 +48,14 @@ static int mca_bus_match (struct device 
 	struct mca_device *mca_dev = to_mca_device (dev);
 	struct mca_driver *mca_drv = to_mca_driver (drv);
 	const unsigned short *mca_ids = mca_drv->id_table;
-	int i;
+	int i = 0;
 
-	if (!mca_ids)
-		return 0;
-
-	for(i = 0; mca_ids[i]; i++) {
-		if (mca_ids[i] == mca_dev->pos_id) {
-			mca_dev->index = i;
-			return 1;
+	if (mca_ids) {
+		for(i = 0; mca_ids[i]; i++) {
+			if (mca_ids[i] == mca_dev->pos_id) {
+				mca_dev->index = i;
+				return 1;
+			}
 		}
 	}
 	/* If the integrated id is present, treat it as though it were an
_

Patches currently in -mm which might be from James.Bottomley@SteelEye.com are

origin.patch
mca-fix-bus-matching.patch
mca-add-integrated-device-bus-matching.patch
mca-add-integrated-device-bus-matching-update.patch
fix--confusion-in-fusion-driver.patch
upper-32-bits.patch
