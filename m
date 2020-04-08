From: akpm@linux-foundation.org
Subject: [merged] proc-annotate-close_pdeo-for-sparse.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 19:00:09 -0700
Message-ID: <20200408020009.sByQYmuRF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgDHCAJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, jbi.octave@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/inode.c: annotate close_pdeo() for sparse
has been removed from the -mm tree.  Its filename was
     proc-annotate-close_pdeo-for-sparse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: fs/proc/inode.c: annotate close_pdeo() for sparse

Fix sparse locking imbalance warning:

	warning: context imbalance in close_pdeo() - unexpected unlock

Link: http://lkml.kernel.org/r/20200227201538.GA30462@avx2
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/inode.c~proc-annotate-close_pdeo-for-sparse
+++ a/fs/proc/inode.c
@@ -202,6 +202,7 @@ static void unuse_pde(struct proc_dir_en
 
 /* pde is locked on entry, unlocked on exit */
 static void close_pdeo(struct proc_dir_entry *pde, struct pde_opener *pdeo)
+	__releases(&pde->pde_unload_lock)
 {
 	/*
 	 * close() (proc_reg_release()) can't delete an entry and proceed:
_

Patches currently in -mm which might be from jbi.octave@gmail.com are
