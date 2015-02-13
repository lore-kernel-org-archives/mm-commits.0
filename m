From: akpm@linux-foundation.org
Subject: [merged]
 fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:19:45 -0800
Message-ID: <54de5c61.8bbpAuClFuWYm2y7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbbBMUTq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:19:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, glommer@gmail.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: consolidate {nr,free}_cached_objects args in shrink_control
has been removed from the -mm tree.  Its filename was
     fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: fs: consolidate {nr,free}_cached_objects args in shrink_control

We are going to make FS shrinkers memcg-aware.  To achieve that, we will
have to pass the memcg to scan to the nr_cached_objects and
free_cached_objects VFS methods, which currently take only the NUMA node
to scan.  Since the shrink_control structure already holds the node, and
the memcg to scan will be added to it when we introduce memcg-aware
vmscan, let us consolidate the methods' arguments in this structure to
keep things clean.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c         |   12 ++++++------
 fs/xfs/xfs_super.c |    7 +++----
 include/linux/fs.h |    6 ++++--
 3 files changed, 13 insertions(+), 12 deletions(-)

diff -puN fs/super.c~fs-consolidate-nrfree_cached_objects-args-in-shrink_control fs/super.c
--- a/fs/super.c~fs-consolidate-nrfree_cached_objects-args-in-shrink_control
+++ a/fs/super.c
@@ -75,7 +75,7 @@ static unsigned long super_cache_scan(st
 		return SHRINK_STOP;
 
 	if (sb->s_op->nr_cached_objects)
-		fs_objects = sb->s_op->nr_cached_objects(sb, sc->nid);
+		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
 	dentries = list_lru_shrink_count(&sb->s_dentry_lru, sc);
@@ -97,9 +97,10 @@ static unsigned long super_cache_scan(st
 	sc->nr_to_scan = inodes;
 	freed += prune_icache_sb(sb, sc);
 
-	if (fs_objects)
-		freed += sb->s_op->free_cached_objects(sb, fs_objects,
-						       sc->nid);
+	if (fs_objects) {
+		sc->nr_to_scan = fs_objects;
+		freed += sb->s_op->free_cached_objects(sb, sc);
+	}
 
 	drop_super(sb);
 	return freed;
@@ -122,8 +123,7 @@ static unsigned long super_cache_count(s
 	 * s_op->nr_cached_objects().
 	 */
 	if (sb->s_op && sb->s_op->nr_cached_objects)
-		total_objects = sb->s_op->nr_cached_objects(sb,
-						 sc->nid);
+		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
 	total_objects += list_lru_shrink_count(&sb->s_inode_lru, sc);
diff -puN fs/xfs/xfs_super.c~fs-consolidate-nrfree_cached_objects-args-in-shrink_control fs/xfs/xfs_super.c
--- a/fs/xfs/xfs_super.c~fs-consolidate-nrfree_cached_objects-args-in-shrink_control
+++ a/fs/xfs/xfs_super.c
@@ -1537,7 +1537,7 @@ xfs_fs_mount(
 static long
 xfs_fs_nr_cached_objects(
 	struct super_block	*sb,
-	int			nid)
+	struct shrink_control	*sc)
 {
 	return xfs_reclaim_inodes_count(XFS_M(sb));
 }
@@ -1545,10 +1545,9 @@ xfs_fs_nr_cached_objects(
 static long
 xfs_fs_free_cached_objects(
 	struct super_block	*sb,
-	long			nr_to_scan,
-	int			nid)
+	struct shrink_control	*sc)
 {
-	return xfs_reclaim_inodes_nr(XFS_M(sb), nr_to_scan);
+	return xfs_reclaim_inodes_nr(XFS_M(sb), sc->nr_to_scan);
 }
 
 static const struct super_operations xfs_super_operations = {
diff -puN include/linux/fs.h~fs-consolidate-nrfree_cached_objects-args-in-shrink_control include/linux/fs.h
--- a/include/linux/fs.h~fs-consolidate-nrfree_cached_objects-args-in-shrink_control
+++ a/include/linux/fs.h
@@ -1635,8 +1635,10 @@ struct super_operations {
 	struct dquot **(*get_dquots)(struct inode *);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
-	long (*nr_cached_objects)(struct super_block *, int);
-	long (*free_cached_objects)(struct super_block *, long, int);
+	long (*nr_cached_objects)(struct super_block *,
+				  struct shrink_control *);
+	long (*free_cached_objects)(struct super_block *,
+				    struct shrink_control *);
 };
 
 /*
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

