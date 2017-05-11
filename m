From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Thu, 11 May 2017 11:00:27 -0700
Message-ID: <20170511180027.qxX9n8g66%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44952 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932376AbdEKSA2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 May 2017 14:00:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/btrfs/file.c~linux-next-git-rejects fs/btrfs/file.c
--- a/fs/btrfs/file.c~linux-next-git-rejects
+++ a/fs/btrfs/file.c
@@ -2909,21 +2909,13 @@ static long btrfs_fallocate(struct file
 				free_extent_map(em);
 				break;
 			}
-<<<<<<< HEAD
-			ret = btrfs_qgroup_reserve_data(inode, cur_offset,
-					last_byte - cur_offset);
-=======
 			ret = btrfs_qgroup_reserve_data(inode, &data_reserved,
 					cur_offset, last_byte - cur_offset);
->>>>>>> linux-next/akpm-base
 			if (ret < 0) {
 				free_extent_map(em);
 				break;
 			}
-<<<<<<< HEAD
-=======
 			ret = 0;
->>>>>>> linux-next/akpm-base
 		} else {
 			/*
 			 * Do not need to reserve unwritten extent for this
diff -puN fs/btrfs/qgroup.c~linux-next-git-rejects fs/btrfs/qgroup.c
--- a/fs/btrfs/qgroup.c~linux-next-git-rejects
+++ a/fs/btrfs/qgroup.c
@@ -2022,8 +2022,6 @@ int btrfs_qgroup_account_extents(struct
 
 		if (!ret) {
 			/*
-<<<<<<< HEAD
-=======
 			 * old roots should be searched when inserting qgroup
 			 * extent record
 			 */
@@ -2036,7 +2034,6 @@ int btrfs_qgroup_account_extents(struct
 					goto cleanup;
 			}
 			/*
->>>>>>> linux-next/akpm-base
 			 * Use SEQ_LAST as time_seq to do special search, which
 			 * doesn't lock tree or delayed_refs and search current
 			 * root. It's safe inside commit_transaction().
@@ -2959,10 +2956,7 @@ static int __btrfs_qgroup_release_data(s
 		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
 				BTRFS_I(inode)->root->objectid,
 				changeset.bytes_changed);
-<<<<<<< HEAD
-=======
 	ret = changeset.bytes_changed;
->>>>>>> linux-next/akpm-base
 out:
 	ulist_release(&changeset.range_changed);
 	return ret;
diff -puN fs/btrfs/transaction.c~linux-next-git-rejects fs/btrfs/transaction.c
--- a/fs/btrfs/transaction.c~linux-next-git-rejects
+++ a/fs/btrfs/transaction.c
@@ -2177,16 +2177,6 @@ int btrfs_commit_transaction(struct btrf
 		goto scrub_continue;
 	}
 
-<<<<<<< HEAD
-	ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
-	if (ret) {
-		mutex_unlock(&fs_info->tree_log_mutex);
-		mutex_unlock(&fs_info->reloc_mutex);
-		goto scrub_continue;
-	}
