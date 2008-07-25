From: akpm@linux-foundation.org
Subject: - reiserfs-convert-j_commit_lock-to-mutex.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:19 -0700
Message-ID: <200807252257.m6PMvJnj003175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755209AbYGYXHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, chris.mason@oracle.com, edward.shishkin@gmail.com, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     reiserfs: convert j_commit_lock to mutex
has been removed from the -mm tree.  Its filename was
     reiserfs-convert-j_commit_lock-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: convert j_commit_lock to mutex
From: Jeff Mahoney <jeffm@suse.com>

j_commit_lock is a semaphore but uses it as if it were a mutex.  This patch
converts it to a mutex.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/journal.c          |   22 ++++++++++------------
 include/linux/reiserfs_fs_sb.h |    2 +-
 2 files changed, 11 insertions(+), 13 deletions(-)

diff -puN fs/reiserfs/journal.c~reiserfs-convert-j_commit_lock-to-mutex fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~reiserfs-convert-j_commit_lock-to-mutex
+++ a/fs/reiserfs/journal.c
@@ -34,15 +34,10 @@
 **		        from within kupdate, it will ignore the immediate flag
 */
 
-#include <asm/uaccess.h>
-#include <asm/system.h>
-
 #include <linux/time.h>
 #include <linux/semaphore.h>
-
 #include <linux/vmalloc.h>
 #include <linux/reiserfs_fs.h>
-
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/fcntl.h>
@@ -54,6 +49,9 @@
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
+#include <linux/uaccess.h>
+
+#include <asm/system.h>
 
 /* gets a struct reiserfs_journal_list * from a list head */
 #define JOURNAL_LIST_ENTRY(h) (list_entry((h), struct reiserfs_journal_list, \
@@ -1045,9 +1043,9 @@ static int flush_commit_list(struct supe
 	}
 
 	/* make sure nobody is trying to flush this one at the same time */
-	down(&jl->j_commit_lock);
+	mutex_lock(&jl->j_commit_mutex);
 	if (!journal_list_still_alive(s, trans_id)) {
-		up(&jl->j_commit_lock);
+		mutex_unlock(&jl->j_commit_mutex);
 		goto put_jl;
 	}
 	BUG_ON(jl->j_trans_id == 0);
@@ -1057,7 +1055,7 @@ static int flush_commit_list(struct supe
 		if (flushall) {
 			atomic_set(&(jl->j_older_commits_done), 1);
 		}
-		up(&jl->j_commit_lock);
+		mutex_unlock(&jl->j_commit_mutex);
 		goto put_jl;
 	}
 
@@ -1181,7 +1179,7 @@ static int flush_commit_list(struct supe
 	if (flushall) {
 		atomic_set(&(jl->j_older_commits_done), 1);
 	}
-	up(&jl->j_commit_lock);
+	mutex_unlock(&jl->j_commit_mutex);
       put_jl:
 	put_journal_list(s, jl);
 
@@ -2556,7 +2554,7 @@ static struct reiserfs_journal_list *all
 	INIT_LIST_HEAD(&jl->j_working_list);
 	INIT_LIST_HEAD(&jl->j_tail_bh_list);
 	INIT_LIST_HEAD(&jl->j_bh_list);
-	sema_init(&jl->j_commit_lock, 1);
+	mutex_init(&jl->j_commit_mutex);
 	SB_JOURNAL(s)->j_num_lists++;
 	get_journal_list(jl);
 	return jl;
@@ -4030,7 +4028,7 @@ static int do_journal_end(struct reiserf
 	 * the new transaction is fully setup, and we've already flushed the
 	 * ordered bh list
 	 */
-	down(&jl->j_commit_lock);
+	mutex_lock(&jl->j_commit_mutex);
 
 	/* save the transaction id in case we need to commit it later */
 	commit_trans_id = jl->j_trans_id;
@@ -4196,7 +4194,7 @@ static int do_journal_end(struct reiserf
 		lock_kernel();
 	}
 	BUG_ON(!list_empty(&jl->j_tail_bh_list));
-	up(&jl->j_commit_lock);
+	mutex_unlock(&jl->j_commit_mutex);
 
 	/* honor the flush wishes from the caller, simple commits can
 	 ** be done outside the journal lock, they are done below
diff -puN include/linux/reiserfs_fs_sb.h~reiserfs-convert-j_commit_lock-to-mutex include/linux/reiserfs_fs_sb.h
--- a/include/linux/reiserfs_fs_sb.h~reiserfs-convert-j_commit_lock-to-mutex
+++ a/include/linux/reiserfs_fs_sb.h
@@ -152,7 +152,7 @@ struct reiserfs_journal_list {
 	atomic_t j_nonzerolen;
 	atomic_t j_commit_left;
 	atomic_t j_older_commits_done;	/* all commits older than this on disk */
-	struct semaphore j_commit_lock;
+	struct mutex j_commit_mutex;
 	unsigned long j_trans_id;
 	time_t j_timestamp;
 	struct reiserfs_list_bitmap *j_list_bitmap;
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch

