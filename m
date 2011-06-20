From: akpm@linux-foundation.org
Subject: + ipc-mqueue-refactor-failure-handling.patch added to -mm tree
Date: Mon, 20 Jun 2011 12:14:03 -0700
Message-ID: <201106201914.p5KJE3rR012935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947Ab1FTTOP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 15:14:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, manfred@colorfullife.com


The patch titled
     ipc/mqueue.c: refactor failure handling
has been added to the -mm tree.  Its filename is
     ipc-mqueue-refactor-failure-handling.patch

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
Subject: ipc/mqueue.c: refactor failure handling
From: Jiri Slaby <jslaby@suse.cz>

If new_inode fails to allocate an inode we need only to return with NULL. 
But now we test the opposite and have all the work in a nested block.  So
do the opposite to save one indentation level (and remove unnecessary line
breaks).

This is only a preparation/cleanup for the next patch where we fix up
return values from mqueue_get_inode.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |  113 ++++++++++++++++++++++++-------------------------
 1 file changed, 57 insertions(+), 56 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-refactor-failure-handling ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-refactor-failure-handling
+++ a/ipc/mqueue.c
@@ -115,69 +115,70 @@ static struct inode *mqueue_get_inode(st
 	struct inode *inode;
 
 	inode = new_inode(sb);
-	if (inode) {
-		inode->i_ino = get_next_ino();
-		inode->i_mode = mode;
-		inode->i_uid = current_fsuid();
-		inode->i_gid = current_fsgid();
-		inode->i_mtime = inode->i_ctime = inode->i_atime =
-				CURRENT_TIME;
+	if (!inode)
+		goto err;
 
-		if (S_ISREG(mode)) {
-			struct mqueue_inode_info *info;
-			struct task_struct *p = current;
-			unsigned long mq_bytes, mq_msg_tblsz;
-
-			inode->i_fop = &mqueue_file_operations;
-			inode->i_size = FILENT_SIZE;
-			/* mqueue specific info */
-			info = MQUEUE_I(inode);
-			spin_lock_init(&info->lock);
-			init_waitqueue_head(&info->wait_q);
-			INIT_LIST_HEAD(&info->e_wait_q[0].list);
-			INIT_LIST_HEAD(&info->e_wait_q[1].list);
-			info->notify_owner = NULL;
-			info->qsize = 0;
-			info->user = NULL;	/* set when all is ok */
-			memset(&info->attr, 0, sizeof(info->attr));
-			info->attr.mq_maxmsg = ipc_ns->mq_msg_max;
-			info->attr.mq_msgsize = ipc_ns->mq_msgsize_max;
-			if (attr) {
-				info->attr.mq_maxmsg = attr->mq_maxmsg;
-				info->attr.mq_msgsize = attr->mq_msgsize;
-			}
-			mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
-			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
-			if (!info->messages)
-				goto out_inode;
-
-			mq_bytes = (mq_msg_tblsz +
-				(info->attr.mq_maxmsg * info->attr.mq_msgsize));
-
-			spin_lock(&mq_lock);
-			if (u->mq_bytes + mq_bytes < u->mq_bytes ||
-		 	    u->mq_bytes + mq_bytes >
-			    task_rlimit(p, RLIMIT_MSGQUEUE)) {
-				spin_unlock(&mq_lock);
-				/* mqueue_evict_inode() releases info->messages */
-				goto out_inode;
-			}
-			u->mq_bytes += mq_bytes;
-			spin_unlock(&mq_lock);
+	inode->i_ino = get_next_ino();
+	inode->i_mode = mode;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
+	inode->i_mtime = inode->i_ctime = inode->i_atime = CURRENT_TIME;
+
+	if (S_ISREG(mode)) {
+		struct mqueue_inode_info *info;
+		struct task_struct *p = current;
+		unsigned long mq_bytes, mq_msg_tblsz;
+
+		inode->i_fop = &mqueue_file_operations;
+		inode->i_size = FILENT_SIZE;
+		/* mqueue specific info */
+		info = MQUEUE_I(inode);
+		spin_lock_init(&info->lock);
+		init_waitqueue_head(&info->wait_q);
+		INIT_LIST_HEAD(&info->e_wait_q[0].list);
+		INIT_LIST_HEAD(&info->e_wait_q[1].list);
+		info->notify_owner = NULL;
+		info->qsize = 0;
+		info->user = NULL;	/* set when all is ok */
+		memset(&info->attr, 0, sizeof(info->attr));
+		info->attr.mq_maxmsg = ipc_ns->mq_msg_max;
+		info->attr.mq_msgsize = ipc_ns->mq_msgsize_max;
+		if (attr) {
+			info->attr.mq_maxmsg = attr->mq_maxmsg;
+			info->attr.mq_msgsize = attr->mq_msgsize;
+		}
+		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
+		info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
+		if (!info->messages)
+			goto out_inode;
 
-			/* all is ok */
-			info->user = get_uid(u);
-		} else if (S_ISDIR(mode)) {
-			inc_nlink(inode);
-			/* Some things misbehave if size == 0 on a directory */
-			inode->i_size = 2 * DIRENT_SIZE;
-			inode->i_op = &mqueue_dir_inode_operations;
-			inode->i_fop = &simple_dir_operations;
+		mq_bytes = (mq_msg_tblsz +
+			(info->attr.mq_maxmsg * info->attr.mq_msgsize));
+
+		spin_lock(&mq_lock);
+		if (u->mq_bytes + mq_bytes < u->mq_bytes ||
+		    u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)) {
+			spin_unlock(&mq_lock);
+			/* mqueue_evict_inode() releases info->messages */
+			goto out_inode;
 		}
+		u->mq_bytes += mq_bytes;
+		spin_unlock(&mq_lock);
+
+		/* all is ok */
+		info->user = get_uid(u);
+	} else if (S_ISDIR(mode)) {
+		inc_nlink(inode);
+		/* Some things misbehave if size == 0 on a directory */
+		inode->i_size = 2 * DIRENT_SIZE;
+		inode->i_op = &mqueue_dir_inode_operations;
+		inode->i_fop = &simple_dir_operations;
 	}
+
 	return inode;
 out_inode:
 	iput(inode);
+err:
 	return NULL;
 }
 
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ipc-mqueue-refactor-failure-handling.patch
ipc-mqueue-fix-mq_open-return-value.patch
include-linux-dma-mappingh-remove-dma_xxbit_mask-macros.patch

