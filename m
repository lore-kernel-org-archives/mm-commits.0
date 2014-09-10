From: akpm@linux-foundation.org
Subject: + fs-ocfs2-dlm-dlmdebugc-use-seq_open_private-not-seq_open.patch
 added to -mm tree
Date: Wed, 10 Sep 2014 12:27:46 -0700
Message-ID: <5410a632.kXygsgjJNsJScVKj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaIJT1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 15:27:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob.jones@codethink.co.uk, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/dlm/dlmdebug.c: use seq_open_private() not seq_open()
has been added to the -mm tree.  Its filename is
     fs-ocfs2-dlm-dlmdebugc-use-seq_open_private-not-seq_open.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ocfs2-dlm-dlmdebugc-use-seq_open_private-not-seq_open.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ocfs2-dlm-dlmdebugc-use-seq_open_private-not-seq_open.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Jones <rob.jones@codethink.co.uk>
Subject: fs/ocfs2/dlm/dlmdebug.c: use seq_open_private() not seq_open()

Reduce boilerplate code by using seq_open_private() instead of seq_open()

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdebug.c |   39 +++++++++++++-------------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdebug.c~fs-ocfs2-dlm-dlmdebugc-use-seq_open_private-not-seq_open fs/ocfs2/dlm/dlmdebug.c
--- a/fs/ocfs2/dlm/dlmdebug.c~fs-ocfs2-dlm-dlmdebugc-use-seq_open_private-not-seq_open
+++ a/fs/ocfs2/dlm/dlmdebug.c
@@ -647,41 +647,30 @@ static const struct seq_operations debug
 static int debug_lockres_open(struct inode *inode, struct file *file)
 {
 	struct dlm_ctxt *dlm = inode->i_private;
-	int ret = -ENOMEM;
-	struct seq_file *seq;
-	struct debug_lockres *dl = NULL;
-
-	dl = kzalloc(sizeof(struct debug_lockres), GFP_KERNEL);
-	if (!dl) {
-		mlog_errno(ret);
-		goto bail;
-	}
+	struct debug_lockres *dl;
+	void *buf;
 
-	dl->dl_len = PAGE_SIZE;
-	dl->dl_buf = kmalloc(dl->dl_len, GFP_KERNEL);
-	if (!dl->dl_buf) {
-		mlog_errno(ret);
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
 		goto bail;
-	}
 
-	ret = seq_open(file, &debug_lockres_ops);
-	if (ret) {
-		mlog_errno(ret);
-		goto bail;
-	}
+	dl = __seq_open_private(file, &debug_lockres_ops, sizeof(*dl));
+	if (!dl)
+		goto bailfree;
 
-	seq = file->private_data;
-	seq->private = dl;
+	dl->dl_len = PAGE_SIZE;
+	dl->dl_buf = buf;
 
 	dlm_grab(dlm);
 	dl->dl_ctxt = dlm;
 
 	return 0;
+
+bailfree:
+	kfree(buf);
 bail:
-	if (dl)
-		kfree(dl->dl_buf);
-	kfree(dl);
-	return ret;
+	mlog_errno(-ENOMEM);
+	return -ENOMEM;
 }
 
 static int debug_lockres_release(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from rob.jones@codethink.co.uk are

fs-ocfs2-dlm-dlmdebugc-use-seq_open_private-not-seq_open.patch
fs-ocfs2-cluster-netdebugc-use-seq_open_private-not-seq_open.patch
fs-ocfs2-dlmgluec-use-__seq_open_private-not-seq_open.patch
mm-use-seq_open_private-instead-of-seq_open.patch
mm-use-__seq_open_private-instead-of-seq_open.patch
lib-use-seq_open_private-instead-of-seq_open.patch
ipc-use-__seq_open_private-instead-of-seq_open.patch

