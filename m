Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B352B37267C
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028772; cv=none; b=gXErTge2zf8FKARpG2ACrKRaclwkHONYsdbyvkn7UmVtRbm0O9Nhus/k9Ri/inxuNHwLanRuEPqcuTk1mNIsbQwoG0KRDZBpt9ZH5mb+TnHmyZnHBrKDNHqBjOSCbI6swk+uWMHmxLq3KiferKHfHChVY7CgusCRUWlXzw8uyGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028772; c=relaxed/simple;
	bh=Z8rAhUJPqQ2MQezUEOQjK6fmD8sS16hHmqbODtEbCRg=;
	h=Date:To:From:Subject:Message-Id; b=B/Y5QgghIKGXL8VxzgltpTgCLCDzPFWb/RcI5F4Ti8Y/vpbgPspYovanhuJ/bso8XnzBCSscyRDIalkDFS3aYsd7k7OTMnsr74TzHt4DgOGxZeXVavYwCL4jyWQJY6M1njJiWOt/ry/KRTjOqijlSAKLdtW0hr+6NYzUbPzzpGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v0nr0fdI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v0nr0fdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6335E1F00898;
	Fri, 29 May 2026 04:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028771;
	bh=XwDVDoJZvLMj2s7RFEeHt/APrfg77egW6C0XIoyfzuY=;
	h=Date:To:From:Subject;
	b=v0nr0fdIE91/HHKK5YNiR1CqozROxMkhnFePueO5y78mjl/HJRhkQy8HUgJDTRg2g
	 RG0r9btKFR3Oo1aD1Xt+RohVWdhtXAf1pYWl0Rb1+x+lkSPzmU5VueiHfBgKL8b+cx
	 ykkX2KaXewp/VJqHs9TnhKefjKIW90fgZESV8hUc=
Date: Thu, 28 May 2026 21:26:10 -0700
To: mm-commits@vger.kernel.org,r33s3n6@gmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,baijiaju1990@gmail.com,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-inline-xattr-header-before-checking-outside-values.patch removed from -mm tree
Message-Id: <20260529042611.6335E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate inline xattr header before checking outside values
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-inline-xattr-header-before-checking-outside-values.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


