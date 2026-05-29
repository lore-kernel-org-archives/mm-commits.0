Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2331F37268C
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028776; cv=none; b=XIh6ldjxp9cr4N3Axi50aGujXFH9rZhqlOjxm9w0sqXlMnN5keOAQ/GCMJm9Jg8JEgdfJn1YPgUdCAYM0w1uP2811jekQVJDQDjIVtPTbDOdnaL1zvgqF0LK1z0pLsPmDm0RvnWAQfAsGoXDpPRLE6wIEezQShSNh1JuXi5E6Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028776; c=relaxed/simple;
	bh=yVSYFu95M9ScWeP2yNqAOjyKuVV6ZqsCzsI3qKHN9MY=;
	h=Date:To:From:Subject:Message-Id; b=iFmFdlzTua1eaBrPit5Qej4SbcFKU9v9NQFStbxdNAeIqnrk/c6J4IYiQ1PO6tlvbrKCXPppulHfBfATZxYsp3t+9XaBJatUOasebEQ52Z1my7UtBnOM8BLiWM0XaqftvaKjL7djyJS8MQX+n/PYyhqwirCbLGV+YWRdhiTY7wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VDoABPw8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VDoABPw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2931F00893;
	Fri, 29 May 2026 04:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028775;
	bh=p/RFUxm1Lz6DsRpkH+8v4ICIENpl3jtpkI9UVt5/txI=;
	h=Date:To:From:Subject;
	b=VDoABPw878SpM/Uj8oHEMvRKnl6sKi56gI7AyixKNBiHDWCiLDY5agKEZRq34Dj1m
	 4VPOYR68M0r4Q9Y7t4vZU5l3yovCdo4IrQPOAPlEU7epa3JxA69l73TB4AYPK61z1O
	 /4RClYeDmUz6nwSGHtaH7PHEMl3EVnLrnyIIMSdQ=
Date: Thu, 28 May 2026 21:26:14 -0700
To: mm-commits@vger.kernel.org,r33s3n6@gmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,baijiaju1990@gmail.com,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-inline-xattr-header-before-reflinking-inline-xattrs.patch removed from -mm tree
Message-Id: <20260529042614.EB2931F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate inline xattr header before reflinking inline xattrs
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-inline-xattr-header-before-reflinking-inline-xattrs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhengYuan Huang <gality369@gmail.com>
Subject: ocfs2: validate inline xattr header before reflinking inline xattrs
Date: Fri, 8 May 2026 16:59:14 +0800

[BUG]
A corrupt inline xattr header can make ocfs2_reflink_xattr_inline() lock,
copy, and reflink xattr state from an unchecked ibody xattr header.

[CAUSE]
The inline reflink path still trusted di->i_xattr_inline_size to compute
header_off, xh, and new_xh before handing the source header to the reflink
allocator and copy logic.

[FIX]
Validate the source inode's inline xattr header with the shared helper
first, then derive the reflink copy offsets from the validated inline
size/header. This keeps the reflink path from traversing corrupt ibody
xattr geometry.

Link: https://lore.kernel.org/20260508085914.61647-6-gality369@gmail.com
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Zixuan Fu <r33s3n6@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-validate-inline-xattr-header-before-reflinking-inline-xattrs
+++ a/fs/ocfs2/xattr.c
@@ -6511,12 +6511,10 @@ static int ocfs2_reflink_xattr_inline(st
 	handle_t *handle;
 	struct ocfs2_super *osb = OCFS2_SB(args->old_inode->i_sb);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)args->old_bh->b_data;
-	int inline_size = le16_to_cpu(di->i_xattr_inline_size);
-	int header_off = osb->sb->s_blocksize - inline_size;
-	struct ocfs2_xattr_header *xh = (struct ocfs2_xattr_header *)
-					(args->old_bh->b_data + header_off);
-	struct ocfs2_xattr_header *new_xh = (struct ocfs2_xattr_header *)
-					(args->new_bh->b_data + header_off);
+	int inline_size;
+	int header_off;
+	struct ocfs2_xattr_header *xh;
+	struct ocfs2_xattr_header *new_xh;
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	struct ocfs2_inode_info *new_oi;
 	struct ocfs2_dinode *new_di;
@@ -6525,6 +6523,15 @@ static int ocfs2_reflink_xattr_inline(st
 		.vb_access = ocfs2_journal_access_di,
 	};
 
+	ret = ocfs2_xattr_ibody_lookup_header(args->old_inode, di, &xh);
+	if (ret)
+		goto out;
+
+	inline_size = le16_to_cpu(di->i_xattr_inline_size);
+	header_off = osb->sb->s_blocksize - inline_size;
+	new_xh = (struct ocfs2_xattr_header *)
+		(args->new_bh->b_data + header_off);
+
 	ret = ocfs2_reflink_lock_xattr_allocators(osb, xh, args->ref_root_bh,
 						  &credits, &meta_ac);
 	if (ret) {
_

Patches currently in -mm which might be from gality369@gmail.com are


