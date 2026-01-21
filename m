Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6223115B0
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967397; cv=none; b=CJkRE6r3qFup1zcvrQJikpvQelywqxJKeL8Va//+FYXA4cznM2+Lfte0RDrB7L6AolcNyxo71j5mbV22AnOC12rts7A0d7uXhHOlSx8g0AWfcuOVz/e3yipGiCaVwfqirXkQ93tKSAz23eFHFLv0plfY8sfAe4/UzSXCjSpjATs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967397; c=relaxed/simple;
	bh=kzMdl0I9mAzoqnZmsFypzN+JYlWLk3behsbw1x4xvJ8=;
	h=Date:To:From:Subject:Message-Id; b=KMm8NlcsAmbFfJB1ECqJdPXF2J+XjbwXQ/kCFr+6nO9XJ06NeJmKslvX017oqjxdECYtZR0Sa+bPquogGy/AFJ6qV3SQ0YaDMSSyXM5A0Le4qdOJvE/qq5UY2LPXJXFvtD7KGNPcwQuQaM6Oat2vZ7q/WJ0zvsPlhYcGiQwmmOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V7G/4ysJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V7G/4ysJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CB4C16AAE;
	Wed, 21 Jan 2026 03:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967396;
	bh=kzMdl0I9mAzoqnZmsFypzN+JYlWLk3behsbw1x4xvJ8=;
	h=Date:To:From:Subject:From;
	b=V7G/4ysJioGZAgGPHIT1hZt5gljuwnyNjuCo8ShP5jOz6NtdtdeX2s5mFMHm3Aywv
	 AcQslas/eoLpul9tc0C3NKHN8owXzEkasVB3Ffu3YQlyyn5O6T2aWz5kSuQAfsEF9m
	 lO7vr4uhkXB4TygTG8fyCxXR3NnCJgIko9NeQieo=
Date: Tue, 20 Jan 2026 19:49:56 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-add-check-for-free-bits-before-allocation-in-ocfs2_move_extent.patch removed from -mm tree
Message-Id: <20260121034956.A4CB4C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add check for free bits before allocation in ocfs2_move_extent()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-check-for-free-bits-before-allocation-in-ocfs2_move_extent.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: ocfs2: add check for free bits before allocation in ocfs2_move_extent()
Date: Sun, 4 Jan 2026 19:05:04 +0530

Add a check to verify the group descriptor has enough free bits before
attempting allocation in ocfs2_move_extent().  This prevents a kernel
BUG_ON crash in ocfs2_block_group_set_bits() when the move_extents ioctl
is called on a crafted or corrupted filesystem.

The existing validation in ocfs2_validate_gd_self() only checks static
metadata consistency (bg_free_bits_count <= bg_bits) when the descriptor
is first read from disk.  However, during move_extents operations,
multiple allocations can exhaust the free bits count below the requested
allocation size, triggering BUG_ON(le16_to_cpu(bg->bg_free_bits_count) <
num_bits).

The debug trace shows the issue clearly:
  - Block group 32 validated with bg_free_bits_count=427
  - Repeated allocations decreased count: 427 -> 171 -> 43 -> ... -> 1
  - Final request for 2 bits with only 1 available triggers BUG_ON

By adding an early check in ocfs2_move_extent() right after
ocfs2_find_victim_alloc_group(), we return -ENOSPC gracefully instead of
crashing the kernel.  This also avoids unnecessary work in
ocfs2_probe_alloc_group() and __ocfs2_move_extent() when the allocation
will fail.

Link: https://lkml.kernel.org/r/20260104133504.14810-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+7960178e777909060224@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7960178e777909060224
Link: https://lore.kernel.org/all/20251231115801.293726-1-kartikey406@gmail.com/T/ [v1]
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/move_extents.c~ocfs2-add-check-for-free-bits-before-allocation-in-ocfs2_move_extent
+++ a/fs/ocfs2/move_extents.c
@@ -662,6 +662,12 @@ static int ocfs2_move_extent(struct ocfs
 		goto out_commit;
 	}
 
+	gd = (struct ocfs2_group_desc *)gd_bh->b_data;
+	if (le16_to_cpu(gd->bg_free_bits_count) < len) {
+		ret = -ENOSPC;
+		goto out_commit;
+	}
+
 	/*
 	 * probe the victim cluster group to find a proper
 	 * region to fit wanted movement, it even will perform
@@ -682,7 +688,6 @@ static int ocfs2_move_extent(struct ocfs
 		goto out_commit;
 	}
 
-	gd = (struct ocfs2_group_desc *)gd_bh->b_data;
 	ret = ocfs2_alloc_dinode_update_counts(gb_inode, handle, gb_bh, len,
 					       le16_to_cpu(gd->bg_chain));
 	if (ret) {
_

Patches currently in -mm which might be from kartikey406@gmail.com are

mm-swap_cgroup-fix-kernel-bug-in-swap_cgroup_record.patch
mm-vmalloc-prevent-rcu-stalls-in-kasan_release_vmalloc_node.patch

