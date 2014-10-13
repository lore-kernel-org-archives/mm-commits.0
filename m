From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:18 -0700
Message-ID: <543c176a.LuMZVX1X2LpGP2Vh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSSS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gerg@uclinux.org, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_nommu.c: change maps_open() to use __seq_open_private()
has been removed from the -mm tree.  Its filename was
     fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/proc/task_nommu.c: change maps_open() to use __seq_open_private()

Cleanup and preparation. maps_open() can use __seq_open_private()
like proc_maps_open() does.

[akpm@linux-foundation.org: deuglify]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff -puN fs/proc/task_nommu.c~fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private
+++ a/fs/proc/task_nommu.c
@@ -269,20 +269,13 @@ static int maps_open(struct inode *inode
 		     const struct seq_operations *ops)
 {
 	struct proc_maps_private *priv;
-	int ret = -ENOMEM;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv) {
-		priv->pid = proc_pid(inode);
-		ret = seq_open(file, ops);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			m->private = priv;
-		} else {
-			kfree(priv);
-		}
-	}
-	return ret;
+	priv = __seq_open_private(file, ops, sizeof(struct proc_maps_private));
+	if (!priv)
+		return -ENOMEM;
+
+	priv->pid = proc_pid(inode);
+	return 0;
 }
 
 static int pid_maps_open(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

