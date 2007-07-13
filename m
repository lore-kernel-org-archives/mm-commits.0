From: akpm@linux-foundation.org
Subject: + coda-coda-doesnt-track-atime.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:29:33 -0700
Message-ID: <200707130529.l6D5TX00030796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36596 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203AbXGMFaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaharkes@cs.cmu.edu


The patch titled
     coda: coda doesn't track atime
has been added to the -mm tree.  Its filename is
     coda-coda-doesnt-track-atime.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coda: coda doesn't track atime
From: Jan Harkes <jaharkes@cs.cmu.edu>

Set MS_NOATIME flag to avoid unnecessary calls when the coda inode is
accessed.

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

coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error.patch
coda-correctly-invalidate-cached-access-rights.patch
coda-fix-nlink-updates-for-directories.patch
coda-allow-removal-of-busy-directories.patch
coda-coda-doesnt-track-atime.patch
coda-use-ilookup5.patch
coda-cleanup-dev-cfs-open-and-close-handling.patch
coda-cleanup-for-upcall-handling-path.patch
coda-block-signals-during-upcall-processing.patch
coda-avoid-lockdep-warning-in-coda_readdir.patch
coda-replace-upc_alloc-upc_free-with-kmalloc-kfree.patch
coda-ignore-returned-values-when-upcalls-return-errors.patch
coda-cleanup-coda_lookup-use-dsplice_alias.patch
coda-cleanup-downcall-handler.patch
coda-remove-struct-coda_sb_info.patch
coda-remove-statistics-counters-from-proc-fs-coda.patch
coda-update-module-information.patch
