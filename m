From: akpm@linux-foundation.org
Subject: + dvb-dont-return-with-locks-held.patch added to -mm tree
Date: Mon, 29 Oct 2007 13:56:29 -0700
Message-ID: <200710292056.l9TKuT83022839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37957 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbXJ2U4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:56:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, mchehab@infradead.org


The patch titled
     dvb: don't return with locks held
has been added to the -mm tree.  Its filename is
     dvb-dont-return-with-locks-held.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dvb: don't return with locks held
From: Roel Kluin <12o3l@tiscali.nl>

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/au6610.c |    6 +++---
 drivers/media/dvb/dvb-usb/gl861.c  |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/media/dvb/dvb-usb/au6610.c~dvb-dont-return-with-locks-held drivers/media/dvb/dvb-usb/au6610.c
--- a/drivers/media/dvb/dvb-usb/au6610.c~dvb-dont-return-with-locks-held
+++ a/drivers/media/dvb/dvb-usb/au6610.c
@@ -79,12 +79,12 @@ static int au6610_i2c_xfer(struct i2c_ad
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	int i;
 
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-		return -EAGAIN;
-
 	if (num > 2)
 		return -EINVAL;
 
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
+
 	for (i = 0; i < num; i++) {
 		/* write/read request */
 		if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
diff -puN drivers/media/dvb/dvb-usb/gl861.c~dvb-dont-return-with-locks-held drivers/media/dvb/dvb-usb/gl861.c
--- a/drivers/media/dvb/dvb-usb/gl861.c~dvb-dont-return-with-locks-held
+++ a/drivers/media/dvb/dvb-usb/gl861.c
@@ -56,12 +56,12 @@ static int gl861_i2c_xfer(struct i2c_ada
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	int i;
 
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-		return -EAGAIN;
-
 	if (num > 2)
 		return -EINVAL;
 
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
+
 	for (i = 0; i < num; i++) {
 		/* write/read request */
 		if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
git-arm-master.patch
dvb-dont-return-with-locks-held.patch
git-ocfs2.patch
git-s390.patch
i4l-errors-with-assignments-in-if.patch
