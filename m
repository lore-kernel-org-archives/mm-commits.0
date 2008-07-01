From: akpm@linux-foundation.org
Subject: + autofs4-fix-waitq-locking.patch added to -mm tree
Date: Tue, 01 Jul 2008 11:03:02 -0700
Message-ID: <200807011803.m61I32xj007298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbYGASDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 14:03:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     autofs4: fix waitq locking
has been added to the -mm tree.  Its filename is
     autofs4-fix-waitq-locking.patch

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
Subject: autofs4: fix waitq locking
From: Ian Kent <raven@themaw.net>

The autofs4_catatonic_mode() function accesses the wait queue without any
locking but can be called at any time.  This could lead to a possible
double free of the name field of the wait and a double fput of the daemon
communication pipe or an fput of a NULL file pointer.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |    4 ++--
 fs/autofs4/waitq.c |   23 ++++++++++++-----------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff -puN fs/autofs4/inode.c~autofs4-fix-waitq-locking fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-fix-waitq-locking
+++ a/fs/autofs4/inode.c
@@ -163,8 +163,8 @@ void autofs4_kill_sb(struct super_block 
 	if (!sbi)
 		goto out_kill_sb;
 
-	if (!sbi->catatonic)
-		autofs4_catatonic_mode(sbi); /* Free wait queues, close pipe */
+	/* Free wait queues, close pipe */
+	autofs4_catatonic_mode(sbi);
 
 	/* Clean up and release dangling references */
 	autofs4_force_release(sbi);
diff -puN fs/autofs4/waitq.c~autofs4-fix-waitq-locking fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-fix-waitq-locking
+++ a/fs/autofs4/waitq.c
@@ -28,6 +28,12 @@ void autofs4_catatonic_mode(struct autof
 {
 	struct autofs_wait_queue *wq, *nwq;
 
+	mutex_lock(&sbi->wq_mutex);
+	if (sbi->catatonic) {
+		mutex_unlock(&sbi->wq_mutex);
+		return;
+	}
+
 	DPRINTK("entering catatonic mode");
 
 	sbi->catatonic = 1;
@@ -45,6 +51,8 @@ void autofs4_catatonic_mode(struct autof
 	}
 	fput(sbi->pipe);	/* Close the pipe */
 	sbi->pipe = NULL;
+	sbi->pipefd = -1;
+	mutex_unlock(&sbi->wq_mutex);
 }
 
 static int autofs4_write(struct file *file, const void *addr, int bytes)
@@ -333,17 +341,10 @@ int autofs4_wait(struct autofs_sb_info *
 			wq->name.name, notify);
 	}
 
-	/* wq->name is NULL if and only if the lock is already released */
-
-	if (sbi->catatonic) {
-		/* We might have slept, so check again for catatonic mode */
-		wq->status = -ENOENT;
-		if (wq->name.name) {
-			kfree(wq->name.name);
-			wq->name.name = NULL;
-		}
-	}
