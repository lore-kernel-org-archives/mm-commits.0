Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A213EDE6F
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 22:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778624130; cv=none; b=cBL+Fw+0CqfbxIqOGJtPPacCo4lyaqWVCFeueqWhLIGxvzZtr6RndzD5394MBKu5WrPtXw3rgJ2V/nApMKhBcK/2D8TPAIv7DeSz3UU/bnPfcP/nNDBqmXXtFQf9w972RTJrKMlzQ4f/JX+3cyEyzkgcjxIFW3Oe+tYm+ca9u9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778624130; c=relaxed/simple;
	bh=ghQQfv9Ty/ODybQLoAi1mWp1i9rdraqji/S2SbKR9gU=;
	h=Date:To:From:Subject:Message-Id; b=tD2gFlWPW0X1igAad+Rzagmf5XQjcc3DwElXd26ws6adFx0lkUOQZq7qg6mzqvwfB6N1OpvGggcE/YMZxcdB+0xT2xTZYNYD/utMBGsr1fPZ0CZ8ODQB4OsYa0shrMfmaBh6eeS7NvtR18ju23K1wWphXKokCfLM/zdyY2M5Ts4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p4ODkhuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p4ODkhuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCC4C2BCB0;
	Tue, 12 May 2026 22:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778624130;
	bh=ghQQfv9Ty/ODybQLoAi1mWp1i9rdraqji/S2SbKR9gU=;
	h=Date:To:From:Subject:From;
	b=p4ODkhuusC6n8AJyVYwS3Inh5JSlS7l0E+P+aD6WZlyCKEbbk6SmbXWEdms/PX9Y0
	 0CWMWum9t7BUqyc0BzRGVTY8mn089cBhgd8d1Vr7hcYFdXDByyjuGvK1kOSi5+LUpq
	 GGxaQ6KRSMHuu+CGzu6CbUH8rCmLSFVdcaEm4B68=
Date: Tue, 12 May 2026 15:15:29 -0700
To: mm-commits@vger.kernel.org,r33s3n6@gmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,baijiaju1990@gmail.com,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-inline-xattr-header-before-checking-outside-values.patch added to mm-nonmm-unstable branch
Message-Id: <20260512221530.6FCC4C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate inline xattr header before checking outside values
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-inline-xattr-header-before-checking-outside-values.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-inline-xattr-header-before-checking-outside-values.patch

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
Subject: ocfs2: validate inline xattr header before checking outside values
Date: Fri, 8 May 2026 16:59:11 +0800

[BUG]
A corrupt inline xattr header can make
ocfs2_has_inline_xattr_value_outside() walk xh_count from an unchecked
header while refcount-tree teardown decides whether inline xattrs still
point outside the inode body.

[CAUSE]
ocfs2_has_inline_xattr_value_outside() still computed the inline header
directly from di->i_xattr_inline_size and immediately iterated xh_count.
That is the same unchecked metadata boundary as the ibody lookup bug.

[FIX]
Reuse the shared inline-header helper before iterating xh_count. Because
this helper returns a boolean-style answer to its caller, treat a corrupt
header conservatively as "has outside values" instead of walking it.

Link: https://lore.kernel.org/20260508085914.61647-3-gality369@gmail.com
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

 fs/ocfs2/xattr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-validate-inline-xattr-header-before-checking-outside-values
+++ a/fs/ocfs2/xattr.c
@@ -989,11 +989,12 @@ int ocfs2_has_inline_xattr_value_outside
 					 struct ocfs2_dinode *di)
 {
 	struct ocfs2_xattr_header *xh;
+	int ret;
 	int i;
 
-	xh = (struct ocfs2_xattr_header *)
-		 ((void *)di + inode->i_sb->s_blocksize -
-		 le16_to_cpu(di->i_xattr_inline_size));
+	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &xh);
+	if (ret)
+		return 1;
 
 	for (i = 0; i < le16_to_cpu(xh->xh_count); i++)
 		if (!ocfs2_xattr_is_local(&xh->xh_entries[i]))
_

Patches currently in -mm which might be from gality369@gmail.com are

ocfs2-reject-inconsistent-inode-size-before-truncate.patch
ocfs2-dont-bug_on-an-invalid-journal-dinode.patch
ocfs2-validate-inline-xattr-header-before-ibody-lookups.patch
ocfs2-validate-inline-xattr-header-before-checking-outside-values.patch
ocfs2-validate-inline-xattr-header-before-ibody-remove.patch
ocfs2-validate-inline-xattr-header-before-inline-refcount-attach.patch
ocfs2-validate-inline-xattr-header-before-reflinking-inline-xattrs.patch

