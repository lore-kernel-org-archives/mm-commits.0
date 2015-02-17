From: akpm@linux-foundation.org
Subject: + ocfs2-remove-unneeded-rc-for-kfree.patch added to -mm tree
Date: Tue, 17 Feb 2015 15:32:07 -0800
Message-ID: <54e3cf77.u8mie52zQedDwSSV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbbBQXcI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 18:32:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unneeded 'rc' for kfree()
has been added to the -mm tree.  Its filename is
     ocfs2-remove-unneeded-rc-for-kfree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-unneeded-rc-for-kfree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-unneeded-rc-for-kfree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
ocfs2-remove-unneeded-rc-for-kfree.patch

