From: akpm@linux-foundation.org
Subject: + fuse-limit-queued-background-requests.patch added to -mm tree
Date: Tue, 29 Jan 2008 12:31:53 -0800
Message-ID: <200801292031.m0TKVr9g003154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43786 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505AbYA2UcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 15:32:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: limit queued background requests
has been added to the -mm tree.  Its filename is
     fuse-limit-queued-background-requests.patch

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
Subject: fuse: limit queued background requests
From: Miklos Szeredi <mszeredi@suse.cz>

Libfuse basically creates a new thread for each new request.  This is fine for
synchronous requests, which are naturally limited.  However background
requests (especially writepage) can cause a thread creation storm.

To avoid this, limit the number of background requests available to userspace.

This is done by introducing another queue for background requests, and a
counter for the number of "active" requests, which are currently available for
userspace.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c    |  113 ++++++++++++++++++++++++++-------------------
 fs/fuse/fuse_i.h |    6 ++
 fs/fuse/inode.c  |    1 
 3 files changed, 74 insertions(+), 46 deletions(-)

diff -puN fs/fuse/dev.c~fuse-limit-queued-background-requests fs/fuse/dev.c
--- a/fs/fuse/dev.c~fuse-limit-queued-background-requests
+++ a/fs/fuse/dev.c
@@ -201,6 +201,55 @@ void fuse_put_request(struct fuse_conn *
 	}
 }
 
+static unsigned len_args(unsigned numargs, struct fuse_arg *args)
+{
+	unsigned nbytes = 0;
+	unsigned i;
+
+	for (i = 0; i < numargs; i++)
+		nbytes += args[i].size;
+
+	return nbytes;
+}
+
+static u64 fuse_get_unique(struct fuse_conn *fc)
+{
+	fc->reqctr++;
+	/* zero is special */
+	if (fc->reqctr == 0)
+		fc->reqctr = 1;
+
+	return fc->reqctr;
+}
+
+static void queue_request(struct fuse_conn *fc, struct fuse_req *req)
+{
+	req->in.h.unique = fuse_get_unique(fc);
+	req->in.h.len = sizeof(struct fuse_in_header) +
+		len_args(req->in.numargs, (struct fuse_arg *) req->in.args);
+	list_add_tail(&req->list, &fc->pending);
+	req->state = FUSE_REQ_PENDING;
+	if (!req->waiting) {
+		req->waiting = 1;
+		atomic_inc(&fc->num_waiting);
+	}
+	wake_up(&fc->waitq);
+	kill_fasync(&fc->fasync, SIGIO, POLL_IN);
+}
+
+static void flush_bg_queue(struct fuse_conn *fc)
+{
+	while (fc->active_background < FUSE_MAX_BACKGROUND &&
+	       !list_empty(&fc->bg_queue)) {
+		struct fuse_req *req;
+
+		req = list_entry(fc->bg_queue.next, struct fuse_req, list);
+		list_del(&req->list);
+		fc->active_background++;
+		queue_request(fc, req);
+	}
+}
+
 /*
  * This function is called when a request is finished.  Either a reply
  * has arrived or it was aborted (and not yet sent) or some error
@@ -229,6 +278,8 @@ static void request_end(struct fuse_conn
 			clear_bdi_congested(&fc->bdi, WRITE);
 		}
 		fc->num_background--;
+		fc->active_background--;
+		flush_bg_queue(fc);
 	}
 	spin_unlock(&fc->lock);
 	wake_up(&req->waitq);
@@ -320,42 +371,6 @@ static void request_wait_answer(struct f
 	}
 }
 
-static unsigned len_args(unsigned numargs, struct fuse_arg *args)
-{
-	unsigned nbytes = 0;
-	unsigned i;
-
-	for (i = 0; i < numargs; i++)
-		nbytes += args[i].size;
-
-	return nbytes;
-}
-
-static u64 fuse_get_unique(struct fuse_conn *fc)
- {
- 	fc->reqctr++;
- 	/* zero is special */
- 	if (fc->reqctr == 0)
- 		fc->reqctr = 1;
-
-	return fc->reqctr;
-}
-
-static void queue_request(struct fuse_conn *fc, struct fuse_req *req)
-{
-	req->in.h.unique = fuse_get_unique(fc);
-	req->in.h.len = sizeof(struct fuse_in_header) +
-		len_args(req->in.numargs, (struct fuse_arg *) req->in.args);
-	list_add_tail(&req->list, &fc->pending);
-	req->state = FUSE_REQ_PENDING;
-	if (!req->waiting) {
-		req->waiting = 1;
-		atomic_inc(&fc->num_waiting);
-	}
-	wake_up(&fc->waitq);
-	kill_fasync(&fc->fasync, SIGIO, POLL_IN);
-}
-
 void request_send(struct fuse_conn *fc, struct fuse_req *req)
 {
 	req->isreply = 1;
@@ -375,20 +390,26 @@ void request_send(struct fuse_conn *fc, 
 	spin_unlock(&fc->lock);
 }
 
+static void request_send_nowait_locked(struct fuse_conn *fc,
+				       struct fuse_req *req)
+{
+	req->background = 1;
+	fc->num_background++;
+	if (fc->num_background == FUSE_MAX_BACKGROUND)
+		fc->blocked = 1;
+	if (fc->num_background == FUSE_CONGESTION_THRESHOLD) {
+		set_bdi_congested(&fc->bdi, READ);
+		set_bdi_congested(&fc->bdi, WRITE);
+	}
+	list_add_tail(&req->list, &fc->bg_queue);
+	flush_bg_queue(fc);
+}
+
 static void request_send_nowait(struct fuse_conn *fc, struct fuse_req *req)
 {
 	spin_lock(&fc->lock);
 	if (fc->connected) {
-		req->background = 1;
-		fc->num_background++;
-		if (fc->num_background == FUSE_MAX_BACKGROUND)
-			fc->blocked = 1;
-		if (fc->num_background == FUSE_CONGESTION_THRESHOLD) {
-			set_bdi_congested(&fc->bdi, READ);
-			set_bdi_congested(&fc->bdi, WRITE);
-		}
-
-		queue_request(fc, req);
+		request_send_nowait_locked(fc, req);
 		spin_unlock(&fc->lock);
 	} else {
 		req->out.h.error = -ENOTCONN;
diff -puN fs/fuse/fuse_i.h~fuse-limit-queued-background-requests fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-limit-queued-background-requests
+++ a/fs/fuse/fuse_i.h
@@ -296,6 +296,12 @@ struct fuse_conn {
 	/** Number of requests currently in the background */
 	unsigned num_background;
 
+	/** Number of background requests currently queued for userspace */
+	unsigned active_background;
+
+	/** The list of background requests set aside for later queuing */
+	struct list_head bg_queue;
+
 	/** Pending interrupts */
 	struct list_head interrupts;
 
diff -puN fs/fuse/inode.c~fuse-limit-queued-background-requests fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-limit-queued-background-requests
+++ a/fs/fuse/inode.c
@@ -465,6 +465,7 @@ static struct fuse_conn *new_conn(void)
 		INIT_LIST_HEAD(&fc->processing);
 		INIT_LIST_HEAD(&fc->io);
 		INIT_LIST_HEAD(&fc->interrupts);
+		INIT_LIST_HEAD(&fc->bg_queue);
 		atomic_set(&fc->num_waiting, 0);
 		fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-x86.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
