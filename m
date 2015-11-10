From: akpm@linux-foundation.org
Subject: [merged] fs-jfs-remove-unnecessary-new_valid_dev-check.patch
 removed from -mm tree
Date: Tue, 10 Nov 2015 12:33:34 -0800
Message-ID: <5642549e.PJ1BPcpzpYr525X8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbbKJUde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, dave.kleikamp@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/jfs: remove unnecessary new_valid_dev() checks
has been removed from the -mm tree.  Its filename was
     fs-jfs-remove-unnecessary-new_valid_dev-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: fs/jfs: remove unnecessary new_valid_dev() checks

new_valid_dev() always returns 1, so the !new_valid_dev() checks are not
needed.  Remove them.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/namei.c |    3 ---
 fs/jfs/super.c |    3 ---
 2 files changed, 6 deletions(-)

diff -puN fs/jfs/namei.c~fs-jfs-remove-unnecessary-new_valid_dev-check fs/jfs/namei.c
--- a/fs/jfs/namei.c~fs-jfs-remove-unnecessary-new_valid_dev-check
+++ a/fs/jfs/namei.c
@@ -1372,9 +1372,6 @@ static int jfs_mknod(struct inode *dir,
 	tid_t tid;
 	struct tblock *tblk;
 
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
-
 	jfs_info("jfs_mknod: %pd", dentry);
 
 	rc = dquot_initialize(dir);
diff -puN fs/jfs/super.c~fs-jfs-remove-unnecessary-new_valid_dev-check fs/jfs/super.c
--- a/fs/jfs/super.c~fs-jfs-remove-unnecessary-new_valid_dev-check
+++ a/fs/jfs/super.c
@@ -496,9 +496,6 @@ static int jfs_fill_super(struct super_b
 
 	jfs_info("In jfs_read_super: s_flags=0x%lx", sb->s_flags);
 
-	if (!new_valid_dev(sb->s_bdev->bd_dev))
-		return -EOVERFLOW;
