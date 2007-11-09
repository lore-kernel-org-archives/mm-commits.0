From: akpm@linux-foundation.org
Subject: - dvb-dont-return-with-locks-held.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:12:47 -0800
Message-ID: <200711091912.lA9JClD4027950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52500 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638AbXKITND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:13:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     dvb: don't return with locks held
has been removed from the -mm tree.  Its filename was
     dvb-dont-return-with-locks-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

unlock-when-ssp-tries-to-close-an-invalid-port.patch
git-dvb.patch
git-ia64.patch
git-mips.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-netdev-all.patch
git-ocfs2.patch
cris-gpio-undo-locks-before-returning.patch
mips-undo-locking-on-error-path-returns.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
