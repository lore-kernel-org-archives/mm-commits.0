From: akpm@linux-foundation.org
Subject: [merged] dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch removed from -mm tree
Date: Fri, 12 Jun 2009 11:22:00 -0700
Message-ID: <200906121822.n5CIM0hS030797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762865AbZFLSXM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 14:23:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@fire.lp0.eu, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     dvb-core: fix potential mutex_unlock without mutex_lock in dvb_dvr_read
has been removed from the -mm tree.  Its filename was
     dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dvb-core: fix potential mutex_unlock without mutex_lock in dvb_dvr_read
From: Simon Arlott <simon@fire.lp0.eu>

dvb_dvr_read may unlock the dmxdev mutex and return -ENODEV, except this
function is a file op and will never be called with the mutex held.

There's existing mutex_lock and mutex_unlock around the actual read but
it's commented out.  These should probably be uncommented but the read
blocks and this could block another non-blocking reader on the mutex
instead.

This change comments out the extra mutex_unlock.

[akpm@linux-foundation.org: cleanups, simplification]
Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-core/dmxdev.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN drivers/media/dvb/dvb-core/dmxdev.c~dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read drivers/media/dvb/dvb-core/dmxdev.c
--- a/drivers/media/dvb/dvb-core/dmxdev.c~dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read
+++ a/drivers/media/dvb/dvb-core/dmxdev.c
@@ -244,19 +244,13 @@ static ssize_t dvb_dvr_read(struct file 
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
-	int ret;
 
-	if (dmxdev->exit) {
-		mutex_unlock(&dmxdev->mutex);
+	if (dmxdev->exit)
 		return -ENODEV;
-	}
 
-	//mutex_lock(&dmxdev->mutex);
-	ret = dvb_dmxdev_buffer_read(&dmxdev->dvr_buffer,
-				     file->f_flags & O_NONBLOCK,
-				     buf, count, ppos);
-	//mutex_unlock(&dmxdev->mutex);
-	return ret;
+	return dvb_dmxdev_buffer_read(&dmxdev->dvr_buffer,
+				      file->f_flags & O_NONBLOCK,
+				      buf, count, ppos);
 }
 
 static int dvb_dvr_set_buffer_size(struct dmxdev *dmxdev,
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

linux-next.patch

