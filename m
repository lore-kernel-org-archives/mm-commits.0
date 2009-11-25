From: akpm@linux-foundation.org
Subject: + ext2-report-metadata-errors-during-fsync.patch added to -mm tree
Date: Wed, 25 Nov 2009 13:49:49 -0800
Message-ID: <200911252149.nAPLnnaD012492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933357AbZKYVuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 16:50:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, chris.mason@oracle.com


The patch titled
     ext2: report metadata errors during fsync
has been added to the -mm tree.  Its filename is
     ext2-report-metadata-errors-during-fsync.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: report metadata errors during fsync
From: Jan Kara <jack@suse.cz>
Return-Path: <jack@suse.cz>
X-Spam-Checker-Version: SpamAssassin 3.2.4 (2008-01-01) on y.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=AWL autolearn=unavailable
	version=3.2.4
Received: from y.localdomain (y.localdomain [127.0.0.1])
	by y.localdomain (8.14.2/8.14.2) with ESMTP id nAPAQDTw001247
	for <akpm@localhost>; Wed, 25 Nov 2009 02:26:15 -0800
Received: from imap1.linux-foundation.org [140.211.169.55]
	by y.localdomain with POP3 (fetchmail-6.3.8)
	for <akpm@localhost> (single-drop); Wed, 25 Nov 2009 02:26:15 -0800 (PST)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id nAPAPeKu007504
	for <akpm@imap1.linux-foundation.org>; Wed, 25 Nov 2009 02:25:40 -0800
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id nAPAPVc9010518
	for <akpm@linux-foundation.org>; Wed, 25 Nov 2009 02:25:32 -0800
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 8F02A8655F;
	Wed, 25 Nov 2009 11:25:29 +0100 (CET)
Received: by duck.suse.cz (Postfix, from userid 10005)
	id 1DC982515FE; Wed, 25 Nov 2009 11:25:28 +0100 (CET)
To: linux-ext4@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu,
        chris.mason@oracle.com, Jan Kara <jack@suse.cz>
Subject: [PATCH] ext2: Report metadata errors during fsync
Date: Wed, 25 Nov 2009 11:24:53 +0100
Message-Id: <1259144693-6732-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
Received-SPF: none (domain of jack@suse.cz does not designate permitted sender hosts)
X-MIMEDefang-Filter: lf$Revision: 1.188 $
X-Scanned-By: MIMEDefang 2.63 on 140.211.169.13

When an IO error happens while writing metadata buffers, we should better
report it and call ext2_error since the filesystem is probably no longer
consistent. Sometimes such IO errors happen while flushing thread does
background writeback, the buffer gets later evicted from memory, and thus
the only trace of the error remains as AS_EIO bit set in blockdevice's
mapping. So we check this bit in ext2_fsync and report the error although
we cannot be really sure which buffer we failed to write.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/dir.c  |    2 +-
 fs/ext2/ext2.h |    1 +
 fs/ext2/file.c |   21 +++++++++++++++++++--
 3 files changed, 21 insertions(+), 3 deletions(-)

  Guys, what do you think about the patch below? We carried something similar
in SUSE kernels for quite some time (the original patch was by Chris Mason) -
I've just now got to porting it to current kernel. If nobody objects, I'd
merge the patch...

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 6cde970..545eb42 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -721,5 +721,5 @@ const struct file_operations ext2_dir_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
-	.fsync		= simple_fsync,
+	.fsync		= ext2_fsync,
 };
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 9a8a8e2..aff22e0 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -155,6 +155,7 @@ extern void ext2_write_super (struct super_block *);
 extern const struct file_operations ext2_dir_operations;
 
 /* file.c */
+extern int ext2_fsync(struct file *file, struct dentry *dentry, int datasync);
 extern const struct inode_operations ext2_file_inode_operations;
 extern const struct file_operations ext2_file_operations;
 extern const struct file_operations ext2_xip_file_operations;
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index a2f3afd..586e358 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/time.h>
+#include <linux/pagemap.h>
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
@@ -38,6 +39,22 @@ static int ext2_release_file (struct inode * inode, struct file * filp)
 	return 0;
 }
 
+int ext2_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	int ret;
+	struct super_block *sb = dentry->d_inode->i_sb;
+	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
+
+	ret = simple_fsync(file, dentry, datasync);
+	if (ret == -EIO || test_and_clear_bit(AS_EIO, &mapping->flags)) {
+		/* We don't really know where the IO error happened... */
+		ext2_error(sb, __func__,
+			   "detected IO error when writing metadata buffers");
+		ret = -EIO;
+	}
+	return ret;
+}
+
 /*
  * We have mostly NULL's here: the current defaults are ok for
  * the ext2 filesystem.
@@ -55,7 +72,7 @@ const struct file_operations ext2_file_operations = {
 	.mmap		= generic_file_mmap,
 	.open		= generic_file_open,
 	.release	= ext2_release_file,
-	.fsync		= simple_fsync,
+	.fsync		= ext2_fsync,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
 };
@@ -72,7 +89,7 @@ const struct file_operations ext2_xip_file_operations = {
 	.mmap		= xip_file_mmap,
 	.open		= generic_file_open,
 	.release	= ext2_release_file,
-	.fsync		= simple_fsync,
+	.fsync		= ext2_fsync,
 };
 #endif
 
-- 
1.6.4.2

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
ext2-report-metadata-errors-during-fsync.patch
reiserfs-truncate-blocks-not-used-by-a-write-v2.patch
reiser4-update-names-of-quota-methods.patch

