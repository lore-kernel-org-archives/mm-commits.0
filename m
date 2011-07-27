From: akpm@linux-foundation.org
Subject: [merged] ipc-mqueue-fix-mq_open-return-value.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:29:01 -0700
Message-ID: <201107271927.p6RJRlR4003240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553Ab1G0T2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     ipc/mqueue.c: fix mq_open() return value
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-fix-mq_open-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc/mqueue.c: fix mq_open() return value
From: Jiri Slaby <jslaby@suse.cz>

We return ENOMEM from mqueue_get_inode even when we have enough memory. 
Namely in case the system rlimit of mqueue was reached.  This error
propagates to mq_queue and user sees the error unexpectedly.  So fix this
up to properly return EMFILE as described in the manpage:

	EMFILE The process already has the maximum number of files and
	       message queues open.
instead of:
	ENOMEM Insufficient memory.

With the previous patch we just switch to ERR_PTR/PTR_ERR/IS_ERR error
handling here.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-fix-mq_open-return-value ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-fix-mq_open-return-value
+++ a/ipc/mqueue.c
@@ -113,6 +113,7 @@ static struct inode *mqueue_get_inode(st
 {
 	struct user_struct *u = current_user();
 	struct inode *inode;
+	int ret = -ENOMEM;
 
 	inode = new_inode(sb);
 	if (!inode)
@@ -160,6 +161,7 @@ static struct inode *mqueue_get_inode(st
 		    u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)) {
 			spin_unlock(&mq_lock);
 			/* mqueue_evict_inode() releases info->messages */
+			ret = -EMFILE;
 			goto out_inode;
 		}
 		u->mq_bytes += mq_bytes;
@@ -179,7 +181,7 @@ static struct inode *mqueue_get_inode(st
 out_inode:
 	iput(inode);
 err:
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 static int mqueue_fill_super(struct super_block *sb, void *data, int silent)
@@ -195,8 +197,8 @@ static int mqueue_fill_super(struct supe
 
 	inode = mqueue_get_inode(sb, ns, S_IFDIR | S_ISVTX | S_IRWXUGO,
 				NULL);
-	if (!inode) {
-		error = -ENOMEM;
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
 		goto out;
 	}
 
@@ -316,8 +318,8 @@ static int mqueue_create(struct inode *d
 	spin_unlock(&mq_lock);
 
 	inode = mqueue_get_inode(dir->i_sb, ipc_ns, mode, attr);
-	if (!inode) {
-		error = -ENOMEM;
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
 		spin_lock(&mq_lock);
 		ipc_ns->mq_queues_count--;
 		goto out_unlock;
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch

