From: akpm@linux-foundation.org
Subject: + ocfs2-unlock-bh_state-if-bg-check-fails.patch added to -mm tree
Date: Thu, 25 Jan 2018 14:49:04 -0800
Message-ID: <5a6a5ee0.mFJ3D2vKj/Idjice%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48348 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751238AbeAYWtF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jan 2018 17:49:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ge.changwei@h3c.com, akpm@linux-foundation.org, jack@suse.cz, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: unlock bh_state if bg check fails
has been added to the -mm tree.  Its filename is
     ocfs2-unlock-bh_state-if-bg-check-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-unlock-bh_state-if-bg-check-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-unlock-bh_state-if-bg-check-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-dlm-clean-dead-code-up.patch
ocfs2-cluster-neaten-a-member-of-o2net_msg_handler.patch
ocfs2-clean-dead-code-in-suballocc.patch
ocfs2-clean-dead-code-up-in-allocc.patch
ocfs2-make-metadata-estimation-accurate-and-clear.patch
ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc.patch
ocfs2-unlock-bh_state-if-bg-check-fails.patch

