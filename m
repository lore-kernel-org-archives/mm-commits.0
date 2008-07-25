From: akpm@linux-foundation.org
Subject: - reiserfs-convert-j_lock-to-mutex.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:14 -0700
Message-ID: <200807252257.m6PMvE8L003165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbYGYXHp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, chris.mason@oracle.com, edward.shishkin@gmail.com, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     reiserfs: convert j_lock to mutex
has been removed from the -mm tree.  Its filename was
     reiserfs-convert-j_lock-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: convert j_lock to mutex
From: Jeff Mahoney <jeffm@suse.com>

j_lock is a semaphore but uses it as if it were a mutex.  This patch converts
it to a mutex.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/journal.c          |    6 +++---
 include/linux/reiserfs_fs_sb.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/reiserfs/journal.c~reiserfs-convert-j_lock-to-mutex fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~reiserfs-convert-j_lock-to-mutex
+++ a/fs/reiserfs/journal.c
@@ -558,13 +558,13 @@ static inline void insert_journal_hash(s
 static inline void lock_journal(struct super_block *p_s_sb)
 {
 	PROC_INFO_INC(p_s_sb, journal.lock_journal);
-	down(&SB_JOURNAL(p_s_sb)->j_lock);
+	mutex_lock(&SB_JOURNAL(p_s_sb)->j_mutex);
 }
 
 /* unlock the current transaction */
 static inline void unlock_journal(struct super_block *p_s_sb)
 {
-	up(&SB_JOURNAL(p_s_sb)->j_lock);
+	mutex_unlock(&SB_JOURNAL(p_s_sb)->j_mutex);
 }
 
 static inline void get_journal_list(struct reiserfs_journal_list *jl)
@@ -2837,7 +2837,7 @@ int journal_init(struct super_block *p_s
 	journal->j_last = NULL;
 	journal->j_first = NULL;
 	init_waitqueue_head(&(journal->j_join_wait));
-	sema_init(&journal->j_lock, 1);
+	mutex_init(&journal->j_mutex);
 	sema_init(&journal->j_flush_sem, 1);
 
 	journal->j_trans_id = 10;
diff -puN include/linux/reiserfs_fs_sb.h~reiserfs-convert-j_lock-to-mutex include/linux/reiserfs_fs_sb.h
--- a/include/linux/reiserfs_fs_sb.h~reiserfs-convert-j_lock-to-mutex
+++ a/include/linux/reiserfs_fs_sb.h
@@ -193,7 +193,7 @@ struct reiserfs_journal {
 	struct buffer_head *j_header_bh;
 
 	time_t j_trans_start_time;	/* time this transaction started */
-	struct semaphore j_lock;
+	struct mutex j_mutex;
 	struct semaphore j_flush_sem;
 	wait_queue_head_t j_join_wait;	/* wait for current transaction to finish before starting new one */
 	atomic_t j_jlock;	/* lock for j_join_wait */
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch

