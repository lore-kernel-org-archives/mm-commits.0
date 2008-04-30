From: akpm@linux-foundation.org
Subject: - mm-bdi-export-bdi-attributes-in-sysfs-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:18:54 -0700
Message-ID: <200804300618.m3U6IsDT031410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126AbYD3GS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:18:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mm: bdi: fix read_ahead_kb_store()
has been removed from the -mm tree.  Its filename was
     mm-bdi-export-bdi-attributes-in-sysfs-fix.patch

This patch was dropped because it was folded into mm-bdi-export-bdi-attributes-in-sysfs.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: bdi: fix read_ahead_kb_store()
From: Miklos Szeredi <mszeredi@suse.cz>

This managed to completely evade testing :(

Fix return value to be count or -errno.  Also bring the function in
line with the other store functions on this object, which have more
strict input checking.

Also fix bdi_set_max_ratio() to actually return an error, instead of
always zero.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |   11 ++++++++---
 page-writeback.c |    0 
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/backing-dev.c~mm-bdi-export-bdi-attributes-in-sysfs-fix mm/backing-dev.c
--- a/mm/backing-dev.c~mm-bdi-export-bdi-attributes-in-sysfs-fix
+++ a/mm/backing-dev.c
@@ -16,10 +16,15 @@ static ssize_t read_ahead_kb_store(struc
 {
 	struct backing_dev_info *bdi = dev_get_drvdata(dev);
 	char *end;
+	unsigned long read_ahead_kb;
+	ssize_t ret = -EINVAL;
 
-	bdi->ra_pages = simple_strtoul(buf, &end, 10) >> (PAGE_SHIFT - 10);
-
-	return end - buf;
+	read_ahead_kb = simple_strtoul(buf, &end, 10);
+	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
+		bdi->ra_pages = read_ahead_kb >> (PAGE_SHIFT - 10);
+		ret = count;
+	}
+	return ret;
 }
 
 #define K(pages) ((pages) << (PAGE_SHIFT - 10))
diff -puN mm/page-writeback.c~mm-bdi-export-bdi-attributes-in-sysfs-fix mm/page-writeback.c
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

