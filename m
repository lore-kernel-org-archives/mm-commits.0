Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDE13EDE6F
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 22:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778624133; cv=none; b=k8I7rfBmNxumL5eSoNiY18ILrx2ALpJWGATZN/KvjmdUEKFgiMkuLnsmlxPX2TkApN7xUkPKq45eSZC+ii1cp+K+3UXfwfNYOhp//XkcQy+ZQaEfRrQ48thlvqWMM9xXHwFMqIfsHJqex0r7/RbaIdnORB9jIvsDX4GT12dINSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778624133; c=relaxed/simple;
	bh=bzO5UHaNjddSMe4wFbVqV1wj9eoXJxA4KO5QJPDRQKs=;
	h=Date:To:From:Subject:Message-Id; b=aWISUcdJK9BmVzMx8DYVRe2pNgcWyr3xXfc9hVQL7yWko5LP+vNkFlGjlGyK9zKA8Ei9pBPkmZ40OnZtyi2+o0l1t/uK1n5ycq31QV61X+fS17kBF4VySnsnsbVZ3gm4qPXlEkGPd20ogHnjbJqoBGT//7cI7svQNLpHVXY0SEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GwPn8olJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GwPn8olJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D9FC2BCB0;
	Tue, 12 May 2026 22:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778624132;
	bh=bzO5UHaNjddSMe4wFbVqV1wj9eoXJxA4KO5QJPDRQKs=;
	h=Date:To:From:Subject:From;
	b=GwPn8olJpJGOY3+3GDmjaT2xvB7P9MrDVHUB1Zec4xmnYIcDA/WRfEawdEhhnkW30
	 r5pxTnCOliM0kjcTH9GNVkW8SdqMULSMJvKt9oGuxtZxwEXiZ/ErN5wvdM43E0epf8
	 pD4eUxh+tq0EYyMHP+F5xinQO+CQQj1zbENcLH0I=
Date: Tue, 12 May 2026 15:15:32 -0700
To: mm-commits@vger.kernel.org,r33s3n6@gmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,baijiaju1990@gmail.com,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-inline-xattr-header-before-inline-refcount-attach.patch added to mm-nonmm-unstable branch
Message-Id: <20260512221532.C2D9FC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate inline xattr header before inline refcount attach
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-inline-xattr-header-before-inline-refcount-attach.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-inline-xattr-header-before-inline-refcount-attach.patch

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

ocfs2-reject-inconsistent-inode-size-before-truncate.patch
ocfs2-dont-bug_on-an-invalid-journal-dinode.patch
ocfs2-validate-inline-xattr-header-before-ibody-lookups.patch
ocfs2-validate-inline-xattr-header-before-checking-outside-values.patch
ocfs2-validate-inline-xattr-header-before-ibody-remove.patch
ocfs2-validate-inline-xattr-header-before-inline-refcount-attach.patch
ocfs2-validate-inline-xattr-header-before-reflinking-inline-xattrs.patch

