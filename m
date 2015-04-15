From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-one-function-call-less-in-user_cluster_connect-after-error-detection.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:08:02 -0700
Message-ID: <552eb712.xVUDMA+SKjqVYrYM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbbDOTIC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: one function call less in user_cluster_connect() after error detection
has been removed from the -mm tree.  Its filename was
     ocfs2-one-function-call-less-in-user_cluster_connect-after-error-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

