From: akpm@linux-foundation.org
Subject: [patch 114/126] shmem: make shmem_inode_info::lock irq-safe
Date: Tue, 26 Jul 2016 15:26:29 -0700
Message-ID: <5797e395.uvRotkQz6xgCQt4w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698AbcGZW0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:26:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: shmem: make shmem_inode_info::lock irq-safe

We are going to need to call shmem_charge() under tree_lock to get
accoutning right on collapse of small tmpfs pages into a huge one.

The problem is that tree_lock is irq-safe and lockdep is not happy, that
we take irq-unsafe lock under irq-safe[1].

Let's convert the lock to irq-safe.

[1] https://gist.github.com/kiryl/80c0149e03ed35dfaf26628b8e03cdbc

Link: http://lkml.kernel.org/r/1466021202-61880-34-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c  |    4 ++--
 mm/shmem.c |   50 ++++++++++++++++++++++++++------------------------
 2 files changed, 28 insertions(+), 26 deletions(-)

diff -puN ipc/shm.c~shmem-make-shmem_inode_info-lock-irq-safe ipc/shm.c
--- a/ipc/shm.c~shmem-make-shmem_inode_info-lock-irq-safe
+++ a/ipc/shm.c
@@ -766,10 +766,10 @@ static void shm_add_rss_swap(struct shmi
 	} else {
 #ifdef CONFIG_SHMEM
 		struct shmem_inode_info *info = SHMEM_I(inode);
-		spin_lock(&info->lock);
+		spin_lock_irq(&info->lock);
 		*rss_add += inode->i_mapping->nrpages;
 		*swp_add += info->swapped;
-		spin_unlock(&info->lock);
+		spin_unlock_irq(&info->lock);
 #else
 		*rss_add += inode->i_mapping->nrpages;
 #endif
diff -puN mm/shmem.c~shmem-make-shmem_inode_info-lock-irq-safe mm/shmem.c
--- a/mm/shmem.c~shmem-make-shmem_inode_info-lock-irq-safe
+++ a/mm/shmem.c
@@ -258,14 +258,15 @@ bool shmem_charge(struct inode *inode, l
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	unsigned long flags;
 
 	if (shmem_acct_block(info->flags, pages))
 		return false;
-	spin_lock(&info->lock);
+	spin_lock_irqsave(&info->lock, flags);
 	info->alloced += pages;
 	inode->i_blocks += pages * BLOCKS_PER_PAGE;
 	shmem_recalc_inode(inode);
-	spin_unlock(&info->lock);
+	spin_unlock_irqrestore(&info->lock, flags);
 	inode->i_mapping->nrpages += pages;
 
 	if (!sbinfo->max_blocks)
@@ -273,10 +274,10 @@ bool shmem_charge(struct inode *inode, l
 	if (percpu_counter_compare(&sbinfo->used_blocks,
 				sbinfo->max_blocks - pages) > 0) {
 		inode->i_mapping->nrpages -= pages;
-		spin_lock(&info->lock);
+		spin_lock_irqsave(&info->lock, flags);
 		info->alloced -= pages;
 		shmem_recalc_inode(inode);
-		spin_unlock(&info->lock);
+		spin_unlock_irqrestore(&info->lock, flags);
 
 		return false;
 	}
@@ -288,12 +289,13 @@ void shmem_uncharge(struct inode *inode,
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	unsigned long flags;
 
-	spin_lock(&info->lock);
+	spin_lock_irqsave(&info->lock, flags);
 	info->alloced -= pages;
 	inode->i_blocks -= pages * BLOCKS_PER_PAGE;
 	shmem_recalc_inode(inode);
-	spin_unlock(&info->lock);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	if (sbinfo->max_blocks)
 		percpu_counter_sub(&sbinfo->used_blocks, pages);
@@ -818,10 +820,10 @@ static void shmem_undo_range(struct inod
 		index++;
 	}
 
-	spin_lock(&info->lock);
+	spin_lock_irq(&info->lock);
 	info->swapped -= nr_swaps_freed;
 	shmem_recalc_inode(inode);
-	spin_unlock(&info->lock);
+	spin_unlock_irq(&info->lock);
 }
 
 void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
@@ -838,9 +840,9 @@ static int shmem_getattr(struct vfsmount
 	struct shmem_inode_info *info = SHMEM_I(inode);
 
 	if (info->alloced - info->swapped != inode->i_mapping->nrpages) {
-		spin_lock(&info->lock);
+		spin_lock_irq(&info->lock);
 		shmem_recalc_inode(inode);
-		spin_unlock(&info->lock);
+		spin_unlock_irq(&info->lock);
 	}
 	generic_fillattr(inode, stat);
 	return 0;
@@ -984,9 +986,9 @@ static int shmem_unuse_inode(struct shme
 		delete_from_swap_cache(*pagep);
 		set_page_dirty(*pagep);
 		if (!error) {
-			spin_lock(&info->lock);
+			spin_lock_irq(&info->lock);
 			info->swapped--;
-			spin_unlock(&info->lock);
+			spin_unlock_irq(&info->lock);
 			swap_free(swap);
 		}
 	}
@@ -1134,10 +1136,10 @@ static int shmem_writepage(struct page *
 		list_add_tail(&info->swaplist, &shmem_swaplist);
 
 	if (add_to_swap_cache(page, swap, GFP_ATOMIC) == 0) {
-		spin_lock(&info->lock);
+		spin_lock_irq(&info->lock);
 		shmem_recalc_inode(inode);
 		info->swapped++;
-		spin_unlock(&info->lock);
+		spin_unlock_irq(&info->lock);
 
 		swap_shmem_alloc(swap);
 		shmem_delete_from_page_cache(page, swp_to_radix_entry(swap));
@@ -1523,10 +1525,10 @@ repeat:
 
 		mem_cgroup_commit_charge(page, memcg, true, false);
 
-		spin_lock(&info->lock);
+		spin_lock_irq(&info->lock);
 		info->swapped--;
 		shmem_recalc_inode(inode);
-		spin_unlock(&info->lock);
+		spin_unlock_irq(&info->lock);
 
 		if (sgp == SGP_WRITE)
 			mark_page_accessed(page);
@@ -1603,11 +1605,11 @@ alloc_nohuge:		page = shmem_alloc_and_ac
 				PageTransHuge(page));
 		lru_cache_add_anon(page);
 
-		spin_lock(&info->lock);
+		spin_lock_irq(&info->lock);
 		info->alloced += 1 << compound_order(page);
 		inode->i_blocks += BLOCKS_PER_PAGE << compound_order(page);
 		shmem_recalc_inode(inode);
-		spin_unlock(&info->lock);
+		spin_unlock_irq(&info->lock);
 		alloced = true;
 
 		/*
@@ -1639,9 +1641,9 @@ clear:
 		if (alloced) {
 			ClearPageDirty(page);
 			delete_from_page_cache(page);
-			spin_lock(&info->lock);
+			spin_lock_irq(&info->lock);
 			shmem_recalc_inode(inode);
-			spin_unlock(&info->lock);
+			spin_unlock_irq(&info->lock);
 		}
 		error = -EINVAL;
 		goto unlock;
@@ -1673,9 +1675,9 @@ unlock:
 	}
 	if (error == -ENOSPC && !once++) {
 		info = SHMEM_I(inode);
-		spin_lock(&info->lock);
+		spin_lock_irq(&info->lock);
 		shmem_recalc_inode(inode);
-		spin_unlock(&info->lock);
+		spin_unlock_irq(&info->lock);
 		goto repeat;
 	}
 	if (error == -EEXIST)	/* from above or from radix_tree_insert */
@@ -1874,7 +1876,7 @@ int shmem_lock(struct file *file, int lo
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	int retval = -ENOMEM;
 
-	spin_lock(&info->lock);
+	spin_lock_irq(&info->lock);
 	if (lock && !(info->flags & VM_LOCKED)) {
 		if (!user_shm_lock(inode->i_size, user))
 			goto out_nomem;
@@ -1889,7 +1891,7 @@ int shmem_lock(struct file *file, int lo
 	retval = 0;
 
 out_nomem:
-	spin_unlock(&info->lock);
+	spin_unlock_irq(&info->lock);
 	return retval;
 }
 
_
