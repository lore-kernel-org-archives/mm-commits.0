Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD8657C9F;
	Sat, 18 Oct 2025 00:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746524; cv=none; b=tReHSJ1v134T02sCRHAqzMv1Dc483wGUDeWE7/uPiMoLFFPyBN9zQq0+c4WjjhHnjX02NEYg079D++MP0GjzrtAGk+Mk0BHEmYyG5vN1eDLlXnOdwuPCVgma9AkpmSGeeGpGZUpxRpuM14iZok2I56rQCOt2rmBJ/eMgYmqciCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746524; c=relaxed/simple;
	bh=YZ4N1rHj1pwjtt3i7gLo9zt8/inKBT+EiPtspcVyryU=;
	h=Date:To:From:Subject:Message-Id; b=cI/Z0RgceZosszWM0ugogj0IvK+ZYHx5m6ca4WmSheFr1Eg4p2jA9qveRvypMseTZxnVoEP7PKs3OfP9odO9o6UB6udzmVopLJeRv1BdJHzLnEFL6Bn6nAILGoNlyXgENpQB++SrbPSKOBmCtvopP5bmHdb1IQUDFzCeSJ3g9vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oNJf3lCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oNJf3lCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6525FC4CEE7;
	Sat, 18 Oct 2025 00:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760746523;
	bh=YZ4N1rHj1pwjtt3i7gLo9zt8/inKBT+EiPtspcVyryU=;
	h=Date:To:From:Subject:From;
	b=oNJf3lCNqqClmapKBFwa+m3V7b6OxDCVYMA4l6UCWexgDtIL9O/asSXbhnCInfQ4R
	 oqX79ZxSoAoEBjISaqDd0LkLA0GRU03t75EkQe0Yzkj0ppjZglzOLVQTH0ZKrUi4DE
	 mABKukY3WUYF0X1A+qFT0WA1PNRSIT+0XlSDzrJA=
Date: Fri, 17 Oct 2025 17:15:22 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-chain-list-sanity-check-to-ocfs2_block_group_alloc.patch added to mm-nonmm-unstable branch
Message-Id: <20251018001523.6525FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: add chain list sanity check to ocfs2_block_group_alloc()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-add-chain-list-sanity-check-to-ocfs2_block_group_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-chain-list-sanity-check-to-ocfs2_block_group_alloc.patch

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
Subject: ocfs2: add chain list sanity check to ocfs2_block_group_alloc()
Date: Thu, 16 Oct 2025 11:46:53 +0300

Fix a UBSAN error:

UBSAN: array-index-out-of-bounds in fs/ocfs2/suballoc.c:380:22
index 0 is out of range for type 'struct ocfs2_chain_rec[] __counted_by(cl_count)' (aka 'struct ocfs2_chain_rec[]')

In 'ocfs2_block_group_alloc()', add an extra check whether the maximum
amount of chain records in 'struct ocfs2_chain_list' matches the value
calculated based on the filesystem block size.

Link: https://lkml.kernel.org/r/20251016084653.59686-1-dmantipov@yandex.ru
Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
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
ocfs2-add-chain-list-sanity-check-to-ocfs2_block_group_alloc.patch

