Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2E1170A0B
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742266; cv=none; b=hUdtyxSPW+U3TD8BPzyGPlqrreP73dPW6ChfMvnvVlavX11Dz005EOXll1AI7v711JdChL+jRGuXt7sg8NKAMVD/x2QprB+Lw6sEvixm1sEf/n1B5AGpzxudnuIS8O0hf1d8xzY2Nvkj2F40rJVl06CWMAwgjkS3hTRDPkDmEyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742266; c=relaxed/simple;
	bh=LmT3xniza0Pd98/O56S0NsI28XRntSIQ8DNrqM7xxRY=;
	h=Date:To:From:Subject:Message-Id; b=izWCfcoApKv/utaG5zfPaQ3KQ3IyMfb9khXz1ID9geTk21Y0OkJps1oyHqPaxZjowFPfuFq505NYp2YjWPrji13MNDqoYqmti58VFpb2Da3cKhZzU3oJEIzVH7PkBDiUryAxKhMLYGQVzZQeFPOvMRcN2XX/1BJ/I+pnyyTCAEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jfFPPMTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jfFPPMTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53007C4CED6;
	Mon, 13 Jan 2025 04:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742266;
	bh=LmT3xniza0Pd98/O56S0NsI28XRntSIQ8DNrqM7xxRY=;
	h=Date:To:From:Subject:From;
	b=jfFPPMTFD5hJKK4ycUB7SLd/7u0V9fw1jYDRGVKCSa9VO7GVvi68jOPZRMiUwvfxn
	 fGbEZqZaaG4cQnub+QiGYRZw+pNOcdlH6aK5TJnPRr5ugvm0L6iz2+LKZq2gdZ+lPh
	 9ttPRI/YJmct9mxInCLQlCuhKiJu0eCFC6jNulP8=
Date: Sun, 12 Jan 2025 20:24:25 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-parameter-parent_fe_bh-from-__ocfs2_mknod_locked.patch removed from -mm tree
Message-Id: <20250113042426.53007C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove parameter parent_fe_bh from __ocfs2_mknod_locked
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-parameter-parent_fe_bh-from-__ocfs2_mknod_locked.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Su Yue <glass.su@suse.com>
Subject: ocfs2: remove parameter parent_fe_bh from __ocfs2_mknod_locked
Date: Mon, 6 Jan 2025 22:06:34 +0800

The parameter is not used in __ocfs2_mknod_locked().  So remove it.

No functional change.

Link: https://lkml.kernel.org/r/20250106140634.92241-1-glass.su@suse.com
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-remove-parameter-parent_fe_bh-from-__ocfs2_mknod_locked
+++ a/fs/ocfs2/namei.c
@@ -508,7 +508,6 @@ static int __ocfs2_mknod_locked(struct i
 				struct inode *inode,
 				dev_t dev,
 				struct buffer_head **new_fe_bh,
-				struct buffer_head *parent_fe_bh,
 				handle_t *handle,
 				struct ocfs2_alloc_context *inode_ac,
 				u64 fe_blkno, u64 suballoc_loc, u16 suballoc_bit)
@@ -641,8 +640,8 @@ static int ocfs2_mknod_locked(struct ocf
 	}
 
 	return __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
-				    parent_fe_bh, handle, inode_ac,
-				    fe_blkno, suballoc_loc, suballoc_bit);
+				    handle, inode_ac, fe_blkno,
+				    suballoc_loc, suballoc_bit);
 }
 
 static int ocfs2_mkdir(struct mnt_idmap *idmap,
@@ -2576,7 +2575,7 @@ int ocfs2_create_inode_in_orphan(struct
 	clear_nlink(inode);
 	/* do the real work now. */
 	status = __ocfs2_mknod_locked(dir, inode,
-				      0, &new_di_bh, parent_di_bh, handle,
+				      0, &new_di_bh, handle,
 				      inode_ac, di_blkno, suballoc_loc,
 				      suballoc_bit);
 	if (status < 0) {
_

Patches currently in -mm which might be from glass.su@suse.com are


