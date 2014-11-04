From: akpm@linux-foundation.org
Subject: [wrecked] single_open-seq_release-leak-diagnostics.patch removed
 from -mm tree
Date: Tue, 04 Nov 2014 15:36:51 -0800
Message-ID: <54596313.1vAo2qtqnDZtQdhZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaKDXgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 18:36:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: single_open/seq_release leak diagnostics
has been removed from the -mm tree.  Its filename was
     single_open-seq_release-leak-diagnostics.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@sw.ru>
Subject: single_open/seq_release leak diagnostics

"[PATCH] Fix leaks on /proc/{*/sched,sched_debug,timer_list,timer_stats}" and
"[PATCH] Fix leak on /proc/lockdep_stats" fixed 5 leaks which happen if one
uses single_open() as .open function and seq_release() as .release function.

Let's add small amount of runtime checking.

Sample output is:

	memory leak: 'timer_list'
	WARNING: at fs/seq_file.c:289 seq_release()
	 [<c015e311>] seq_release+0x53/0x68
	 [<c0171bd8>] proc_reg_release+0x63/0x74
	 [<c0149877>] __fput+0x28/0xd3
	 [<c0147681>] filp_close+0x48/0x4f
	 [<c014876a>] sys_close+0x74/0xbe
	 [<c010248e>] sysenter_past_esp+0x5f/0x85
	 =======================

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   25 ++++++++++++++++++++-----
 include/linux/seq_file.h |    1 +
 2 files changed, 21 insertions(+), 5 deletions(-)

diff -puN fs/seq_file.c~single_open-seq_release-leak-diagnostics fs/seq_file.c
--- a/fs/seq_file.c~single_open-seq_release-leak-diagnostics
+++ a/fs/seq_file.c
@@ -362,6 +362,13 @@ EXPORT_SYMBOL(seq_lseek);
 int seq_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
+
+	if (m->seq_ops_allocated) {
+		struct dentry *dentry = file->f_dentry;
+		printk("memory leak: '%.*s'\n",
+			dentry->d_name.len, dentry->d_name.name);
+		WARN_ON(1);
+	}
 	kvfree(m->buf);
 	kfree(m);
 	return 0;
@@ -605,9 +612,12 @@ int single_open(struct file *file, int (
 		op->stop = single_stop;
 		op->show = show;
 		res = seq_open(file, op);
-		if (!res)
-			((struct seq_file *)file->private_data)->private = data;
-		else
+		if (!res) {
+			struct seq_file *seq = file->private_data;
+
+			seq->private = data;
+			seq->seq_ops_allocated = 1;
+		} else
 			kfree(op);
 	}
 	return res;
@@ -634,8 +644,13 @@ EXPORT_SYMBOL(single_open_size);
 
 int single_release(struct inode *inode, struct file *file)
 {
-	const struct seq_operations *op = ((struct seq_file *)file->private_data)->op;
-	int res = seq_release(inode, file);
+	struct seq_file *seq = file->private_data;
+	const struct seq_operations *op = seq->op;
+	int res;
+
+	/* All roads lead to seq_release(), so... */
+	seq->seq_ops_allocated = 0;
+	res = seq_release(inode, file);
 	kfree(op);
 	return res;
 }
diff -puN include/linux/seq_file.h~single_open-seq_release-leak-diagnostics include/linux/seq_file.h
--- a/include/linux/seq_file.h~single_open-seq_release-leak-diagnostics
+++ a/include/linux/seq_file.h
@@ -31,6 +31,7 @@ struct seq_file {
 	struct user_namespace *user_ns;
 #endif
 	void *private;
+	unsigned int seq_ops_allocated:1;
 };
 
 struct seq_operations {
_

Patches currently in -mm which might be from adobriyan@sw.ru are


