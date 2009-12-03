From: akpm@linux-foundation.org
Subject: + task_struct-make-journal_info-conditional.patch added to -mm tree
Date: Thu, 03 Dec 2009 14:40:57 -0800
Message-ID: <200912032240.nB3Mevae027408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbZLCWla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 17:41:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: h-shimamoto@ct.jp.nec.com, chris.mason@oracle.com, konishi.ryusuke@lab.ntt.co.jp, swhiteho@redhat.com, tytso@mit.edu


The patch titled
     task_struct: make journal_info conditional
has been added to the -mm tree.  Its filename is
     task_struct-make-journal_info-conditional.patch

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
Subject: task_struct: make journal_info conditional
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

journal_info in task_struct is used in journaling file system only.  So
introduce CONFIG_FS_JOURNAL_INFO and make it conditional.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig                |    4 ++++
 fs/btrfs/Kconfig          |    1 +
 fs/ext4/Kconfig           |    1 +
 fs/gfs2/Kconfig           |    1 +
 fs/jbd/Kconfig            |    1 +
 fs/jbd2/Kconfig           |    1 +
 fs/nilfs2/Kconfig         |    1 +
 fs/reiserfs/Kconfig       |    1 +
 include/linux/init_task.h |    8 +++++++-
 include/linux/sched.h     |    2 ++
 10 files changed, 20 insertions(+), 1 deletion(-)

diff -puN fs/Kconfig~task_struct-make-journal_info-conditional fs/Kconfig
--- a/fs/Kconfig~task_struct-make-journal_info-conditional
+++ a/fs/Kconfig
@@ -6,6 +6,10 @@ menu "File systems"
 
 if BLOCK
 
+config FS_JOURNAL_INFO
+	bool
+	default n
+
 source "fs/ext2/Kconfig"
 source "fs/ext3/Kconfig"
 source "fs/ext4/Kconfig"
diff -puN fs/btrfs/Kconfig~task_struct-make-journal_info-conditional fs/btrfs/Kconfig
--- a/fs/btrfs/Kconfig~task_struct-make-journal_info-conditional
+++ a/fs/btrfs/Kconfig
@@ -4,6 +4,7 @@ config BTRFS_FS
 	select LIBCRC32C
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
+	select FS_JOURNAL_INFO
 	help
 	  Btrfs is a new filesystem with extents, writable snapshotting,
 	  support for multiple devices and many more features.
diff -puN fs/ext4/Kconfig~task_struct-make-journal_info-conditional fs/ext4/Kconfig
--- a/fs/ext4/Kconfig~task_struct-make-journal_info-conditional
+++ a/fs/ext4/Kconfig
@@ -2,6 +2,7 @@ config EXT4_FS
 	tristate "The Extended 4 (ext4) filesystem"
 	select JBD2
 	select CRC16
+	select FS_JOURNAL_INFO
 	help
 	  This is the next generation of the ext3 filesystem.
 
diff -puN fs/gfs2/Kconfig~task_struct-make-journal_info-conditional fs/gfs2/Kconfig
--- a/fs/gfs2/Kconfig~task_struct-make-journal_info-conditional
+++ a/fs/gfs2/Kconfig
@@ -10,6 +10,7 @@ config GFS2_FS
 	select SLOW_WORK
 	select QUOTA
 	select QUOTACTL
+	select FS_JOURNAL_INFO
 	help
 	  A cluster filesystem.
 
diff -puN fs/jbd/Kconfig~task_struct-make-journal_info-conditional fs/jbd/Kconfig
--- a/fs/jbd/Kconfig~task_struct-make-journal_info-conditional
+++ a/fs/jbd/Kconfig
@@ -1,5 +1,6 @@
 config JBD
 	tristate
+	select FS_JOURNAL_INFO
 	help
 	  This is a generic journalling layer for block devices.  It is
 	  currently used by the ext3 file system, but it could also be
diff -puN fs/jbd2/Kconfig~task_struct-make-journal_info-conditional fs/jbd2/Kconfig
--- a/fs/jbd2/Kconfig~task_struct-make-journal_info-conditional
+++ a/fs/jbd2/Kconfig
@@ -1,6 +1,7 @@
 config JBD2
 	tristate
 	select CRC32
+	select FS_JOURNAL_INFO
 	help
 	  This is a generic journaling layer for block devices that support
 	  both 32-bit and 64-bit block numbers.  It is currently used by
diff -puN fs/nilfs2/Kconfig~task_struct-make-journal_info-conditional fs/nilfs2/Kconfig
--- a/fs/nilfs2/Kconfig~task_struct-make-journal_info-conditional
+++ a/fs/nilfs2/Kconfig
@@ -2,6 +2,7 @@ config NILFS2_FS
 	tristate "NILFS2 file system support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	select CRC32
+	select FS_JOURNAL_INFO
 	help
 	  NILFS2 is a log-structured file system (LFS) supporting continuous
 	  snapshotting.  In addition to versioning capability of the entire
diff -puN fs/reiserfs/Kconfig~task_struct-make-journal_info-conditional fs/reiserfs/Kconfig
--- a/fs/reiserfs/Kconfig~task_struct-make-journal_info-conditional
+++ a/fs/reiserfs/Kconfig
@@ -1,6 +1,7 @@
 config REISERFS_FS
 	tristate "Reiserfs support"
 	select CRC32
+	select FS_JOURNAL_INFO
 	help
 	  Stores not just filenames but the files themselves in a balanced
 	  tree.  Uses journalling.
diff -puN include/linux/init_task.h~task_struct-make-journal_info-conditional include/linux/init_task.h
--- a/include/linux/init_task.h~task_struct-make-journal_info-conditional
+++ a/include/linux/init_task.h
@@ -111,6 +111,12 @@ extern struct cred init_cred;
 # define INIT_PERF_EVENTS(tsk)
 #endif
 
+#ifdef CONFIG_FS_JOURNAL_INFO
+#define INIT_JOURNAL_INFO	.journal_info = NULL,
+#else
+#define INIT_JOURNAL_INFO
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -162,7 +168,6 @@ extern struct cred init_cred;
 		.signal = {{0}}},					\
 	.blocked	= {{0}},					\
 	.alloc_lock	= __SPIN_LOCK_UNLOCKED(tsk.alloc_lock),		\
-	.journal_info	= NULL,						\
 	.cpu_timers	= INIT_CPU_TIMERS(tsk.cpu_timers),		\
 	.fs_excl	= ATOMIC_INIT(0),				\
 	.pi_lock	= __SPIN_LOCK_UNLOCKED(tsk.pi_lock),		\
@@ -173,6 +178,7 @@ extern struct cred init_cred;
 		[PIDTYPE_SID]  = INIT_PID_LINK(PIDTYPE_SID),		\
 	},								\
 	.dirties = INIT_PROP_LOCAL_SINGLE(dirties),			\
+	INIT_JOURNAL_INFO						\
 	INIT_IDS							\
 	INIT_PERF_EVENTS(tsk)						\
 	INIT_TRACE_IRQFLAGS						\
diff -puN include/linux/sched.h~task_struct-make-journal_info-conditional include/linux/sched.h
--- a/include/linux/sched.h~task_struct-make-journal_info-conditional
+++ a/include/linux/sched.h
@@ -1452,8 +1452,10 @@ struct task_struct {
 	gfp_t lockdep_reclaim_gfp;
 #endif
 
+#ifdef CONFIG_FS_JOURNAL_INFO
 /* journalling filesystem info */
 	void *journal_info;
+#endif
 
 /* stacked block device info */
 	struct bio *bio_list, **bio_tail;
_

Patches currently in -mm which might be from h-shimamoto@ct.jp.nec.com are

linux-next.patch
kernelh-add-printk_ratelimited-and-pr_level_rl.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
task_struct-make-journal_info-conditional.patch

