Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF363446C8
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 20:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767731978; cv=none; b=PL1mgS7r5XLlSZHhIsEEyLG0zwfuxSpgAL4c/6LOzpzJr7PpElK437D9ylFETnx9LlHn6FXENyZi8H8B2rnwwTdOjhANJYpHYbNot3ouiiBl+RU2UDmlNSYv7kQ1uLZ8mnj8lfXPCeNaR4i2mfrsegQ9/m5QcRb5ycimjkg2/6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767731978; c=relaxed/simple;
	bh=sIvbKK7hOZoV18tu0SB5kC88zxt3GStCDX95AeP7sIU=;
	h=Date:To:From:Subject:Message-Id; b=CrxZc6sOSOXgXiewu2BD2ZYfRy9agiCoyyqakcBYtcslS1W0LU58VChkZ4ciOp5w39vGyb6jVgMNyCE75gvba1WrFNtju0AVF9l9eldmZ8e10Il8GgLE31uWLcTgbOD09ObCSxSXtME3EQ1phNPTGWcAKvhq5KpAQ+zf6SS5HQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ncSPNt69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ncSPNt69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB08CC116C6;
	Tue,  6 Jan 2026 20:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767731977;
	bh=sIvbKK7hOZoV18tu0SB5kC88zxt3GStCDX95AeP7sIU=;
	h=Date:To:From:Subject:From;
	b=ncSPNt69NUhJsURRPaveeTBRULOvnR4iJgnCY+LW91FxWn810mhGNMSiAE9K3p3DW
	 scsycThSUGHfSxkuNG3uZ7FedhqcCMlAp5mDd5+cT0xZUaI+2eS2sELEqLIeWKWP0r
	 NVEz5UBHaRWmG9f0LbuESPIQGuPfTR5NEQojCgMQ=
Date: Tue, 06 Jan 2026 12:39:37 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-check-for-free-bits-before-allocation-in-ocfs2_move_extent.patch added to mm-nonmm-unstable branch
Message-Id: <20260106203937.CB08CC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: add check for free bits before allocation in ocfs2_move_extent()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-add-check-for-free-bits-before-allocation-in-ocfs2_move_extent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-check-for-free-bits-before-allocation-in-ocfs2_move_extent.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

ocfs2-validate-i_refcount_loc-when-refcount-flag-is-set.patch
ocfs2-validate-inline-data-i_size-during-inode-read.patch
ocfs2-add-check-for-free-bits-before-allocation-in-ocfs2_move_extent.patch

