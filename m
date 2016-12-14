From: akpm@linux-foundation.org
Subject: [merged] proc-just-list_del-struct-pde_opener.patch removed from
 -mm tree
Date: Wed, 14 Dec 2016 11:26:50 -0800
Message-ID: <58519cfa.f+13ZQO1Jyp+uhhG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752189AbcLNT0v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:26:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: just list_del() struct pde_opener
has been removed from the -mm tree.  Its filename was
     proc-just-list_del-struct-pde_opener.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from adobriyan@gmail.com are

kbuild-simpler-generation-of-assembly-constants.patch
coredump-clarify-unsafe-core_pattern-warning.patch

