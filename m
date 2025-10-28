Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACBB35502B
	for <mm-commits@vger.kernel.org>; Tue, 28 Oct 2025 23:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761693848; cv=none; b=UB4Ujdu6beiwn+7rfnYjPjJOJq1xlTVE0Y3p7L0ZCVujLfSX9s9wkSd/i5vNNwfjkNRMzBsh6cgOW1L6hQkh4QDco/DyfCUl2EXJ466+l6E+Vg5680hV3955AuMRqNxdpj3Cs3YOeAk113DvMTzlagHDSAHhDxVcPHhhziuNp5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761693848; c=relaxed/simple;
	bh=y2sgoMK9dQMq82LXWUYD5tNLnKJMy5+X4/LUWiHTxpg=;
	h=Date:To:From:Subject:Message-Id; b=SDsWrVhOUIgJSimfkJsCXDJv0nf5eeZGqKci+sXmbJNZQGFwn/oxyOgfPBN7qQSmT/lwMYkfmnl/WhZ/wG3MwTZT/8jKiKYQJkUIASFD2QHqhaUR9XzzxWVpxHR09viN5DBs3dj/x/aYEc5l/uv1UrL3g2nGgGfoXuW4mM27ZBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dUGo5NcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dUGo5NcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61992C4CEE7;
	Tue, 28 Oct 2025 23:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761693848;
	bh=y2sgoMK9dQMq82LXWUYD5tNLnKJMy5+X4/LUWiHTxpg=;
	h=Date:To:From:Subject:From;
	b=dUGo5NcSjEVpeuHWChtJuTA20ccGEIBsjKCr5YRX6kYEFauoYPR6xhdTpoVSAszDY
	 N5+TNVKX5DoZpEjDGV4T4VP21O/Oh1eTPrort0kQN7Gu7K83Y6NdGVLrF/DQqIEKw/
	 soiAgfD9cGJbBpJE3RxQZ5ZAfzEXOklw8P7kBT1I=
Date: Tue, 28 Oct 2025 16:24:07 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch added to mm-nonmm-unstable branch
Message-Id: <20251028232408.61992C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: add extra consistency checks for chain allocator dinodes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch

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
Subject: ocfs2: add extra consistency checks for chain allocator dinodes
Date: Tue, 28 Oct 2025 13:14:47 +0300

When validating chain allocator dinode in 'ocfs2_validate_inode_block()',
add an extra checks whether a) the maximum amount of chain records in
'struct ocfs2_chain_list' matches the value calculated based on the
filesystem block size, and b) the next free slot index is within the valid
range.

Link: https://lkml.kernel.org/r/20251028101447.693289-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes
+++ a/fs/ocfs2/inode.c
@@ -1528,6 +1528,23 @@ int ocfs2_validate_inode_block(struct su
 		}
 	}
 
+	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
+		struct ocfs2_chain_list *cl = &di->id2.i_chain;
+
+		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_count));
+			goto bail;
+		}
+		if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list index %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_next_free_rec));
+			goto bail;
+		}
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
ocfs2-add-boundary-check-to-ocfs2_check_dir_entry.patch
ocfs2-add-inline-inode-consistency-check-to-ocfs2_validate_inode_block.patch
ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch

