From: akpm@linux-foundation.org
Subject: [patch 094/114] fs: ceph: CURRENT_TIME with
 ktime_get_real_ts()
Date: Mon, 08 May 2017 15:59:19 -0700
Message-ID: <20170508225919.fh5tePP93%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47470 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdEHW7U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:59:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, deepa.kernel@gmail.com, idryomov@gmail.com, mm-commits@vger.kernel.org, sage@redhat.com, torvalds@linux-foundation.org, zyan@redhat.com

From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: fs: ceph: CURRENT_TIME with ktime_get_real_ts()

CURRENT_TIME is not y2038 safe.  The macro will be deleted and all the
references to it will be replaced by ktime_get_* apis.

struct timespec is also not y2038 safe.  Retain timespec for timestamp
representation here as ceph uses it internally everywhere.  These
references will be changed to use struct timespec64 in a separate patch.

The current_fs_time() api is being changed to use vfs struct inode* as an
argument instead of struct super_block*.

Set the new mds client request r_stamp field using ktime_get_real_ts()
instead of using current_fs_time().

Also, since r_stamp is used as mtime on the server, use timespec_trunc()
to truncate the timestamp, using the right granularity from the
superblock.

This api will be transitioned to be y2038 safe along with vfs.

Link: http://lkml.kernel.org/r/1491613030-11599-5-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
M:	Ilya Dryomov <idryomov@gmail.com>
M:	"Yan, Zheng" <zyan@redhat.com>
M:	Sage Weil <sage@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/rbd.c   |    2 +-
 fs/ceph/mds_client.c  |    4 +++-
 net/ceph/messenger.c  |    6 ++++--
 net/ceph/osd_client.c |    4 ++--
 4 files changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/block/rbd.c~fs-ceph-current_time-with-ktime_get_real_ts drivers/block/rbd.c
--- a/drivers/block/rbd.c~fs-ceph-current_time-with-ktime_get_real_ts
+++ a/drivers/block/rbd.c
@@ -1922,7 +1922,7 @@ static void rbd_osd_req_format_write(str
 {
 	struct ceph_osd_request *osd_req = obj_request->osd_req;
 
-	osd_req->r_mtime = CURRENT_TIME;
+	ktime_get_real_ts(&osd_req->r_mtime);
 	osd_req->r_data_offset = obj_request->offset;
 }
 
diff -puN fs/ceph/mds_client.c~fs-ceph-current_time-with-ktime_get_real_ts fs/ceph/mds_client.c
--- a/fs/ceph/mds_client.c~fs-ceph-current_time-with-ktime_get_real_ts
+++ a/fs/ceph/mds_client.c
@@ -1666,6 +1666,7 @@ struct ceph_mds_request *
 ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
 {
 	struct ceph_mds_request *req = kzalloc(sizeof(*req), GFP_NOFS);
+	struct timespec ts;
 
 	if (!req)
 		return ERR_PTR(-ENOMEM);
@@ -1684,7 +1685,8 @@ ceph_mdsc_create_request(struct ceph_mds
 	init_completion(&req->r_safe_completion);
 	INIT_LIST_HEAD(&req->r_unsafe_item);
 
-	req->r_stamp = current_fs_time(mdsc->fsc->sb);
+	ktime_get_real_ts(&ts);
+	req->r_stamp = timespec_trunc(ts, mdsc->fsc->sb->s_time_gran);
 
 	req->r_op = op;
 	req->r_direct_mode = mode;
diff -puN net/ceph/messenger.c~fs-ceph-current_time-with-ktime_get_real_ts net/ceph/messenger.c
--- a/net/ceph/messenger.c~fs-ceph-current_time-with-ktime_get_real_ts
+++ a/net/ceph/messenger.c
@@ -1386,8 +1386,9 @@ static void prepare_write_keepalive(stru
 	dout("prepare_write_keepalive %p\n", con);
 	con_out_kvec_reset(con);
 	if (con->peer_features & CEPH_FEATURE_MSGR_KEEPALIVE2) {
-		struct timespec now = CURRENT_TIME;
+		struct timespec now;
 
+		ktime_get_real_ts(&now);
 		con_out_kvec_add(con, sizeof(tag_keepalive2), &tag_keepalive2);
 		ceph_encode_timespec(&con->out_temp_keepalive2, &now);
 		con_out_kvec_add(con, sizeof(con->out_temp_keepalive2),
@@ -3176,8 +3177,9 @@ bool ceph_con_keepalive_expired(struct c
 {
 	if (interval > 0 &&
 	    (con->peer_features & CEPH_FEATURE_MSGR_KEEPALIVE2)) {
-		struct timespec now = CURRENT_TIME;
+		struct timespec now;
 		struct timespec ts;
+		ktime_get_real_ts(&now);
 		jiffies_to_timespec(interval, &ts);
 		ts = timespec_add(con->last_keepalive_ack, ts);
 		return timespec_compare(&now, &ts) >= 0;
diff -puN net/ceph/osd_client.c~fs-ceph-current_time-with-ktime_get_real_ts net/ceph/osd_client.c
--- a/net/ceph/osd_client.c~fs-ceph-current_time-with-ktime_get_real_ts
+++ a/net/ceph/osd_client.c
@@ -3574,7 +3574,7 @@ ceph_osdc_watch(struct ceph_osd_client *
 	ceph_oid_copy(&lreq->t.base_oid, oid);
 	ceph_oloc_copy(&lreq->t.base_oloc, oloc);
 	lreq->t.flags = CEPH_OSD_FLAG_WRITE;
-	lreq->mtime = CURRENT_TIME;
+	ktime_get_real_ts(&lreq->mtime);
 
 	lreq->reg_req = alloc_linger_request(lreq);
 	if (!lreq->reg_req) {
@@ -3632,7 +3632,7 @@ int ceph_osdc_unwatch(struct ceph_osd_cl
 	ceph_oid_copy(&req->r_base_oid, &lreq->t.base_oid);
 	ceph_oloc_copy(&req->r_base_oloc, &lreq->t.base_oloc);
 	req->r_flags = CEPH_OSD_FLAG_WRITE;
-	req->r_mtime = CURRENT_TIME;
+	ktime_get_real_ts(&req->r_mtime);
 	osd_req_op_watch_init(req, 0, lreq->linger_id,
 			      CEPH_OSD_WATCH_OP_UNWATCH);
 
_
