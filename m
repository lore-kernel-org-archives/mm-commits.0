From: akpm@linux-foundation.org
Subject: + autofs4-fix-waitq-memory-leak.patch added to -mm tree
Date: Tue, 01 Jul 2008 11:04:38 -0700
Message-ID: <200807011804.m61I4cYP007333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222AbYGASFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 14:05:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     autofs4: fix waitq memory leak
has been added to the -mm tree.  Its filename is
     autofs4-fix-waitq-memory-leak.patch

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
@@ -378,7 +379,7 @@ int autofs4_wait(struct autofs_sb_info *
 		wq->pid = current->pid;
 		wq->tgid = current->tgid;
 		wq->status = -EINTR; /* Status return if interrupted */
-		atomic_set(&wq->wait_ctr, 2);
+		wq->wait_ctr = 2;
 		mutex_unlock(&sbi->wq_mutex);
 
 		if (sbi->version < 5) {
@@ -404,7 +405,7 @@ int autofs4_wait(struct autofs_sb_info *
 		/* autofs4_notify_daemon() may block */
 		autofs4_notify_daemon(sbi, wq, type);
 	} else {
-		atomic_inc(&wq->wait_ctr);
+		wq->wait_ctr++;
 		mutex_unlock(&sbi->wq_mutex);
 		kfree(qstr.name);
 		DPRINTK("existing wait id = 0x%08lx, name = %.*s, nfy=%d",
@@ -440,8 +441,10 @@ int autofs4_wait(struct autofs_sb_info *
 	status = wq->status;
 
 	/* Are we the last process to need status? */
-	if (atomic_dec_and_test(&wq->wait_ctr))
+	mutex_lock(&sbi->wq_mutex);
+	if (!--wq->wait_ctr)
 		kfree(wq);
+	mutex_unlock(&sbi->wq_mutex);
 
 	return status;
 }
@@ -465,14 +468,11 @@ int autofs4_wait_release(struct autofs_s
 	*wql = wq->next;	/* Unlink from chain */
 	kfree(wq->name.name);
 	wq->name.name = NULL;	/* Do not wait on this queue */
-	mutex_unlock(&sbi->wq_mutex);
-
 	wq->status = status;
-
-	if (atomic_dec_and_test(&wq->wait_ctr))	/* Is anyone still waiting for this guy? */
+	wake_up_interruptible(&wq->queue);
+	if (!--wq->wait_ctr)
 		kfree(wq);
-	else
-		wake_up_interruptible(&wq->queue);
+	mutex_unlock(&sbi->wq_mutex);
 
 	return 0;
 }
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-dont-make-expiring-dentry-negative.patch
autofs4-dont-make-expiring-dentry-negative-fix.patch
autofs4-revert-redo-lookup-in-ttfd.patch
autofs4-use-look-aside-list-for-lookups.patch
autofs4-use-look-aside-list-for-lookups-autofs4-fix-symlink-name-allocation.patch
autofs4-dont-release-directory-mutex-if-called-in-oz_mode.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts.patch
autofs4-use-struct-qstr-in-waitqc.patch
autofs4-fix-waitq-locking.patch
autofs4-fix-pending-mount-race.patch
autofs4-check-kernel-communication-pipe-is-valid-for-write.patch
autofs4-fix-waitq-memory-leak.patch

