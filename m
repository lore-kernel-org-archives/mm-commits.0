Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF204252BE;
	Tue,  4 Aug 2026 04:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816362; cv=none; b=OKzD06xE5zx/05YOTF73YVn+/goFpSt9fmngn8p1nscTpSKmCkKmAVsHowuFP9MjkC2T3d7DgI5c+G5aefUis2jeKuyynQzUvr8DSC3dzMC7lFMcapnG7KYvBpbNpOlONxEOUu1rbGuTBdCK1WrZVda1ftDM5kNBcRkNw55G21s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816362; c=relaxed/simple;
	bh=S2VJlX6OpfofPCr2X33fcN7iZ1p6ZRiNTWHMACgo1dI=;
	h=Date:To:From:Subject:Message-Id; b=reEAfCI2dKAnUvIIFeiItQbQjDAwPK42ZtYvTMbFABDckzE/l+q59zj+yL1DA2V+1keDDkBVCzE2R3aW1rF07qDFf15C5lqWO4gHjqKwbi8XcvJAxxfn92PB5DnUDi/5tfvc51xPAFiAW8euHxR4tkB582HkwxiuCgNPJPUMdV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wg4BbhPU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wg4BbhPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906DA1F000E9;
	Tue,  4 Aug 2026 04:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816360;
	bh=EqnkrdFzJs+lInZhC5Dzf0+IVehFSJxCxKGuhqCRUn8=;
	h=Date:To:From:Subject;
	b=Wg4BbhPUwJ9Ra6L/n7O8PzrYECGGq6Dqn/qfiiwCZ45NDCaKP/UP8RZlmnSgdmasG
	 0svQ6DpXCdUZJlFmiSf/VBrZ0AwOiLM2rHDT9CVlTs40NE5icz0FA7dC6AdvQbsUY4
	 YTYdtC8cnu9+G+dYhB3Dj77lqFLZOv7BCl2c0uSo=
Date: Mon, 03 Aug 2026 21:06:00 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,icb@fastmail.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-missing-metadata-reservation-for-large-xattrs.patch removed from -mm tree
Message-Id: <20260804040600.906DA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix missing metadata reservation for large xattrs
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-missing-metadata-reservation-for-large-xattrs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ian Bridges <icb@fastmail.org>
Subject: ocfs2: fix missing metadata reservation for large xattrs
Date: Thu, 23 Jul 2026 23:57:03 -0500

[BUG]
lsetxattr() panics the kernel when setting a large xattr value on a
fragmented filesystem where the file already has an external xattr
block.

[CAUSE]
ocfs2_calc_xattr_set_need() never reserves metadata blocks for a new
xattr value's extent tree when the file already has an external xattr
block. The not_found path leaves meta_add at zero, so meta_ac is NULL
when ocfs2_xattr_extend_allocation() runs.

A new value root has room for a single extent record. On a fragmented
filesystem, the allocator cannot satisfy the xattr value in one
contiguous run, so each non-contiguous run requires its own extent
record. When the value root's extent list is full and meta_ac is NULL,
ocfs2_add_clusters_in_btree() returns RESTART_META, and
ocfs2_xattr_extend_allocation() hits BUG_ON(why == RESTART_META).

[FIX]
The case where no xattr block exists yet already calls
ocfs2_extend_meta_needed(&def_xv.xv.xr_list) to reserve value tree
metadata. Add the same reservation to the case where an xattr block
already exists, making the two cases consistent.

Replace the BUG_ON with a -ENOSPC return so that if RESTART_META is
returned despite the reservation, the error propagates to userspace
instead of panicking the kernel.

Link: https://lore.kernel.org/amLwn3i9tET8yhG7@dev
Fixes: a78f9f466894 ("ocfs2: make xattr extension work with new local alloc reservation.")
Signed-off-by: Ian Bridges <icb@fastmail.org>
Reported-by: syzbot+e538032956b1157914a3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e538032956b1157914a3
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-fix-missing-metadata-reservation-for-large-xattrs
+++ a/fs/ocfs2/xattr.c
@@ -764,12 +764,10 @@ static int ocfs2_xattr_extend_allocation
 					 prev_clusters;
 
 		if (why != RESTART_NONE && clusters_to_add) {
-			/*
-			 * We can only fail in case the alloc file doesn't give
-			 * up enough clusters.
-			 */
-			BUG_ON(why == RESTART_META);
-
+			if (why == RESTART_META) {
+				status = -ENOSPC;
+				break;
+			}
 			credits = ocfs2_calc_extend_credits(inode->i_sb,
 							    &vb->vb_xv->xr_list);
 			status = ocfs2_extend_trans(handle, credits);
@@ -3444,6 +3442,14 @@ meta_guess:
 			credits += OCFS2_SUBALLOC_ALLOC + 1;
 
 		/*
+		 * Reserve metadata for the new xattr's value extent tree.
+		 * The not_found path above adds credits for this tree but
+		 * omits meta_add, leaving meta_ac NULL for large values.
+		 */
+		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
+			meta_add += ocfs2_extend_meta_needed(&def_xv.xv.xr_list);
+
+		/*
 		 * This cluster will be used either for new bucket or for
 		 * new xattr block.
 		 * If the cluster size is the same as the bucket size, one
_

Patches currently in -mm which might be from icb@fastmail.org are


