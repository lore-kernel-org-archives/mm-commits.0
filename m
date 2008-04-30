From: akpm@linux-foundation.org
Subject: - mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:19:01 -0700
Message-ID: <200804300619.m3U6J1cC031419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757717AbYD3GTF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:19:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mm: bdi: use MAJOR:MINOR in /sys/class/bdi
has been removed from the -mm tree.  Its filename was
     mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch

This patch was dropped because it was folded into mm-bdi-export-bdi-attributes-in-sysfs.patch

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

 include/linux/backing-dev.h |    1 +
 mm/backing-dev.c            |    6 ++++++
 2 files changed, 7 insertions(+)

diff -puN include/linux/backing-dev.h~mm-bdi-export-bdi-attributes-in-sysfs-fix-4 include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-bdi-export-bdi-attributes-in-sysfs-fix-4
+++ a/include/linux/backing-dev.h
@@ -59,6 +59,7 @@ void bdi_destroy(struct backing_dev_info
 
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...);
+int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
 
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
diff -puN mm/backing-dev.c~mm-bdi-export-bdi-attributes-in-sysfs-fix-4 mm/backing-dev.c
--- a/mm/backing-dev.c~mm-bdi-export-bdi-attributes-in-sysfs-fix-4
+++ a/mm/backing-dev.c
@@ -105,6 +105,12 @@ exit:
 }
 EXPORT_SYMBOL(bdi_register);
 
+int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev)
+{
+	return bdi_register(bdi, NULL, "%u:%u", MAJOR(dev), MINOR(dev));
+}
+EXPORT_SYMBOL(bdi_register_dev);
+
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
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

