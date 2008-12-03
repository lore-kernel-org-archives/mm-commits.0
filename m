From: akpm@linux-foundation.org
Subject: - quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables.patch removed from -mm tree
Date: Wed, 03 Dec 2008 12:27:29 -0800
Message-ID: <200812032027.mB3KRTbG027352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759049AbYLCU2G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 15:28:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmm@us.ibm.com, hch@lst.de, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     quota cleanup: move EXPORT_SYMBOL immediatlely next to the functions/variables
has been removed from the -mm tree.  Its filename was
     quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables.patch

This patch was dropped because of rejects against linux-next

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota cleanup: move EXPORT_SYMBOL immediatlely next to the functions/variables
From: Mingming Cao <cmm@us.ibm.com>

EXPORT_SYMBOL(foo); should immediately follow its function/variable.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |   68 ++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 35 deletions(-)

diff -puN fs/dquot.c~quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables fs/dquot.c
--- a/fs/dquot.c~quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables
+++ a/fs/dquot.c
@@ -127,6 +127,7 @@
 
 static DEFINE_SPINLOCK(dq_list_lock);
 DEFINE_SPINLOCK(dq_data_lock);
+EXPORT_SYMBOL(dq_data_lock);
 
 static char *quotatypes[] = INITQFNAMES;
 static struct quota_format_type *quota_formats;	/* List of registered formats */
@@ -143,6 +144,7 @@ int register_quota_format(struct quota_f
 	spin_unlock(&dq_list_lock);
 	return 0;
 }
+EXPORT_SYMBOL(register_quota_format);
 
 void unregister_quota_format(struct quota_format_type *fmt)
 {
@@ -154,6 +156,7 @@ void unregister_quota_format(struct quot
 		*actqf = (*actqf)->qf_next;
 	spin_unlock(&dq_list_lock);
 }
+EXPORT_SYMBOL(unregister_quota_format);
 
 static struct quota_format_type *find_quota_format(int id)
 {
@@ -210,6 +213,7 @@ static unsigned int dq_hash_bits, dq_has
 static struct hlist_head *dquot_hash;
 
 struct dqstats dqstats;
+EXPORT_SYMBOL(dqstats);
 
 static void dqput(struct dquot *dquot);
 
@@ -306,6 +310,7 @@ int dquot_mark_dquot_dirty(struct dquot 
 	spin_unlock(&dq_list_lock);
 	return 0;
 }
+EXPORT_SYMBOL(dquot_mark_dquot_dirty);
 
 /* This function needs dq_list_lock */
 static inline int clear_dquot_dirty(struct dquot *dquot)
@@ -357,6 +362,7 @@ out_iolock:
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_acquire);
 
 /*
  *	Write dquot to disk
@@ -386,6 +392,7 @@ out_sem:
 	mutex_unlock(&dqopt->dqio_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_commit);
 
 /*
  *	Release dquot
@@ -414,6 +421,7 @@ out_dqlock:
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_release);
 
 static void destroy_dquot(struct dquot *dquot)
 {
@@ -522,6 +530,7 @@ int vfs_quota_sync(struct super_block *s
 
 	return 0;
 }
+EXPORT_SYMBOL(vfs_quota_sync);
 
 /* Free unused dquots from cache */
 static void prune_dqcache(int count)
@@ -1201,6 +1210,7 @@ out_err:
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_initialize);
 
 /*
  * 	Release all quotas referenced by inode
@@ -1220,6 +1230,7 @@ int dquot_drop(struct inode *inode)
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return 0;
 }
+EXPORT_SYMBOL(dquot_drop);
 
 /* Wrapper to remove references to quota structures from inode */
 void vfs_dq_drop(struct inode *inode)
@@ -1242,6 +1253,7 @@ void vfs_dq_drop(struct inode *inode)
 			inode->i_sb->dq_op->drop(inode);
 	}
 }
+EXPORT_SYMBOL(vfs_dq_drop);
 
 /*
  * Following four functions update i_blocks+i_bytes fields and
@@ -1318,6 +1330,7 @@ out:
 		inode_add_bytes(inode, number);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_alloc_space);
 
 int dquot_reserve_space(struct inode *inode, qsize_t number, int warn)
 {
@@ -1336,6 +1349,7 @@ out_unlock:
 out:
 	return ret;
 }
+EXPORT_SYMBOL(dquot_reserve_space);
 
 int dquot_claim_space(struct inode *inode, qsize_t number)
 {
@@ -1374,6 +1388,7 @@ int dquot_claim_space(struct inode *inod
 	inode_add_bytes(inode, number);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_reserve_space);
 
 /*
  * Release reserved quota space
@@ -1403,6 +1418,7 @@ out_unlock:
 out:
 	return;
 }
+EXPORT_SYMBOL(dquot_release_reserved_space);
 
 /*
  * This operation can block, but only after everything is updated
@@ -1448,6 +1464,7 @@ warn_put_all:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_alloc_inode);
 
 /*
  * This operation can block, but only after everything is updated
@@ -1488,6 +1505,7 @@ out_sub:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
+EXPORT_SYMBOL(dquot_free_space);
 
 /*
  * This operation can block, but only after everything is updated
@@ -1524,6 +1542,7 @@ int dquot_free_inode(const struct inode 
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
+EXPORT_SYMBOL(dquot_free_inode);
 
 /*
  * Transfer the number of inode and blocks from one diskquota to an other.
@@ -1634,6 +1653,7 @@ warn_put_all:
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_transfer);
 
 /* Wrapper for transferring ownership of an inode */
 int vfs_dq_transfer(struct inode *inode, struct iattr *iattr)
@@ -1645,7 +1665,7 @@ int vfs_dq_transfer(struct inode *inode,
 	}
 	return 0;
 }
-
+EXPORT_SYMBOL(vfs_dq_transfer);
 
 /*
  * Write info of quota file to disk
@@ -1660,6 +1680,7 @@ int dquot_commit_info(struct super_block
 	mutex_unlock(&dqopt->dqio_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_commit_info);
 
 /*
  * Definitions of diskquota operations.
@@ -1805,12 +1826,14 @@ put_inodes:
 		}
 	return ret;
 }
+EXPORT_SYMBOL(vfs_quota_disable);
 
 int vfs_quota_off(struct super_block *sb, int type, int remount)
 {
 	return vfs_quota_disable(sb, type, remount ? DQUOT_SUSPENDED :
 				 (DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED));
 }
+EXPORT_SYMBOL(vfs_quota_off);
 
 /*
  *	Turn quotas on on a device
@@ -1948,6 +1971,7 @@ static int vfs_quota_on_remount(struct s
 
 	return ret;
 }
+EXPORT_SYMBOL(vfs_dq_quota_on_remount);
 
 int vfs_quota_on_path(struct super_block *sb, int type, int format_id,
 		      struct path *path)
@@ -1964,6 +1988,7 @@ int vfs_quota_on_path(struct super_block
 					     DQUOT_LIMITS_ENABLED);
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on_path);
 
 int vfs_quota_on(struct super_block *sb, int type, int format_id, char *name,
 		 int remount)
@@ -1981,6 +2006,7 @@ int vfs_quota_on(struct super_block *sb,
 	}
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on);
 
 /*
  * More powerful function for turning on quotas allowing setting
@@ -2025,6 +2051,7 @@ out_lock:
 load_quota:
 	return vfs_load_quota_inode(inode, type, format_id, flags);
 }
+EXPORT_SYMBOL(vfs_quota_enable);
 
 /*
  * This function is used when filesystem needs to initialize quotas
@@ -2054,6 +2081,7 @@ out:
 	dput(dentry);
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on_mount);
 
 /* Wrapper to turn on quotas when remounting rw */
 int vfs_dq_quota_on_remount(struct super_block *sb)
@@ -2070,6 +2098,7 @@ int vfs_dq_quota_on_remount(struct super
 	}
 	return ret;
 }
+EXPORT_SYMBOL(vfs_dq_quota_on_remount);
 
 static inline qsize_t qbtos(qsize_t blocks)
 {
@@ -2113,6 +2142,7 @@ int vfs_get_dqblk(struct super_block *sb
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(vfs_get_dqblk);
 
 /* Generic routine for setting common part of quota structure */
 static int do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
@@ -2196,6 +2226,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return rc;
 }
+EXPORT_SYMBOL(vfs_set_dqblk);
 
 /* Generic routine for getting common part of quota file information */
 int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
@@ -2217,6 +2248,7 @@ int vfs_get_dqinfo(struct super_block *s
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(vfs_get_dqinfo);
 
 /* Generic routine for setting common part of quota file information */
 int vfs_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
@@ -2400,37 +2432,3 @@ static int __init dquot_init(void)
 	return 0;
 }
 module_init(dquot_init);
-
-EXPORT_SYMBOL(register_quota_format);
-EXPORT_SYMBOL(unregister_quota_format);
-EXPORT_SYMBOL(dqstats);
-EXPORT_SYMBOL(dq_data_lock);
-EXPORT_SYMBOL(vfs_quota_enable);
-EXPORT_SYMBOL(vfs_quota_on);
-EXPORT_SYMBOL(vfs_quota_on_path);
-EXPORT_SYMBOL(vfs_quota_on_mount);
-EXPORT_SYMBOL(vfs_quota_disable);
-EXPORT_SYMBOL(vfs_quota_off);
-EXPORT_SYMBOL(vfs_quota_sync);
-EXPORT_SYMBOL(vfs_get_dqinfo);
-EXPORT_SYMBOL(vfs_set_dqinfo);
-EXPORT_SYMBOL(vfs_get_dqblk);
-EXPORT_SYMBOL(vfs_set_dqblk);
-EXPORT_SYMBOL(dquot_commit);
-EXPORT_SYMBOL(dquot_commit_info);
-EXPORT_SYMBOL(dquot_acquire);
-EXPORT_SYMBOL(dquot_release);
-EXPORT_SYMBOL(dquot_mark_dquot_dirty);
-EXPORT_SYMBOL(dquot_initialize);
-EXPORT_SYMBOL(dquot_drop);
-EXPORT_SYMBOL(vfs_dq_drop);
-EXPORT_SYMBOL(dquot_alloc_space);
-EXPORT_SYMBOL(dquot_alloc_inode);
-EXPORT_SYMBOL(dquot_free_space);
-EXPORT_SYMBOL(dquot_free_inode);
-EXPORT_SYMBOL(dquot_reserve_space);
-EXPORT_SYMBOL(dquot_claim_space);
-EXPORT_SYMBOL(dquot_release_reserved_space);
-EXPORT_SYMBOL(dquot_transfer);
-EXPORT_SYMBOL(vfs_dq_transfer);
-EXPORT_SYMBOL(vfs_dq_quota_on_remount);
_

Patches currently in -mm which might be from cmm@us.ibm.com are

quota-add-reservation-support-for-delayed-block-allocation.patch
quota-add-quota-claim-and-release-reserved-quota-blocks-operations.patch
ext4-quota-handling-for-delayed-allocation.patch
quota-cleanup-use-inode-i_blkbits-to-get-block-bits.patch
quota-cleanup-use-inode-i_blkbits-to-get-block-bits-fix.patch
quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables.patch
quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables-fix.patch

