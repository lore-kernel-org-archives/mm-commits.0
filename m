From: akpm@linux-foundation.org
Subject: - security-revalidate-rw-permissions-for-sys_splice-and.patch removed from -mm tree
Date: Wed, 30 May 2007 16:28:50 -0700
Message-ID: <200705302328.l4UNSnNa007780@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753171AbXE3X35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 19:29:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmorris@namei.org, jens.axboe@oracle.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     security: revalidate rw permissions for sys_splice and sys_vmsplice
has been removed from the -mm tree.  Its filename was
     security-revalidate-rw-permissions-for-sys_splice-and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: security: revalidate rw permissions for sys_splice and sys_vmsplice
From: James Morris <jmorris@namei.org>

Revalidate read/write permissions for splice(2) and vmslice(2), in case
security policy has changed since the files were opened.

Note that this brings the splice code into line with other mechanisms for
reading and writing files, where an LSM check is made on open, then
revalidated on read or write as a form of partial revocation.

Signed-off-by: James Morris <jmorris@namei.org>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+)

diff -puN fs/splice.c~security-revalidate-rw-permissions-for-sys_splice-and fs/splice.c
--- a/fs/splice.c~security-revalidate-rw-permissions-for-sys_splice-and
+++ a/fs/splice.c
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/uio.h>
+#include <linux/security.h>
 
 struct partial_page {
 	unsigned int offset;
@@ -912,6 +913,10 @@ static long do_splice_from(struct pipe_i
 	if (unlikely(ret < 0))
 		return ret;
 
+	ret = security_file_permission(out, MAY_WRITE);
+	if (unlikely(ret < 0))
+		return ret;
+
 	return out->f_op->splice_write(pipe, out, ppos, len, flags);
 }
 
@@ -935,6 +940,10 @@ static long do_splice_to(struct file *in
 	if (unlikely(ret < 0))
 		return ret;
 
+	ret = security_file_permission(in, MAY_READ);
+	if (unlikely(ret < 0))
+		return ret;
+
 	isize = i_size_read(in->f_mapping->host);
 	if (unlikely(*ppos >= isize))
 		return 0;
@@ -1263,6 +1272,7 @@ static int get_iovec_page_array(const st
 static long do_vmsplice(struct file *file, const struct iovec __user *iov,
 			unsigned long nr_segs, unsigned int flags)
 {
+	long err;
 	struct pipe_inode_info *pipe;
 	struct page *pages[PIPE_BUFFERS];
 	struct partial_page partial[PIPE_BUFFERS];
@@ -1281,6 +1291,10 @@ static long do_vmsplice(struct file *fil
 	else if (unlikely(!nr_segs))
 		return 0;
 
+	err = security_file_permission(file, MAY_WRITE);
+	if (unlikely(err < 0))
+		return err;
+
 	spd.nr_pages = get_iovec_page_array(iov, nr_segs, pages, partial,
 					    flags & SPLICE_F_GIFT);
 	if (spd.nr_pages <= 0)
_

Patches currently in -mm which might be from jmorris@namei.org are

git-selinux.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-update.patch
lguest-the-net-driver.patch
lguest-the-documentation-example-launcher.patch
