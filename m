Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE20371D01
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028775; cv=none; b=QBNznVF4pdFGyze7B6ux6xnlTHB4fgoKgHUklMza13LPAJiaX4AsodBdIYZrp18wNL0QMIJkqoZiqlW0UOFguCDdRLZRowRpyGZGBuA3rx4wminPITopp0y2HK9OEWaYjmNSC5JH9/rpTuqW1peINibU+H0pB8U93OT8Xmbgbv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028775; c=relaxed/simple;
	bh=kHzOvpc54QVyMy3yus7Efnz626l7dIMxGCj1vKvq8qk=;
	h=Date:To:From:Subject:Message-Id; b=QX8iDhgpGQioKkgX9lT+nEc927qeXUp9OArx6vAE4NTp5bwp6Rfn18fNIcmEhFDfh4r7GJHClcO2+RY4VizRJ+XT+P8kjmjrc/5qfOQ9/ToUyB3WJ/MjJSeqo8ihL8OC79CCVtXJiUKahPB2T40IYHl4elDduGKcXHqucqKVYYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NWjdtCt+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NWjdtCt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABBB1F00898;
	Fri, 29 May 2026 04:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028773;
	bh=Q9Od8MLmjHztaPH5flONAvJaObP4FInSQ76/FQa3eQc=;
	h=Date:To:From:Subject;
	b=NWjdtCt+39V5P/gnHUCvjlF7ITWr6+WsApGlo8jYbAol/lSahwUcPQKnlbFNHJU9I
	 I72KhnLpbAOTpYR/dzFaJYHZK5pV5UUMXly+lxzQI6OfCpN7T8cZkaGUUgO04QniDq
	 tLiuUBNUGmaHyzJPhyNalmUC8erX0b1tR9U3bACc=
Date: Thu, 28 May 2026 21:26:13 -0700
To: mm-commits@vger.kernel.org,r33s3n6@gmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,baijiaju1990@gmail.com,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-inline-xattr-header-before-inline-refcount-attach.patch removed from -mm tree
Message-Id: <20260529042613.BABBB1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate inline xattr header before inline refcount attach
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-inline-xattr-header-before-inline-refcount-attach.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhengYuan Huang <gality369@gmail.com>
Subject: ocfs2: validate inline xattr header before inline refcount attach
Date: Fri, 8 May 2026 16:59:13 +0800

[BUG]
A corrupt inline xattr header can make ocfs2_xattr_inline_attach_refcount()
feed an unchecked header into the refcount-attachment walk for inline
xattr values.

[CAUSE]
The inline refcount-attach path still derived the header directly from
di->i_xattr_inline_size and then passed it to code that iterates xh_count
and xattr entries.

[FIX]
Use the shared ibody header helper before attaching refcounts to inline
xattr values so corrupt header geometry is rejected with -EFSCORRUPTED
instead of being traversed.

Link: https://lore.kernel.org/20260508085914.61647-5-gality369@gmail.com
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

 fs/ocfs2/xattr.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-validate-inline-xattr-header-before-inline-refcount-attach
+++ a/fs/ocfs2/xattr.c
@@ -6016,14 +6016,17 @@ static int ocfs2_xattr_inline_attach_ref
 				struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)fe_bh->b_data;
-	struct ocfs2_xattr_header *header = (struct ocfs2_xattr_header *)
-				(fe_bh->b_data + inode->i_sb->s_blocksize -
-				le16_to_cpu(di->i_xattr_inline_size));
+	struct ocfs2_xattr_header *header;
+	int ret;
 	struct ocfs2_xattr_value_buf vb = {
 		.vb_bh = fe_bh,
 		.vb_access = ocfs2_journal_access_di,
 	};
 
+	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &header);
+	if (ret)
+		return ret;
+
 	return ocfs2_xattr_attach_refcount_normal(inode, &vb, header,
 						  ref_ci, ref_root_bh, dealloc);
 }
_

Patches currently in -mm which might be from gality369@gmail.com are


