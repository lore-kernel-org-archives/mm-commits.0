From: akpm@linux-foundation.org
Subject: - autofs4-fix-waitq-memory-leak.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:32 -0700
Message-ID: <200807242329.m6ONTWMS011388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756062AbYGXX3g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: fix waitq memory leak
has been removed from the -mm tree.  Its filename was
     autofs4-fix-waitq-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: fix waitq memory leak
From: Ian Kent <raven@themaw.net>

If an autofs mount becomes catatonic before autofs4_wait_release() is
called the wait queue counter will not be decremented down to zero and the
entry will never be freed.  There are also races decrementing the wait
counter in the wait release function.  To deal with this the counter needs
to be updated while holding the wait queue mutex and waiters need to be
woken up unconditionally when the wait is removed from the queue to ensure
we eventually free the wait.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    2 +-
 fs/autofs4/waitq.c    |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-fix-waitq-memory-leak fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-fix-waitq-memory-leak
+++ a/fs/autofs4/autofs_i.h
@@ -84,7 +84,7 @@ struct autofs_wait_queue {
 	pid_t tgid;
 	/* This is for status reporting upon return */
 	int status;
-	atomic_t wait_ctr;
+	unsigned int wait_ctr;
 };
 
 #define AUTOFS_SBI_MAGIC 0x6d4a556d
diff -puN fs/autofs4/waitq.c~autofs4-fix-waitq-memory-leak fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-fix-waitq-memory-leak
+++ a/fs/autofs4/waitq.c
@@ -46,6 +46,7 @@ void autofs4_catatonic_mode(struct autof
 			kfree(wq->name.name);
 			wq->name.name = NULL;
 		}
+		wq->wait_ctr--;
 		wake_up_interruptible(&wq->queue);
 		wq = nwq;
 	}
@@ -380,7 +381,7 @@ int autofs4_wait(struct autofs_sb_info *
 		wq->pid = current->pid;
 		wq->tgid = current->tgid;
 		wq->status = -EINTR; /* Status return if interrupted */
-		atomic_set(&wq->wait_ctr, 2);
+		wq->wait_ctr = 2;
 		mutex_unlock(&sbi->wq_mutex);
 
 		if (sbi->version < 5) {
@@ -406,7 +407,7 @@ int autofs4_wait(struct autofs_sb_info *
 		/* autofs4_notify_daemon() may block */
 		autofs4_notify_daemon(sbi, wq, type);
 	} else {
-		atomic_inc(&wq->wait_ctr);
+		wq->wait_ctr++;
 		mutex_unlock(&sbi->wq_mutex);
 		kfree(qstr.name);
 		DPRINTK("existing wait id = 0x%08lx, name = %.*s, nfy=%d",
@@ -442,8 +443,10 @@ int autofs4_wait(struct autofs_sb_info *
 	status = wq->status;
 
 	/* Are we the last process to need status? */
-	if (atomic_dec_and_test(&wq->wait_ctr))
+	mutex_lock(&sbi->wq_mutex);
+	if (!--wq->wait_ctr)
 		kfree(wq);
+	mutex_unlock(&sbi->wq_mutex);
 
 	return status;
 }
@@ -467,14 +470,11 @@ int autofs4_wait_release(struct autofs_s
 	*wql = wq->next;	/* Unlink from chain */
 	kfree(wq->name.name);
 	wq->name.name = NULL;	/* Do not wait on this queue */
-	mutex_unlock(&sbi->wq_mutex);
-
 	wq->status = status;
