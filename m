From: akpm@linux-foundation.org
Subject: - kcopyd-use-mutex-instead-of-semaphore.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:11:43 -0700
Message-ID: <200708201911.l7KJBhxP018281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35436 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697AbXHTTMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:12:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Kcopyd: use mutex instead of semaphore
has been removed from the -mm tree.  Its filename was
     kcopyd-use-mutex-instead-of-semaphore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Kcopyd: use mutex instead of semaphore
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Kcopyd uses a semaphore as mutex.  Use the mutex API instead of the (binary)
semaphore,

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Acked-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/kcopyd.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/md/kcopyd.c~kcopyd-use-mutex-instead-of-semaphore drivers/md/kcopyd.c
--- a/drivers/md/kcopyd.c~kcopyd-use-mutex-instead-of-semaphore
+++ a/drivers/md/kcopyd.c
@@ -198,7 +198,7 @@ struct kcopyd_job {
 	 * These fields are only used if the job has been split
 	 * into more manageable parts.
 	 */
-	struct semaphore lock;
+	struct mutex lock;
 	atomic_t sub_jobs;
 	sector_t progress;
 };
@@ -456,7 +456,7 @@ static void segment_complete(int read_er
 	sector_t count = 0;
 	struct kcopyd_job *job = (struct kcopyd_job *) context;
 
-	down(&job->lock);
+	mutex_lock(&job->lock);
 
 	/* update the error */
 	if (read_err)
@@ -480,7 +480,7 @@ static void segment_complete(int read_er
 			job->progress += count;
 		}
 	}
-	up(&job->lock);
+	mutex_unlock(&job->lock);
 
 	if (count) {
 		int i;
@@ -562,7 +562,7 @@ int kcopyd_copy(struct kcopyd_client *kc
 		dispatch_job(job);
 
 	else {
-		init_MUTEX(&job->lock);
+		mutex_init(&job->lock);
 		job->progress = 0;
 		split_job(job);
 	}
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

git-dvb.patch
git-mtd.patch
git-netdev-all.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
