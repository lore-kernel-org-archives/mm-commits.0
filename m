From: akpm@linux-foundation.org
Subject: - coda-coda-doesnt-track-atime.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:03 -0700
Message-ID: <200707192003.l6JK33VT019823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49938 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759894AbXGSUQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     coda: coda doesn't track atime
has been removed from the -mm tree.  Its filename was
     coda-coda-doesnt-track-atime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: coda: coda doesn't track atime
From: Jan Harkes <jaharkes@cs.cmu.edu>

Set MS_NOATIME flag to avoid unnecessary calls when the coda inode is
accessed.

Also, set statfs.f_bsize to 4k.  1k is obviously too small for the suggested
IO size.

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/inode.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/coda/inode.c~coda-coda-doesnt-track-atime fs/coda/inode.c
--- a/fs/coda/inode.c~coda-coda-doesnt-track-atime
+++ a/fs/coda/inode.c
@@ -83,7 +83,7 @@ void coda_destroy_inodecache(void)
 
 static int coda_remount(struct super_block *sb, int *flags, char *data)
 {
-	*flags |= MS_NODIRATIME;
+	*flags |= MS_NOATIME;
 	return 0;
 }
 
@@ -176,12 +176,12 @@ static int coda_fill_super(struct super_
 
 	sbi->sbi_vcomm = vc;
 
-        sb->s_fs_info = sbi;
-	sb->s_flags |= MS_NODIRATIME; /* probably even noatime */
-        sb->s_blocksize = 1024;	/* XXXXX  what do we put here?? */
-        sb->s_blocksize_bits = 10;
-        sb->s_magic = CODA_SUPER_MAGIC;
-        sb->s_op = &coda_super_operations;
+	sb->s_fs_info = sbi;
+	sb->s_flags |= MS_NOATIME;
+	sb->s_blocksize = 4096;	/* XXXXX  what do we put here?? */
+	sb->s_blocksize_bits = 12;
+	sb->s_magic = CODA_SUPER_MAGIC;
+	sb->s_op = &coda_super_operations;
 
 	/* get root fid from Venus: this needs the root inode */
 	error = venus_rootfid(sb, &fid);
@@ -296,7 +296,7 @@ static int coda_statfs(struct dentry *de
 
 	/* and fill in the rest */
 	buf->f_type = CODA_SUPER_MAGIC;
-	buf->f_bsize = 1024;
+	buf->f_bsize = 4096;
 	buf->f_namelen = CODA_MAXNAMLEN;
 
 	return 0; 
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

origin.patch
