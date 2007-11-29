From: akpm@linux-foundation.org
Subject: + vfs-use-mutex_lock_killable-in-vfs_readdir.patch added to -mm tree
Date: Thu, 29 Nov 2007 14:07:07 -0800
Message-ID: <200711292207.lATM77Y0009588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934085AbXK2WIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 17:08:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: howlett@gmail.com, a.p.zijlstra@chello.nl, bfields@fieldses.org, hch@lst.de, mingo@elte.hu, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk, willy@linux.intel.com


The patch titled
     vfs: use mutex_lock_killable() in vfs_readdir()
has been added to the -mm tree.  Its filename is
     vfs-use-mutex_lock_killable-in-vfs_readdir.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
