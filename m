Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C13914B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908581; cv=none; b=HHrcSbaRn4wlvCWypc4zvHOBwapmKU+pANuILYD5EWWbzrUdIEm2DiJCaQW+X7ASVa3ODV7/OxsUf/Y+ClM0wI8X1wBMdaM2zUmAOsUyTEd/LrHVxsBkXvuZsJYfxW7eWgJZO9/bsz1N/jwMSId8xQBfG7R1DH/3lD6HCl8LKnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908581; c=relaxed/simple;
	bh=+FJ9kc2vnPm/CuzYvRV5PhKdEqnDQiO2/TxbPRPy44c=;
	h=Date:To:From:Subject:Message-Id; b=lUNdKW/Cuhi8gfULXJTQBpuhw6Cp5KKr9X7Tq9a5Y97rtZNJt8qz4vOAKfp3wO4ATq/zw+OqIpd2BjnNQyAs1GamHLL/eDXzmEEflUJocpTJZR9EYLdSMmqorxYpplMOq5EOpLJP5zRotjqTi8OAf6Kg0FTJx0R4WGK2O2e37BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LokyV5ct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LokyV5ct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A7EC4CEF5;
	Wed, 12 Nov 2025 00:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908580;
	bh=+FJ9kc2vnPm/CuzYvRV5PhKdEqnDQiO2/TxbPRPy44c=;
	h=Date:To:From:Subject:From;
	b=LokyV5ct6QM7DTAg1mE6h2KNJOiskE5VItQMzybhiC8PtFEdk0hl4qBcDJpR16Qq/
	 O4JAySxar+Q++5mMp3RF0l7XmrHgKTRlyTPTHCLHy2EC/MOUnjn2RFgacRqSezaewO
	 KK8Hq79RL2OqA6SLtC2QzpGGKS+AIAtCGux/di4A=
Date: Tue, 11 Nov 2025 16:49:40 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec.patch removed from -mm tree
Message-Id: <20251112004940.90A7EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add extra consistency check to ocfs2_dx_dir_lookup_rec()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch

