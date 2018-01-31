From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix.patch
 removed from -mm tree
Date: Wed, 31 Jan 2018 15:46:37 -0800
Message-ID: <5a72555d.2Ato/QZnLa6KMeFE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55414 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753463AbeAaXqj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 18:46:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ge.changwei@h3c.com, dan.carpenter@oracle.com, jiangqi903@gmail.com, jlbec@evilplan.org, john@nixnuts.net, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix.patch

This patch was dropped because it was folded into ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc.patch

------------------------------------------------------
From: Changwei Ge <ge.changwei@h3c.com>
Subject: ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix

fix static checker warnning

Link: http://lkml.kernel.org/r/63ADC13FD55D6546B7DECE290D39E373F29196AE@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: John Lightsey <john@nixnuts.net>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix
+++ a/fs/ocfs2/alloc.c
@@ -6756,8 +6756,8 @@ static int ocfs2_reuse_blk_from_dealloc(
 	*blk_given = i;
 
 bail:
-	if (unlikely(status)) {
-		for (; i >= 0; i--) {
+	if (unlikely(status < 0)) {
+		for (i = 0; i < blk_wanted; i++) {
 			if (new_eb_bh[i])
 				brelse(new_eb_bh[i]);
 		}
_

Patches currently in -mm which might be from ge.changwei@h3c.com are

ocfs2-dlm-clean-dead-code-up.patch
ocfs2-cluster-neaten-a-member-of-o2net_msg_handler.patch
ocfs2-clean-dead-code-in-suballocc.patch
ocfs2-clean-dead-code-up-in-allocc.patch
ocfs2-make-metadata-estimation-accurate-and-clear.patch
ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc.patch
ocfs2-unlock-bh_state-if-bg-check-fails.patch

