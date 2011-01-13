From: akpm@linux-foundation.org
Subject: [merged] proc-use-single_open-correctly.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:37 -0800
Message-ID: <201101132011.p0DKBItm030162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933611Ab1AMUXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:23:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bookjovi@gmail.com, adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     proc: use single_open() correctly
has been removed from the -mm tree.  Its filename was
     proc-use-single_open-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: use single_open() correctly
From: Jovi Zhang <bookjovi@gmail.com>

single_open()'s third argument is for copying into seq_file->private.  Use
that, rather than open-coding it.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   29 +++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

diff -puN fs/proc/base.c~proc-use-single_open-correctly fs/proc/base.c
--- a/fs/proc/base.c~proc-use-single_open-correctly
+++ a/fs/proc/base.c
@@ -745,14 +745,7 @@ static int proc_single_show(struct seq_f
 
 static int proc_single_open(struct inode *inode, struct file *filp)
 {
-	int ret;
-	ret = single_open(filp, proc_single_show, NULL);
-	if (!ret) {
-		struct seq_file *m = filp->private_data;
-
-		m->private = inode;
-	}
-	return ret;
+	return single_open(filp, proc_single_show, inode);
 }
 
 static const struct file_operations proc_single_file_operations = {
@@ -1380,15 +1373,7 @@ sched_write(struct file *file, const cha
 
 static int sched_open(struct inode *inode, struct file *filp)
 {
-	int ret;
-
-	ret = single_open(filp, sched_show, NULL);
-	if (!ret) {
-		struct seq_file *m = filp->private_data;
-
-		m->private = inode;
-	}
-	return ret;
+	return single_open(filp, sched_show, inode);
 }
 
 static const struct file_operations proc_pid_sched_operations = {
@@ -1524,15 +1509,7 @@ static int comm_show(struct seq_file *m,
 
 static int comm_open(struct inode *inode, struct file *filp)
 {
-	int ret;
-
-	ret = single_open(filp, comm_show, NULL);
-	if (!ret) {
-		struct seq_file *m = filp->private_data;
