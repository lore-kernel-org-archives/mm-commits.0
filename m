Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F7BC433E1
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D59CE221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781225;
	bh=VqiFsLhUvzWDsnbBeIlUs9wGC6URW0MJz9rKg1JG/Vg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jvUKDAUw4SWFZDgQSAY+Xuwt6SPIMDnfHwoKDehRC1kovJ+upnYewtuhAkcLBE4Rb
	 Tmanue/3B9rqkGW9ZmQJBbsQ2ns0fbvpTqbbbqIdwFYCGupN/J7q2je+hlhCTizVHm
	 syXc1yDKsdkxwdlGzlWGhyQH7IBvdm1swiJUatv8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgHGGUZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgHGGUZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:20:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EBE522CF6;
        Fri,  7 Aug 2020 06:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781223;
        bh=VqiFsLhUvzWDsnbBeIlUs9wGC6URW0MJz9rKg1JG/Vg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vC4BnVm2WuvkBAlBbGJlH4iDpddWSa/CSMGPRPmFYD9S43++kuUPqqTsI7gLiLDGI
         Qw8Z1GvvvYFAI9YdyipuYWYUGQfIEjjn7GqBb8qQUvlqXxKL40B+qDZ4JFBNJlJ8oM
         g0xROGPlncDr4KQtBCerCjfU2qV9ZhD7R67s9H9I=
Date:   Thu, 06 Aug 2020 23:20:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amir73il@gmail.com,
        chris@chrisdown.name, hannes@cmpxchg.org, hughd@google.com,
        jlayton@kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        tj@kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [patch 059/163] tmpfs: per-superblock i_ino support
Message-ID: <20200807062020.G315bvcEC%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chris Down <chris@chrisdown.name>
Subject: tmpfs: per-superblock i_ino support

Patch series "tmpfs: inode: Reduce risk of inum overflow", v7.

In Facebook production we are seeing heavy i_ino wraparounds on tmpfs.  On
affected tiers, in excess of 10% of hosts show multiple files with
different content and the same inode number, with some servers even having
as many as 150 duplicated inode numbers with differing file content.

This causes actual, tangible problems in production.  For example, we have
complaints from those working on remote caches that their application is
reporting cache corruptions because it uses (device, inodenum) to
establish the identity of a particular cache object, but because it's not
unique any more, the application refuses to continue and reports cache
corruption.  Even worse, sometimes applications may not even detect the
corruption but may continue anyway, causing phantom and hard to debug
behaviour.

In general, userspace applications expect that (device, inodenum) should
be enough to be uniquely point to one inode, which seems fair enough.  One
might also need to check the generation, but in this case:

1. That's not currently exposed to userspace
   (ioctl(...FS_IOC_GETVERSION...) returns ENOTTY on tmpfs);
2. Even with generation, there shouldn't be two live inodes with the
   same inode number on one device.

In order to mitigate this, we take a two-pronged approach:

1. Moving inum generation from being global to per-sb for tmpfs. This
   itself allows some reduction in i_ino churn. This works on both 64-
   and 32- bit machines.
2. Adding inode{64,32} for tmpfs. This fix is supported on machines with
   64-bit ino_t only: we allow users to mount tmpfs with a new inode64
   option that uses the full width of ino_t, or CONFIG_TMPFS_INODE64.

You can see how this compares to previous related patches which didn't
implement this per-superblock:

- https://patchwork.kernel.org/patch/11254001/
- https://patchwork.kernel.org/patch/11023915/


This patch (of 2):

get_next_ino has a number of problems:

- It uses and returns a uint, which is susceptible to become overflowed
  if a lot of volatile inodes that use get_next_ino are created.
- It's global, with no specificity per-sb or even per-filesystem. This
  means it's not that difficult to cause inode number wraparounds on a
  single device, which can result in having multiple distinct inodes
  with the same inode number.

This patch adds a per-superblock counter that mitigates the second case. 
This design also allows us to later have a specific i_ino size per-device,
for example, allowing users to choose whether to use 32- or 64-bit inodes
for each tmpfs mount.  This is implemented in the next commit.

For internal shmem mounts which may be less tolerant to spinlock delays,
we implement a percpu batching scheme which only takes the stat_lock at
each batch boundary.

Link: http://lkml.kernel.org/r/cover.1594661218.git.chris@chrisdown.name
Link: http://lkml.kernel.org/r/1986b9d63b986f08ec07a4aa4b2275e718e47d8a.1594661218.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h       |   15 ++++++++
 include/linux/shmem_fs.h |    2 +
 mm/shmem.c               |   66 ++++++++++++++++++++++++++++++++++---
 3 files changed, 78 insertions(+), 5 deletions(-)

--- a/include/linux/fs.h~tmpfs-per-superblock-i_ino-support
+++ a/include/linux/fs.h
@@ -2946,6 +2946,21 @@ extern void discard_new_inode(struct ino
 extern unsigned int get_next_ino(void);
 extern void evict_inodes(struct super_block *sb);
 
+/*
+ * Userspace may rely on the the inode number being non-zero. For example, glibc
+ * simply ignores files with zero i_ino in unlink() and other places.
+ *
+ * As an additional complication, if userspace was compiled with
+ * _FILE_OFFSET_BITS=32 on a 64-bit kernel we'll only end up reading out the
+ * lower 32 bits, so we need to check that those aren't zero explicitly. With
+ * _FILE_OFFSET_BITS=64, this may cause some harmless false-negatives, but
+ * better safe than sorry.
+ */
+static inline bool is_zero_ino(ino_t ino)
+{
+	return (u32)ino == 0;
+}
+
 extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
--- a/include/linux/shmem_fs.h~tmpfs-per-superblock-i_ino-support
+++ a/include/linux/shmem_fs.h
@@ -36,6 +36,8 @@ struct shmem_sb_info {
 	unsigned char huge;	    /* Whether to try for hugepages */
 	kuid_t uid;		    /* Mount uid for root directory */
 	kgid_t gid;		    /* Mount gid for root directory */
+	ino_t next_ino;		    /* The next per-sb inode number to use */
+	ino_t __percpu *ino_batch;  /* The next per-cpu inode number to use */
 	struct mempolicy *mpol;     /* default memory policy for mappings */
 	spinlock_t shrinklist_lock;   /* Protects shrinklist */
 	struct list_head shrinklist;  /* List of shinkable inodes */
--- a/mm/shmem.c~tmpfs-per-superblock-i_ino-support
+++ a/mm/shmem.c
@@ -260,18 +260,67 @@ bool vma_is_shmem(struct vm_area_struct
 static LIST_HEAD(shmem_swaplist);
 static DEFINE_MUTEX(shmem_swaplist_mutex);
 
-static int shmem_reserve_inode(struct super_block *sb)
+/*
+ * shmem_reserve_inode() performs bookkeeping to reserve a shmem inode, and
+ * produces a novel ino for the newly allocated inode.
+ *
+ * It may also be called when making a hard link to permit the space needed by
+ * each dentry. However, in that case, no new inode number is needed since that
+ * internally draws from another pool of inode numbers (currently global
+ * get_next_ino()). This case is indicated by passing NULL as inop.
+ */
+#define SHMEM_INO_BATCH 1024
+static int shmem_reserve_inode(struct super_block *sb, ino_t *inop)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
-	if (sbinfo->max_inodes) {
+	ino_t ino;
+
+	if (!(sb->s_flags & SB_KERNMOUNT)) {
 		spin_lock(&sbinfo->stat_lock);
 		if (!sbinfo->free_inodes) {
 			spin_unlock(&sbinfo->stat_lock);
 			return -ENOSPC;
 		}
 		sbinfo->free_inodes--;
+		if (inop) {
+			ino = sbinfo->next_ino++;
+			if (unlikely(is_zero_ino(ino)))
+				ino = sbinfo->next_ino++;
+			if (unlikely(ino > UINT_MAX)) {
+				/*
+				 * Emulate get_next_ino uint wraparound for
+				 * compatibility
+				 */
+				ino = 1;
+			}
+			*inop = ino;
+		}
 		spin_unlock(&sbinfo->stat_lock);
+	} else if (inop) {
+		/*
+		 * __shmem_file_setup, one of our callers, is lock-free: it
+		 * doesn't hold stat_lock in shmem_reserve_inode since
+		 * max_inodes is always 0, and is called from potentially
+		 * unknown contexts. As such, use a per-cpu batched allocator
+		 * which doesn't require the per-sb stat_lock unless we are at
+		 * the batch boundary.
+		 */
+		ino_t *next_ino;
+		next_ino = per_cpu_ptr(sbinfo->ino_batch, get_cpu());
+		ino = *next_ino;
+		if (unlikely(ino % SHMEM_INO_BATCH == 0)) {
+			spin_lock(&sbinfo->stat_lock);
+			ino = sbinfo->next_ino;
+			sbinfo->next_ino += SHMEM_INO_BATCH;
+			spin_unlock(&sbinfo->stat_lock);
+			if (unlikely(is_zero_ino(ino)))
+				ino++;
+		}
+		*inop = ino;
+		*next_ino = ++ino;
+		put_cpu();
 	}
+
 	return 0;
 }
 
@@ -2222,13 +2271,14 @@ static struct inode *shmem_get_inode(str
 	struct inode *inode;
 	struct shmem_inode_info *info;
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
+	ino_t ino;
 
-	if (shmem_reserve_inode(sb))
+	if (shmem_reserve_inode(sb, &ino))
 		return NULL;
 
 	inode = new_inode(sb);
 	if (inode) {
-		inode->i_ino = get_next_ino();
+		inode->i_ino = ino;
 		inode_init_owner(inode, dir, mode);
 		inode->i_blocks = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = current_time(inode);
@@ -2932,7 +2982,7 @@ static int shmem_link(struct dentry *old
 	 * first link must skip that, to get the accounting right.
 	 */
 	if (inode->i_nlink) {
-		ret = shmem_reserve_inode(inode->i_sb);
+		ret = shmem_reserve_inode(inode->i_sb, NULL);
 		if (ret)
 			goto out;
 	}
@@ -3584,6 +3634,7 @@ static void shmem_put_super(struct super
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 
+	free_percpu(sbinfo->ino_batch);
 	percpu_counter_destroy(&sbinfo->used_blocks);
 	mpol_put(sbinfo->mpol);
 	kfree(sbinfo);
@@ -3626,6 +3677,11 @@ static int shmem_fill_super(struct super
 #endif
 	sbinfo->max_blocks = ctx->blocks;
 	sbinfo->free_inodes = sbinfo->max_inodes = ctx->inodes;
+	if (sb->s_flags & SB_KERNMOUNT) {
+		sbinfo->ino_batch = alloc_percpu(ino_t);
+		if (!sbinfo->ino_batch)
+			goto failed;
+	}
 	sbinfo->uid = ctx->uid;
 	sbinfo->gid = ctx->gid;
 	sbinfo->mode = ctx->mode;
_
