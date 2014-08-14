From: akpm@linux-foundation.org
Subject: +
 fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch added
 to -mm tree
Date: Thu, 14 Aug 2014 14:53:39 -0700
Message-ID: <53ed2fe3.eBLJZKfvn6/NMkAQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:64765 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbaHNVxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:53:40 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so490749pab.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:53:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_nommu.c: change maps_open() to use __seq_open_private()
has been added to the -mm tree.  Its filename is
     fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/proc/task_nommu.c: change maps_open() to use __seq_open_private()

Cleanup and preparation. maps_open() can use __seq_open_private()
like proc_maps_open() does.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff -puN fs/proc/task_nommu.c~fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private
+++ a/fs/proc/task_nommu.c
@@ -268,21 +268,13 @@ static const struct seq_operations proc_
 static int maps_open(struct inode *inode, struct file *file,
 		     const struct seq_operations *ops)
 {
-	struct proc_maps_private *priv;
-	int ret = -ENOMEM;
+	struct proc_maps_private *priv = __seq_open_private(file, ops,
+					 sizeof(struct proc_maps_private));
+	if (!priv)
+		return -ENOMEM;
 
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
+	priv->pid = proc_pid(inode);
+	return 0;
 }
 
 static int pid_maps_open(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
earlyprintk-re-enable-earlyprintk-calling-early_param.patch
fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch
fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch
proc-introduce-proc_mem_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch
fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch
fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch
fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch
fs-proc-task_mmuc-introduce-m_next_vma-helper.patch
fs-proc-task_mmuc-reintroduce-m-version-logic.patch
fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_nommuc-dont-use-priv-task-mm.patch
linux-next.patch

