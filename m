Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14123EDE6F
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 22:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778624132; cv=none; b=QJVQSew1i8bbfVnm2gnBIr0XbGlUW7L/qCd9JnW0IF0SnwG86su71FVhKkzT15NK8MI+l9q+TVePIBohS0+UoB/0UWpIHTQLRSxybvxwyrHJYyTy9rv8aHDEF55rQ7NDVm7VoONuJSEbBCYNzgLRchztON8RJiaBp/TL7DK64Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778624132; c=relaxed/simple;
	bh=jIK2mM4KgAi/gLSD3Oa3UI8YpQyGY1IQW6iEL7/Ek7M=;
	h=Date:To:From:Subject:Message-Id; b=PTB2gvRxHUE8YR/FiQ6MjRdAu2GpxxLhkITZZCrDabupJCLErBvpSy3RYHblxg0kxOyHN38Km7nDsUwYqwp8HHrKcKDJlfDFjVwvG3hk521UtNh2CUIyMrnrufY3UKZ0TGbVqCl77lR27laBCqSLec/igYuXUqheLR5j1SxvykM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mez5lPO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mez5lPO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D14C2BCB0;
	Tue, 12 May 2026 22:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778624131;
	bh=jIK2mM4KgAi/gLSD3Oa3UI8YpQyGY1IQW6iEL7/Ek7M=;
	h=Date:To:From:Subject:From;
	b=Mez5lPO2N4IsSoCjs90TEETew0tf3LEjwawNPH3W88IZb4yJswsS0ItGgULc8/VS4
	 E+6bTiI+6HQFR4XgqfqqfeajfcAmIkOdSdAyiHTilVqbUGnIWl/XT2olXO2akJl5GW
	 FLaSIqu5dqdY/H7c2rp/IKyxNycg3qG2LZZxH8Dk=
Date: Tue, 12 May 2026 15:15:31 -0700
To: mm-commits@vger.kernel.org,r33s3n6@gmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,baijiaju1990@gmail.com,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-inline-xattr-header-before-ibody-remove.patch added to mm-nonmm-unstable branch
Message-Id: <20260512221531.97D14C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate inline xattr header before ibody remove
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-inline-xattr-header-before-ibody-remove.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-inline-xattr-header-before-ibody-remove.patch

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
Subject: ocfs2: validate inline xattr header before ibody remove
Date: Fri, 8 May 2026 16:59:12 +0800

[BUG]
A corrupt inline xattr header can make ocfs2_xattr_ibody_remove() pass an
unchecked header into ocfs2_remove_value_outside() during inode xattr
teardown.

[CAUSE]
ocfs2_xattr_ibody_remove() still rebuilt the ibody xattr header directly
from di->i_xattr_inline_size and then handed it to code that iterates
xh_count and entry geometry.

[FIX]
Validate the inline xattr header with the shared helper before handing it
to the outside-value removal path, and propagate -EFSCORRUPTED on bad
metadata instead of traversing the unchecked header.

Link: https://lore.kernel.org/20260508085914.61647-4-gality369@gmail.com
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

 fs/ocfs2/xattr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-validate-inline-xattr-header-before-ibody-remove
+++ a/fs/ocfs2/xattr.c
@@ -2476,9 +2476,9 @@ static int ocfs2_xattr_ibody_remove(stru
 		.vb_access = ocfs2_journal_access_di,
 	};
 
-	header = (struct ocfs2_xattr_header *)
-		 ((void *)di + inode->i_sb->s_blocksize -
-		 le16_to_cpu(di->i_xattr_inline_size));
+	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &header);
+	if (ret)
+		return ret;
 
 	ret = ocfs2_remove_value_outside(inode, &vb, header,
 					 ref_ci, ref_root_bh);
_

Patches currently in -mm which might be from gality369@gmail.com are

ocfs2-reject-inconsistent-inode-size-before-truncate.patch
ocfs2-dont-bug_on-an-invalid-journal-dinode.patch
ocfs2-validate-inline-xattr-header-before-ibody-lookups.patch
ocfs2-validate-inline-xattr-header-before-checking-outside-values.patch
ocfs2-validate-inline-xattr-header-before-ibody-remove.patch
ocfs2-validate-inline-xattr-header-before-inline-refcount-attach.patch
ocfs2-validate-inline-xattr-header-before-reflinking-inline-xattrs.patch

