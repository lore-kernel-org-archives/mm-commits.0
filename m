Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C933A16A1;
	Wed, 17 Jun 2026 22:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781735906; cv=none; b=lT3p8PRm4tfWaBxKYKEar6q9kob7OR0GXNbhD1ZtDr/BuD65A/gsT3ztExrWFDJFmOOX0vzRPJncyoPcGB45UpFcfnGA4cu4Jwjr3MiFXs9hMVfjSzJ9Fiq+eRm66h3M8+JUQl/5nfEAuEJ3gP7RJNULnOcvi470XK+UEpzjF28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781735906; c=relaxed/simple;
	bh=HMH+lVLGgqe99xy19Rj4iMRMltZOaARfEJkZk5GFEH4=;
	h=Date:To:From:Subject:Message-Id; b=WPtTHW4Cl6jp+x/KqvdtiW6r/tzFgRy5Sx+iAIOZbXX/1Oqhn07L5CNa74UAAShlHlE2PCES5Iq98j5rsx5Pg9uHFGg4xbUv2EhWUEKWXYzmsQufaXTzIG4uklVFdilwvQ85+PuuPfNFo9d2p5D/cOfPtsZ+6C3J1qSQyllqlFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XdjE4U2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XdjE4U2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EFA1F000E9;
	Wed, 17 Jun 2026 22:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781735905;
	bh=QxXjVPmNZT+NleJZwxvesXV9FeS2lbLn27IajwUm/FE=;
	h=Date:To:From:Subject;
	b=XdjE4U2FdDYY11MsWFGGQCxqCfXd5vDc5BilDc45FR3fzzvxmcIUcD7GtCOCPrZRd
	 D8GdPvMVgCry+wYMx2dI9aiN9NPthGREICtnFUar6mqHOAjltDwTBTCoZBJI2qqtu8
	 hJNzGgMyVBXqSWTothDyt4eAIb/W/ajJjONVz2UQ=
Date: Wed, 17 Jun 2026 15:38:24 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,icb@fastmail.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-ubsan-array-index-out-of-bounds-in-ocfs2_sum_rightmost_rec.patch removed from -mm tree
Message-Id: <20260617223825.11EFA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-ubsan-array-index-out-of-bounds-in-ocfs2_sum_rightmost_rec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ian Bridges <icb@fastmail.org>
Subject: ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec
Date: Wed, 10 Jun 2026 19:23:11 -0500

[BUG]
On-disk corruption setting l_next_free_rec to 0 in an inode's embedded
extent list triggers a UBSAN panic on the next write to that file.

[CAUSE]
ocfs2_sum_rightmost_rec() computes
i = le16_to_cpu(el->l_next_free_rec) - 1
and accesses el->l_recs[i] without validating i. When l_next_free_rec
is 0, i becomes -1; when l_next_free_rec exceeds l_count, i falls
past the end of the array. Either case violates the
__counted_by_le(l_count) annotation on l_recs[] and triggers UBSAN.

[FIX]
Validate the inode's embedded extent list when the inode is read, in
ocfs2_validate_inode_block(): l_count must be non-zero and no larger
than the inode block can hold, and l_next_free_rec must not exceed
l_count. A corrupt list is rejected at read time, before the b-tree
code can index l_recs[] out of bounds.

Link: https://lore.kernel.org/ain_780qc0P4ypNd@dev
Signed-off-by: Ian Bridges <icb@fastmail.org>
Reported-by: syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=be16e33db01e6644db7a
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

 fs/ocfs2/inode.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-fix-ubsan-array-index-out-of-bounds-in-ocfs2_sum_rightmost_rec
+++ a/fs/ocfs2/inode.c
@@ -1696,6 +1696,38 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_extents(di)) {
+		struct ocfs2_extent_list *el = &di->id2.i_list;
+		u16 count = le16_to_cpu(el->l_count);
+		u16 next_free = le16_to_cpu(el->l_next_free_rec);
+
+		if (count == 0) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: extent list l_count is zero\n",
+					 (unsigned long long)bh->b_blocknr);
+			goto bail;
+		}
+		/*
+		 * The exact capacity depends on i_xattr_inline_size, another
+		 * unvalidated on-disk field. Inline xattrs only shrink the
+		 * list, so the no-xattr maximum is a safe upper bound that a
+		 * valid l_count never exceeds.
+		 */
+		if (count > ocfs2_extent_recs_per_inode(sb)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: extent list l_count %u exceeds max %u\n",
+					 (unsigned long long)bh->b_blocknr, count,
+					 ocfs2_extent_recs_per_inode(sb));
+			goto bail;
+		}
+		if (next_free > count) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: extent list l_next_free_rec %u exceeds l_count %u\n",
+					 (unsigned long long)bh->b_blocknr, next_free, count);
+			goto bail;
+		}
+	}
+
 	rc = 0;
 
 bail:
_

Patches currently in -mm which might be from icb@fastmail.org are


