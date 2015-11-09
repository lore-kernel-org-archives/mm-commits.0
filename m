From: akpm@linux-foundation.org
Subject: [merged] fs-ubifs-remove-unnecessary-new_valid_dev-check.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 12:14:01 -0800
Message-ID: <5640fe89.cMo2nPoQzYQrGdKY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbbKIUOC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:14:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, adrian.hunter@intel.com, artem.bityutskiy@linux.intel.com, richard@nod.at, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ubifs/: remove unnecessary new_valid_dev() checks
has been removed from the -mm tree.  Its filename was
     fs-ubifs-remove-unnecessary-new_valid_dev-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: fs/ubifs/: remove unnecessary new_valid_dev() checks

new_valid_dev() always returns 1, so the !new_valid_dev() checks are not
needed.  Remove them.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Acked-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ubifs/dir.c  |    3 ---
 fs/ubifs/misc.h |    9 ++-------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff -puN fs/ubifs/dir.c~fs-ubifs-remove-unnecessary-new_valid_dev-check fs/ubifs/dir.c
--- a/fs/ubifs/dir.c~fs-ubifs-remove-unnecessary-new_valid_dev-check
+++ a/fs/ubifs/dir.c
@@ -787,9 +787,6 @@ static int ubifs_mknod(struct inode *dir
 
 	dbg_gen("dent '%pd' in dir ino %lu", dentry, dir->i_ino);
 
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
-
 	if (S_ISBLK(mode) || S_ISCHR(mode)) {
 		dev = kmalloc(sizeof(union ubifs_dev_desc), GFP_NOFS);
 		if (!dev)
diff -puN fs/ubifs/misc.h~fs-ubifs-remove-unnecessary-new_valid_dev-check fs/ubifs/misc.h
--- a/fs/ubifs/misc.h~fs-ubifs-remove-unnecessary-new_valid_dev-check
+++ a/fs/ubifs/misc.h
@@ -155,13 +155,8 @@ static inline int ubifs_wbuf_sync(struct
  */
 static inline int ubifs_encode_dev(union ubifs_dev_desc *dev, dev_t rdev)
 {
-	if (new_valid_dev(rdev)) {
-		dev->new = cpu_to_le32(new_encode_dev(rdev));
-		return sizeof(dev->new);
-	} else {
-		dev->huge = cpu_to_le64(huge_encode_dev(rdev));
-		return sizeof(dev->huge);
-	}
+	dev->new = cpu_to_le32(new_encode_dev(rdev));
+	return sizeof(dev->new);
 }
 
 /**
_

Patches currently in -mm which might be from bywxiaobai@163.com are

fs-kdev_t-remove-unused-huge_valid_dev-function.patch
fs-kdev_t-old-new_valid_dev-can-be-boolean.patch
fs-vfs-remove-unnecessary-new_valid_dev-check.patch
fs-btrfs-remove-unnecessary-new_valid_dev-check.patch
fs-exofs-remove-unnecessary-new_valid_dev-check.patch
fs-ext2-remove-unnecessary-new_valid_dev-check.patch
fs-f2fs-remove-unnecessary-new_valid_dev-check.patch
fs-hpfs-remove-unnecessary-new_valid_dev-check.patch
fs-jfs-remove-unnecessary-new_valid_dev-check.patch
fs-ncpfs-remove-unnecessary-new_valid_dev-check.patch
fs-nilfs2-remove-unnecessary-new_valid_dev-check.patch
fs-reiserfs-remove-unnecessary-new_valid_dev-check.patch
fs-stat-remove-unnecessary-new_valid_dev-check.patch

