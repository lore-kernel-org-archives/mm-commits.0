Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980BAC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8294760E9B
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350205AbhICU5w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350270AbhICU5o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8608360C3E;
        Fri,  3 Sep 2021 20:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702602;
        bh=4ffA98b+8SITKvrljM+KkFYrskMI2E+c4HgIj+lf7Fs=;
        h=Date:From:To:Subject:From;
        b=O0Y5nyWiJ6m5EBAJaA+SU8/+QOiwZGnGLfl6bzSZm6CEyeK3vXka2VPjrQrq/dEll
         rtmalRH4lYG5cQfipbFX+a2R0NJmVvNvn/H82VoaZOtT+eqvzrOG8tZog17KiwPUXH
         5OHkSRE5u1PAIq+Lx8U69hsEShAN916/XhVKS424=
Date:   Fri, 03 Sep 2021 13:56:42 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, hughd@google.com, mm-commits@vger.kernel.org
Subject:  [merged] shmem-use-raw_spinlock_t-for-stat_lock.patch
 removed from -mm tree
Message-ID: <20210903205642.VQu6T799f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: use raw_spinlock_t for ->stat_lock
has been removed from the -mm tree.  Its filename was
     shmem-use-raw_spinlock_t-for-stat_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: shmem: use raw_spinlock_t for ->stat_lock

Each CPU has SHMEM_INO_BATCH inodes available in `->ino_batch' which is
per-CPU.  Access here is serialized by disabling preemption.  If the pool
is empty, it gets reloaded from `->next_ino'.  Access here is serialized
by ->stat_lock which is a spinlock_t and can not be acquired with disabled
preemption.

One way around it would make per-CPU ino_batch struct containing the inode
number a local_lock_t.

Another solution is to promote ->stat_lock to a raw_spinlock_t.  The
critical sections are short.  The mpol_put() must be moved outside of the
critical section to avoid invoking the destructor with disabled
preemption.

Link: https://lkml.kernel.org/r/20210806142916.jdwkb5bx62q5fwfo@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    2 +-
 mm/shmem.c               |   31 +++++++++++++++++--------------
 2 files changed, 18 insertions(+), 15 deletions(-)

--- a/include/linux/shmem_fs.h~shmem-use-raw_spinlock_t-for-stat_lock
+++ a/include/linux/shmem_fs.h
@@ -31,7 +31,7 @@ struct shmem_sb_info {
 	struct percpu_counter used_blocks;  /* How many are allocated */
 	unsigned long max_inodes;   /* How many inodes are allowed */
 	unsigned long free_inodes;  /* How many are left for allocation */
-	spinlock_t stat_lock;	    /* Serialize shmem_sb_info changes */
+	raw_spinlock_t stat_lock;   /* Serialize shmem_sb_info changes */
 	umode_t mode;		    /* Mount mode for root directory */
 	unsigned char huge;	    /* Whether to try for hugepages */
 	kuid_t uid;		    /* Mount uid for root directory */
--- a/mm/shmem.c~shmem-use-raw_spinlock_t-for-stat_lock
+++ a/mm/shmem.c
@@ -278,10 +278,10 @@ static int shmem_reserve_inode(struct su
 	ino_t ino;
 
 	if (!(sb->s_flags & SB_KERNMOUNT)) {
-		spin_lock(&sbinfo->stat_lock);
+		raw_spin_lock(&sbinfo->stat_lock);
 		if (sbinfo->max_inodes) {
 			if (!sbinfo->free_inodes) {
-				spin_unlock(&sbinfo->stat_lock);
+				raw_spin_unlock(&sbinfo->stat_lock);
 				return -ENOSPC;
 			}
 			sbinfo->free_inodes--;
@@ -304,7 +304,7 @@ static int shmem_reserve_inode(struct su
 			}
 			*inop = ino;
 		}
-		spin_unlock(&sbinfo->stat_lock);
+		raw_spin_unlock(&sbinfo->stat_lock);
 	} else if (inop) {
 		/*
 		 * __shmem_file_setup, one of our callers, is lock-free: it
@@ -319,13 +319,14 @@ static int shmem_reserve_inode(struct su
 		 * to worry about things like glibc compatibility.
 		 */
 		ino_t *next_ino;
+
 		next_ino = per_cpu_ptr(sbinfo->ino_batch, get_cpu());
 		ino = *next_ino;
 		if (unlikely(ino % SHMEM_INO_BATCH == 0)) {
-			spin_lock(&sbinfo->stat_lock);
+			raw_spin_lock(&sbinfo->stat_lock);
 			ino = sbinfo->next_ino;
 			sbinfo->next_ino += SHMEM_INO_BATCH;
-			spin_unlock(&sbinfo->stat_lock);
+			raw_spin_unlock(&sbinfo->stat_lock);
 			if (unlikely(is_zero_ino(ino)))
 				ino++;
 		}
@@ -341,9 +342,9 @@ static void shmem_free_inode(struct supe
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 	if (sbinfo->max_inodes) {
-		spin_lock(&sbinfo->stat_lock);
+		raw_spin_lock(&sbinfo->stat_lock);
 		sbinfo->free_inodes++;
-		spin_unlock(&sbinfo->stat_lock);
+		raw_spin_unlock(&sbinfo->stat_lock);
 	}
 }
 
@@ -1453,10 +1454,10 @@ static struct mempolicy *shmem_get_sbmpo
 {
 	struct mempolicy *mpol = NULL;
 	if (sbinfo->mpol) {
-		spin_lock(&sbinfo->stat_lock);	/* prevent replace/use races */
+		raw_spin_lock(&sbinfo->stat_lock);	/* prevent replace/use races */
 		mpol = sbinfo->mpol;
 		mpol_get(mpol);
-		spin_unlock(&sbinfo->stat_lock);
+		raw_spin_unlock(&sbinfo->stat_lock);
 	}
 	return mpol;
 }
@@ -3488,9 +3489,10 @@ static int shmem_reconfigure(struct fs_c
 	struct shmem_options *ctx = fc->fs_private;
 	struct shmem_sb_info *sbinfo = SHMEM_SB(fc->root->d_sb);
 	unsigned long inodes;
+	struct mempolicy *mpol = NULL;
 	const char *err;
 
-	spin_lock(&sbinfo->stat_lock);
+	raw_spin_lock(&sbinfo->stat_lock);
 	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
 	if ((ctx->seen & SHMEM_SEEN_BLOCKS) && ctx->blocks) {
 		if (!sbinfo->max_blocks) {
@@ -3535,14 +3537,15 @@ static int shmem_reconfigure(struct fs_c
 	 * Preserve previous mempolicy unless mpol remount option was specified.
 	 */
 	if (ctx->mpol) {
-		mpol_put(sbinfo->mpol);
+		mpol = sbinfo->mpol;
 		sbinfo->mpol = ctx->mpol;	/* transfers initial ref */
 		ctx->mpol = NULL;
 	}
-	spin_unlock(&sbinfo->stat_lock);
+	raw_spin_unlock(&sbinfo->stat_lock);
+	mpol_put(mpol);
 	return 0;
 out:
-	spin_unlock(&sbinfo->stat_lock);
+	raw_spin_unlock(&sbinfo->stat_lock);
 	return invalfc(fc, "%s", err);
 }
 
@@ -3659,7 +3662,7 @@ static int shmem_fill_super(struct super
 	sbinfo->mpol = ctx->mpol;
 	ctx->mpol = NULL;
 
-	spin_lock_init(&sbinfo->stat_lock);
+	raw_spin_lock_init(&sbinfo->stat_lock);
 	if (percpu_counter_init(&sbinfo->used_blocks, 0, GFP_KERNEL))
 		goto failed;
 	spin_lock_init(&sbinfo->shrinklist_lock);
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context.patch
mm-slub-make-object_map_lock-a-raw_spinlock_t.patch
highmem-dont-disable-preemption-on-rt-in-kmap_atomic.patch

