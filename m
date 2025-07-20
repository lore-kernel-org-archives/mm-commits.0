Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B6515687D
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977366; cv=none; b=EJfoqLh1Jmk0iwuQW+bT/GVZHGxii9J79o0g1gfGDOZ2q+4AVyhErAYpTFOHLLNTgx6U5Kx0MsDmHakg2vtsVtEOrlYIzXI/7xq/KX19V1KzVeTOGZq56l3xEF8tGAhnOrBlqd/85Ki+TK/mwdoNEYWyqjzCmzNdn4g0Aye22bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977366; c=relaxed/simple;
	bh=WmI0wwYVhSDcRyLMozow3VzdJa7SMRa4NdYqOBq8y9s=;
	h=Date:To:From:Subject:Message-Id; b=Q0l1SrlzFOwE2qgN79vX00HehwSl/Or2H8DFracm6YItCChceTr+LOt9MnaKO9C98UtTINwWHalbIz6Y+jxIyfV6FM5lS4tR4/iRRH0yVDXwgFOds0eHGQbZkYtbJbru7LkjuLZ8+8DuiTTnyZXF7qoQAnWYDxGTGqEk1xL7/3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u6TVRhGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u6TVRhGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15584C4CEE3;
	Sun, 20 Jul 2025 02:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977366;
	bh=WmI0wwYVhSDcRyLMozow3VzdJa7SMRa4NdYqOBq8y9s=;
	h=Date:To:From:Subject:From;
	b=u6TVRhGCZVwBJrffqa6RROisyFKLHXQ2CA0qn1fbWue/2GXvSqRX3JirObtY8BGJp
	 I6y/ZhtgKyBlmujEpkGM/1FMqSjklzIFsai0T3Y22+1mneu1kcyQF1vCDD01s0qW9r
	 9RgZ4kE1B8FhBu/RnK09NR643dFZiMrtnQKDU8mI=
Date: Sat, 19 Jul 2025 19:09:25 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,ipravdin.official@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-avoid-null-pointer-dereference-in-dx_dir_lookup_rec.patch removed from -mm tree
Message-Id: <20250720020926.15584C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: avoid NULL pointer dereference in dx_dir_lookup_rec()
has been removed from the -mm tree.  Its filename was
     ocfs2-avoid-null-pointer-dereference-in-dx_dir_lookup_rec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ivan Pravdin <ipravdin.official@gmail.com>
Subject: ocfs2: avoid NULL pointer dereference in dx_dir_lookup_rec()
Date: Mon, 7 Jul 2025 20:10:09 -0400

When a directory entry is not found, ocfs2_dx_dir_lookup_rec() prints an
error message that unconditionally dereferences the 'rec' pointer. 
However, if 'rec' is NULL, this leads to a NULL pointer dereference and a
kernel panic.

Add an explicit check empty extent list to avoid dereferencing NULL
'rec' pointer.

Link: https://lkml.kernel.org/r/20250708001009.372263-1-ipravdin.official@gmail.com
Reported-by: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67cd7e29.050a0220.e1a89.0007.GAE@google.com/
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/dir.c~ocfs2-avoid-null-pointer-dereference-in-dx_dir_lookup_rec
+++ a/fs/ocfs2/dir.c
@@ -798,6 +798,14 @@ static int ocfs2_dx_dir_lookup_rec(struc
 		}
 	}
 
+	if (le16_to_cpu(el->l_next_free_rec) == 0) {
+		ret = ocfs2_error(inode->i_sb,
+				  "Inode %lu has empty extent list at depth %u\n",
+				  inode->i_ino,
+				  le16_to_cpu(el->l_tree_depth));
+		goto out;
+	}
+
 	found = 0;
 	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
 		rec = &el->l_recs[i];
_

Patches currently in -mm which might be from ipravdin.official@gmail.com are


