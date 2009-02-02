From: akpm@linux-foundation.org
Subject: + preadv-pwritev-create-compat_writev.patch added to -mm tree
Date: Mon, 02 Feb 2009 13:35:33 -0800
Message-ID: <200902022135.n12LZXvp010670__47735.9013668776$1233610704$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754663AbZBBVgW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 16:36:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kraxel@redhat.com, arnd@arndb.de, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, ralf@linux-mips.org, viro@zeniv.linux.org.uk


The patch titled
     preadv/pwritev: create compat_writev()
has been added to the -mm tree.  Its filename is
     preadv-pwritev-create-compat_writev.patch

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
Subject: preadv/pwritev: create compat_writev()
From: Gerd Hoffmann <kraxel@redhat.com>

Factor out some code from compat_sys_writev() which can be shared with the
upcoming compat_sys_pwritev().

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <linux-api@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff -puN fs/compat.c~preadv-pwritev-create-compat_writev fs/compat.c
--- a/fs/compat.c~preadv-pwritev-create-compat_writev
+++ a/fs/compat.c
@@ -1204,15 +1204,12 @@ compat_sys_readv(unsigned long fd, const
 	return ret;
 }
 
-asmlinkage ssize_t
-compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
+static size_t compat_writev(struct file *file,
+			    const struct compat_iovec __user *vec,
+			    unsigned long vlen, loff_t *pos)
 {
-	struct file *file;
 	ssize_t ret = -EBADF;
 
-	file = fget(fd);
-	if (!file)
-		return -EBADF;
 	if (!(file->f_mode & FMODE_WRITE))
 		goto out;
 
@@ -1220,12 +1217,26 @@ compat_sys_writev(unsigned long fd, cons
 	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
 		goto out;
 
-	ret = compat_do_readv_writev(WRITE, file, vec, vlen, &file->f_pos);
+	ret = compat_do_readv_writev(WRITE, file, vec, vlen, pos);
 
 out:
 	if (ret > 0)
 		add_wchar(current, ret);
 	inc_syscw(current);
+	return ret;
+}
+
+asmlinkage ssize_t
+compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec,
+		  unsigned long vlen)
+{
+	struct file *file;
+	ssize_t ret;
+
+	file = fget(fd);
+	if (!file)
+		return -EBADF;
+	ret = compat_writev(file, vec, vlen, &file->f_pos);
 	fput(file);
 	return ret;
 }
_

Patches currently in -mm which might be from kraxel@redhat.com are

linux-next.patch
preadv-pwritev-create-compat_readv.patch
preadv-pwritev-create-compat_writev.patch
preadv-pwritev-add-preadv-and-pwritev-system-calls.patch
preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls.patch
preadv-pwritev-switch-compat-readv-preadv-writev-pwritev-from-fget-to-fget_light.patch

