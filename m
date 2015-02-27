From: akpm@linux-foundation.org
Subject: [nacked] ocfs2-remove-unneeded-rc-for-kfree.patch removed from
 -mm tree
Date: Thu, 26 Feb 2015 23:12:45 -0800
Message-ID: <54f018ed.mZUPLNcscT4dSNg1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbbB0HNa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 02:13:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unneeded 'rc' for kfree()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unneeded-rc-for-kfree.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: ocfs2: remove unneeded 'rc' for kfree()

If kzalloc() failed, just goto 'out' label and 'out_free' label doesn't
need to check 'rc' variable.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_o2cb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/stack_o2cb.c~ocfs2-remove-unneeded-rc-for-kfree fs/ocfs2/stack_o2cb.c
--- a/fs/ocfs2/stack_o2cb.c~ocfs2-remove-unneeded-rc-for-kfree
+++ a/fs/ocfs2/stack_o2cb.c
@@ -347,7 +347,7 @@ static int o2cb_cluster_connect(struct o
 	priv = kzalloc(sizeof(struct o2dlm_private), GFP_KERNEL);
 	if (!priv) {
 		rc = -ENOMEM;
-		goto out_free;
+		goto out;
 	}
 
 	/* This just fills the structure in.  It is safe to pass conn. */
@@ -376,8 +376,7 @@ static int o2cb_cluster_connect(struct o
 	dlm_register_eviction_cb(dlm, &priv->op_eviction_cb);
 
 out_free:
-	if (rc)
-		kfree(conn->cc_private);
+	kfree(conn->cc_private);
 
 out:
 	return rc;
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check.patch
ocfs2-remove-unneeded-variable-status.patch
ocfs2-remove-extra-mlog_errno-call-in-__ocfs2_add_entry.patch
ocfs2-need-to-handle-error-for-ocfs2_journal_access_di-call.patch

