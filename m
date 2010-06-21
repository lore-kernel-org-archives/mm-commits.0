From: akpm@linux-foundation.org
Subject: + tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-blocks.patch added to -mm tree
Date: Mon, 21 Jun 2010 13:19:59 -0700
Message-ID: <201006212019.o5LKJxlx002598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714Ab0FUUUL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 16:20:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tim.c.chen@linux.intel.com, hughd@google.com


The patch titled
     tmpfs: make tmpfs scalable with percpu_counter for used blocks
has been added to the -mm tree.  Its filename is
     tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-blocks.patch

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
Subject: tmpfs: make tmpfs scalable with percpu_counter for used blocks
From: Tim Chen <tim.c.chen@linux.intel.com>

The current implementation of tmpfs is not scalable.  We found that
stat_lock is contended by multiple threads when we need to get a new page,
leading to useless spinning inside this spin lock.

This patch makes use of the percpu_counter library to maintain local count
of used blocks to speed up getting and returning of pages.  So the
acquisition of stat_lock is unnecessary for getting and returning blocks,
improving the performance of tmpfs on system with large number of cpus. 
On a 4 socket 32 core NHM-EX system, we saw improvement of 270%.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    3 +-
 mm/shmem.c               |   40 +++++++++++++++----------------------
 2 files changed, 19 insertions(+), 24 deletions(-)

diff -puN include/linux/shmem_fs.h~tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-blocks include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-blocks
+++ a/include/linux/shmem_fs.h
@@ -3,6 +3,7 @@
 
 #include <linux/swap.h>
 #include <linux/mempolicy.h>
+#include <linux/percpu_counter.h>
 
 /* inode in-kernel data */
 
@@ -23,7 +24,7 @@ struct shmem_inode_info {
 
 struct shmem_sb_info {
 	unsigned long max_blocks;   /* How many blocks are allowed */
-	unsigned long free_blocks;  /* How many are left for allocation */
+	struct percpu_counter used_blocks;  /* How many are allocated */
 	unsigned long max_inodes;   /* How many inodes are allowed */
 	unsigned long free_inodes;  /* How many are left for allocation */
 	spinlock_t stat_lock;	    /* Serialize shmem_sb_info changes */
diff -puN mm/shmem.c~tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-blocks mm/shmem.c
--- a/mm/shmem.c~tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-blocks
+++ a/mm/shmem.c
@@ -28,6 +28,7 @@
 #include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/percpu_counter.h>
 #include <linux/swap.h>
 
 static struct vfsmount *shm_mnt;
@@ -233,10 +234,10 @@ static void shmem_free_blocks(struct ino
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	if (sbinfo->max_blocks) {
-		spin_lock(&sbinfo->stat_lock);
-		sbinfo->free_blocks += pages;
+		percpu_counter_add(&sbinfo->used_blocks, -pages);
+		spin_lock(&inode->i_lock);
 		inode->i_blocks -= pages*BLOCKS_PER_PAGE;
-		spin_unlock(&sbinfo->stat_lock);
+		spin_unlock(&inode->i_lock);
 	}
 }
 
@@ -416,19 +417,17 @@ static swp_entry_t *shmem_swp_alloc(stru
 		if (sgp == SGP_READ)
 			return shmem_swp_map(ZERO_PAGE(0));
 		/*
-		 * Test free_blocks against 1 not 0, since we have 1 data
+		 * Test used_blocks against 1 less max_blocks, since we have 1 data
 		 * page (and perhaps indirect index pages) yet to allocate:
 		 * a waste to allocate index if we cannot allocate data.
 		 */
 		if (sbinfo->max_blocks) {
-			spin_lock(&sbinfo->stat_lock);
-			if (sbinfo->free_blocks <= 1) {
-				spin_unlock(&sbinfo->stat_lock);
+			if (percpu_counter_compare(&sbinfo->used_blocks, (sbinfo->max_blocks - 1)) > 0)
 				return ERR_PTR(-ENOSPC);
-			}
-			sbinfo->free_blocks--;
+			percpu_counter_inc(&sbinfo->used_blocks);
+			spin_lock(&inode->i_lock);
 			inode->i_blocks += BLOCKS_PER_PAGE;
-			spin_unlock(&sbinfo->stat_lock);
+			spin_unlock(&inode->i_lock);
 		}
 
 		spin_unlock(&info->lock);
@@ -1388,17 +1387,16 @@ repeat:
 		shmem_swp_unmap(entry);
 		sbinfo = SHMEM_SB(inode->i_sb);
 		if (sbinfo->max_blocks) {
-			spin_lock(&sbinfo->stat_lock);
-			if (sbinfo->free_blocks == 0 ||
+			if ((percpu_counter_compare(&sbinfo->used_blocks, sbinfo->max_blocks) > 0) ||
 			    shmem_acct_block(info->flags)) {
-				spin_unlock(&sbinfo->stat_lock);
 				spin_unlock(&info->lock);
 				error = -ENOSPC;
 				goto failed;
 			}
-			sbinfo->free_blocks--;
+			percpu_counter_inc(&sbinfo->used_blocks);
+			spin_lock(&inode->i_lock);
 			inode->i_blocks += BLOCKS_PER_PAGE;
-			spin_unlock(&sbinfo->stat_lock);
+			spin_unlock(&inode->i_lock);
 		} else if (shmem_acct_block(info->flags)) {
 			spin_unlock(&info->lock);
 			error = -ENOSPC;
@@ -1792,17 +1790,16 @@ static int shmem_statfs(struct dentry *d
 	buf->f_type = TMPFS_MAGIC;
 	buf->f_bsize = PAGE_CACHE_SIZE;
 	buf->f_namelen = NAME_MAX;
-	spin_lock(&sbinfo->stat_lock);
 	if (sbinfo->max_blocks) {
 		buf->f_blocks = sbinfo->max_blocks;
-		buf->f_bavail = buf->f_bfree = sbinfo->free_blocks;
+		buf->f_bavail = buf->f_bfree =
+				sbinfo->max_blocks - percpu_counter_sum(&sbinfo->used_blocks);
 	}
 	if (sbinfo->max_inodes) {
 		buf->f_files = sbinfo->max_inodes;
 		buf->f_ffree = sbinfo->free_inodes;
 	}
 	/* else leave those fields 0 like simple_statfs */
-	spin_unlock(&sbinfo->stat_lock);
 	return 0;
 }
 
@@ -2243,7 +2240,6 @@ static int shmem_remount_fs(struct super
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 	struct shmem_sb_info config = *sbinfo;
-	unsigned long blocks;
 	unsigned long inodes;
 	int error = -EINVAL;
 
@@ -2251,9 +2247,8 @@ static int shmem_remount_fs(struct super
 		return error;
 
 	spin_lock(&sbinfo->stat_lock);
-	blocks = sbinfo->max_blocks - sbinfo->free_blocks;
 	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
-	if (config.max_blocks < blocks)
+	if (config.max_blocks < percpu_counter_sum(&sbinfo->used_blocks))
 		goto out;
 	if (config.max_inodes < inodes)
 		goto out;
@@ -2270,7 +2265,6 @@ static int shmem_remount_fs(struct super
 
 	error = 0;
 	sbinfo->max_blocks  = config.max_blocks;
-	sbinfo->free_blocks = config.max_blocks - blocks;
 	sbinfo->max_inodes  = config.max_inodes;
 	sbinfo->free_inodes = config.max_inodes - inodes;
 
@@ -2345,7 +2339,7 @@ int shmem_fill_super(struct super_block 
 #endif
 
 	spin_lock_init(&sbinfo->stat_lock);
-	sbinfo->free_blocks = sbinfo->max_blocks;
+	percpu_counter_init(&sbinfo->used_blocks, 0);
 	sbinfo->free_inodes = sbinfo->max_inodes;
 
 	sb->s_maxbytes = SHMEM_MAX_BYTES;
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

tmpfs-add-accurate-compare-function-to-percpu_counter-library.patch
tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-blocks.patch

