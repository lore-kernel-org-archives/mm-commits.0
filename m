From: akpm@linux-foundation.org
Subject: - quota-add-possibly-missing-iput-when-quotaon-and-quotaoff-races.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:13 -0700
Message-ID: <200803212029.m2LKTDRA008850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758342AbYCUU3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:29:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: add possibly missing iput() when quotaon and quotaoff races
has been removed from the -mm tree.  Its filename was
     quota-add-possibly-missing-iput-when-quotaon-and-quotaoff-races.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: add possibly missing iput() when quotaon and quotaoff races
From: Jan Kara <jack@suse.cz>

We should always put inode we have reference to, even if quota was reenabled
in the mean time.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dquot.c~quota-add-possibly-missing-iput-when-quotaon-and-quotaoff-races fs/dquot.c
--- a/fs/dquot.c~quota-add-possibly-missing-iput-when-quotaon-and-quotaoff-races
+++ a/fs/dquot.c
@@ -1522,8 +1522,8 @@ int vfs_quota_off(struct super_block *sb
 				truncate_inode_pages(&toputinode[cnt]->i_data, 0);
 				mutex_unlock(&toputinode[cnt]->i_mutex);
 				mark_inode_dirty(toputinode[cnt]);
-				iput(toputinode[cnt]);
 			}
+			iput(toputinode[cnt]);
 			mutex_unlock(&dqopt->dqonoff_mutex);
 		}
 	if (sb->s_bdev)
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
git-udf.patch
git-ocfs2.patch
quota-do-not-allow-setting-of-quota-limits-to-too-high-values.patch
quota-remove-superfluous-dquot_off-in-fs-namespacec.patch
quota-various-style-cleanups.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-reiserfs-make-reiserfs-handle-quotaon-on-remount.patch
ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
quota-le_add_cpu-conversion.patch

