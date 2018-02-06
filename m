From: akpm@linux-foundation.org
Subject: [patch 023/114] fs/proc/internal.h: fix up comment
Date: Tue, 06 Feb 2018 15:37:21 -0800
Message-ID: <20180206233721.sh_DCDJ0x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54426 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbeBFXhW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:37:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
