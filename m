From: akpm@linux-foundation.org
Subject: + single_open-seq_release-leak-diagnostics.patch added to -mm tree
Date: Tue, 31 Jul 2007 11:42:17 -0700
Message-ID: <200707311842.l6VIgH7c016631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60528 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbXGaSnG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 14:43:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, viro@zeniv.linux.org.uk


The patch titled
     single_open/seq_release leak diagnostics
has been added to the -mm tree.  Its filename is
     single_open-seq_release-leak-diagnostics.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: single_open/seq_release leak diagnostics
From: Alexey Dobriyan <adobriyan@sw.ru>

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
@@ -281,6 +281,13 @@ EXPORT_SYMBOL(seq_lseek);
 int seq_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
+
+	if (m->seq_ops_allocated) {
+		struct dentry *dentry = file->f_dentry;
+		printk("memory leak: '%.*s'\n",
+			dentry->d_name.len, dentry->d_name.name);
+		WARN_ON(1);
+	}
 	kfree(m->buf);
 	kfree(m);
 	return 0;
@@ -401,9 +408,12 @@ int single_open(struct file *file, int (
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
@@ -412,8 +422,13 @@ EXPORT_SYMBOL(single_open);
 
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
@@ -22,6 +22,7 @@ struct seq_file {
 	struct mutex lock;
 	const struct seq_operations *op;
 	void *private;
+	unsigned int seq_ops_allocated:1;
 };
 
 struct seq_operations {
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
gitignore-update.patch
add-ctl_proc-back.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-leak-on-proc-lockdep_stats.patch
consolidate-ptrace_detach.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
single_open-seq_release-leak-diagnostics.patch
