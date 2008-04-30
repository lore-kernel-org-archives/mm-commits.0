From: akpm@linux-foundation.org
Subject: - fuse-support-writable-mmap-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:22:27 -0700
Message-ID: <200804300622.m3U6MRkQ031540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760753AbYD3GXB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:23:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     fuse: support writable mmap fix
has been removed from the -mm tree.  Its filename was
     fuse-support-writable-mmap-fix.patch

This patch was dropped because it was folded into fuse-support-writable-mmap.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: support writable mmap fix
From: Miklos Szeredi <mszeredi@suse.cz>


Set the BDI_CAP_NO_ACCT_WB capability, so that fuse can do it's own
accounting of writeback pages.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c  |    3 ++-
 fs/fuse/inode.c |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/fuse/file.c~fuse-support-writable-mmap-fix fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-support-writable-mmap-fix
+++ a/fs/fuse/file.c
@@ -917,8 +917,9 @@ static int fuse_writepage_locked(struct 
 	req->end = fuse_writepage_end;
 	req->inode = inode;
 
+	inc_bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
 	inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
-	__end_page_writeback(page, false);
+	end_page_writeback(page);
 
 	spin_lock(&fc->lock);
 	list_add(&req->writepages_entry, &fi->writepages);
diff -puN fs/fuse/inode.c~fuse-support-writable-mmap-fix fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-support-writable-mmap-fix
+++ a/fs/fuse/inode.c
@@ -483,6 +483,8 @@ static struct fuse_conn *new_conn(struct
 		atomic_set(&fc->num_waiting, 0);
 		fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
+		/* fuse does it's own writeback accounting */
+		fc->bdi.capabilities = BDI_CAP_NO_ACCT_WB;
 		fc->dev = sb->s_dev;
 		err = bdi_init(&fc->bdi);
 		if (err)
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-add-nr_writeback_temp-counter.patch
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

