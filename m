From: akpm@linux-foundation.org
Subject: + quota-split-out-quota_structh-out-of-quotah.patch added to -mm tree
Date: Tue, 03 Jun 2008 16:18:49 -0700
Message-ID: <200806032318.m53NInCW025113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289AbYFCXSy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 19:18:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     quota: split out quota_struct.h out of quota.h
has been added to the -mm tree.  Its filename is
     quota-split-out-quota_structh-out-of-quotah.patch

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
Subject: quota: split out quota_struct.h out of quota.h
From: Jan Kara <jack@suse.cz>

Split some structure definitions from quota.h to quota_struct.h so that
they can be separately included in fs.h.  This makes it possible to
declare some useful inline functions in quota.h because it can now include
fs.h.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h       |    2 
 include/linux/quota.h    |  193 -------------------------------------
 include/linux/quotaops.h |    1 
 include/linux/syscalls.h |    2 
 4 files changed, 5 insertions(+), 193 deletions(-)

diff -puN include/linux/fs.h~quota-split-out-quota_structh-out-of-quotah include/linux/fs.h
--- a/include/linux/fs.h~quota-split-out-quota_structh-out-of-quotah
+++ a/include/linux/fs.h
@@ -369,7 +369,7 @@ struct iattr {
 /*
  * Includes for diskquotas.
  */
-#include <linux/quota.h>
+#include <linux/quota_struct.h>
 
 /** 
  * enum positive_aop_returns - aop return codes with specific semantics
diff -puN include/linux/quota.h~quota-split-out-quota_structh-out-of-quotah include/linux/quota.h
--- a/include/linux/quota.h~quota-split-out-quota_structh-out-of-quotah
+++ a/include/linux/quota.h
@@ -37,13 +37,11 @@
 
 #include <linux/errno.h>
 #include <linux/types.h>
+#include <linux/quota_struct.h>
 
 #define __DQUOT_VERSION__	"dquot_6.5.1"
 #define __DQUOT_NUM_VERSION__	6*10000+5*100+1
 
-typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
-typedef __u64 qsize_t;          /* Type in which we store sizes */
-
 /* Size of blocks in which are counted size limits */
 #define QUOTABLOCK_BITS 10
 #define QUOTABLOCK_SIZE (1 << QUOTABLOCK_BITS)
@@ -53,10 +51,6 @@ typedef __u64 qsize_t;          /* Type 
 #define kb2qb(x) ((x) >> (QUOTABLOCK_BITS-10))
 #define toqb(x) (((x) + QUOTABLOCK_SIZE - 1) >> QUOTABLOCK_BITS)
 
-#define MAXQUOTAS 2
-#define USRQUOTA  0		/* element used for user quotas */
-#define GRPQUOTA  1		/* element used for group quotas */
-
 /*
  * Definitions for the default names of the quotas files.
  */
@@ -86,49 +80,6 @@ typedef __u64 qsize_t;          /* Type 
 #define Q_SETQUOTA 0x800008	/* set user quota structure */
 
 /*
- * Quota structure used for communication with userspace via quotactl
- * Following flags are used to specify which fields are valid
- */
-#define QIF_BLIMITS	1
-#define QIF_SPACE	2
-#define QIF_ILIMITS	4
-#define QIF_INODES	8
-#define QIF_BTIME	16
-#define QIF_ITIME	32
-#define QIF_LIMITS	(QIF_BLIMITS | QIF_ILIMITS)
-#define QIF_USAGE	(QIF_SPACE | QIF_INODES)
-#define QIF_TIMES	(QIF_BTIME | QIF_ITIME)
-#define QIF_ALL		(QIF_LIMITS | QIF_USAGE | QIF_TIMES)
-
-struct if_dqblk {
-	__u64 dqb_bhardlimit;
-	__u64 dqb_bsoftlimit;
-	__u64 dqb_curspace;
-	__u64 dqb_ihardlimit;
-	__u64 dqb_isoftlimit;
-	__u64 dqb_curinodes;
-	__u64 dqb_btime;
-	__u64 dqb_itime;
-	__u32 dqb_valid;
-};
-
-/*
- * Structure used for setting quota information about file via quotactl
- * Following flags are used to specify which fields are valid
- */
-#define IIF_BGRACE	1
-#define IIF_IGRACE	2
-#define IIF_FLAGS	4
-#define IIF_ALL		(IIF_BGRACE | IIF_IGRACE | IIF_FLAGS)
-
-struct if_dqinfo {
-	__u64 dqi_bgrace;
-	__u64 dqi_igrace;
-	__u32 dqi_flags;
-	__u32 dqi_valid;
-};
-
-/*
  * Definitions for quota netlink interface
  */
 #define QUOTA_NL_NOWARN 0
@@ -160,15 +111,7 @@ enum {
 
 
 #ifdef __KERNEL__
-#include <linux/list.h>
-#include <linux/mutex.h>
-#include <linux/rwsem.h>
 #include <linux/spinlock.h>
-#include <linux/wait.h>
-
-#include <linux/dqblk_xfs.h>
-#include <linux/dqblk_v1.h>
-#include <linux/dqblk_v2.h>
 
 #include <asm/atomic.h>
 
@@ -181,48 +124,7 @@ extern spinlock_t dq_data_lock;
 #define DQUOT_DEL_ALLOC max(V1_DEL_ALLOC, V2_DEL_ALLOC)
 #define DQUOT_DEL_REWRITE max(V1_DEL_REWRITE, V2_DEL_REWRITE)
 
-/*
- * Data for one user/group kept in memory
- */
-struct mem_dqblk {
-	__u32 dqb_bhardlimit;	/* absolute limit on disk blks alloc */
-	__u32 dqb_bsoftlimit;	/* preferred limit on disk blks */
-	qsize_t dqb_curspace;	/* current used space */
-	__u32 dqb_ihardlimit;	/* absolute limit on allocated inodes */
-	__u32 dqb_isoftlimit;	/* preferred inode limit */
-	__u32 dqb_curinodes;	/* current # allocated inodes */
-	time_t dqb_btime;	/* time limit for excessive disk use */
-	time_t dqb_itime;	/* time limit for excessive inode use */
-};
-
-/*
- * Data for one quotafile kept in memory
- */
-struct quota_format_type;
-
-struct mem_dqinfo {
-	struct quota_format_type *dqi_format;
-	int dqi_fmt_id;		/* Id of the dqi_format - used when turning
-				 * quotas on after remount RW */
-	struct list_head dqi_dirty_list;	/* List of dirty dquots */
-	unsigned long dqi_flags;
-	unsigned int dqi_bgrace;
-	unsigned int dqi_igrace;
-	qsize_t dqi_maxblimit;
-	qsize_t dqi_maxilimit;
-	union {
-		struct v1_mem_dqinfo v1_i;
-		struct v2_mem_dqinfo v2_i;
-	} u;
-};
-
-struct super_block;
-
-#define DQF_MASK 0xffff		/* Mask for format specific flags */
-#define DQF_INFO_DIRTY_B 16
-#define DQF_INFO_DIRTY (1 << DQF_INFO_DIRTY_B)	/* Is info dirty? */
-
-extern void mark_info_dirty(struct super_block *sb, int type);
+void mark_info_dirty(struct super_block *sb, int type);
 #define info_dirty(info) test_bit(DQF_INFO_DIRTY_B, &(info)->dqi_flags)
 
 #define sb_dqopt(sb) (&(sb)->s_dquot)
@@ -241,100 +143,9 @@ struct dqstats {
 
 extern struct dqstats dqstats;
 
-#define DQ_MOD_B	0	/* dquot modified since read */
-#define DQ_BLKS_B	1	/* uid/gid has been warned about blk limit */
-#define DQ_INODES_B	2	/* uid/gid has been warned about inode limit */
-#define DQ_FAKE_B	3	/* no limits only usage */
-#define DQ_READ_B	4	/* dquot was read into memory */
-#define DQ_ACTIVE_B	5	/* dquot is active (dquot_release not called) */
-
-struct dquot {
-	struct hlist_node dq_hash;	/* Hash list in memory */
-	struct list_head dq_inuse;	/* List of all quotas */
-	struct list_head dq_free;	/* Free list element */
-	struct list_head dq_dirty;	/* List of dirty dquots */
-	struct mutex dq_lock;		/* dquot IO lock */
-	atomic_t dq_count;		/* Use count */
-	wait_queue_head_t dq_wait_unused;	/* Wait queue for dquot to become unused */
-	struct super_block *dq_sb;	/* superblock this applies to */
-	unsigned int dq_id;		/* ID this applies to (uid, gid) */
-	loff_t dq_off;			/* Offset of dquot on disk */
-	unsigned long dq_flags;		/* See DQ_* */
-	short dq_type;			/* Type of quota */
-	struct mem_dqblk dq_dqb;	/* Diskquota usage */
-};
-
-#define NODQUOT (struct dquot *)NULL
-
 #define QUOTA_OK          0
 #define NO_QUOTA          1
 
-/* Operations which must be implemented by each quota format */
-struct quota_format_ops {
-	int (*check_quota_file)(struct super_block *sb, int type);	/* Detect whether file is in our format */
-	int (*read_file_info)(struct super_block *sb, int type);	/* Read main info about file - called on quotaon() */
-	int (*write_file_info)(struct super_block *sb, int type);	/* Write main info about file */
-	int (*free_file_info)(struct super_block *sb, int type);	/* Called on quotaoff() */
-	int (*read_dqblk)(struct dquot *dquot);		/* Read structure for one user */
-	int (*commit_dqblk)(struct dquot *dquot);	/* Write structure for one user */
-	int (*release_dqblk)(struct dquot *dquot);	/* Called when last reference to dquot is being dropped */
-};
-
-/* Operations working with dquots */
-struct dquot_operations {
-	int (*initialize) (struct inode *, int);
-	int (*drop) (struct inode *);
-	int (*alloc_space) (struct inode *, qsize_t, int);
-	int (*alloc_inode) (const struct inode *, unsigned long);
-	int (*free_space) (struct inode *, qsize_t);
-	int (*free_inode) (const struct inode *, unsigned long);
-	int (*transfer) (struct inode *, struct iattr *);
-	int (*write_dquot) (struct dquot *);		/* Ordinary dquot write */
-	int (*acquire_dquot) (struct dquot *);		/* Quota is going to be created on disk */
-	int (*release_dquot) (struct dquot *);		/* Quota is going to be deleted from disk */
-	int (*mark_dirty) (struct dquot *);		/* Dquot is marked dirty */
-	int (*write_info) (struct super_block *, int);	/* Write of quota "superblock" */
-};
-
-/* Operations handling requests from userspace */
-struct quotactl_ops {
-	int (*quota_on)(struct super_block *, int, int, char *, int);
-	int (*quota_off)(struct super_block *, int, int);
-	int (*quota_sync)(struct super_block *, int);
-	int (*get_info)(struct super_block *, int, struct if_dqinfo *);
-	int (*set_info)(struct super_block *, int, struct if_dqinfo *);
-	int (*get_dqblk)(struct super_block *, int, qid_t, struct if_dqblk *);
-	int (*set_dqblk)(struct super_block *, int, qid_t, struct if_dqblk *);
-	int (*get_xstate)(struct super_block *, struct fs_quota_stat *);
-	int (*set_xstate)(struct super_block *, unsigned int, int);
-	int (*get_xquota)(struct super_block *, int, qid_t, struct fs_disk_quota *);
-	int (*set_xquota)(struct super_block *, int, qid_t, struct fs_disk_quota *);
-};
-
-struct quota_format_type {
-	int qf_fmt_id;	/* Quota format id */
-	struct quota_format_ops *qf_ops;	/* Operations of format */
-	struct module *qf_owner;		/* Module implementing quota format */
-	struct quota_format_type *qf_next;
-};
-
-#define DQUOT_USR_ENABLED	0x01		/* User diskquotas enabled */
-#define DQUOT_GRP_ENABLED	0x02		/* Group diskquotas enabled */
-#define DQUOT_USR_SUSPENDED	0x04		/* User diskquotas are off, but
-						 * we have necessary info in
-						 * memory to turn them on */
-#define DQUOT_GRP_SUSPENDED	0x08		/* The same for group quotas */
-
-struct quota_info {
-	unsigned int flags;			/* Flags for diskquotas on this device */
-	struct mutex dqio_mutex;		/* lock device while I/O in progress */
-	struct mutex dqonoff_mutex;		/* Serialize quotaon & quotaoff */
-	struct rw_semaphore dqptr_sem;		/* serialize ops using quota_info struct, pointers from inode to dquots */
-	struct inode *files[MAXQUOTAS];		/* inodes of quotafiles */
-	struct mem_dqinfo info[MAXQUOTAS];	/* Information for each quota type */
-	struct quota_format_ops *ops[MAXQUOTAS];	/* Operations for each type */
-};
-
 #define sb_has_quota_enabled(sb, type) ((type)==USRQUOTA ? \
 	(sb_dqopt(sb)->flags & DQUOT_USR_ENABLED) : (sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED))
 
diff -puN include/linux/quotaops.h~quota-split-out-quota_structh-out-of-quotah include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-split-out-quota_structh-out-of-quotah
+++ a/include/linux/quotaops.h
@@ -13,6 +13,7 @@
 #include <linux/smp_lock.h>
 
 #include <linux/fs.h>
+#include <linux/quota.h>
 
 #if defined(CONFIG_QUOTA)
 
diff -puN include/linux/syscalls.h~quota-split-out-quota_structh-out-of-quotah include/linux/syscalls.h
--- a/include/linux/syscalls.h~quota-split-out-quota_structh-out-of-quotah
+++ a/include/linux/syscalls.h
@@ -62,7 +62,7 @@ struct getcpu_cache;
 #include <linux/sem.h>
 #include <asm/siginfo.h>
 #include <asm/signal.h>
-#include <linux/quota.h>
+#include <linux/quota_struct.h>
 #include <linux/key.h>
 
 asmlinkage long sys_time(time_t __user *tloc);
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
jbd-strictly-check-for-write-errors-on-data-buffers.patch
jbd-ordered-data-integrity-fix.patch
jbd-abort-when-failed-to-log-metadata-buffers.patch
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-abort-ext3-if-the-journal-has-aborted.patch
reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode.patch
reiserfs-fix-typos-in-messages-and-comments-journalled-journaled.patch
reiserfs-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
quota-rename-quota-functions-from-upper-case-make-bigger-ones-non-inline.patch
quota-cleanup-loop-in-sync_dquots.patch
ext4-add-explicit-include-of-linux-quotah-into-ext4_jbd2h.patch
ext2-add-explicit-include-of-linux-quotah-into-superc.patch
quota-split-out-quota_structh-out-of-quotah.patch
quota-convert-macros-to-inline-functions.patch

