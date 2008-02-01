From: akpm@linux-foundation.org
Subject: - vfs-use-mutex_lock_killable-in-vfs_readdir.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:25 -0800
Message-ID: <200802012230.m11MUPRu001909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757030AbYBAWtq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:49:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: howlett@gmail.com, a.p.zijlstra@chello.nl, bfields@fieldses.org, hch@lst.de, mingo@elte.hu, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger


The patch titled
     vfs: use mutex_lock_killable() in vfs_readdir()
has been removed from the -mm tree.  Its filename was
     vfs-use-mutex_lock_killable-in-vfs_readdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: use mutex_lock_killable() in vfs_readdir()
From: "Liam R. Howlett" <howlett@gmail.com>

Signed-off-by: Liam R. Howlett <howlett@gmail.com>
Acked-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/readdir.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/readdir.c~vfs-use-mutex_lock_killable-in-vfs_readdir fs/readdir.c
--- a/fs/readdir.c~vfs-use-mutex_lock_killable-in-vfs_readdir
+++ a/fs/readdir.c
@@ -30,7 +30,10 @@ int vfs_readdir(struct file *file, filld
 	if (res)
 		goto out;
 
-	mutex_lock(&inode->i_mutex);
+	res = -EINTR;
+	if (mutex_lock_killable(&inode->i_mutex))
+		goto out;
+
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
 		res = file->f_op->readdir(file, buf, filler);
_

Patches currently in -mm which might be from howlett@gmail.com are

origin.patch
