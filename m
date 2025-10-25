Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE831F4E34
	for <mm-commits@vger.kernel.org>; Sat, 25 Oct 2025 23:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761436528; cv=none; b=RRVlsqTdRuQOd27GJLxJckmtFWRpjvKI1o3JoEVtabJJ1z4Q6Mn2lDk0wUU/7osjJChUa2xjLaLHfXWAFz/i1JxVyJi5xwsemss+SHmEB9MCVgnBu75awssiRopPiY384K7Y9T65QcIro0PjxemJeXySamsPia39S+VgFBdR1Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761436528; c=relaxed/simple;
	bh=ORmg90CbJsbx2C47J9MY9mHoFDCyKECxgHgXSWCnY0w=;
	h=Date:To:From:Subject:Message-Id; b=SRkEQ9anqlN9OQin31/kM5jQxghq3E8FaoiZz5ztd0VeugacNqoWNjSEPT2LjLgMsbYrJCh3zlHdCZr1YJ3/BdKysb1615BGKWrelfcwO999cSJXyFTO7BZwsQ3bQfvNqQ4ykv/3firvIZsRJGMOh/GOvW1kIO95DWnQJK47xjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oKmS8om1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oKmS8om1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130A4C4CEF5;
	Sat, 25 Oct 2025 23:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761436528;
	bh=ORmg90CbJsbx2C47J9MY9mHoFDCyKECxgHgXSWCnY0w=;
	h=Date:To:From:Subject:From;
	b=oKmS8om1L/Gjguqy5Q8awultWsbUL7Mp6cL2Qt2J9rk2R0pgLREbrWVTx64Txpcdc
	 8qX8Dipul8e1NqmrDFgrx116GgNNRvvAjOEB6K2t/Y3+Uu1WuhzX5K5N1YvHO5E50b
	 ED1aHPHLa/nexyXSgX9WWaAFGIc1H43qyUuMkuuM=
Date: Sat, 25 Oct 2025 16:55:27 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-inline-inode-consistency-check-to-ocfs2_validate_inode_block.patch added to mm-nonmm-unstable branch
Message-Id: <20251025235528.130A4C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: add inline inode consistency check to ocfs2_validate_inode_block()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-add-inline-inode-consistency-check-to-ocfs2_validate_inode_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-inline-inode-consistency-check-to-ocfs2_validate_inode_block.patch

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

ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch
ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le-fix.patch
ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec.patch
ocfs2-add-directory-size-check-to-ocfs2_find_dir_space_id.patch
ocfs2-add-chain-list-sanity-check-to-ocfs2_block_group_alloc.patch
ocfs2-add-boundary-check-to-ocfs2_check_dir_entry.patch
ocfs2-add-inline-inode-consistency-check-to-ocfs2_validate_inode_block.patch

