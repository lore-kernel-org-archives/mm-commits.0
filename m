From: akpm@linux-foundation.org
Subject: [merged] autofs-use-is_root-to-replace-root-dentry-checks.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:02:22 -0800
Message-ID: <52e2b8be.CRrDZJs3YGn3x0V9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaAXTCW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, raven@themaw.net, rui.xiang@huawei.com

Subject: [merged] autofs-use-is_root-to-replace-root-dentry-checks.patch removed from -mm tree
To: rui.xiang@huawei.com,raven@themaw.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:22 -0800


The patch titled
     Subject: autofs: use IS_ROOT to replace root dentry checks
has been removed from the -mm tree.  Its filename was
     autofs-use-is_root-to-replace-root-dentry-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rui Xiang <rui.xiang@huawei.com>
Subject: autofs: use IS_ROOT to replace root dentry checks

Use the helper macro !IS_ROOT to replace parent != dentry->d_parent.  Just
clean up.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/autofs4/root.c~autofs-use-is_root-to-replace-root-dentry-checks fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-use-is_root-to-replace-root-dentry-checks
+++ a/fs/autofs4/root.c
@@ -558,7 +558,7 @@ static int autofs4_dir_symlink(struct in
 	dget(dentry);
 	atomic_inc(&ino->count);
 	p_ino = autofs4_dentry_ino(dentry->d_parent);
-	if (p_ino && dentry->d_parent != dentry)
+	if (p_ino && !IS_ROOT(dentry))
 		atomic_inc(&p_ino->count);
 
 	dir->i_mtime = CURRENT_TIME;
@@ -593,7 +593,7 @@ static int autofs4_dir_unlink(struct ino
 
 	if (atomic_dec_and_test(&ino->count)) {
 		p_ino = autofs4_dentry_ino(dentry->d_parent);
-		if (p_ino && dentry->d_parent != dentry)
+		if (p_ino && !IS_ROOT(dentry))
 			atomic_dec(&p_ino->count);
 	}
 	dput(ino->dentry);
@@ -732,7 +732,7 @@ static int autofs4_dir_mkdir(struct inod
 	dget(dentry);
 	atomic_inc(&ino->count);
 	p_ino = autofs4_dentry_ino(dentry->d_parent);
-	if (p_ino && dentry->d_parent != dentry)
+	if (p_ino && !IS_ROOT(dentry))
 		atomic_inc(&p_ino->count);
 	inc_nlink(dir);
 	dir->i_mtime = CURRENT_TIME;
_

Patches currently in -mm which might be from rui.xiang@huawei.com are

origin.patch

