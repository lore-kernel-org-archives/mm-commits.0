From: akpm@linux-foundation.org
Subject: +
 fs-ocfs2-cluster-netdebugc-use-seq_open_private-not-seq_open.patch added to -mm tree
Date: Wed, 10 Sep 2014 12:27:47 -0700
Message-ID: <5410a633.ZwUDEJOrZ3a+IoE0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaIJT1s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 15:27:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob.jones@codethink.co.uk, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/cluster/netdebug.c: use seq_open_private() not seq_open()
has been added to the -mm tree.  Its filename is
     fs-ocfs2-cluster-netdebugc-use-seq_open_private-not-seq_open.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ocfs2-cluster-netdebugc-use-seq_open_private-not-seq_open.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ocfs2-cluster-netdebugc-use-seq_open_private-not-seq_open.patch

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
Subject: fs/ocfs2/cluster/netdebug.c: use seq_open_private() not seq_open()

Reduce boilerplate code by using seq_open_private() instead of seq_open()

Note that the code in and using sc_common_open() has been quite
extensively changed.  Not least because there was a latent memory leak in
the code as was: if sc_common_open() failed, the previously allocated
buffer was not freed.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/netdebug.c |   78 ++++++++--------------------------
 1 file changed, 19 insertions(+), 59 deletions(-)

diff -puN fs/ocfs2/cluster/netdebug.c~fs-ocfs2-cluster-netdebugc-use-seq_open_private-not-seq_open fs/ocfs2/cluster/netdebug.c
--- a/fs/ocfs2/cluster/netdebug.c~fs-ocfs2-cluster-netdebugc-use-seq_open_private-not-seq_open
+++ a/fs/ocfs2/cluster/netdebug.c
@@ -185,29 +185,13 @@ static const struct seq_operations nst_s
 static int nst_fop_open(struct inode *inode, struct file *file)
 {
 	struct o2net_send_tracking *dummy_nst;
-	struct seq_file *seq;
-	int ret;
 
-	dummy_nst = kmalloc(sizeof(struct o2net_send_tracking), GFP_KERNEL);
-	if (dummy_nst == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	dummy_nst->st_task = NULL;
-
-	ret = seq_open(file, &nst_seq_ops);
-	if (ret)
-		goto out;
-
-	seq = file->private_data;
-	seq->private = dummy_nst;
+	dummy_nst = __seq_open_private(file, &nst_seq_ops, sizeof(*dummy_nst));
+	if (!dummy_nst)
+		return -ENOMEM;
 	o2net_debug_add_nst(dummy_nst);
 
-	dummy_nst = NULL;
-
-out:
-	kfree(dummy_nst);
-	return ret;
+	return 0;
 }
 
 static int nst_fop_release(struct inode *inode, struct file *file)
@@ -412,33 +396,27 @@ static const struct seq_operations sc_se
 	.show = sc_seq_show,
 };
 
-static int sc_common_open(struct file *file, struct o2net_sock_debug *sd)
+static int sc_common_open(struct file *file, int ctxt)
 {
+	struct o2net_sock_debug *sd;
 	struct o2net_sock_container *dummy_sc;
-	struct seq_file *seq;
-	int ret;
 
-	dummy_sc = kmalloc(sizeof(struct o2net_sock_container), GFP_KERNEL);
-	if (dummy_sc == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	dummy_sc->sc_page = NULL;
+	dummy_sc = kzalloc(sizeof(*dummy_sc), GFP_KERNEL);
+	if (!dummy_sc)
+		return -ENOMEM;
 
-	ret = seq_open(file, &sc_seq_ops);
-	if (ret)
-		goto out;
+	sd = __seq_open_private(file, &sc_seq_ops, sizeof(*sd));
+	if (!sd) {
+		kfree(dummy_sc);
+		return -ENOMEM;
+	}
 
-	seq = file->private_data;
-	seq->private = sd;
+	sd->dbg_ctxt = ctxt;
 	sd->dbg_sock = dummy_sc;
-	o2net_debug_add_sc(dummy_sc);
 
-	dummy_sc = NULL;
+	o2net_debug_add_sc(dummy_sc);
 
-out:
-	kfree(dummy_sc);
-	return ret;
+	return 0;
 }
 
 static int sc_fop_release(struct inode *inode, struct file *file)
@@ -453,16 +431,7 @@ static int sc_fop_release(struct inode *
 
 static int stats_fop_open(struct inode *inode, struct file *file)
 {
-	struct o2net_sock_debug *sd;
-
-	sd = kmalloc(sizeof(struct o2net_sock_debug), GFP_KERNEL);
-	if (sd == NULL)
-		return -ENOMEM;
-
-	sd->dbg_ctxt = SHOW_SOCK_STATS;
-	sd->dbg_sock = NULL;
-
-	return sc_common_open(file, sd);
+	return sc_common_open(file, SHOW_SOCK_STATS);
 }
 
 static const struct file_operations stats_seq_fops = {
@@ -474,16 +443,7 @@ static const struct file_operations stat
 
 static int sc_fop_open(struct inode *inode, struct file *file)
 {
-	struct o2net_sock_debug *sd;
-
-	sd = kmalloc(sizeof(struct o2net_sock_debug), GFP_KERNEL);
-	if (sd == NULL)
-		return -ENOMEM;
-
-	sd->dbg_ctxt = SHOW_SOCK_CONTAINERS;
-	sd->dbg_sock = NULL;
