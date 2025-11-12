Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BEB2045AD
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908605; cv=none; b=Ez6/tEeHn4UOsZy9ECGeep1+2DCcUJ9dMPFt+V3mxpoxCHOyUFvyJsp+d8PLx3mDTpLAzodaQBu1ve0e0W5s1xdov08se4xw8ONIkgk/D7NQQhS2IX9d24QYGX5LI45Zl7sePsUo+E+/3TYlEv8Ek9DP7N0fKPJB/A1Ns4xaS94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908605; c=relaxed/simple;
	bh=DWwuF57MolwbM5i8eNBjm/jHuuvrzQNXijS70lKRAgE=;
	h=Date:To:From:Subject:Message-Id; b=byRtQ7+nlP9Lv+UvUJf/x2av1ubisvS8EWaACYfktQcQvu7jKgDJTO15wmZpO8Zan0dsHsWokKG9yenoOUFAlJottSXX4ryO0CzzwyyV/cdlZEBxacBN38EeJEeJUeO0pI7M19QMnHTtE4diTaF0y/kNCSkpS2DpHgun6+oMabU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=04/of75G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="04/of75G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA104C4CEF5;
	Wed, 12 Nov 2025 00:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908605;
	bh=DWwuF57MolwbM5i8eNBjm/jHuuvrzQNXijS70lKRAgE=;
	h=Date:To:From:Subject:From;
	b=04/of75GEtlP0YXOKwSTiXsQ3ha0ZBPfIo4d3ZgsckxZ/hzeCFd9dPT6eNQeqEN92
	 ionE39YUhbubcQ0MlHtU/wocP4AwwD+vgUM2YsaAI1Q1iUU770+DM2PIBBV3jP5/il
	 nEgfYl3tLB2rwBxTDktnrJJsDElr9wEOuXgCrtdw=
Date: Tue, 11 Nov 2025 16:50:05 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-add-inline-inode-consistency-check-to-ocfs2_validate_inode_block.patch removed from -mm tree
Message-Id: <20251112005005.AA104C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add inline inode consistency check to ocfs2_validate_inode_block()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-inline-inode-consistency-check-to-ocfs2_validate_inode_block.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: add inline inode consistency check to ocfs2_validate_inode_block()
Date: Thu, 23 Oct 2025 17:16:50 +0300

In 'ocfs2_validate_inode_block()', add an extra check whether an inode
with inline data (i.e.  self-contained) has no clusters, thus preventing
an invalid inode from being passed to 'ocfs2_evict_inode()' and below.

Link: https://lkml.kernel.org/r/20251023141650.417129-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c16daba279a1161acfb0
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-add-inline-inode-consistency-check-to-ocfs2_validate_inode_block
+++ a/fs/ocfs2/inode.c
@@ -1505,6 +1505,14 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) &&
+	    le32_to_cpu(di->i_clusters)) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: %u clusters\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le32_to_cpu(di->i_clusters));
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch

