From: akpm@linux-foundation.org
Subject: + reiserfs-convert-j_flush_sem-to-mutex.patch added to -mm tree
Date: Wed, 07 May 2008 12:41:21 -0700
Message-ID: <200805071941.m47JfL0Z013206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756362AbYEGTmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 15:42:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, chris.mason@oracle.com, edward.shishkin@gmail.com, matthew@wil.cx


The patch titled
     reiserfs: convert j_flush_sem to mutex
has been added to the -mm tree.  Its filename is
     reiserfs-convert-j_flush_sem-to-mutex.patch

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
Subject: reiserfs: convert j_flush_sem to mutex
From: Jeff Mahoney <jeffm@suse.com>

j_flush_sem is a semaphore but uses it as if it were a mutex.  This patch
converts it to a mutex.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/journal.c          |   14 +++++++-------
 include/linux/reiserfs_fs_sb.h |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/reiserfs/journal.c~reiserfs-convert-j_flush_sem-to-mutex fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~reiserfs-convert-j_flush_sem-to-mutex
+++ a/fs/reiserfs/journal.c
@@ -1411,8 +1411,8 @@ static int flush_journal_list(struct sup
 
 	/* if flushall == 0, the lock is already held */
 	if (flushall) {
-		down(&journal->j_flush_sem);
-	} else if (down_nowait(&journal->j_flush_sem)) {
+		mutex_lock(&journal->j_flush_mutex);
+	} else if (!mutex_trylock(&journal->j_flush_mutex)) {
 		BUG();
 	}
 
@@ -1642,7 +1642,7 @@ static int flush_journal_list(struct sup
 	jl->j_state = 0;
 	put_journal_list(s, jl);
 	if (flushall)
-		up(&journal->j_flush_sem);
+		mutex_unlock(&journal->j_flush_mutex);
 	put_fs_excl();
 	return err;
 }
@@ -1772,12 +1772,12 @@ static int kupdate_transactions(struct s
 	struct reiserfs_journal *journal = SB_JOURNAL(s);
 	chunk.nr = 0;
 
-	down(&journal->j_flush_sem);
+	mutex_lock(&journal->j_flush_mutex);
 	if (!journal_list_still_alive(s, orig_trans_id)) {
 		goto done;
 	}
 
-	/* we've got j_flush_sem held, nobody is going to delete any
+	/* we've got j_flush_mutex held, nobody is going to delete any
 	 * of these lists out from underneath us
 	 */
 	while ((num_trans && transactions_flushed < num_trans) ||
@@ -1812,7 +1812,7 @@ static int kupdate_transactions(struct s
 	}
 
       done:
-	up(&journal->j_flush_sem);
+	mutex_unlock(&journal->j_flush_mutex);
 	return ret;
 }
 
@@ -2838,7 +2838,7 @@ int journal_init(struct super_block *p_s
 	journal->j_first = NULL;
 	init_waitqueue_head(&(journal->j_join_wait));
 	mutex_init(&journal->j_mutex);
-	sema_init(&journal->j_flush_sem, 1);
+	mutex_init(&journal->j_flush_mutex);
 
 	journal->j_trans_id = 10;
 	journal->j_mount_id = 10;
diff -puN include/linux/reiserfs_fs_sb.h~reiserfs-convert-j_flush_sem-to-mutex include/linux/reiserfs_fs_sb.h
--- a/include/linux/reiserfs_fs_sb.h~reiserfs-convert-j_flush_sem-to-mutex
+++ a/include/linux/reiserfs_fs_sb.h
@@ -194,7 +194,7 @@ struct reiserfs_journal {
 
 	time_t j_trans_start_time;	/* time this transaction started */
 	struct mutex j_mutex;
-	struct semaphore j_flush_sem;
+	struct mutex j_flush_mutex;
 	wait_queue_head_t j_join_wait;	/* wait for current transaction to finish before starting new one */
 	atomic_t j_jlock;	/* lock for j_join_wait */
 	int j_list_bitmap_index;	/* number of next list bitmap to use */
_

Patches currently in -mm which might be from jeffm@suse.com are

reiserfs-convert-j_lock-to-mutex.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex.patch

