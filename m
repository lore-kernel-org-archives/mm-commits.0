From: akpm@linux-foundation.org
Subject: [merged] proc-fixup-comment.patch removed from -mm tree
Date: Wed, 07 Feb 2018 11:56:12 -0800
Message-ID: <20180207195612.lvkd-Q_yh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754157AbeBGT4O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:56:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/internal.h: fix up comment
has been removed from the -mm tree.  Its filename was
     proc-fixup-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/proc/internal.h: fix up comment

Document what ->pde_unload_lock actually does.

Link: http://lkml.kernel.org/r/20180103185120.GB31849@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/proc/internal.h~proc-fixup-comment fs/proc/internal.h
--- a/fs/proc/internal.h~proc-fixup-comment
+++ a/fs/proc/internal.h
@@ -38,7 +38,8 @@ struct proc_dir_entry {
 	atomic_t in_use;
 	atomic_t count;		/* use count */
 	struct list_head pde_openers;	/* who did ->open, but not ->release */
-	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
+	/* protects ->pde_openers and all struct pde_opener instances */
+	spinlock_t pde_unload_lock;
 	struct completion *pde_unload_completion;
 	const struct inode_operations *proc_iops;
 	const struct file_operations *proc_fops;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

seq_file-delete-small-value-optimization.patch

