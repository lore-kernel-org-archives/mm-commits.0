From: akpm@linux-foundation.org
Subject: [merged] ecryptfs-fix-truncation-error-in-ecryptfs_read_update_atime.patch removed from -mm tree
Date: Wed, 10 Nov 2010 12:13:14 -0800
Message-ID: <201011102015.oAAKFbQF003529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755814Ab0KJUPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Nov 2010 15:15:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, kirkland@canonical.com, tyhicks@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: fix truncation error in  ecryptfs_read_update_atime()
has been removed from the -mm tree.  Its filename was
     ecryptfs-fix-truncation-error-in-ecryptfs_read_update_atime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: fix truncation error in  ecryptfs_read_update_atime()
From: Edward Shishkin <edward.shishkin@gmail.com>

This is similar to the bug found in direct-io not so long ago.

Fix up truncation (ssize_t->int).  This only matters with >2G
reads/writes, which the kernel doesn't permit.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/file.c~ecryptfs-fix-truncation-error-in-ecryptfs_read_update_atime fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-fix-truncation-error-in-ecryptfs_read_update_atime
+++ a/fs/ecryptfs/file.c
@@ -47,7 +47,7 @@ static ssize_t ecryptfs_read_update_atim
 				const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos)
 {
-	int rc;
+	ssize_t rc;
 	struct dentry *lower_dentry;
 	struct vfsmount *lower_vfsmount;
 	struct file *file = iocb->ki_filp;
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

linux-next.patch

