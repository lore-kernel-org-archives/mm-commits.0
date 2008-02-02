From: akpm@linux-foundation.org
Subject: + mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch added to -mm tree
Date: Sat, 02 Feb 2008 15:38:41 -0800
Message-ID: <200802022338.m12NcMwI021733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59142 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764191AbYBBXi0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 2 Feb 2008 18:38:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     mm: bdi: use MAJOR:MINOR in /sys/class/bdi
has been added to the -mm tree.  Its filename is
     mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
sys_remap_file_pages-fix-vm_file-accounting.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
mount-options-add-documentation.patch
mount-options-add-generic_show_options.patch
mount-options-fix-adfs.patch
mount-options-fix-affs.patch
mount-options-fix-afs.patch
mount-options-fix-autofs4.patch
mount-options-fix-autofs.patch
mount-options-fix-befs.patch
mount-options-fix-capifs.patch
mount-options-fix-devpts.patch
mount-options-fix-ext2.patch
mount-options-fix-fat.patch
mount-options-fix-fuse.patch
mount-options-fix-hostfs.patch
mount-options-fix-hpfs.patch
mount-options-fix-hugetlbfs.patch
mount-options-fix-isofs.patch
mount-options-fix-ncpfs.patch
mount-options-fix-reiserfs.patch
mount-options-fix-spufs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
mount-options-fix-udf.patch
vfs-create-proc-pid-mountinfo.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
