From: akpm@linux-foundation.org
Subject: + fs-relax-count-limitation-in-rw_verify_area-permit-2g-read-and-write.patch added to -mm tree
Date: Fri, 10 Dec 2010 15:42:34 -0800
Message-ID: <201012102342.oBANgYrN009690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522Ab0LJXnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Dec 2010 18:43:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com, hch@lst.de, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk


The patch titled
     fs: relax count limitation in rw_verify_area(), permit >2G read() and write()
has been added to the -mm tree.  Its filename is
     fs-relax-count-limitation-in-rw_verify_area-permit-2g-read-and-write.patch

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
Subject: fs: relax count limitation in rw_verify_area(), permit >2G read() and write()
From: Edward Shishkin <edward.shishkin@gmail.com>

Relax synthetic limitation introduced by rw_verify_area().

We limit @count to something that fits in ssize_t instead of int, so that
the kernel now permits single reads and writes of up to 2^63 bytes on
64-bit systems (whereas it was previously limited to 2^31), because:

1. This is more conformable to man pages, where @count
   should be of size_t (but not more than SSIZE_MAX for
   predictable results).

2. Old limitation restricts size of atomic writes that
   can be performed by a local file system: 2G can be
   not enough in the near future.

3. Some applications of our users don't work with the
   old limitation (and it is really hard to fix them).

The following subsystems were tested with this patch applied:

direct-io,
ntfs,
squashfs,
cifs,
ecryptfs,
ext[2,3,4]
hfs,
hfsplus,
reiserfs,
xfs,
jfs,
nfs,
gfs2,
btrfs,
isofs

Everything works fine.  While testing the new relaxed limitation there
were found and fixed truncation bugs in direct-io and ecryptfs.  The
fixups are in upstream already.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c    |   16 ++++++----------
 fs/splice.c        |    4 ++--
 include/linux/fs.h |    4 ++--
 3 files changed, 10 insertions(+), 14 deletions(-)

diff -puN fs/read_write.c~fs-relax-count-limitation-in-rw_verify_area-permit-2g-read-and-write fs/read_write.c
--- a/fs/read_write.c~fs-relax-count-limitation-in-rw_verify_area-permit-2g-read-and-write
+++ a/fs/read_write.c
@@ -236,21 +236,19 @@ bad:
 }
 #endif
 
-
 /*
- * rw_verify_area doesn't like huge counts. We limit
- * them to something that fits in "int" so that others
- * won't have to do range checks all the time.
+ * We limit huge counts to something that fits in "ssize_t"
  */
-int rw_verify_area(int read_write, struct file *file, loff_t *ppos, size_t count)
+ssize_t rw_verify_area(int read_write, struct file *file, loff_t *ppos,
+		       size_t count)
 {
 	struct inode *inode;
 	loff_t pos;
 	int retval = -EINVAL;
 
 	inode = file->f_path.dentry->d_inode;
-	if (unlikely((ssize_t) count < 0))
-		return retval;
+	if (unlikely(count > MAX_RW_COUNT))
+		count = MAX_RW_COUNT;
 	pos = *ppos;
 	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0)) {
 		retval = __negative_fpos_check(file, pos, count);
@@ -267,9 +265,7 @@ int rw_verify_area(int read_write, struc
 	}
 	retval = security_file_permission(file,
 				read_write == READ ? MAY_READ : MAY_WRITE);
-	if (retval)
-		return retval;
-	return count > MAX_RW_COUNT ? MAX_RW_COUNT : count;
+	return retval ? retval : count;
 }
 
 static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
diff -puN fs/splice.c~fs-relax-count-limitation-in-rw_verify_area-permit-2g-read-and-write fs/splice.c
--- a/fs/splice.c~fs-relax-count-limitation-in-rw_verify_area-permit-2g-read-and-write
+++ a/fs/splice.c
@@ -1097,7 +1097,7 @@ static long do_splice_from(struct pipe_i
 {
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *,
 				loff_t *, size_t, unsigned int);
-	int ret;
+	ssize_t ret;
 
 	if (unlikely(!(out->f_mode & FMODE_WRITE)))
 		return -EBADF;
@@ -1126,7 +1126,7 @@ static long do_splice_to(struct file *in
 {
 	ssize_t (*splice_read)(struct file *, loff_t *,
 			       struct pipe_inode_info *, size_t, unsigned int);
-	int ret;
+	ssize_t ret;
 
 	if (unlikely(!(in->f_mode & FMODE_READ)))
 		return -EBADF;
diff -puN include/linux/fs.h~fs-relax-count-limitation-in-rw_verify_area-permit-2g-read-and-write include/linux/fs.h
--- a/include/linux/fs.h~fs-relax-count-limitation-in-rw_verify_area-permit-2g-read-and-write
+++ a/include/linux/fs.h
@@ -1872,8 +1872,8 @@ extern int current_umask(void);
 /* /sys/fs */
 extern struct kobject *fs_kobj;
 
-#define MAX_RW_COUNT (INT_MAX & PAGE_CACHE_MASK)
-extern int rw_verify_area(int, struct file *, loff_t *, size_t);
+#define MAX_RW_COUNT ((~(size_t)0) >> 1 & PAGE_CACHE_MASK)
+extern ssize_t rw_verify_area(int, struct file *, loff_t *, size_t);
 
 #define FLOCK_VERIFY_READ  1
 #define FLOCK_VERIFY_WRITE 2
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

linux-next.patch
fs-relax-count-limitation-in-rw_verify_area-permit-2g-read-and-write.patch

