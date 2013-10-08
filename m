From: akpm@linux-foundation.org
Subject: + writeback-do-not-sync-data-dirtied-after-sync-start.patch added to -mm tree
Date: Tue, 08 Oct 2013 15:14:32 -0700
Message-ID: <525483c8.fvjW6uRIsqF9GggY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3JHWOd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Oct 2013 18:14:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, dchinner@redhat.com, jack@suse.cz

Subject: + writeback-do-not-sync-data-dirtied-after-sync-start.patch added to -mm tree
To: jack@suse.cz,dchinner@redhat.com,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Tue, 08 Oct 2013 15:14:32 -0700


The patch titled
     Subject: writeback: do not sync data dirtied after sync start
has been added to the -mm tree.  Its filename is
     writeback-do-not-sync-data-dirtied-after-sync-start.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-do-not-sync-data-dirtied-after-sync-start.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-do-not-sync-data-dirtied-after-sync-start.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: writeback: do not sync data dirtied after sync start

When there are processes heavily creating small files while sync(2) is
running, it can easily happen that quite some new files are created
between WB_SYNC_NONE and WB_SYNC_ALL pass of sync(2).  That can happen
especially if there are several busy filesystems (remember that sync
traverses filesystems sequentially and waits in WB_SYNC_ALL phase on one
fs before starting it on another fs).  Because WB_SYNC_ALL pass is slow
(e.g.  causes a transaction commit and cache flush for each inode in
ext3), resulting sync(2) times are rather large.

The following script reproduces the problem:

function run_writers
{
  for (( i = 0; i < 10; i++ )); do
    mkdir $1/dir$i
    for (( j = 0; j < 40000; j++ )); do
      dd if=/dev/zero of=$1/dir$i/$j bs=4k count=4 &>/dev/null
    done &
  done
}

for dir in "$@"; do
  run_writers $dir
done

sleep 40
time sync
======

Fix the problem by disregarding inodes dirtied after sync(2) was called in
the WB_SYNC_ALL pass.  To allow for this, sync_inodes_sb() now takes a
time stamp when sync has started which is used for setting up work for
flusher threads.

To give some numbers, when above script is run on two ext4 filesystems on
simple SATA drive, the average sync time from 10 runs is 267.549 seconds
with standard deviation 104.799426.  With the patched kernel, the average
sync time from 10 runs is 2.995 seconds with standard deviation 0.096.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c                |   17 ++++++++---------
 fs/sync.c                        |   15 +++++++++------
 fs/xfs/xfs_super.c               |    2 +-
 include/linux/writeback.h        |    2 +-
 include/trace/events/writeback.h |    6 +++---
 5 files changed, 22 insertions(+), 20 deletions(-)

diff -puN fs/fs-writeback.c~writeback-do-not-sync-data-dirtied-after-sync-start fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-do-not-sync-data-dirtied-after-sync-start
+++ a/fs/fs-writeback.c
@@ -39,7 +39,7 @@
 struct wb_writeback_work {
 	long nr_pages;
 	struct super_block *sb;
-	unsigned long *older_than_this;
+	unsigned long older_than_this;
 	enum writeback_sync_modes sync_mode;
 	unsigned int tagged_writepages:1;
 	unsigned int for_kupdate:1;
@@ -248,8 +248,7 @@ static int move_expired_inodes(struct li
 
 	while (!list_empty(delaying_queue)) {
 		inode = wb_inode(delaying_queue->prev);
-		if (work->older_than_this &&
-		    inode_dirtied_after(inode, *work->older_than_this))
+		if (inode_dirtied_after(inode, work->older_than_this))
 			break;
 		list_move(&inode->i_wb_list, &tmp);
 		moved++;
@@ -791,12 +790,11 @@ static long wb_writeback(struct bdi_writ
 {
 	unsigned long wb_start = jiffies;
 	long nr_pages = work->nr_pages;
-	unsigned long oldest_jif;
 	struct inode *inode;
 	long progress;
 
-	oldest_jif = jiffies;
-	work->older_than_this = &oldest_jif;
+	if (!work->older_than_this)
+		work->older_than_this = jiffies;
 
 	spin_lock(&wb->list_lock);
 	for (;;) {
@@ -830,10 +828,10 @@ static long wb_writeback(struct bdi_writ
 		 * safe.
 		 */
 		if (work->for_kupdate) {
-			oldest_jif = jiffies -
+			work->older_than_this = jiffies -
 				msecs_to_jiffies(dirty_expire_interval * 10);
 		} else if (work->for_background)
-			oldest_jif = jiffies;
+			work->older_than_this = jiffies;
 
 		trace_writeback_start(wb->bdi, work);
 		if (list_empty(&wb->b_io))
@@ -1350,13 +1348,14 @@ EXPORT_SYMBOL(try_to_writeback_inodes_sb
  * This function writes and waits on any dirty inode belonging to this
  * super_block.
  */
-void sync_inodes_sb(struct super_block *sb)
+void sync_inodes_sb(struct super_block *sb, unsigned long older_than_this)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	struct wb_writeback_work work = {
 		.sb		= sb,
 		.sync_mode	= WB_SYNC_ALL,
 		.nr_pages	= LONG_MAX,
+		.older_than_this = older_than_this,
 		.range_cyclic	= 0,
 		.done		= &done,
 		.reason		= WB_REASON_SYNC,
diff -puN fs/sync.c~writeback-do-not-sync-data-dirtied-after-sync-start fs/sync.c
--- a/fs/sync.c~writeback-do-not-sync-data-dirtied-after-sync-start
+++ a/fs/sync.c
@@ -27,10 +27,11 @@
  * wait == 1 case since in that case write_inode() functions do
  * sync_dirty_buffer() and thus effectively write one block at a time.
  */
-static int __sync_filesystem(struct super_block *sb, int wait)
+static int __sync_filesystem(struct super_block *sb, int wait,
+			     unsigned long start)
 {
 	if (wait)
-		sync_inodes_sb(sb);
+		sync_inodes_sb(sb, start);
 	else
 		writeback_inodes_sb(sb, WB_REASON_SYNC);
 
@@ -47,6 +48,7 @@ static int __sync_filesystem(struct supe
 int sync_filesystem(struct super_block *sb)
 {
 	int ret;
+	unsigned long start = jiffies;
 
 	/*
 	 * We need to be protected against the filesystem going from
@@ -60,17 +62,17 @@ int sync_filesystem(struct super_block *
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
-	ret = __sync_filesystem(sb, 0);
+	ret = __sync_filesystem(sb, 0, start);
 	if (ret < 0)
 		return ret;
-	return __sync_filesystem(sb, 1);
+	return __sync_filesystem(sb, 1, start);
 }
 EXPORT_SYMBOL_GPL(sync_filesystem);
 
 static void sync_inodes_one_sb(struct super_block *sb, void *arg)
 {
 	if (!(sb->s_flags & MS_RDONLY))
-		sync_inodes_sb(sb);
+		sync_inodes_sb(sb, *((unsigned long *)arg));
 }
 
 static void sync_fs_one_sb(struct super_block *sb, void *arg)
@@ -102,9 +104,10 @@ static void fdatawait_one_bdev(struct bl
 SYSCALL_DEFINE0(sync)
 {
 	int nowait = 0, wait = 1;
+	unsigned long start = jiffies;
 
 	wakeup_flusher_threads(0, WB_REASON_SYNC);
-	iterate_supers(sync_inodes_one_sb, NULL);
+	iterate_supers(sync_inodes_one_sb, &start);
 	iterate_supers(sync_fs_one_sb, &nowait);
 	iterate_supers(sync_fs_one_sb, &wait);
 	iterate_bdevs(fdatawrite_one_bdev, NULL);
diff -puN fs/xfs/xfs_super.c~writeback-do-not-sync-data-dirtied-after-sync-start fs/xfs/xfs_super.c
--- a/fs/xfs/xfs_super.c~writeback-do-not-sync-data-dirtied-after-sync-start
+++ a/fs/xfs/xfs_super.c
@@ -918,7 +918,7 @@ xfs_flush_inodes(
 	struct super_block	*sb = mp->m_super;
 
 	if (down_read_trylock(&sb->s_umount)) {
-		sync_inodes_sb(sb);
+		sync_inodes_sb(sb, jiffies);
 		up_read(&sb->s_umount);
 	}
 }
diff -puN include/linux/writeback.h~writeback-do-not-sync-data-dirtied-after-sync-start include/linux/writeback.h
--- a/include/linux/writeback.h~writeback-do-not-sync-data-dirtied-after-sync-start
+++ a/include/linux/writeback.h
@@ -97,7 +97,7 @@ void writeback_inodes_sb_nr(struct super
 int try_to_writeback_inodes_sb(struct super_block *, enum wb_reason reason);
 int try_to_writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
 				  enum wb_reason reason);
-void sync_inodes_sb(struct super_block *);
+void sync_inodes_sb(struct super_block *sb, unsigned long older_than_this);
 void wakeup_flusher_threads(long nr_pages, enum wb_reason reason);
 void inode_wait_for_writeback(struct inode *inode);
 
diff -puN include/trace/events/writeback.h~writeback-do-not-sync-data-dirtied-after-sync-start include/trace/events/writeback.h
--- a/include/trace/events/writeback.h~writeback-do-not-sync-data-dirtied-after-sync-start
+++ a/include/trace/events/writeback.h
@@ -287,11 +287,11 @@ TRACE_EVENT(writeback_queue_io,
 		__field(int,		reason)
 	),
 	TP_fast_assign(
-		unsigned long *older_than_this = work->older_than_this;
+		unsigned long older_than_this = work->older_than_this;
 		strncpy(__entry->name, dev_name(wb->bdi->dev), 32);
-		__entry->older	= older_than_this ?  *older_than_this : 0;
+		__entry->older	= older_than_this;
 		__entry->age	= older_than_this ?
-				  (jiffies - *older_than_this) * 1000 / HZ : -1;
+				  (jiffies - older_than_this) * 1000 / HZ : -1;
 		__entry->moved	= moved;
 		__entry->reason	= work->reason;
 	),
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-dont-spam-on-edquot.patch
writeback-do-not-sync-data-dirtied-after-sync-start.patch
linux-next.patch

