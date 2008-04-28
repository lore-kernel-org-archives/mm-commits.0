From: akpm@linux-foundation.org
Subject: + fuse-fix-race-in-llseek.patch added to -mm tree
Date: Sun, 27 Apr 2008 19:26:35 -0700
Message-ID: <200804280226.m3S2QZ3b003428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764959AbYD1C1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 22:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: fix race in llseek
has been added to the -mm tree.  Its filename is
     fuse-fix-race-in-llseek.patch

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
Subject: fuse: fix race in llseek
From: Miklos Szeredi <mszeredi@suse.cz>

Fuse doesn't use i_mutex to protect setting i_size, and so
generic_file_llseek() can be racy: it doesn't use i_size_read().

So do a fuse specific llseek method, which does use i_size_read().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff -puN fs/fuse/file.c~fuse-fix-race-in-llseek fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-fix-race-in-llseek
+++ a/fs/fuse/file.c
@@ -1431,8 +1431,33 @@ static sector_t fuse_bmap(struct address
 	return err ? 0 : outarg.block;
 }
 
+static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
+{
+	long long retval;
+	struct inode *inode = file->f_path.dentry->d_inode;
+
+	mutex_lock(&inode->i_mutex);
+	switch (origin) {
+	case SEEK_END:
+		offset += i_size_read(inode);
+		break;
+	case SEEK_CUR:
+		offset += file->f_pos;
+	}
+	retval = -EINVAL;
+	if (offset >= 0 && offset <= inode->i_sb->s_maxbytes) {
+		if (offset != file->f_pos) {
+			file->f_pos = offset;
+			file->f_version = 0;
+		}
+		retval = offset;
+	}
+	mutex_unlock(&inode->i_mutex);
+	return retval;
+}
+
 static const struct file_operations fuse_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= fuse_file_llseek,
 	.read		= do_sync_read,
 	.aio_read	= fuse_file_aio_read,
 	.write		= do_sync_write,
@@ -1448,7 +1473,7 @@ static const struct file_operations fuse
 };
 
 static const struct file_operations fuse_direct_io_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= fuse_file_llseek,
 	.read		= fuse_direct_read,
 	.write		= fuse_direct_write,
 	.open		= fuse_open,
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-nfsd.patch
mm-rotate_reclaimable_page-cleanup.patch
vfs-remove-lives_below_in_same_fs.patch
ecryptfs-add-missing-lock-around-notify_change.patch
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

