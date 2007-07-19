From: akpm@linux-foundation.org
Subject: - coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:55 -0700
Message-ID: <200707192002.l6JK2tRQ019797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46020 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761107AbXGSUQZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     coda: do not grab an uninitialized fd when the open upcall returns an error
has been removed from the -mm tree.  Its filename was
     coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: coda: do not grab an uninitialized fd when the open upcall returns an error
From: Jan Harkes <jaharkes@cs.cmu.edu>

When open fails the fd in the response is uninitialized and we ended up taking
a reference on the file struct and never released it.

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/file.c   |    7 +++++--
 fs/coda/psdev.c  |    3 ++-
 fs/coda/upcall.c |   10 +++++-----
 3 files changed, 12 insertions(+), 8 deletions(-)

diff -puN fs/coda/file.c~coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error fs/coda/file.c
--- a/fs/coda/file.c~coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error
+++ a/fs/coda/file.c
@@ -143,8 +143,11 @@ int coda_open(struct inode *coda_inode, 
 	lock_kernel();
 
 	error = venus_open(coda_inode->i_sb, coda_i2f(coda_inode), coda_flags,
-			   &host_file); 
-	if (error || !host_file) {
+			   &host_file);
+	if (!host_file)
+		error = -EIO;
+
+	if (error) {
 		kfree(cfi);
 		unlock_kernel();
 		return error;
diff -puN fs/coda/psdev.c~coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error fs/coda/psdev.c
--- a/fs/coda/psdev.c~coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error
+++ a/fs/coda/psdev.c
@@ -195,7 +195,8 @@ static ssize_t coda_psdev_write(struct f
 	if (req->uc_opcode == CODA_OPEN_BY_FD) {
 		struct coda_open_by_fd_out *outp =
 			(struct coda_open_by_fd_out *)req->uc_data;
-		outp->fh = fget(outp->fd);
+		if (!outp->oh.result)
+			outp->fh = fget(outp->fd);
 	}
 
         wake_up(&req->uc_sleep);
diff -puN fs/coda/upcall.c~coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error fs/coda/upcall.c
--- a/fs/coda/upcall.c~coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error
+++ a/fs/coda/upcall.c
@@ -251,12 +251,12 @@ int venus_open(struct super_block *sb, s
 	insize = SIZE(open_by_fd);
 	UPARG(CODA_OPEN_BY_FD);
 
-        inp->coda_open.VFid = *fid;
-        inp->coda_open.flags = flags;
+	inp->coda_open_by_fd.VFid = *fid;
+	inp->coda_open_by_fd.flags = flags;
 
-        error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
-
-	*fh = outp->coda_open_by_fd.fh;
+	error = coda_upcall(coda_sbp(sb), insize, &outsize, inp);
+	if (!error)
+		*fh = outp->coda_open_by_fd.fh;
 
 	CODA_FREE(inp, insize);
 	return error;
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

origin.patch
