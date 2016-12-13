From: akpm@linux-foundation.org
Subject: [patch 094/123] proc: fix type of struct pde_opener::closing
 field
Date: Mon, 12 Dec 2016 16:45:17 -0800
Message-ID: <584f449d.mUT5osMeIw/IK9Oh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41780 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932499AbcLMApS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:45:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: fix type of struct pde_opener::closing field

struct pde_opener::closing is boolean.

Link: http://lkml.kernel.org/r/20161029155439.GB1246@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c    |    2 +-
 fs/proc/internal.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/inode.c~proc-fix-type-of-struct-pde_opener-closing-field fs/proc/inode.c
--- a/fs/proc/inode.c~proc-fix-type-of-struct-pde_opener-closing-field
+++ a/fs/proc/inode.c
@@ -147,7 +147,7 @@ static void close_pdeo(struct proc_dir_e
 		spin_lock(&pde->pde_unload_lock);
 	} else {
 		struct file *file;
-		pdeo->closing = 1;
+		pdeo->closing = true;
 		spin_unlock(&pde->pde_unload_lock);
 		file = pdeo->file;
 		pde->proc_fops->release(file_inode(file), file);
diff -puN fs/proc/internal.h~proc-fix-type-of-struct-pde_opener-closing-field fs/proc/internal.h
--- a/fs/proc/internal.h~proc-fix-type-of-struct-pde_opener-closing-field
+++ a/fs/proc/internal.h
@@ -203,7 +203,7 @@ struct proc_dir_entry *proc_create_mount
 struct pde_opener {
 	struct file *file;
 	struct list_head lh;
-	int closing;
+	bool closing;
 	struct completion *c;
 };
 extern const struct inode_operations proc_link_inode_operations;
_
