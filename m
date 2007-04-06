From: akpm@linux-foundation.org
Subject: + fuse-validate-rootmode-mount-option.patch added to -mm tree
Date: Fri, 06 Apr 2007 15:53:10 -0700
Message-ID: <200704062253.l36MrAce021376@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36615 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933297AbXDFWxg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 18:53:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tsavola@movial.fi, mszeredi@suse.cz


The patch titled
     fuse: validate rootmode mount option
has been added to the -mm tree.  Its filename is
     fuse-validate-rootmode-mount-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: validate rootmode mount option
From: Timo Savola <tsavola@movial.fi>

If rootmode isn't valid, we hit the BUG() in fuse_init_inode.  Now
EINVAL is returned.

Signed-off-by: Timo Savola <tsavola@movial.fi>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c    |    5 +++--
 fs/fuse/fuse_i.h |    5 +++++
 fs/fuse/inode.c  |    2 ++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/fuse/dir.c~fuse-validate-rootmode-mount-option fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-validate-rootmode-mount-option
+++ a/fs/fuse/dir.c
@@ -195,7 +195,7 @@ static struct dentry_operations fuse_den
 	.d_revalidate	= fuse_dentry_revalidate,
 };
 
-static int valid_mode(int m)
+int fuse_valid_type(int m)
 {
 	return S_ISREG(m) || S_ISDIR(m) || S_ISLNK(m) || S_ISCHR(m) ||
 		S_ISBLK(m) || S_ISFIFO(m) || S_ISSOCK(m);
@@ -248,7 +248,8 @@ static struct dentry *fuse_lookup(struct
 	fuse_put_request(fc, req);
 	/* Zero nodeid is same as -ENOENT, but with valid timeout */
 	if (!err && outarg.nodeid &&
-	    (invalid_nodeid(outarg.nodeid) || !valid_mode(outarg.attr.mode)))
+	    (invalid_nodeid(outarg.nodeid) ||
+	     !fuse_valid_type(outarg.attr.mode)))
 		err = -EIO;
 	if (!err && outarg.nodeid) {
 		inode = fuse_iget(dir->i_sb, outarg.nodeid, outarg.generation,
diff -puN fs/fuse/fuse_i.h~fuse-validate-rootmode-mount-option fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-validate-rootmode-mount-option
+++ a/fs/fuse/fuse_i.h
@@ -552,3 +552,8 @@ int fuse_ctl_add_conn(struct fuse_conn *
  * Remove connection from control filesystem
  */
 void fuse_ctl_remove_conn(struct fuse_conn *fc);
+
+/**
+ * Is file type valid?
+ */
+int fuse_valid_type(int m);
diff -puN fs/fuse/inode.c~fuse-validate-rootmode-mount-option fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-validate-rootmode-mount-option
+++ a/fs/fuse/inode.c
@@ -330,6 +330,8 @@ static int parse_fuse_opt(char *opt, str
 		case OPT_ROOTMODE:
 			if (match_octal(&args[0], &value))
 				return 0;
+			if (!fuse_valid_type(value))
+				return 0;
 			d->rootmode = value;
 			d->rootmode_present = 1;
 			break;
_

Patches currently in -mm which might be from tsavola@movial.fi are

fuse-validate-rootmode-mount-option.patch
