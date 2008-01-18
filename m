From: akpm@linux-foundation.org
Subject: + drivers-cdrom-cdromc-simplify-logic-in-cdrom_release.patch added to -mm tree
Date: Fri, 18 Jan 2008 14:03:43 -0800
Message-ID: <200801182203.m0IM3hEw007453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760670AbYARWE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jan 2008 17:04:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bbpetkov@yahoo.de, jens.axboe@oracle.com


The patch titled
     drivers/cdrom/cdrom.c: simplify logic in cdrom_release()
has been added to the -mm tree.  Its filename is
     drivers-cdrom-cdromc-simplify-logic-in-cdrom_release.patch

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

git-acpi.patch
git-x86.patch
git-cryptodev.patch
drivers-cdrom-cdromc-simplify-logic-in-cdrom_release.patch
