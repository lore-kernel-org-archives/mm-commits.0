From: akpm@linux-foundation.org
Subject: [merged] ocfs2-unlock-bh_state-if-bg-check-fails.patch
 removed from -mm tree
Date: Thu, 01 Feb 2018 11:30:03 -0800
Message-ID: <20180201193003.jCHqmGCgN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57116 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754565AbeBATaI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:30:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ge.changwei@h3c.com, jack@suse.cz, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: unlock bh_state if bg check fails
has been removed from the -mm tree.  Its filename was
     ocfs2-unlock-bh_state-if-bg-check-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Changwei Ge <ge.changwei@h3c.com>
Subject: ocfs2: unlock bh_state if bg check fails

We should unlock bh_stat if bg->bg_free_bits_count > bg->bg_bits

Link: http://lkml.kernel.org/r/1516843095-23680-1-git-send-email-ge.changwei@h3c.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ocfs2/suballoc.c~ocfs2-unlock-bh_state-if-bg-check-fails fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-unlock-bh_state-if-bg-check-fails
+++ a/fs/ocfs2/suballoc.c
@@ -2438,6 +2438,8 @@ static int ocfs2_block_group_clear_bits(
 	}
 	le16_add_cpu(&bg->bg_free_bits_count, num_bits);
 	if (le16_to_cpu(bg->bg_free_bits_count) > le16_to_cpu(bg->bg_bits)) {
+		if (undo_fn)
+			jbd_unlock_bh_state(group_bh);
 		return ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit count %u but claims %u are freed. num_bits %d\n",
 				   (unsigned long long)le64_to_cpu(bg->bg_blkno),
 				   le16_to_cpu(bg->bg_bits),
_

Patches currently in -mm which might be from ge.changwei@h3c.com are


