From: akpm@linux-foundation.org
Subject: - quota-add-callbacks-for-allocating-and-destroying-dquot-structures.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:27:02 -0800
Message-ID: <200811262027.mAQKR23v032756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbYKZU1P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:27:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: add callbacks for allocating and destroying dquot structures
has been removed from the -mm tree.  Its filename was
     quota-add-callbacks-for-allocating-and-destroying-dquot-structures.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: add callbacks for allocating and destroying dquot structures
From: Jan Kara <jack@suse.cz>

Some filesystems would like to keep private information together with each
dquot.  Add callbacks alloc_dquot and destroy_dquot allowing filesystem to
allocate larger dquots from their private slab in a similar fashion we
currently allocate inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c            |   19 +++++++++++++++----
 include/linux/quota.h |    2 ++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff -puN fs/dquot.c~quota-add-callbacks-for-allocating-and-destroying-dquot-structures fs/dquot.c
--- a/fs/dquot.c~quota-add-callbacks-for-allocating-and-destroying-dquot-structures
+++ a/fs/dquot.c
@@ -415,6 +415,14 @@ out_dqlock:
 	return ret;
 }
 
+static void destroy_dquot(struct dquot *dquot)
+{
+	if (dquot->dq_sb->dq_op->destroy_dquot)
+		dquot->dq_sb->dq_op->destroy_dquot(dquot);
+	else
+		kmem_cache_free(dquot_cachep, dquot);
+}
+
 /* Invalidate all dquots on the list. Note that this function is called after
  * quota is disabled and pointers from inodes removed so there cannot be new
  * quota users. There can still be some users of quotas due to inodes being
@@ -463,7 +471,7 @@ restart:
 		remove_dquot_hash(dquot);
 		remove_free_dquot(dquot);
 		remove_inuse(dquot);
-		kmem_cache_free(dquot_cachep, dquot);
+		destroy_dquot(dquot);
 	}
 	spin_unlock(&dq_list_lock);
 }
@@ -527,7 +535,7 @@ static void prune_dqcache(int count)
 		remove_dquot_hash(dquot);
 		remove_free_dquot(dquot);
 		remove_inuse(dquot);
-		kmem_cache_free(dquot_cachep, dquot);
+		destroy_dquot(dquot);
 		count--;
 		head = free_dquots.prev;
 	}
@@ -629,7 +637,10 @@ static struct dquot *get_empty_dquot(str
 {
 	struct dquot *dquot;
 
-	dquot = kmem_cache_zalloc(dquot_cachep, GFP_NOFS);
+	if (sb->dq_op->alloc_dquot)
+		dquot = sb->dq_op->alloc_dquot(sb, type);
+	else
+		dquot = kmem_cache_zalloc(dquot_cachep, GFP_NOFS);
 	if(!dquot)
 		return NODQUOT;
 
@@ -682,7 +693,7 @@ we_slept:
 		dqstats.lookups++;
 		spin_unlock(&dq_list_lock);
 		if (empty)
-			kmem_cache_free(dquot_cachep, empty);
+			destroy_dquot(empty);
 	}
 	/* Wait for dq_lock - after this we know that either dquot_release() is already
 	 * finished or it will be canceled due to dq_count > 1 test */
diff -puN include/linux/quota.h~quota-add-callbacks-for-allocating-and-destroying-dquot-structures include/linux/quota.h
--- a/include/linux/quota.h~quota-add-callbacks-for-allocating-and-destroying-dquot-structures
+++ a/include/linux/quota.h
@@ -292,6 +292,8 @@ struct dquot_operations {
 	int (*free_inode) (const struct inode *, unsigned long);
 	int (*transfer) (struct inode *, struct iattr *);
 	int (*write_dquot) (struct dquot *);		/* Ordinary dquot write */
+	struct dquot *(*alloc_dquot)(struct super_block *, int);	/* Allocate memory for new dquot (can be NULL if no special entries dquot are needed) */
+	void (*destroy_dquot)(struct dquot *);		/* Free memory for dquot (can be NULL if alloc_dquot is NULL) */
 	int (*acquire_dquot) (struct dquot *);		/* Quota is going to be created on disk */
 	int (*release_dquot) (struct dquot *);		/* Quota is going to be deleted from disk */
 	int (*mark_dirty) (struct dquot *);		/* Dquot is marked dirty */
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
quota-add-callbacks-for-allocating-and-destroying-dquot-structures.patch
quota-increase-size-of-variables-for-limits-and-inode-usage.patch
quota-remove-bogus-optimization-in-check_idq-and-check_bdq.patch
quota-make-_suspended-just-a-flag.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
ext3-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
ext4-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
reiserfs-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
quota-remove-compatibility-function-sb_any_quota_enabled.patch
quota-introduce-dquot_quota_sys_file-flag.patch
quota-move-quotaio_vh-from-include-linux-to-fs.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-split-off-quota-tree-handling-into-a-separate-file.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch

