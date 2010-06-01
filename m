From: akpm@linux-foundation.org
Subject: + tmpfs-make-tmpfs-scalable-with-caches-for-free-blocks.patch added to -mm tree
Date: Tue, 01 Jun 2010 14:52:01 -0700
Message-ID: <201006012152.o51Lq1rl021031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755188Ab0FAVwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 17:52:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tim.c.chen@linux.intel.com, ak@linux.intel.com, hughd@google.com


The patch titled
     tmpfs: make tmpfs scalable with caches for free blocks
has been added to the -mm tree.  Its filename is
     tmpfs-make-tmpfs-scalable-with-caches-for-free-blocks.patch

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
Subject: tmpfs: make tmpfs scalable with caches for free blocks
From: Tim Chen <tim.c.chen@linux.intel.com>

The current implementation of tmpfs is not scalable.  The stat_lock is
contended whenever we need to get a new page, leading to lots lock
contentions.  This patch makes use of the qtoken library to maintain local
caches of free pages to speed up getting and returning of pages without
acquisition of stat_lock improve the performance of tmpfs.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    4 +-
 mm/shmem.c               |   58 ++++++++++++++++++++-----------------
 2 files changed, 35 insertions(+), 27 deletions(-)

diff -puN include/linux/shmem_fs.h~tmpfs-make-tmpfs-scalable-with-caches-for-free-blocks include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~tmpfs-make-tmpfs-scalable-with-caches-for-free-blocks
+++ a/include/linux/shmem_fs.h
@@ -3,10 +3,12 @@
 
 #include <linux/swap.h>
 #include <linux/mempolicy.h>
+#include <linux/qtoken.h>
 
 /* inode in-kernel data */
 
 #define SHMEM_NR_DIRECT 16
+#define SHMEM_FREE_BLK_CACHE_SZ 512
 
 struct shmem_inode_info {
 	spinlock_t		lock;
@@ -23,7 +25,7 @@ struct shmem_inode_info {
 
 struct shmem_sb_info {
 	unsigned long max_blocks;   /* How many blocks are allowed */
-	unsigned long free_blocks;  /* How many are left for allocation */
+	struct qtoken token_jar;    /* Token jar of free blocks */
 	unsigned long max_inodes;   /* How many inodes are allowed */
 	unsigned long free_inodes;  /* How many are left for allocation */
 	spinlock_t stat_lock;	    /* Serialize shmem_sb_info changes */
diff -puN mm/shmem.c~tmpfs-make-tmpfs-scalable-with-caches-for-free-blocks mm/shmem.c
--- a/mm/shmem.c~tmpfs-make-tmpfs-scalable-with-caches-for-free-blocks
+++ a/mm/shmem.c
@@ -29,6 +29,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/swap.h>
+#include <linux/qtoken.h>
 
 static struct vfsmount *shm_mnt;
 
@@ -233,10 +234,10 @@ static void shmem_free_blocks(struct ino
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	if (sbinfo->max_blocks) {
-		spin_lock(&sbinfo->stat_lock);
-		sbinfo->free_blocks += pages;
+		spin_lock(&inode->i_lock);
+		qtoken_return(&sbinfo->token_jar, pages);
 		inode->i_blocks -= pages*BLOCKS_PER_PAGE;
-		spin_unlock(&sbinfo->stat_lock);
+		spin_unlock(&inode->i_lock);
 	}
 }
 
@@ -416,19 +417,18 @@ static swp_entry_t *shmem_swp_alloc(stru
 		if (sgp == SGP_READ)
 			return shmem_swp_map(ZERO_PAGE(0));
 		/*
-		 * Test free_blocks against 1 not 0, since we have 1 data
-		 * page (and perhaps indirect index pages) yet to allocate:
+		 * Leave 1 pg in reserve in token jar, since we have
+		 * 1 data pg (and perhaps indirect index pages) yet to allocate:
 		 * a waste to allocate index if we cannot allocate data.
 		 */
 		if (sbinfo->max_blocks) {
-			spin_lock(&sbinfo->stat_lock);
-			if (sbinfo->free_blocks <= 1) {
-				spin_unlock(&sbinfo->stat_lock);
+			spin_lock(&inode->i_lock);
+			if (qtoken_get(&sbinfo->token_jar, 1, 1)) {
+				spin_unlock(&inode->i_lock);
 				return ERR_PTR(-ENOSPC);
 			}
-			sbinfo->free_blocks--;
 			inode->i_blocks += BLOCKS_PER_PAGE;
-			spin_unlock(&sbinfo->stat_lock);
+			spin_unlock(&inode->i_lock);
 		}
 
 		spin_unlock(&info->lock);
@@ -1386,17 +1386,20 @@ repeat:
 		shmem_swp_unmap(entry);
 		sbinfo = SHMEM_SB(inode->i_sb);
 		if (sbinfo->max_blocks) {
-			spin_lock(&sbinfo->stat_lock);
-			if (sbinfo->free_blocks == 0 ||
-			    shmem_acct_block(info->flags)) {
-				spin_unlock(&sbinfo->stat_lock);
+			if (shmem_acct_block(info->flags)) {
+				spin_unlock(&info->lock);
+				error = -ENOSPC;
+				goto failed;
+			}
+			spin_lock(&inode->i_lock);
+			if (qtoken_get(&sbinfo->token_jar, 1, 0)) {
+				spin_unlock(&inode->i_lock);
 				spin_unlock(&info->lock);
 				error = -ENOSPC;
 				goto failed;
 			}
-			sbinfo->free_blocks--;
 			inode->i_blocks += BLOCKS_PER_PAGE;
-			spin_unlock(&sbinfo->stat_lock);
+			spin_unlock(&inode->i_lock);
 		} else if (shmem_acct_block(info->flags)) {
 			spin_unlock(&info->lock);
 			error = -ENOSPC;
@@ -1793,7 +1796,7 @@ static int shmem_statfs(struct dentry *d
 	spin_lock(&sbinfo->stat_lock);
 	if (sbinfo->max_blocks) {
 		buf->f_blocks = sbinfo->max_blocks;
-		buf->f_bavail = buf->f_bfree = sbinfo->free_blocks;
+		buf->f_bavail = buf->f_bfree = qtoken_avail(&sbinfo->token_jar);
 	}
 	if (sbinfo->max_inodes) {
 		buf->f_files = sbinfo->max_inodes;
@@ -2241,7 +2244,6 @@ static int shmem_remount_fs(struct super
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 	struct shmem_sb_info config = *sbinfo;
-	unsigned long blocks;
 	unsigned long inodes;
 	int error = -EINVAL;
 
@@ -2249,12 +2251,6 @@ static int shmem_remount_fs(struct super
 		return error;
 
 	spin_lock(&sbinfo->stat_lock);
-	blocks = sbinfo->max_blocks - sbinfo->free_blocks;
-	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
-	if (config.max_blocks < blocks)
-		goto out;
-	if (config.max_inodes < inodes)
-		goto out;
 	/*
 	 * Those tests also disallow limited->unlimited while any are in
 	 * use, so i_blocks will always be zero when max_blocks is zero;
@@ -2265,10 +2261,14 @@ static int shmem_remount_fs(struct super
 		goto out;
 	if (config.max_inodes && !sbinfo->max_inodes)
 		goto out;
+	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
+	if (config.max_inodes < inodes)
+		goto out;
+	if (qtoken_resize(&sbinfo->token_jar, config.max_blocks))
+		goto out;
 
 	error = 0;
 	sbinfo->max_blocks  = config.max_blocks;
-	sbinfo->free_blocks = config.max_blocks - blocks;
 	sbinfo->max_inodes  = config.max_inodes;
 	sbinfo->free_inodes = config.max_inodes - inodes;
 
@@ -2301,6 +2301,10 @@ static int shmem_show_options(struct seq
 
 static void shmem_put_super(struct super_block *sb)
 {
+	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
+
+	if (sbinfo)
+		qtoken_free(&sbinfo->token_jar);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 }
@@ -2343,8 +2347,10 @@ int shmem_fill_super(struct super_block 
 #endif
 
 	spin_lock_init(&sbinfo->stat_lock);
-	sbinfo->free_blocks = sbinfo->max_blocks;
 	sbinfo->free_inodes = sbinfo->max_inodes;
+	if (qtoken_init(&sbinfo->token_jar, sbinfo->max_blocks,
+				SHMEM_FREE_BLK_CACHE_SZ))
+		goto failed;
 
 	sb->s_maxbytes = SHMEM_MAX_BYTES;
 	sb->s_blocksize = PAGE_CACHE_SIZE;
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar.patch
tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix.patch
tmpfs-make-tmpfs-scalable-with-caches-for-free-blocks.patch

