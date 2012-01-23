From: akpm@linux-foundation.org
Subject: [merged] ipc-mqueue-simplify-reading-msgqueue-limit.patch removed from -mm tree
Date: Mon, 23 Jan 2012 12:21:23 -0800
Message-ID: <20120123202123.A74991E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:52214 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab2AWUVY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 15:21:24 -0500
Received: by ggnk1 with SMTP id k1so171003ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 12:21:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@gnu.org, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: simplify reading msgqueue limit
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-simplify-reading-msgqueue-limit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Davidlohr Bueso <dave@gnu.org>
Subject: ipc/mqueue: simplify reading msgqueue limit

Because the current task is being used to get the limit, we can simply use
rlimit() instead of task_rlimit().

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-simplify-reading-msgqueue-limit ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-simplify-reading-msgqueue-limit
+++ a/ipc/mqueue.c
@@ -128,7 +128,6 @@ static struct inode *mqueue_get_inode(st
 
 	if (S_ISREG(mode)) {
 		struct mqueue_inode_info *info;
-		struct task_struct *p = current;
 		unsigned long mq_bytes, mq_msg_tblsz;
 
 		inode->i_fop = &mqueue_file_operations;
@@ -159,7 +158,7 @@ static struct inode *mqueue_get_inode(st
 
 		spin_lock(&mq_lock);
 		if (u->mq_bytes + mq_bytes < u->mq_bytes ||
-		    u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)) {
+		    u->mq_bytes + mq_bytes > rlimit(RLIMIT_MSGQUEUE)) {
 			spin_unlock(&mq_lock);
 			/* mqueue_evict_inode() releases info->messages */
 			ret = -EMFILE;
_

Patches currently in -mm which might be from dave@gnu.org are

origin.patch
maintainers-update-lguest-f-patterns.patch

