From: akpm@linux-foundation.org
Subject: [merged] proc-remove-inf-macro.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:16 -0700
Message-ID: <53ea6da0.gYRh0CnNj/Ra5mxH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:35379 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbaHLTkR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:17 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2673488pde.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: remove INF macro
has been removed from the -mm tree.  Its filename was
     proc-remove-inf-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -604,43 +600,6 @@ static const struct inode_operations pro
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
