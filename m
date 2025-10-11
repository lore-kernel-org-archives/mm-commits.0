Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FC41A08BC
	for <mm-commits@vger.kernel.org>; Sat, 11 Oct 2025 18:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760208952; cv=none; b=GMQcsl5Up8jE/ZWW4h8HftVxQ07w08JeuafAPbZ1UOOzalzTpozLmZwkDjY6QluGCSR0hpbXiGD1YRXtqFljm0hVZpViDWO3DQ65PzwCFUVNOBSBVkWLslw+8OyMhetux1OnLGvfWkyxyY0hC2MyCdOMORYXhL0FyaH6G0si17s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760208952; c=relaxed/simple;
	bh=jIA/xTfWJ8dDC68WT4U9BrzvyPyMkoMyL9Q1FGWtJRQ=;
	h=Date:To:From:Subject:Message-Id; b=uw9S9QvT/otF3LRjgOH3lNpuhZZC6UemQ8ztWY6ZZsXo0sbpDSQtgLiVmLM4BHrQ7p9rCVoyxaWrIFhqgozVHibVz5DQGWmnxgvPro77fxm2v43S8G+Z0ZONVS4dwgKMERuJufC4fID9LITk3/KR+cRNqw0NlltdfiWS8x3OsUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Znvr1MNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Znvr1MNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14209C4CEF4;
	Sat, 11 Oct 2025 18:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760208952;
	bh=jIA/xTfWJ8dDC68WT4U9BrzvyPyMkoMyL9Q1FGWtJRQ=;
	h=Date:To:From:Subject:From;
	b=Znvr1MNa75ScO1BuwBbYRfMwoV6R9qv+R7ilC09T1Zxk9esSFkBfV2tGxbESaSlza
	 Y180+qnOhcKM608eIjbbjrWT0xxp/p68mnU4heny7xwJZcAfG+r9wlTG8resWINAsl
	 OxC7fJ+DFCLJ+PQd+Dh3LKcvgIOWQ/Edve/Zofnc=
Date: Sat, 11 Oct 2025 11:55:51 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec.patch added to mm-nonmm-unstable branch
Message-Id: <20251011185552.14209C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: add extra consistency check to ocfs2_dx_dir_lookup_rec()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec.patch

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
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: add extra consistency check to ocfs2_dx_dir_lookup_rec()
Date: Tue, 7 Oct 2025 12:46:26 +0300

In 'ocfs2_dx_dir_lookup_rec()', check whether an extent list length of the
directory indexing block matches the one configured via the superblock
parameters established at mount, thus preventing an out-of-bounds accesses
while iterating over the extent records below.

Link: https://lkml.kernel.org/r/20251007094626.196143-1-dmantipov@yandex.ru
Reported-by: syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=30b53487d00b4f7f0922
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>> 
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/dir.c~ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec
+++ a/fs/ocfs2/dir.c
@@ -778,6 +778,14 @@ static int ocfs2_dx_dir_lookup_rec(struc
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_rec *rec = NULL;
 
+	if (le16_to_cpu(el->l_count) !=
+	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
+		ret = ocfs2_error(inode->i_sb,
+				  "Inode %lu has invalid extent list length %u\n",
+				  inode->i_ino, le16_to_cpu(el->l_count));
+		goto out;
+	}
+
 	if (el->l_tree_depth) {
 		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, major_hash,
 				      &eb_bh);
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch
ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch
ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec.patch

