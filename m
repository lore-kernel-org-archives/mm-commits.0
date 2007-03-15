From: akpm@linux-foundation.org
Subject: - dvb-core-fix-several-locking-related-problems.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:57:13 -0800
Message-ID: <200703152157.l2FLvDu4027620@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42383 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbXCOV5p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:57:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@fire.lp0.eu, mchehab@infradead.org, obi@linuxtv.org, mm-commits@vger.kernel.org


The patch titled
     dvb-core: fix several locking related problems
has been removed from the -mm tree.  Its filename was
     dvb-core-fix-several-locking-related-problems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dvb-core: fix several locking related problems
From: Simon Arlott <simon@fire.lp0.eu>

Fix several instances of dvb-core functions using mutex_lock_interruptible
and returning -ERESTARTSYS where the calling function will either never
retry or never check the return value.

These cause a race condition with dvb_dmxdev_filter_free and
dvb_dvr_release, both of which are filesystem release functions whose
return value is ignored and will never be retried.  When this happens it
becomes impossible to open dvr0 again (-EBUSY) since it has not been
released properly.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-core/dmxdev.c    |   12 +++---------
 drivers/media/dvb/dvb-core/dvb_demux.c |   21 +++++++--------------
 drivers/media/dvb/dvb-core/dvbdev.c    |    9 +++------
 3 files changed, 13 insertions(+), 29 deletions(-)

diff -puN drivers/media/dvb/dvb-core/dmxdev.c~dvb-core-fix-several-locking-related-problems drivers/media/dvb/dvb-core/dmxdev.c
--- a/drivers/media/dvb/dvb-core/dmxdev.c~dvb-core-fix-several-locking-related-problems
+++ a/drivers/media/dvb/dvb-core/dmxdev.c
@@ -180,8 +180,7 @@ static int dvb_dvr_release(struct inode 
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
 
-	if (mutex_lock_interruptible(&dmxdev->mutex))
-		return -ERESTARTSYS;
+	mutex_lock(&dmxdev->mutex);
 
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY) {
 		dmxdev->demux->disconnect_frontend(dmxdev->demux);
@@ -673,13 +672,8 @@ static int dvb_demux_open(struct inode *
 static int dvb_dmxdev_filter_free(struct dmxdev *dmxdev,
 				  struct dmxdev_filter *dmxdevfilter)
 {
-	if (mutex_lock_interruptible(&dmxdev->mutex))
-		return -ERESTARTSYS;
-
-	if (mutex_lock_interruptible(&dmxdevfilter->mutex)) {
-		mutex_unlock(&dmxdev->mutex);
-		return -ERESTARTSYS;
-	}
+	mutex_lock(&dmxdev->mutex);
+	mutex_lock(&dmxdevfilter->mutex);
 
 	dvb_dmxdev_filter_stop(dmxdevfilter);
 	dvb_dmxdev_filter_reset(dmxdevfilter);
diff -puN drivers/media/dvb/dvb-core/dvb_demux.c~dvb-core-fix-several-locking-related-problems drivers/media/dvb/dvb-core/dvb_demux.c
--- a/drivers/media/dvb/dvb-core/dvb_demux.c~dvb-core-fix-several-locking-related-problems
+++ a/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -673,8 +673,7 @@ static int dmx_ts_feed_stop_filtering(st
 	struct dvb_demux *demux = feed->demux;
 	int ret;
 
-	if (mutex_lock_interruptible(&demux->mutex))
-		return -ERESTARTSYS;
+	mutex_lock(&demux->mutex);
 
 	if (feed->state < DMX_STATE_GO) {
 		mutex_unlock(&demux->mutex);
@@ -748,8 +747,7 @@ static int dvbdmx_release_ts_feed(struct
 	struct dvb_demux *demux = (struct dvb_demux *)dmx;
 	struct dvb_demux_feed *feed = (struct dvb_demux_feed *)ts_feed;
 
-	if (mutex_lock_interruptible(&demux->mutex))
-		return -ERESTARTSYS;
+	mutex_lock(&demux->mutex);
 
 	if (feed->state == DMX_STATE_FREE) {
 		mutex_unlock(&demux->mutex);
@@ -916,8 +914,7 @@ static int dmx_section_feed_stop_filteri
 	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
 	int ret;
 
-	if (mutex_lock_interruptible(&dvbdmx->mutex))
-		return -ERESTARTSYS;
+	mutex_lock(&dvbdmx->mutex);
 
 	if (!dvbdmx->stop_feed) {
 		mutex_unlock(&dvbdmx->mutex);
@@ -942,8 +939,7 @@ static int dmx_section_feed_release_filt
 	struct dvb_demux_feed *dvbdmxfeed = (struct dvb_demux_feed *)feed;
 	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
 
-	if (mutex_lock_interruptible(&dvbdmx->mutex))
-		return -ERESTARTSYS;
+	mutex_lock(&dvbdmx->mutex);
 
 	if (dvbdmxfilter->feed != dvbdmxfeed) {
 		mutex_unlock(&dvbdmx->mutex);
@@ -1016,8 +1012,7 @@ static int dvbdmx_release_section_feed(s
 	struct dvb_demux_feed *dvbdmxfeed = (struct dvb_demux_feed *)feed;
 	struct dvb_demux *dvbdmx = (struct dvb_demux *)demux;
 
-	if (mutex_lock_interruptible(&dvbdmx->mutex))
-		return -ERESTARTSYS;
+	mutex_lock(&dvbdmx->mutex);
 
 	if (dvbdmxfeed->state == DMX_STATE_FREE) {
 		mutex_unlock(&dvbdmx->mutex);
@@ -1126,8 +1121,7 @@ static int dvbdmx_connect_frontend(struc
 	if (demux->frontend)
 		return -EINVAL;
 
-	if (mutex_lock_interruptible(&dvbdemux->mutex))
-		return -ERESTARTSYS;
+	mutex_lock(&dvbdemux->mutex);
 
 	demux->frontend = frontend;
 	mutex_unlock(&dvbdemux->mutex);
@@ -1138,8 +1132,7 @@ static int dvbdmx_disconnect_frontend(st
 {
 	struct dvb_demux *dvbdemux = (struct dvb_demux *)demux;
 
-	if (mutex_lock_interruptible(&dvbdemux->mutex))
-		return -ERESTARTSYS;
+	mutex_lock(&dvbdemux->mutex);
 
 	demux->frontend = NULL;
 	mutex_unlock(&dvbdemux->mutex);
diff -puN drivers/media/dvb/dvb-core/dvbdev.c~dvb-core-fix-several-locking-related-problems drivers/media/dvb/dvb-core/dvbdev.c
--- a/drivers/media/dvb/dvb-core/dvbdev.c~dvb-core-fix-several-locking-related-problems
+++ a/drivers/media/dvb/dvb-core/dvbdev.c
@@ -203,8 +203,7 @@ int dvb_register_device(struct dvb_adapt
 
 	int id;
 
-	if (mutex_lock_interruptible(&dvbdev_register_lock))
-		return -ERESTARTSYS;
+	mutex_lock(&dvbdev_register_lock);
 
 	if ((id = dvbdev_get_free_id (adap, type)) < 0){
 		mutex_unlock(&dvbdev_register_lock);
@@ -294,8 +293,7 @@ int dvb_register_adapter(struct dvb_adap
 {
 	int num;
 
-	if (mutex_lock_interruptible(&dvbdev_register_lock))
-		return -ERESTARTSYS;
+	mutex_lock(&dvbdev_register_lock);
 
 	if ((num = dvbdev_get_free_adapter_num ()) < 0) {
 		mutex_unlock(&dvbdev_register_lock);
@@ -323,8 +321,7 @@ EXPORT_SYMBOL(dvb_register_adapter);
 
 int dvb_unregister_adapter(struct dvb_adapter *adap)
 {
-	if (mutex_lock_interruptible(&dvbdev_register_lock))
-		return -ERESTARTSYS;
+	mutex_lock(&dvbdev_register_lock);
 	list_del (&adap->list_head);
 	mutex_unlock(&dvbdev_register_lock);
 	return 0;
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

git-dvb.patch
