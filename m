Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F231420D4
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 21:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716413088; cv=none; b=BhjuUzbKvU8e1GmGwQYiy9l3WVuRQh+3DlV5rdY4grnP6Y5FuZmtyDDwL99CylJtfJACchGKKaH4z9CnSmnsOl245kEjTLwfEDsnIgSC4M9+G7Uc96TPage0HIg9TbIuAmaKAkd+uOv+JeJ1lIigz7itakv3/VqnjeARFAd6XVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716413088; c=relaxed/simple;
	bh=DcFozj3IhDuyCrDreZddD9EXWX2DY4TFfGYEuIekFD4=;
	h=Date:To:From:Subject:Message-Id; b=gP4f03HbzQ0tkQqFLKjcPTwjrVXw99Le2K+stJS+eyT5mxaWFs6CW8yNEeghyCiyxXaY9ydybed6EhLblX8NBfH3eUORFIkVYZyrhezzBzyT+LRO0hOvGDmVXwAfjFCNEjw4mGaRLf8D8hTf6+YckB6zaGRFPgFcHfL0+Pp+3sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l+e3fqcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l+e3fqcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E070C2BBFC;
	Wed, 22 May 2024 21:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716413087;
	bh=DcFozj3IhDuyCrDreZddD9EXWX2DY4TFfGYEuIekFD4=;
	h=Date:To:From:Subject:From;
	b=l+e3fqcbWpXbur0FtEU1tHwzAB7n8WU2ifnHJVHcyRbsACQ0963L6lx4xpkNxigE5
	 vxhnJyAfWE6vzfjvNRfAEssndC70Zizpj1cpdycEZKIb1UEYT91RBBnLhPiCGRdv1a
	 dvSVNEXnRzm0sccvA67vo23U5R1daB2wcThJkEm8=
Date: Wed, 22 May 2024 14:24:46 -0700
To: mm-commits@vger.kernel.org,mengferry@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry.patch added to mm-nonmm-unstable branch
Message-Id: <20240522212447.4E070C2BBFC@smtp.kernel.org>
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
Date: Wed, 15 May 2024 21:29:33 +0800

Just add redundant (perhaps paranoia) checks to make sure it doesn't stray
beyond valid meory region of ocfs2 xattr entry array during a single
match.

Maybe this patch can prevent some crash caused by crafted poison images.

Link: https://lkml.kernel.org/r/20240515132934.69511-2-mengferry@linux.alibaba.com
Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry
+++ a/fs/ocfs2/xattr.c
@@ -1062,8 +1062,8 @@ ssize_t ocfs2_listxattr(struct dentry *d
 	return i_ret + b_ret;
 }
 
-static int ocfs2_xattr_find_entry(int name_index,
-				  const char *name,
+static int ocfs2_xattr_find_entry(struct inode *inode, void *end,
+				  int name_index, const char *name,
 				  struct ocfs2_xattr_search *xs)
 {
 	struct ocfs2_xattr_entry *entry;
@@ -1076,6 +1076,10 @@ static int ocfs2_xattr_find_entry(int na
 	name_len = strlen(name);
 	entry = xs->here;
 	for (i = 0; i < le16_to_cpu(xs->header->xh_count); i++) {
+		if ((void *)entry >= end) {
+			ocfs2_error(inode->i_sb, "corrupted xattr entries");
+			return -EFSCORRUPTED;
+		}
 		cmp = name_index - ocfs2_xattr_get_type(entry);
 		if (!cmp)
 			cmp = name_len - entry->xe_name_len;
@@ -1171,7 +1175,7 @@ static int ocfs2_xattr_ibody_get(struct
 	xs->base = (void *)xs->header;
 	xs->here = xs->header->xh_entries;
 
-	ret = ocfs2_xattr_find_entry(name_index, name, xs);
+	ret = ocfs2_xattr_find_entry(inode, xs->end, name_index, name, xs);
 	if (ret)
 		return ret;
 	size = le64_to_cpu(xs->here->xe_value_size);
@@ -2703,7 +2707,7 @@ static int ocfs2_xattr_ibody_find(struct
 
 	/* Find the named attribute. */
 	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
-		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+		ret = ocfs2_xattr_find_entry(inode, xs->end, name_index, name, xs);
 		if (ret && ret != -ENODATA)
 			return ret;
 		xs->not_found = ret;
@@ -2838,7 +2842,7 @@ static int ocfs2_xattr_block_find(struct
 		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
 		xs->here = xs->header->xh_entries;
 
-		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+		ret = ocfs2_xattr_find_entry(inode, xs->end, name_index, name, xs);
 	} else
 		ret = ocfs2_xattr_index_block_find(inode, blk_bh,
 						   name_index,
_

Patches currently in -mm which might be from mengferry@linux.alibaba.com are

ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry.patch
ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry.patch

