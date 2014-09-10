From: akpm@linux-foundation.org
Subject: + fs-ocfs2-dlmgluec-use-__seq_open_private-not-seq_open.patch
 added to -mm tree
Date: Wed, 10 Sep 2014 12:27:48 -0700
Message-ID: <5410a634.FRvhMxj99fR8/vQU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaIJT1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 15:27:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob.jones@codethink.co.uk, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/dlmglue.c: use __seq_open_private() not seq_open()
has been added to the -mm tree.  Its filename is
     fs-ocfs2-dlmgluec-use-__seq_open_private-not-seq_open.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ocfs2-dlmgluec-use-__seq_open_private-not-seq_open.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ocfs2-dlmgluec-use-__seq_open_private-not-seq_open.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Jones <rob.jones@codethink.co.uk>
Subject: fs/ocfs2/dlmglue.c: use __seq_open_private() not seq_open()

Reduce boilerplate code by using seq_open_private() instead of seq_open()

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~fs-ocfs2-dlmgluec-use-__seq_open_private-not-seq_open fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~fs-ocfs2-dlmgluec-use-__seq_open_private-not-seq_open
+++ a/fs/ocfs2/dlmglue.c
@@ -2892,37 +2892,24 @@ static int ocfs2_dlm_debug_release(struc
 
 static int ocfs2_dlm_debug_open(struct inode *inode, struct file *file)
 {
-	int ret;
 	struct ocfs2_dlm_seq_priv *priv;
-	struct seq_file *seq;
 	struct ocfs2_super *osb;
 
-	priv = kzalloc(sizeof(struct ocfs2_dlm_seq_priv), GFP_KERNEL);
+	priv = __seq_open_private(file, &ocfs2_dlm_seq_ops, sizeof(*priv));
 	if (!priv) {
-		ret = -ENOMEM;
-		mlog_errno(ret);
-		goto out;
+		mlog_errno(-ENOMEM);
+		return -ENOMEM;
 	}
+
 	osb = inode->i_private;
 	ocfs2_get_dlm_debug(osb->osb_dlm_debug);
 	priv->p_dlm_debug = osb->osb_dlm_debug;
 	INIT_LIST_HEAD(&priv->p_iter_res.l_debug_list);
 
-	ret = seq_open(file, &ocfs2_dlm_seq_ops);
-	if (ret) {
-		kfree(priv);
-		mlog_errno(ret);
-		goto out;
-	}
-
-	seq = file->private_data;
-	seq->private = priv;
