From: akpm@linux-foundation.org
Subject: + ipc-mqueue-simplify-reading-msgqueue-limit.patch added to -mm tree
Date: Wed, 09 Nov 2011 15:53:15 -0800
Message-ID: <201111092353.pA9NrFv7014853@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:41277 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab1KIXxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2011 18:53:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@gnu.org


The patch titled
     Subject: ipc/mqueue: simplify reading msgqueue limit
has been added to the -mm tree.  Its filename is
     ipc-mqueue-simplify-reading-msgqueue-limit.patch

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
From: Davidlohr Bueso <dave@gnu.org>
Subject: ipc/mqueue: simplify reading msgqueue limit

Because the current task is being used to get the limit, we can simply use
rlimit() instead of task_rlimit().

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
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
@@ -163,7 +162,7 @@ static struct inode *mqueue_get_inode(st
 
 		spin_lock(&mq_lock);
 		if (u->mq_bytes + mq_bytes < u->mq_bytes ||
-		    u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)) {
+		    u->mq_bytes + mq_bytes > rlimit(RLIMIT_MSGQUEUE)) {
 			spin_unlock(&mq_lock);
 			/* mqueue_evict_inode() releases info->messages */
 			ret = -EMFILE;
_
Subject: Subject: ipc/mqueue: simplify reading msgqueue limit

Patches currently in -mm which might be from dave@gnu.org are

ipc-mqueue-simplify-reading-msgqueue-limit.patch

