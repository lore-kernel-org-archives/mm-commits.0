From: akpm@linux-foundation.org
Subject: + autofs4-fix-pending-mount-race.patch added to -mm tree
Date: Tue, 01 Jul 2008 00:05:39 -0700
Message-ID: <200807010705.m6175du9014120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705AbYGAHGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 03:06:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, jmoyer@redhat.com


The patch titled
     autofs4: fix pending mount race
has been added to the -mm tree.  Its filename is
     autofs4-fix-pending-mount-race.patch

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
Subject: autofs4: fix pending mount race
From: Ian Kent <raven@themaw.net>

Close a race between a pending mount that is about to finish and a new
lookup for the same directory.

Process P1 triggers a mount of directory foo.  It sets
DCACHE_AUTOFS_PENDING in the ->lookup routine, creates a waitq entry for
'foo', and calls out to the daemon to perform the mount.  The autofs
daemon will then create the directory 'foo', using a new dentry that will
be hashed in the dcache.

Before the mount completes, another process, P2, tries to walk into the
'foo' directory.  The vfs path walking code finds an entry for 'foo' and
calls the revalidate method.  Revalidate finds that the entry is not
PENDING (because PENDING was never set on the dentry created by the
mkdir), but it does find the directory is empty.  Revalidate calls
try_to_fill_dentry, which sets the PENDING flag and then calls into the
autofs4 wait code to trigger or wait for a mount of 'foo'.  The wait code
finds the entry for 'foo' and goes to sleep waiting for the completion of
the mount.

Yet another process, P3, tries to walk into the 'foo' directory.  This
process again finds a dentry in the dcache for 'foo', and calls into the
autofs revalidate code.

The revalidate code finds that the PENDING flag is set, and so calls
try_to_fill_dentry.

a) try_to_fill_dentry sets the PENDING flag redundantly for this
   dentry, then calls into the autofs4 wait code.

b) the autofs4 wait code takes the waitq mutex and searches for an
   entry for 'foo'

Between a and b, P1 is woken up because the mount completed.  P1 takes the
wait queue mutex, clears the PENDING flag from the dentry, and removes the
waitqueue entry for 'foo' from the list.

When it releases the waitq mutex, P3 (eventually) acquires it.  At this
time, it looks for an existing waitq for 'foo', finds none, and so creates
a new one and calls out to the daemon to mount the 'foo' directory.

Now, the reason that three processes are required to trigger this race is
that, because the PENDING flag is not set on the dentry created by mkdir,
the window for the race would be way to slim for it to ever occur. 
Basically, between the testing of d_mountpoint(dentry) and the taking of
the waitq mutex, the mount would have to complete and the daemon would
have to be woken up, and that in turn would have to wake up P1.  This is
simply impossible.  Add the third process, though, and it becomes slightly
more likely.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |  135 ++++++++++++++++++++++++++++++-------------
 1 file changed, 97 insertions(+), 38 deletions(-)

diff -puN fs/autofs4/waitq.c~autofs4-fix-pending-mount-race fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-fix-pending-mount-race
+++ a/fs/autofs4/waitq.c
@@ -207,19 +207,106 @@ autofs4_find_wait(struct autofs_sb_info 
 	return wq;
 }
 
+/*
+ * Check if we have a valid request.
+ * Returns
+ * 1 if the request should continue.
+ *   In this case we can return an autofs_wait_queue entry if one is
+ *   found or NULL to idicate a new wait needs to be created.
+ * 0 or a negative errno if the request shouldn't continue.
+ */
+static int validate_request(struct autofs_wait_queue **wait,
+			    struct autofs_sb_info *sbi,
+			    struct qstr *qstr,
+			    struct dentry*dentry, enum autofs_notify notify)
+{
+	struct autofs_wait_queue *wq;
+	struct autofs_info *ino;
+
+	/* Wait in progress, continue; */
+	wq = autofs4_find_wait(sbi, qstr);
+	if (wq) {
+		*wait = wq;
+		return 1;
+	}
+
+	*wait = NULL;
+
+	/* If we don't yet have any info this is a new request */
+	ino = autofs4_dentry_ino(dentry);
+	if (!ino)
+		return 1;
+
+	/*
+	 * If we've been asked to wait on an existing expire (NFY_NONE)
+	 * but there is no wait in the queue ...
+	 */
+	if (notify == NFY_NONE) {
+		/*
+		 * Either we've betean the pending expire to post it's
+		 * wait or it finished while we waited on the mutex.
+		 * So we need to wait till either, the wait appears
+		 * or the expire finishes.
+		 */
+
+		while (ino->flags & AUTOFS_INF_EXPIRING) {
+			mutex_unlock(&sbi->wq_mutex);
+			schedule_timeout_interruptible(HZ/10);
+			if (mutex_lock_interruptible(&sbi->wq_mutex))
+				return -EINTR;
+
+			wq = autofs4_find_wait(sbi, qstr);
+			if (wq) {
+				*wait = wq;
+				return 1;
+			}
+		}
+
+		/*
+		 * Not ideal but the status has already gone. Of the two
+		 * cases where we wait on NFY_NONE neither depend on the
+		 * return status of the wait.
+		 */
+		return 0;
+	}
+
+	/*
+	 * If we've been asked to trigger a mount and the request
+	 * completed while we waited on the mutex ...
+	 */
+	if (notify == NFY_MOUNT) {
+		/*
+		 * If the dentry isn't hashed just go ahead and try the
+		 * mount again with a new wait (not much else we can do).
+		*/
+		if (!d_unhashed(dentry)) {
+			/*
+			 * But if the dentry is hashed, that means that we
+			 * got here through the revalidate path.  Thus, we
+			 * need to check if the dentry has been mounted
+			 * while we waited on the wq_mutex. If it has,
+			 * simply return success.
+			 */
+			if (d_mountpoint(dentry))
+				return 0;
+		}
+	}
+
+	return 1;
+}
+
 int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		enum autofs_notify notify)
 {
-	struct autofs_info *ino;
 	struct autofs_wait_queue *wq;
 	struct qstr qstr;
 	char *name;
-	int status, type;
+	int status, ret, type;
 
 	/* In catatonic mode, we don't wait for nobody */
 	if (sbi->catatonic)
 		return -ENOENT;
-	
+
 	name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
 	if (!name)
 		return -ENOMEM;
@@ -237,43 +324,15 @@ int autofs4_wait(struct autofs_sb_info *
 	qstr.name = name;
 	qstr.hash = full_name_hash(name, qstr.len);
 
-	if (mutex_lock_interruptible(&sbi->wq_mutex)) {
-		kfree(qstr.name);
+	if (mutex_lock_interruptible(&sbi->wq_mutex))
 		return -EINTR;
-	}
 
-	wq = autofs4_find_wait(sbi, &qstr);
-	ino = autofs4_dentry_ino(dentry);
-	if (!wq && ino && notify == NFY_NONE) {
-		/*
-		 * Either we've betean the pending expire to post it's
-		 * wait or it finished while we waited on the mutex.
-		 * So we need to wait till either, the wait appears
-		 * or the expire finishes.
-		 */
-
-		while (ino->flags & AUTOFS_INF_EXPIRING) {
+	ret = validate_request(&wq, sbi, &qstr, dentry, notify);
+	if (ret <= 0) {
+		if (ret == 0)
 			mutex_unlock(&sbi->wq_mutex);
-			schedule_timeout_interruptible(HZ/10);
-			if (mutex_lock_interruptible(&sbi->wq_mutex)) {
-				kfree(qstr.name);
-				return -EINTR;
-			}
-			wq = autofs4_find_wait(sbi, &qstr);
-			if (wq)
-				break;
-		}
-
-		/*
-		 * Not ideal but the status has already gone. Of the two
-		 * cases where we wait on NFY_NONE neither depend on the
-		 * return status of the wait.
-		 */
-		if (!wq) {
-			kfree(qstr.name);
-			mutex_unlock(&sbi->wq_mutex);
-			return 0;
-		}
+		kfree(qstr.name);
+		return ret;
 	}
 
 	if (!wq) {
@@ -391,9 +450,9 @@ int autofs4_wait_release(struct autofs_s
 	}
 
 	*wql = wq->next;	/* Unlink from chain */
-	mutex_unlock(&sbi->wq_mutex);
 	kfree(wq->name.name);
 	wq->name.name = NULL;	/* Do not wait on this queue */
+	mutex_unlock(&sbi->wq_mutex);
 
 	wq->status = status;
 
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-dont-make-expiring-dentry-negative.patch
autofs4-revert-redo-lookup-in-ttfd.patch
autofs4-use-look-aside-list-for-lookups.patch
autofs4-dont-release-directory-mutex-if-called-in-oz_mode.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts.patch
autofs4-use-struct-qstr-in-waitqc.patch
autofs4-fix-pending-mount-race.patch

