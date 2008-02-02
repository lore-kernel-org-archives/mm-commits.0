From: akpm@linux-foundation.org
Subject: + mm-bdi-export-bdi-attributes-in-sysfs-fix.patch added to -mm tree
Date: Sat, 02 Feb 2008 15:25:47 -0800
Message-ID: <200802022325.m12NPSKo021292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44787 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763945AbYBBX0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 2 Feb 2008 18:26:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     mm: bdi: fix read_ahead_kb_store()
has been added to the -mm tree.  Its filename is
     mm-bdi-export-bdi-attributes-in-sysfs-fix.patch

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
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-fix-read_ahead_kb_store-2.patch
mm-bdi-use-majorminor-in-sys-class-bdi.patch
mm-bdi-move-statistics-to-debugfs.patch
