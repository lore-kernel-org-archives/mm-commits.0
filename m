From: akpm@linux-foundation.org
Subject: [merged] jffs2-unlock-f-sem-on-error-in-jffs2_new_inode.patch
 removed from -mm tree
Date: Thu, 27 Feb 2014 12:24:04 -0800
Message-ID: <530f9ee4.08WZ5mZOkEwWqyXS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaB0UYF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 15:24:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wangnan0@huawei.com, stable@vger.kernel.org, dwmw2@infradead.org, computersforpeace@gmail.com, artem.bityutskiy@linux.intel.com, andy.wangguoli@huawei.com

Subject: [merged] jffs2-unlock-f-sem-on-error-in-jffs2_new_inode.patch removed from -mm tree
To: andy.wangguoli@huawei.com,artem.bityutskiy@linux.intel.com,computersforpeace@gmail.com,dwmw2@infradead.org,stable@vger.kernel.org,wangnan0@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 12:24:04 -0800


The patch titled
     Subject: jffs2: unlock f->sem on error in jffs2_new_inode()
has been removed from the -mm tree.  Its filename was
     jffs2-unlock-f-sem-on-error-in-jffs2_new_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Guoli <andy.wangguoli@huawei.com>
Subject: jffs2: unlock f->sem on error in jffs2_new_inode()

If jffs2_new_inode() succeeds, it returns with f->sem held, and the caller
is responsible for releasing the lock.  If it fails, it still returns with
the lock held, but the caller won't release the lock, which will lead to
deadlock.

Fix it by releasing the lock in jffs2_new_inode() on error.

Signed-off-by: Wang Guoli <andy.wangguoli@huawei.com>
Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Wang Guoli <andy.wangguoli@huawei.com>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: <stable@vger.kernel.org> # 2.6.34+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/fs.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/jffs2/fs.c~jffs2-unlock-f-sem-on-error-in-jffs2_new_inode fs/jffs2/fs.c
--- a/fs/jffs2/fs.c~jffs2-unlock-f-sem-on-error-in-jffs2_new_inode
+++ a/fs/jffs2/fs.c
@@ -457,12 +457,14 @@ struct inode *jffs2_new_inode (struct in
 	   The umask is only applied if there's no default ACL */
 	ret = jffs2_init_acl_pre(dir_i, inode, &mode);
 	if (ret) {
-	    make_bad_inode(inode);
-	    iput(inode);
-	    return ERR_PTR(ret);
+		mutex_unlock(&f->sem);
+		make_bad_inode(inode);
+		iput(inode);
+		return ERR_PTR(ret);
 	}
 	ret = jffs2_do_new_inode (c, f, mode, ri);
 	if (ret) {
+		mutex_unlock(&f->sem);
 		make_bad_inode(inode);
 		iput(inode);
 		return ERR_PTR(ret);
@@ -479,6 +481,7 @@ struct inode *jffs2_new_inode (struct in
 	inode->i_size = 0;
 
 	if (insert_inode_locked(inode) < 0) {
+		mutex_unlock(&f->sem);
 		make_bad_inode(inode);
 		iput(inode);
 		return ERR_PTR(-EINVAL);
_

Patches currently in -mm which might be from andy.wangguoli@huawei.com are

linux-next.patch

