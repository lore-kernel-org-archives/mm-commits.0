From: akpm@linux-foundation.org
Subject: [folded-merged]
 list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
 removed from -mm tree
Date: Tue, 10 Sep 2013 15:34:01 -0700
Message-ID: <522f9e59.a3EVLr7ee18d2KpY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3IJWeC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 18:34:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, glommer@openvz.org, dchinner@redhat.com, glommer@gmail.com

Subject: [folded-merged] list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch removed from -mm tree
To: glommer@gmail.com,dchinner@redhat.com,glommer@openvz.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 15:34:01 -0700


The patch titled
     Subject: super: fix for destroy lrus
has been removed from the -mm tree.  Its filename was
     list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch

This patch was dropped because it was folded into list_lru-dynamically-adjust-node-arrays.patch

------------------------------------------------------
From: Glauber Costa <glommer@gmail.com>
Subject: super: fix for destroy lrus

This patch adds the missing call to list_lru_destroy (spotted by Li Zhong)
and moves the deletion to after the shrinker is unregistered, as correctly
spotted by Dave

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c       |    3 +++
 fs/xfs/xfs_buf.c |    2 +-
 fs/xfs/xfs_qm.c  |    2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/super.c~list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus fs/super.c
--- a/fs/super.c~list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus
+++ a/fs/super.c
@@ -328,6 +328,9 @@ void deactivate_locked_super(struct supe
 
 		/* caches are now gone, we can safely kill the shrinker now */
 		unregister_shrinker(&s->s_shrink);
+		list_lru_destroy(&s->s_dentry_lru);
+		list_lru_destroy(&s->s_inode_lru);
+
 		put_filesystem(fs);
 		put_super(s);
 	} else {
diff -puN fs/xfs/xfs_buf.c~list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus fs/xfs/xfs_buf.c
--- a/fs/xfs/xfs_buf.c~list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus
+++ a/fs/xfs/xfs_buf.c
@@ -1592,8 +1592,8 @@ xfs_free_buftarg(
 	struct xfs_mount	*mp,
 	struct xfs_buftarg	*btp)
 {
-	list_lru_destroy(&btp->bt_lru);
 	unregister_shrinker(&btp->bt_shrinker);
+	list_lru_destroy(&btp->bt_lru);
 
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
 		xfs_blkdev_issue_flush(btp);
diff -puN fs/xfs/xfs_qm.c~list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus fs/xfs/xfs_qm.c
--- a/fs/xfs/xfs_qm.c~list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus
+++ a/fs/xfs/xfs_qm.c
@@ -940,8 +940,8 @@ xfs_qm_destroy_quotainfo(
 	qi = mp->m_quotainfo;
 	ASSERT(qi != NULL);
 
-	list_lru_destroy(&qi->qi_lru);
 	unregister_shrinker(&qi->qi_shrinker);
+	list_lru_destroy(&qi->qi_lru);
 
 	if (qi->qi_uquotaip) {
 		IRELE(qi->qi_uquotaip);
_

Patches currently in -mm which might be from glommer@gmail.com are

origin.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
list_lru-per-node-list-infrastructure.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
list_lru-dynamically-adjust-node-arrays.patch

