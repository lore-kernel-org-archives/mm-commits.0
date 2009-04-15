From: akpm@linux-foundation.org
Subject: + mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char.patch added to -mm tree
Date: Tue, 14 Apr 2009 17:09:05 -0700
Message-ID: <200904150009.n3F095J1011993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949AbZDOAK7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 20:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, dwmw2@infradead.org


The patch titled
     mtd: mtd in mtd_release is unused without CONFIG_MTD_CHAR
has been added to the -mm tree.  Its filename is
     mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char.patch

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
Subject: mtd: mtd in mtd_release is unused without CONFIG_MTD_CHAR
From: "Denis V. Lunev" <den@openvz.org>

drivers/mtd/mtdcore.c: In function 'mtd_release':
drivers/mtd/mtdcore.c:51: warning: unused variable 'mtd'

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mtd/mtdcore.c~mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char
+++ a/drivers/mtd/mtdcore.c
@@ -48,11 +48,11 @@ static LIST_HEAD(mtd_notifiers);
  */
 static void mtd_release(struct device *dev)
 {
-	struct mtd_info *mtd = dev_to_mtd(dev);
+	dev_t index = MTD_DEVT(dev_to_mtd(dev));
 
 	/* remove /dev/mtdXro node if needed */
-	if (MTD_DEVT(mtd->index))
-		device_destroy(mtd_class, MTD_DEVT(mtd->index) + 1);
+	if (index)
+		device_destroy(mtd_class, index + 1);
 }
 
 static ssize_t mtd_type_show(struct device *dev,
_

Patches currently in -mm which might be from den@openvz.org are

pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay.patch
pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch
arm-compilation-fix-sys_oabi-compatc.patch
mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char.patch

