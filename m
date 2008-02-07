From: akpm@linux-foundation.org
Subject: - drivers-cdrom-cdromc-simplify-logic-in-cdrom_release.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:25:36 -0800
Message-ID: <200802070025.m170PHAU006701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763287AbYBGAor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     drivers/cdrom/cdrom.c: simplify logic in cdrom_release()
has been removed from the -mm tree.  Its filename was
     drivers-cdrom-cdromc-simplify-logic-in-cdrom_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/cdrom/cdrom.c: simplify logic in cdrom_release()
From: Borislav Petkov <bbpetkov@yahoo.de>

Simplify logic in cdrom_release() without semantic change.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/cdrom.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/cdrom/cdrom.c~drivers-cdrom-cdromc-simplify-logic-in-cdrom_release drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~drivers-cdrom-cdromc-simplify-logic-in-cdrom_release
+++ a/drivers/cdrom/cdrom.c
@@ -1206,25 +1206,26 @@ int check_for_audio_disc(struct cdrom_de
 	return 0;
 }
 
-/* Admittedly, the logic below could be performed in a nicer way. */
 int cdrom_release(struct cdrom_device_info *cdi, struct file *fp)
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
 	int opened_for_data;
 
-	cdinfo(CD_CLOSE, "entering cdrom_release\n"); 
+	cdinfo(CD_CLOSE, "entering cdrom_release\n");
 
 	if (cdi->use_count > 0)
 		cdi->use_count--;
-	if (cdi->use_count == 0)
+
+	if (cdi->use_count == 0) {
 		cdinfo(CD_CLOSE, "Use count for \"/dev/%s\" now zero\n", cdi->name);
-	if (cdi->use_count == 0)
 		cdrom_dvd_rw_close_write(cdi);
-	if (cdi->use_count == 0 &&
-	    (cdo->capability & CDC_LOCK) && !keeplocked) {
-		cdinfo(CD_CLOSE, "Unlocking door!\n");
-		cdo->lock_door(cdi, 0);
+
+		if ((cdo->capability & CDC_LOCK) && !keeplocked) {
+			cdinfo(CD_CLOSE, "Unlocking door!\n");
+			cdo->lock_door(cdi, 0);
+		}
 	}
+
 	opened_for_data = !(cdi->options & CDO_USE_FFLAGS) ||
 		!(fp && fp->f_flags & O_NONBLOCK);
 
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
