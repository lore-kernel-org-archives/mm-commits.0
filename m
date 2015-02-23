From: akpm@linux-foundation.org
Subject: +
 ocfs2-one-function-call-less-in-user_cluster_connect-after-error-detection.patch added to -mm tree
Date: Mon, 23 Feb 2015 15:21:31 -0800
Message-ID: <54ebb5fb.3Xfc3tgHHPgMmrW/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbBWXVc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:21:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: one function call less in user_cluster_connect() after error detection
has been added to the -mm tree.  Its filename is
     ocfs2-one-function-call-less-in-user_cluster_connect-after-error-detection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-one-function-call-less-in-user_cluster_connect-after-error-detection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-one-function-call-less-in-user_cluster_connect-after-error-detection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: ocfs2: one function call less in user_cluster_connect() after error detection

kfree() was called by user_cluster_connect() even if a previous call of
the kzalloc() function failed.

Return from this implementation directly after failure detection.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/stack_user.c~ocfs2-one-function-call-less-in-user_cluster_connect-after-error-detection fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~ocfs2-one-function-call-less-in-user_cluster_connect-after-error-detection
+++ a/fs/ocfs2/stack_user.c
@@ -1004,10 +1004,8 @@ static int user_cluster_connect(struct o
 	BUG_ON(conn == NULL);
 
 	lc = kzalloc(sizeof(struct ocfs2_live_connection), GFP_KERNEL);
-	if (!lc) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	if (!lc)
+		return -ENOMEM;
 
 	init_waitqueue_head(&lc->oc_wait);
 	init_completion(&lc->oc_sync_wait);
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

ocfs2-deletion-of-unnecessary-checks-before-three-function-calls.patch
ocfs2-less-function-calls-in-ocfs2_convert_inline_data_to_extents-after-error-detection.patch
ocfs2-less-function-calls-in-ocfs2_figure_merge_contig_type-after-error-detection.patch
ocfs2-one-function-call-less-in-ocfs2_merge_rec_left-after-error-detection.patch
ocfs2-one-function-call-less-in-ocfs2_merge_rec_right-after-error-detection.patch
ocfs2-one-function-call-less-in-ocfs2_init_slot_info-after-error-detection.patch
ocfs2-one-function-call-less-in-user_cluster_connect-after-error-detection.patch
linux-next.patch

