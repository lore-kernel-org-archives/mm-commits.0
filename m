Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D460221F17
	for <mm-commits@vger.kernel.org>; Tue, 28 Oct 2025 23:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761693813; cv=none; b=hPnN7fBW8rK/i/K/CNhf1uZgVCEy9iR89/r91z3MMl+9s/zWBqpUhE1Im4fl2UHWOf2pFdVNUXl4C2UooUUcKOhG0YI6mOCPAdZyUCTD+h+8thI0obbF0gUKKrKfIAefYx5h2bpZTry0dYglU2RnK9eALZP7Q4njvL82WC3wEZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761693813; c=relaxed/simple;
	bh=4vhpzAanymA8OrO0iUykJuyZTS2B18CZ26VBrY4EJPI=;
	h=Date:To:From:Subject:Message-Id; b=Imer1i3lQ1l2i5n3n8hC86qroJRGzWn7edskvXKKP0NHm5itQZ8KfXiH3ulo2QnwGtB0PWKIAZ569wW/0OBF/Yr7ncvFggMoGKdt32lbpnlMaTcZfl1Iky+xtvM/jOkQ5NGxdkx7JJUdi1wiq9xCAt4n0UfIXo6xJgdKbrVFiQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z7USGOPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z7USGOPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97DDC4CEE7;
	Tue, 28 Oct 2025 23:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761693812;
	bh=4vhpzAanymA8OrO0iUykJuyZTS2B18CZ26VBrY4EJPI=;
	h=Date:To:From:Subject:From;
	b=Z7USGOPnnKKBMgjj8VRzsrylGjgIyNBb0JttsZuolSOMEsbJFq38aPUTv+HuN1zvR
	 xm9SN0SBiEWahTDs1WVFoxGpqERY5bXkTALGrI8Q/dnAiX7oeX8PsfBZ0dWuIlNnyB
	 k5S71jCG1UWOqN9v54arrX/pbdFAw9PAScDaS8gI=
Date: Tue, 28 Oct 2025 16:23:32 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ocfs2-add-chain-list-sanity-check-to-ocfs2_block_group_alloc.patch removed from -mm tree
Message-Id: <20251028232332.C97DDC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add chain list sanity check to ocfs2_block_group_alloc()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-chain-list-sanity-check-to-ocfs2_block_group_alloc.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: add chain list sanity check to ocfs2_block_group_alloc()
Date: Thu, 16 Oct 2025 11:46:53 +0300

In 'ocfs2_block_group_alloc()', add an extra check whether the maximum
amount of chain records in 'struct ocfs2_chain_list' matches the value
calculated based on the filesystem block size.

Link: https://lkml.kernel.org/r/20251016084653.59686-1-dmantipov@yandex.ru
Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ocfs2/suballoc.c~ocfs2-add-chain-list-sanity-check-to-ocfs2_block_group_alloc
+++ a/fs/ocfs2/suballoc.c
@@ -671,6 +671,11 @@ static int ocfs2_block_group_alloc(struc
 	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
 
 	cl = &fe->id2.i_chain;
+	if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(osb->sb)) {
+		status = -EINVAL;
+		goto bail;
+	}
+
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
 						   max_block, flags, &ac);
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

