From: akpm@linux-foundation.org
Subject: + proc-remove-inf-macro.patch added to -mm tree
Date: Thu, 17 Jul 2014 15:54:41 -0700
Message-ID: <53c85431.vIwR1FEAHFpnipJD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:61275 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009AbaGQWym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 18:54:42 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so835431pde.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 15:54:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: remove INF macro
has been added to the -mm tree.  Its filename is
     proc-remove-inf-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-remove-inf-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-remove-inf-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: remove INF macro

If you're applying this patch, all /proc/$PID/* files were converted
to seq_file interface and this code became unused.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |   41 -----------------------------------------
 fs/proc/internal.h |    1 -
 2 files changed, 42 deletions(-)

diff -puN fs/proc/base.c~proc-remove-inf-macro fs/proc/base.c
--- a/fs/proc/base.c~proc-remove-inf-macro
+++ a/fs/proc/base.c
@@ -130,10 +130,6 @@ struct pid_entry {
 		{ .proc_get_link = get_link } )
 #define REG(NAME, MODE, fops)				\
 	NOD(NAME, (S_IFREG|(MODE)), NULL, &fops, {})
-#define INF(NAME, MODE, read)				\
-	NOD(NAME, (S_IFREG|(MODE)), 			\
-		NULL, &proc_info_file_operations,	\
-		{ .proc_read = read } )
 #define ONE(NAME, MODE, show)				\
 	NOD(NAME, (S_IFREG|(MODE)), 			\
 		NULL, &proc_single_file_operations,	\
@@ -605,43 +601,6 @@ static const struct inode_operations pro
 	.setattr	= proc_setattr,
 };
 
-#define PROC_BLOCK_SIZE	(3*1024)		/* 4K page size but our output routines use some slack for overruns */
-
-static ssize_t proc_info_read(struct file * file, char __user * buf,
-			  size_t count, loff_t *ppos)
-{
-	struct inode * inode = file_inode(file);
-	unsigned long page;
-	ssize_t length;
-	struct task_struct *task = get_proc_task(inode);
-
-	length = -ESRCH;
-	if (!task)
-		goto out_no_task;
-
-	if (count > PROC_BLOCK_SIZE)
-		count = PROC_BLOCK_SIZE;
-
-	length = -ENOMEM;
-	if (!(page = __get_free_page(GFP_TEMPORARY)))
-		goto out;
-
-	length = PROC_I(inode)->op.proc_read(task, (char*)page);
-
-	if (length >= 0)
-		length = simple_read_from_buffer(buf, count, ppos, (char *)page, length);
-	free_page(page);
-out:
-	put_task_struct(task);
-out_no_task:
-	return length;
-}
-
-static const struct file_operations proc_info_file_operations = {
-	.read		= proc_info_read,
-	.llseek		= generic_file_llseek,
-};
-
 static int proc_single_show(struct seq_file *m, void *v)
 {
 	struct inode *inode = m->private;
diff -puN fs/proc/internal.h~proc-remove-inf-macro fs/proc/internal.h
--- a/fs/proc/internal.h~proc-remove-inf-macro
+++ a/fs/proc/internal.h
@@ -52,7 +52,6 @@ struct proc_dir_entry {
 
 union proc_op {
 	int (*proc_get_link)(struct dentry *, struct path *);
-	int (*proc_read)(struct task_struct *task, char *page);
 	int (*proc_show)(struct seq_file *m,
 		struct pid_namespace *ns, struct pid *pid,
 		struct task_struct *task);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

lib-test-kstrtoxc-use-array_size-instead-of-sizeof-sizeof.patch
proc-add-and-remove-proc-entry-create-checks.patch
proc-faster-proc-pid-lookup.patch
proc-make-proc_subdir_lock-static.patch
proc-remove-proc_tty_ldisc-variable.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
proc-more-const-char-pointers.patch
proc-convert-proc-pid-auxv-to-seq_file-interface.patch
proc-convert-proc-pid-limits-to-seq_file-interface.patch
proc-convert-proc-pid-syscall-to-seq_file-interface.patch
proc-fix-page_size-limit-of-proc-pid-cmdline.patch
proc-convert-proc-pid-wchan-to-seq_file-interface.patch
proc-convert-proc-pid-schedstat-to-seq_file-interface.patch
proc-convert-proc-pid-oom_score-to-seq_file-interface.patch
proc-convert-proc-pid-io-to-seq_file-interface.patch
proc-convert-proc-pid-hardwall-to-seq_file-interface.patch
proc-remove-inf-macro.patch

