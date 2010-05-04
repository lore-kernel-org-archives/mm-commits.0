From: akpm@linux-foundation.org
Subject: + compat-factor-out-compat_rw_copy_check_uvector-from-compat_do_readv_writev.patch added to -mm tree
Date: Tue, 04 May 2010 13:14:22 -0700
Message-ID: <201005042014.o44KENPQ015989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933608Ab0EDUOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 16:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmoyer@redhat.com, mjt@tls.msk.ru, stable@kernel.org, zach.brown@oracle.com


The patch titled
     compat: factor out compat_rw_copy_check_uvector from compat_do_readv_writev
has been added to the -mm tree.  Its filename is
     compat-factor-out-compat_rw_copy_check_uvector-from-compat_do_readv_writev.patch

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
Subject: compat: factor out compat_rw_copy_check_uvector from compat_do_readv_writev
From: Jeff Moyer <jmoyer@redhat.com>

It was reported in http://lkml.org/lkml/2010/3/8/309 that 32 bit readv and
writev AIO operations were not functioning properly.  It turns out that
the code to convert the 32bit io vectors to 64 bits was never written. 
The results of that can be pretty bad, but in my testing, it mostly ended
up in generating EFAULT as we walked off the list of I/O vectors provided.

This patch set fixes the problem in my environment.  are greatly
appreciated.



This patch:

Factor out code that will be used by both compat_do_readv_writev and the
compat aio submission code paths.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Reported-by: Michael Tokarev <mjt@tls.msk.ru>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c            |  130 +++++++++++++++++++++++----------------
 include/linux/compat.h |    4 +
 2 files changed, 81 insertions(+), 53 deletions(-)

diff -puN fs/compat.c~compat-factor-out-compat_rw_copy_check_uvector-from-compat_do_readv_writev fs/compat.c
--- a/fs/compat.c~compat-factor-out-compat_rw_copy_check_uvector-from-compat_do_readv_writev
+++ a/fs/compat.c
@@ -568,6 +568,79 @@ out:
 	return ret;
 }
 
+/* A write operation does a read from user space and vice versa */
+#define vrfy_dir(type) ((type) == READ ? VERIFY_WRITE : VERIFY_READ)
+
+ssize_t compat_rw_copy_check_uvector(int type,
+		const struct compat_iovec __user *uvector, unsigned long nr_segs,
+		unsigned long fast_segs, struct iovec *fast_pointer,
+		struct iovec **ret_pointer)
+{
+	compat_ssize_t tot_len;
+	struct iovec *iov = *ret_pointer = fast_pointer;
+	ssize_t ret = 0;
+	int seg;
+
+	/*
+	 * SuS says "The readv() function *may* fail if the iovcnt argument
+	 * was less than or equal to 0, or greater than {IOV_MAX}.  Linux has
+	 * traditionally returned zero for zero segments, so...
+	 */
+	if (nr_segs == 0)
+		goto out;
+
+	ret = -EINVAL;
+	if (nr_segs > UIO_MAXIOV || nr_segs < 0)
+		goto out;
+	if (nr_segs > fast_segs) {
+		ret = -ENOMEM;
+		iov = kmalloc(nr_segs*sizeof(struct iovec), GFP_KERNEL);
+		if (iov == NULL) {
+			*ret_pointer = fast_pointer;
+			goto out;
+		}
+	}
+	*ret_pointer = iov;
+
+	/*
+	 * Single unix specification:
+	 * We should -EINVAL if an element length is not >= 0 and fitting an
+	 * ssize_t.  The total length is fitting an ssize_t
+	 *
+	 * Be careful here because iov_len is a size_t not an ssize_t
+	 */
+	tot_len = 0;
+	ret = -EINVAL;
+	for (seg = 0; seg < nr_segs; seg++) {
+		compat_ssize_t tmp = tot_len;
+		compat_uptr_t buf;
+		compat_ssize_t len;
+
+		if (__get_user(len, &uvector->iov_len) ||
+		   __get_user(buf, &uvector->iov_base)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		if (len < 0)	/* size_t not fitting in compat_ssize_t .. */
+			goto out;
+		tot_len += len;
+		if (tot_len < tmp) /* maths overflow on the compat_ssize_t */
+			goto out;
+		if (!access_ok(vrfy_dir(type), buf, len)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		iov->iov_base = compat_ptr(buf);
+		iov->iov_len = (compat_size_t) len;
+		uvector++;
+		iov++;
+	}
+	ret = tot_len;
+
+out:
+	return ret;
+}
+
 static inline long
 copy_iocb(long nr, u32 __user *ptr32, struct iocb __user * __user *ptr64)
 {
@@ -1077,70 +1150,21 @@ static ssize_t compat_do_readv_writev(in
 {
 	compat_ssize_t tot_len;
 	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov=iovstack, *vector;
+	struct iovec *iov;
 	ssize_t ret;
-	int seg;
 	io_fn_t fn;
 	iov_fn_t fnv;
 
-	/*
-	 * SuS says "The readv() function *may* fail if the iovcnt argument
-	 * was less than or equal to 0, or greater than {IOV_MAX}.  Linux has
-	 * traditionally returned zero for zero segments, so...
-	 */
-	ret = 0;
-	if (nr_segs == 0)
-		goto out;
-
-	/*
-	 * First get the "struct iovec" from user memory and
-	 * verify all the pointers
-	 */
 	ret = -EINVAL;
-	if ((nr_segs > UIO_MAXIOV) || (nr_segs <= 0))
-		goto out;
 	if (!file->f_op)
 		goto out;
-	if (nr_segs > UIO_FASTIOV) {
-		ret = -ENOMEM;
-		iov = kmalloc(nr_segs*sizeof(struct iovec), GFP_KERNEL);
-		if (!iov)
-			goto out;
-	}
+
 	ret = -EFAULT;
 	if (!access_ok(VERIFY_READ, uvector, nr_segs*sizeof(*uvector)))
 		goto out;
 
-	/*
-	 * Single unix specification:
-	 * We should -EINVAL if an element length is not >= 0 and fitting an
-	 * ssize_t.  The total length is fitting an ssize_t
-	 *
-	 * Be careful here because iov_len is a size_t not an ssize_t
-	 */
-	tot_len = 0;
-	vector = iov;
-	ret = -EINVAL;
-	for (seg = 0 ; seg < nr_segs; seg++) {
-		compat_ssize_t tmp = tot_len;
-		compat_ssize_t len;
-		compat_uptr_t buf;
-
-		if (__get_user(len, &uvector->iov_len) ||
-		    __get_user(buf, &uvector->iov_base)) {
-			ret = -EFAULT;
-			goto out;
-		}
-		if (len < 0)	/* size_t not fitting an compat_ssize_t .. */
-			goto out;
-		tot_len += len;
-		if (tot_len < tmp) /* maths overflow on the compat_ssize_t */
-			goto out;
-		vector->iov_base = compat_ptr(buf);
-		vector->iov_len = (compat_size_t) len;
-		uvector++;
-		vector++;
-	}
+	tot_len = compat_rw_copy_check_uvector(type, uvector, nr_segs,
+					       UIO_FASTIOV, iovstack, &iov);
 	if (tot_len == 0) {
 		ret = 0;
 		goto out;
diff -puN include/linux/compat.h~compat-factor-out-compat_rw_copy_check_uvector-from-compat_do_readv_writev include/linux/compat.h
--- a/include/linux/compat.h~compat-factor-out-compat_rw_copy_check_uvector-from-compat_do_readv_writev
+++ a/include/linux/compat.h
@@ -356,5 +356,9 @@ asmlinkage long compat_sys_newfstatat(un
 asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
 				  int flags, int mode);
 
+extern ssize_t compat_rw_copy_check_uvector(int type,
+		const struct compat_iovec __user *uvector, unsigned long nr_segs,
+		unsigned long fast_segs, struct iovec *fast_pointer,
+		struct iovec **ret_pointer);
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
_

Patches currently in -mm which might be from jmoyer@redhat.com are

compat-factor-out-compat_rw_copy_check_uvector-from-compat_do_readv_writev.patch
aio-fix-the-compat-vectored-operations.patch

