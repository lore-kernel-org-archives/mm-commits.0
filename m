From: akpm@linux-foundation.org
Subject: - ecryptfs-add-missing-lock-around-notify_change.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:50 -0700
Message-ID: <200804300541.m3U5foSp029087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760496AbYD3GMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: add missing lock around notify_change
has been removed from the -mm tree.  Its filename was
     ecryptfs-add-missing-lock-around-notify_change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: add missing lock around notify_change
From: Miklos Szeredi <mszeredi@suse.cz>

Callers of notify_change() need to hold i_mutex.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ecryptfs/inode.c~ecryptfs-add-missing-lock-around-notify_change fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-add-missing-lock-around-notify_change
+++ a/fs/ecryptfs/inode.c
@@ -908,7 +908,9 @@ static int ecryptfs_setattr(struct dentr
 	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
 		ia->ia_valid &= ~ATTR_MODE;
 
+	mutex_lock(&lower_dentry->d_inode->i_mutex);
 	rc = notify_change(lower_dentry, ia);
+	mutex_unlock(&lower_dentry->d_inode->i_mutex);
 out:
 	fsstack_copy_attr_all(inode, lower_inode, NULL);
 	return rc;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-bdi-export-bdi_writeout_inc-fix.patch
mm-add-nr_writeback_temp-counter.patch
mm-add-nr_writeback_temp-counter-fix.patch
mm-document-missing-fields-for-proc-meminfo.patch
fuse-support-writable-mmap.patch
fuse-support-writable-mmap-fix.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch
fuse-update-file-size-on-short-read-fix.patch
fuse-fix-max-i-o-size-calculation.patch
fuse-fix-node-id-type.patch
fuse-fix-race-in-llseek.patch
fuse-fix-race-in-llseek-fix.patch
fuse-fix-sparse-warnings.patch

