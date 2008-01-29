From: akpm@linux-foundation.org
Subject: + mount-options-fix-fuse.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:36 -0800
Message-ID: <200801292322.m0TNMbeH009710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783AbYA2XWm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:22:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     mount options: fix fuse
has been added to the -mm tree.  Its filename is
     mount-options-fix-fuse.patch

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
Subject: mount options: fix fuse
From: Miklos Szeredi <mszeredi@suse.cz>

Add blksize= option to /proc/mounts for fuseblk filesystems.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/fuse/inode.c~mount-options-fix-fuse fs/fuse/inode.c
--- a/fs/fuse/inode.c~mount-options-fix-fuse
+++ a/fs/fuse/inode.c
@@ -29,6 +29,8 @@ DEFINE_MUTEX(fuse_mutex);
 
 #define FUSE_SUPER_MAGIC 0x65735546
 
+#define FUSE_DEFAULT_BLKSIZE 512
+
 struct fuse_mount_data {
 	int fd;
 	unsigned rootmode;
@@ -355,7 +357,7 @@ static int parse_fuse_opt(char *opt, str
 	char *p;
 	memset(d, 0, sizeof(struct fuse_mount_data));
 	d->max_read = ~0;
-	d->blksize = 512;
+	d->blksize = FUSE_DEFAULT_BLKSIZE;
 
 	while ((p = strsep(&opt, ",")) != NULL) {
 		int token;
@@ -440,6 +442,9 @@ static int fuse_show_options(struct seq_
 		seq_puts(m, ",allow_other");
 	if (fc->max_read != ~0)
 		seq_printf(m, ",max_read=%u", fc->max_read);
+	if (mnt->mnt_sb->s_bdev &&
+	    mnt->mnt_sb->s_blocksize != FUSE_DEFAULT_BLKSIZE)
+		seq_printf(m, ",blksize=%lu", mnt->mnt_sb->s_blocksize);
 	return 0;
 }
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-x86.patch
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
mount-options-fix-udf.patch
