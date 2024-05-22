Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747F75812B
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716416012; cv=none; b=ncqvKT/4jShLYrGBLcdLSfEdBUrGAX0zUvHwXPyiqx67g3YcLNC33Eh2KSmXUawZW2lCsObHd7n3CLzLCv/3Z5/nQjSnCUk3blCXk9r98UHZrXOewyRbUrAyKmm6Hqjl+gS+g9KYhuGgdBiBuFUHYY5la/KKleadLyhhgYGMnAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716416012; c=relaxed/simple;
	bh=nnJGaQ6cv1h9Ysg+AXlPxQw+RCuCSZlqKlyFE45H4kM=;
	h=Date:To:From:Subject:Message-Id; b=pI+jShstEbvcmQBqbiYLaD3FR76+5YfHNtowCf0ztUfnsZnxbQfzuQYlgbeiMlaN0Y4dOB2z63GAcxnhl+ItijeGNUDdPHixiXCw37g62EmFNowycRiVViKSTJLGTdQvL9PoigJCW5lAj7p1HFAu6gabwm+cyV/PJHse2Ngj8wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jiqSP9xf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jiqSP9xf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF107C2BBFC;
	Wed, 22 May 2024 22:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716416011;
	bh=nnJGaQ6cv1h9Ysg+AXlPxQw+RCuCSZlqKlyFE45H4kM=;
	h=Date:To:From:Subject:From;
	b=jiqSP9xf89sE30pA20SzK/yC776YFKaalaZqL6v6Hi0uSOtIclATunskqfj4wq+B0
	 e0FB/2uv3vX0BzrklWSAmhO/t3d7Elk4B1gUk9JAnDxrpy7TAJr1ONRt5Xsfn34R4u
	 v/Uyz64KgRxGk2cGDB0mxHStL+RLp+LoLN6DAOaI=
Date: Wed, 22 May 2024 15:13:30 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,llfamsec@gmail.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,mengferry@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry.patch added to mm-nonmm-unstable branch
Message-Id: <20240522221330.DF107C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: add bounds checking to ocfs2_xattr_find_entry()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ferry Meng <mengferry@linux.alibaba.com>
Subject: ocfs2: add bounds checking to ocfs2_xattr_find_entry()
Date: Mon, 20 May 2024 10:40:23 +0800

Add a paranoia check to make sure it doesn't stray beyond valid memory
region containing ocfs2 xattr entries when scanning for a match.  It will
prevent out-of-bound access in case of crafted images.

Link: https://lkml.kernel.org/r/20240520024024.1976129-1-joseph.qi@linux.alibaba.com
Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>Reported-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry
+++ a/fs/ocfs2/xattr.c
@@ -1062,7 +1062,7 @@ ssize_t ocfs2_listxattr(struct dentry *d
 	return i_ret + b_ret;
 }
 
-static int ocfs2_xattr_find_entry(int name_index,
+static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
 				  const char *name,
 				  struct ocfs2_xattr_search *xs)
 {
@@ -1076,6 +1076,10 @@ static int ocfs2_xattr_find_entry(int na
 	name_len = strlen(name);
 	entry = xs->here;
 	for (i = 0; i < le16_to_cpu(xs->header->xh_count); i++) {
+		if ((void *)entry >= xs->end) {
+			ocfs2_error(inode->i_sb, "corrupted xattr entries");
+			return -EFSCORRUPTED;
+		}
 		cmp = name_index - ocfs2_xattr_get_type(entry);
 		if (!cmp)
 			cmp = name_len - entry->xe_name_len;
@@ -1166,7 +1170,7 @@ static int ocfs2_xattr_ibody_get(struct
 	xs->base = (void *)xs->header;
 	xs->here = xs->header->xh_entries;
 
-	ret = ocfs2_xattr_find_entry(name_index, name, xs);
+	ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
 	if (ret)
 		return ret;
 	size = le64_to_cpu(xs->here->xe_value_size);
@@ -2698,7 +2702,7 @@ static int ocfs2_xattr_ibody_find(struct
 
 	/* Find the named attribute. */
 	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
-		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+		ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
 		if (ret && ret != -ENODATA)
 			return ret;
 		xs->not_found = ret;
@@ -2833,7 +2837,7 @@ static int ocfs2_xattr_block_find(struct
 		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
 		xs->here = xs->header->xh_entries;
 
-		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+		ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
 	} else
 		ret = ocfs2_xattr_index_block_find(inode, blk_bh,
 						   name_index,
_

Patches currently in -mm which might be from mengferry@linux.alibaba.com are

ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry.patch
ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry.patch

