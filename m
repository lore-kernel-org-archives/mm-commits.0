Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E57739BFF8
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 22:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778624134; cv=none; b=gjfq2R/lYatxxoSY4v8KFXh97CU7upsZNzDuzxrdkHdg/es5Dx2so76OOyNqUmeWHzDlwmL8Zgudy/ro0L1uWcNn6hirBR0lfK2r5Cfw2y5AO9/uibrZb1Xa1xedI3I1iw59rX27ZukzilnwXkl6tJrHfiSBLiikqnC7iZSK4w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778624134; c=relaxed/simple;
	bh=uJR3bkdWUkPuyF5+iRRAdpeiYqaayidI3cJe2M3f+1U=;
	h=Date:To:From:Subject:Message-Id; b=o1yUhMsqVHrJCD98aUweOY80O5gZpkbEFiCcxdsfTtqfVmKY9DChYgsZdJBfjoXp1tqv3xANY31YxFOhXCRLtE1L7sxoGc25mkP1gq1fQ1K7yea2AC32c+hXfYE+uKosBTaFrH9Wdq9VLS/+0u8ePMGcW3OwDkMRG0joB3oNGLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ey7/pqmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ey7/pqmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09E6C2BCB0;
	Tue, 12 May 2026 22:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778624134;
	bh=uJR3bkdWUkPuyF5+iRRAdpeiYqaayidI3cJe2M3f+1U=;
	h=Date:To:From:Subject:From;
	b=Ey7/pqmQLJLwjnK4gujjbVaF2YRbp29LzhCZEITlHDXEhkI8qcDfULLq9dQPjnZsc
	 yl0gXlUsLUOJPQAR8Pg2Fcp7WSeL1oxT/tI3ImR1jp3nHSCkh578pnhRgIyx4431R0
	 /iCPpRS180zd0FNtKkW5ZTviKb5wsrmPDTXN836s=
Date: Tue, 12 May 2026 15:15:33 -0700
To: mm-commits@vger.kernel.org,r33s3n6@gmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,baijiaju1990@gmail.com,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-inline-xattr-header-before-reflinking-inline-xattrs.patch added to mm-nonmm-unstable branch
Message-Id: <20260512221533.F09E6C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate inline xattr header before reflinking inline xattrs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-inline-xattr-header-before-reflinking-inline-xattrs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-inline-xattr-header-before-reflinking-inline-xattrs.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

ocfs2-reject-inconsistent-inode-size-before-truncate.patch
ocfs2-dont-bug_on-an-invalid-journal-dinode.patch
ocfs2-validate-inline-xattr-header-before-ibody-lookups.patch
ocfs2-validate-inline-xattr-header-before-checking-outside-values.patch
ocfs2-validate-inline-xattr-header-before-ibody-remove.patch
ocfs2-validate-inline-xattr-header-before-inline-refcount-attach.patch
ocfs2-validate-inline-xattr-header-before-reflinking-inline-xattrs.patch

