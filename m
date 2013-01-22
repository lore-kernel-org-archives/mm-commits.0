From: akpm@linux-foundation.org
Subject: + proc-avoid-extra-pde_put-in-proc_fill_super.patch added to -mm tree
Date: Tue, 22 Jan 2013 14:56:24 -0800
Message-ID: <20130122225624.96DF15A41F2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:37496 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab3AVW4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 17:56:25 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so416985ggn.0
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 14:56:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpatlasov@parallels.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: proc: avoid extra pde_put() in proc_fill_super()
has been added to the -mm tree.  Its filename is
     proc-avoid-extra-pde_put-in-proc_fill_super.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maxim Patlasov <mpatlasov@parallels.com>
Subject: proc: avoid extra pde_put() in proc_fill_super()

If proc_get_inode() succeeded, but d_make_root() failed, pde_put() for
proc_root will be called twice: the first time due to iput() called from
d_make_root() and the second time directly in the end of
proc_fill_super().

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN fs/proc/inode.c~proc-avoid-extra-pde_put-in-proc_fill_super fs/proc/inode.c
--- a/fs/proc/inode.c~proc-avoid-extra-pde_put-in-proc_fill_super
+++ a/fs/proc/inode.c
@@ -486,6 +486,8 @@ struct inode *proc_get_inode(struct supe
 
 int proc_fill_super(struct super_block *s)
 {
+	struct inode *root_inode;
+
 	s->s_flags |= MS_NODIRATIME | MS_NOSUID | MS_NOEXEC;
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
@@ -494,11 +496,18 @@ int proc_fill_super(struct super_block *
 	s->s_time_gran = 1;
 	
 	pde_get(&proc_root);
-	s->s_root = d_make_root(proc_get_inode(s, &proc_root));
-	if (s->s_root)
-		return 0;
+	root_inode = proc_get_inode(s, &proc_root);
+	if (!root_inode) {
+		printk(KERN_ERR "proc_fill_super: get root inode failed\n");
+		pde_put(&proc_root);
+		return -ENOMEM;
+	}
+
+	s->s_root = d_make_root(root_inode);
+	if (!s->s_root) {
+		printk(KERN_ERR "proc_fill_super: allocate dentry failed\n");
+		return -ENOMEM;
+	}
 
-	printk("proc_read_super: get root inode failed\n");
-	pde_put(&proc_root);
-	return -ENOMEM;
+	return 0;
 }
_

Patches currently in -mm which might be from mpatlasov@parallels.com are

linux-next.patch
proc-avoid-extra-pde_put-in-proc_fill_super.patch

