From: akpm@linux-foundation.org
Subject: - mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:20:02 -0700
Message-ID: <200804300620.m3U6K2DU031467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758474AbYD3GUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:20:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mm: bdi: use MAJOR:MINOR in /sys/class/bdi
has been removed from the -mm tree.  Its filename was
     mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch

This patch was dropped because it was folded into mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: bdi: use MAJOR:MINOR in /sys/class/bdi
From: Miklos Szeredi <mszeredi@suse.cz>

Uniformly use MAJOR:MINOR in /sys/class/bdi/ for both block devices
and non-block device backed filesystems: FUSE and NFS.

Add symlink for block devices:

    /sys/block/<name>/bdi -> /sys/class/bdi/<bdi>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/nfs/super.c~mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix fs/nfs/super.c
--- a/fs/nfs/super.c~mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix
+++ a/fs/nfs/super.c
@@ -1572,8 +1572,7 @@ static int nfs_compare_super(struct supe
 
 static int nfs_bdi_register(struct nfs_server *server)
 {
-	return bdi_register(&server->backing_dev_info, NULL, "nfs-%u:%u",
-			    MAJOR(server->s_dev), MINOR(server->s_dev));
+	return bdi_register_dev(&server->backing_dev_info, server->s_dev);
 }
 
 static int nfs_get_sb(struct file_system_type *fs_type,
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
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

