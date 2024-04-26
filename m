Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAA781AB6
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104467; cv=none; b=M8FAsOVJehnn9AmFpsv3L36bLutijbhs12iegoBYy7qjqvMWSj681YnMPqm9jD3g6GPiuGrsWzmRs+FTwLCOMuJeBQydKSSowaFCChQVx99AvUdMnpji3eAIfq0JPDbj6IEADFar6u4Yaq9o+Vwoyj3qFxzG9vWrGEQv8wUSNa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104467; c=relaxed/simple;
	bh=bBL+br0+CfQnDHGEb3+gFjQdWjh4IsYurD0eUVtvrDs=;
	h=Date:To:From:Subject:Message-Id; b=TtOcgeJpx2wcaWM2Erk11zzK/bdk+Hqp5TvgiFCdTDhwRgwQnT6jEWuJOzqDiY0MMbDReXRtotfGj+UpR62Qqg5iyPNH++uQqZpg4pVKeHyCezFVIIpu60IDZ/+q4gh/1JmQq08Bc9iivwNyGEdMI2bXvfsVtnM6sYQ0UQxBVmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZiohpegD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZiohpegD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE67C113CD;
	Fri, 26 Apr 2024 04:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104467;
	bh=bBL+br0+CfQnDHGEb3+gFjQdWjh4IsYurD0eUVtvrDs=;
	h=Date:To:From:Subject:From;
	b=ZiohpegDOkUMJx2UuqvKO1sQZtbcXxxUkG5ibMQTsNavASyGV2ZY77SFG6MStf9Gk
	 a/oE5g2Qi43xFYyeVMXLTgTlKH5IJ+UCzBo7KLGdwFBuXx+GTOZqXj21pBVcNjZyyI
	 3OUFlavTooW9v8d1x+QUD6RWxnbjQGMURUYykMp4=
Date: Thu, 25 Apr 2024 21:07:46 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-sparse-warnings.patch removed from -mm tree
Message-Id: <20240426040747.6EE67C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix sparse warnings
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-sparse-warnings.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: fix sparse warnings
Date: Thu, 28 Mar 2024 20:52:03 +0800

1.
fs/ocfs2/localalloc.c:1224:41: warning: incorrect type in argument 1 (different base types)
fs/ocfs2/localalloc.c:1224:41:    expected unsigned long long val1
fs/ocfs2/localalloc.c:1224:41:    got restricted __le32 [usertype] la_bm_off

2.
fs/ocfs2/export.c:258:32: warning: cast to restricted __le32
fs/ocfs2/export.c:259:33: warning: cast to restricted __le32
fs/ocfs2/export.c:260:32: warning: cast to restricted __le32
fs/ocfs2/export.c:272:32: warning: cast to restricted __le32
fs/ocfs2/export.c:273:33: warning: cast to restricted __le32
fs/ocfs2/export.c:274:32: warning: cast to restricted __le32

3.
fs/ocfs2/inode.c:1623:13: warning: context imbalance in 'ocfs2_inode_cache_lock' - wrong count at exit
fs/ocfs2/inode.c:1630:13: warning: context imbalance in 'ocfs2_inode_cache_unlock' - unexpected unlock

4.
fs/ocfs2/refcounttree.c:633:27: warning: incorrect type in assignment (different base types)
fs/ocfs2/refcounttree.c:633:27:    expected restricted __le32 [usertype] rf_generation
fs/ocfs2/refcounttree.c:633:27:    got unsigned int

5.
fs/ocfs2/dlm/dlmdomain.c:1316:20: warning: context imbalance in 'dlm_query_nodeinfo_handler' - different lock contexts for basic block

Link: https://lkml.kernel.org/r/20240328125203.20892-5-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |   11 +++++------
 fs/ocfs2/export.c        |   12 ++++++------
 fs/ocfs2/inode.c         |    2 ++
 fs/ocfs2/localalloc.c    |    4 ++--
 fs/ocfs2/refcounttree.c  |    2 +-
 5 files changed, 16 insertions(+), 15 deletions(-)

--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-fix-sparse-warnings
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1274,7 +1274,7 @@ static int dlm_query_nodeinfo_handler(st
 {
 	struct dlm_query_nodeinfo *qn;
 	struct dlm_ctxt *dlm = NULL;
-	int locked = 0, status = -EINVAL;
+	int status = -EINVAL;
 
 	qn = (struct dlm_query_nodeinfo *) msg->buf;
 
@@ -1290,12 +1290,11 @@ static int dlm_query_nodeinfo_handler(st
 	}
 
 	spin_lock(&dlm->spinlock);
-	locked = 1;
 	if (dlm->joining_node != qn->qn_nodenum) {
 		mlog(ML_ERROR, "Node %d queried nodes on domain %s but "
 		     "joining node is %d\n", qn->qn_nodenum, qn->qn_domain,
 		     dlm->joining_node);
-		goto bail;
+		goto unlock;
 	}
 
 	/* Support for node query was added in 1.1 */
@@ -1305,14 +1304,14 @@ static int dlm_query_nodeinfo_handler(st
 		     "but active dlm protocol is %d.%d\n", qn->qn_nodenum,
 		     qn->qn_domain, dlm->dlm_locking_proto.pv_major,
 		     dlm->dlm_locking_proto.pv_minor);
-		goto bail;
+		goto unlock;
 	}
 
 	status = dlm_match_nodes(dlm, qn);
 
+unlock:
+	spin_unlock(&dlm->spinlock);
 bail:
-	if (locked)
-		spin_unlock(&dlm->spinlock);
 	spin_unlock(&dlm_domain_lock);
 
 	return status;
--- a/fs/ocfs2/export.c~ocfs2-fix-sparse-warnings
+++ a/fs/ocfs2/export.c
@@ -255,9 +255,9 @@ static struct dentry *ocfs2_fh_to_dentry
 	if (fh_len < 3 || fh_type > 2)
 		return NULL;
 
-	handle.ih_blkno = (u64)le32_to_cpu(fid->raw[0]) << 32;
-	handle.ih_blkno |= (u64)le32_to_cpu(fid->raw[1]);
-	handle.ih_generation = le32_to_cpu(fid->raw[2]);
+	handle.ih_blkno = (u64)le32_to_cpu((__force __le32)fid->raw[0]) << 32;
+	handle.ih_blkno |= (u64)le32_to_cpu((__force __le32)fid->raw[1]);
+	handle.ih_generation = le32_to_cpu((__force __le32)fid->raw[2]);
 	return ocfs2_get_dentry(sb, &handle);
 }
 
@@ -269,9 +269,9 @@ static struct dentry *ocfs2_fh_to_parent
 	if (fh_type != 2 || fh_len < 6)
 		return NULL;
 
-	parent.ih_blkno = (u64)le32_to_cpu(fid->raw[3]) << 32;
-	parent.ih_blkno |= (u64)le32_to_cpu(fid->raw[4]);
-	parent.ih_generation = le32_to_cpu(fid->raw[5]);
+	parent.ih_blkno = (u64)le32_to_cpu((__force __le32)fid->raw[3]) << 32;
+	parent.ih_blkno |= (u64)le32_to_cpu((__force __le32)fid->raw[4]);
+	parent.ih_generation = le32_to_cpu((__force __le32)fid->raw[5]);
 	return ocfs2_get_dentry(sb, &parent);
 }
 
--- a/fs/ocfs2/inode.c~ocfs2-fix-sparse-warnings
+++ a/fs/ocfs2/inode.c
@@ -1621,6 +1621,7 @@ static struct super_block *ocfs2_inode_c
 }
 
 static void ocfs2_inode_cache_lock(struct ocfs2_caching_info *ci)
+__acquires(&oi->ip_lock)
 {
 	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
 
@@ -1628,6 +1629,7 @@ static void ocfs2_inode_cache_lock(struc
 }
 
 static void ocfs2_inode_cache_unlock(struct ocfs2_caching_info *ci)
+__releases(&oi->ip_lock)
 {
 	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
 
--- a/fs/ocfs2/localalloc.c~ocfs2-fix-sparse-warnings
+++ a/fs/ocfs2/localalloc.c
@@ -336,7 +336,7 @@ int ocfs2_load_local_alloc(struct ocfs2_
 		     "found = %u, set = %u, taken = %u, off = %u\n",
 		     num_used, le32_to_cpu(alloc->id1.bitmap1.i_used),
 		     le32_to_cpu(alloc->id1.bitmap1.i_total),
-		     OCFS2_LOCAL_ALLOC(alloc)->la_bm_off);
+		     le32_to_cpu(OCFS2_LOCAL_ALLOC(alloc)->la_bm_off));
 
 		status = -EINVAL;
 		goto bail;
@@ -1214,7 +1214,7 @@ retry_enospc:
 			     OCFS2_LOCAL_ALLOC(alloc)->la_bitmap);
 
 	trace_ocfs2_local_alloc_new_window_result(
-		OCFS2_LOCAL_ALLOC(alloc)->la_bm_off,
+		le32_to_cpu(OCFS2_LOCAL_ALLOC(alloc)->la_bm_off),
 		le32_to_cpu(alloc->id1.bitmap1.i_total));
 
 bail:
--- a/fs/ocfs2/refcounttree.c~ocfs2-fix-sparse-warnings
+++ a/fs/ocfs2/refcounttree.c
@@ -630,7 +630,7 @@ static int ocfs2_create_refcount_tree(st
 	rb->rf_records.rl_count =
 			cpu_to_le16(ocfs2_refcount_recs_per_rb(osb->sb));
 	spin_lock(&osb->osb_lock);
-	rb->rf_generation = osb->s_next_generation++;
+	rb->rf_generation = cpu_to_le32(osb->s_next_generation++);
 	spin_unlock(&osb->osb_lock);
 
 	ocfs2_journal_dirty(handle, new_bh);
_

Patches currently in -mm which might be from heming.zhao@suse.com are


