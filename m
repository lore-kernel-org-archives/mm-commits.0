From: akpm@linux-foundation.org
Subject: [merged]
 fs-ocfs2-dlmgluec-use-__seq_open_private-not-seq_open.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:17:45 -0700
Message-ID: <543c1749.7ZDOjGwkk3TD9sKC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMSRp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob.jones@codethink.co.uk, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/dlmglue.c: use __seq_open_private() not seq_open()
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-dlmgluec-use-__seq_open_private-not-seq_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
