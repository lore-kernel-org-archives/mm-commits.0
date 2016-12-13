From: akpm@linux-foundation.org
Subject: [patch 093/123] proc: just list_del() struct pde_opener
Date: Mon, 12 Dec 2016 16:45:14 -0800
Message-ID: <584f449a.wM0dNNtfeJWAIkZq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932499AbcLMApP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:45:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: just list_del() struct pde_opener

list_del_init() is too much, structure will be freed in three lines anyway.

Link: http://lkml.kernel.org/r/20161029155313.GA1246@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/inode.c~proc-just-list_del-struct-pde_opener fs/proc/inode.c
--- a/fs/proc/inode.c~proc-just-list_del-struct-pde_opener
+++ a/fs/proc/inode.c
@@ -152,7 +152,7 @@ static void close_pdeo(struct proc_dir_e
 		file = pdeo->file;
 		pde->proc_fops->release(file_inode(file), file);
 		spin_lock(&pde->pde_unload_lock);
-		list_del_init(&pdeo->lh);
+		list_del(&pdeo->lh);
 		if (pdeo->c)
 			complete(pdeo->c);
 		kfree(pdeo);
_
