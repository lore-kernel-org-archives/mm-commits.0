Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E23933C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293152; cv=none; b=rfYWuyvbtIzWX7zKc8lSsP3u5cvFkpFz7Vetm9VyYPYgWd2z919Cj6IUF1qO8OsWGVRhpx+gioPr6ANv3B9aWgO7QbraSdNsxNIMGYaTo4qEd2RyItYrUlhvQcWZvCMICpGBTRTCYRleBD2UT0I34ioxun0q3MtosEoE+qxWZpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293152; c=relaxed/simple;
	bh=4vWJbS+wt1YUOTWH+0BRH59f434UXLTJanV1wGKbgfQ=;
	h=Date:To:From:Subject:Message-Id; b=uj8RxoowLsqJPh3rMq4Iz2Ltnl2+dHkvGjNoWkzLG+zXFTEkUBS/eL+pDXJHGKbahWE5lRFFkSJ/A50xb44Gfvc51Nd1WLRArfxJ9Kt4PIWJjWOvNYJsIRuADdeKKkOGUJey5+k9xYlWijDFK/bX1pggix9/KsxeDmkpt0p7LXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zrg0L+DO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zrg0L+DO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB77EC4AF07;
	Tue, 25 Jun 2024 05:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293152;
	bh=4vWJbS+wt1YUOTWH+0BRH59f434UXLTJanV1wGKbgfQ=;
	h=Date:To:From:Subject:From;
	b=zrg0L+DOipHp6NkXK3kR1YRS4ymB9rjeAtaR+tPmkVO8Rv/4VFG01pAnqfAw6yq4+
	 iJfAEEsQ9S9f6v4IJFKVQpZGVNAjHyX5BaiwzmFmZ5R/I0+LLXA5SLih7+Y4ivSQ/n
	 zQFNMsMEsELxPXAf1wuikHprz50V1YfvbPahtY2w=
Date: Mon, 24 Jun 2024 22:25:51 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,llfamsec@gmail.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,mengferry@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry.patch removed from -mm tree
Message-Id: <20240625052551.EB77EC4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add bounds checking to ocfs2_xattr_find_entry()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ferry Meng <mengferry@linux.alibaba.com>
Subject: ocfs2: add bounds checking to ocfs2_xattr_find_entry()
Date: Mon, 20 May 2024 10:40:23 +0800

Add a paranoia check to make sure it doesn't stray beyond valid memory
region containing ocfs2 xattr entries when scanning for a match.  It will
prevent out-of-bound access in case of crafted images.

Link: https://lkml.kernel.org/r/20240520024024.1976129-1-joseph.qi@linux.alibaba.com
Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: lei lu <llfamsec@gmail.com>
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


