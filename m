From: akpm@linux-foundation.org
Subject: + aio-fix-the-compat-vectored-operations.patch added to -mm tree
Date: Tue, 04 May 2010 13:14:27 -0700
Message-ID: <201005042014.o44KEREk015996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933681Ab0EDUOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 16:14:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmoyer@redhat.com, mjt@tls.msk.ru, stable@kernel.org, zach.brown@oracle.com


The patch titled
     aio: fix the compat vectored operations
has been added to the -mm tree.  Its filename is
     aio-fix-the-compat-vectored-operations.patch

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
Subject: aio: fix the compat vectored operations
From: Jeff Moyer <jmoyer@redhat.com>

The aio compat code was not converting the struct iovecs from 32bit to
64bit pointers, causing either EINVAL to be returned from io_getevents, or
EFAULT as the result of the I/O.  This patch passes a compat flag to
io_submit to signal that pointer conversion is necessary for a given iocb
array.

A variant of this was tested by Michael Tokarev.  I have also updated the
libaio test harness to exercise this code path with good success. 
Further, I grabbed a copy of ltp and ran the
testcases/kernel/syscall/readv and writev tests there (compiled with -m32
on my 64bit system).  All seems happy, but extra eyes on this would be
welcome.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Reported-by: Michael Tokarev <mjt@tls.msk.ru>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c            |   63 ++++++++++++++++++++++++++----------------
 fs/compat.c         |    2 -
 include/linux/aio.h |    5 +++
 3 files changed, 45 insertions(+), 25 deletions(-)

diff -puN fs/aio.c~aio-fix-the-compat-vectored-operations fs/aio.c
--- a/fs/aio.c~aio-fix-the-compat-vectored-operations
+++ a/fs/aio.c
@@ -36,6 +36,7 @@
 #include <linux/blkdev.h>
 #include <linux/mempool.h>
 #include <linux/hash.h>
+#include <linux/compat.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -1384,13 +1385,20 @@ static ssize_t aio_fsync(struct kiocb *i
 	return ret;
 }
 
-static ssize_t aio_setup_vectored_rw(int type, struct kiocb *kiocb)
+static ssize_t aio_setup_vectored_rw(int type, struct kiocb *kiocb, bool compat)
 {
 	ssize_t ret;
 
-	ret = rw_copy_check_uvector(type, (struct iovec __user *)kiocb->ki_buf,
-				    kiocb->ki_nbytes, 1,
-				    &kiocb->ki_inline_vec, &kiocb->ki_iovec);
+	if (compat)
+		ret = compat_rw_copy_check_uvector(type,
+				(struct compat_iovec __user *)kiocb->ki_buf,
+				kiocb->ki_nbytes, 1, &kiocb->ki_inline_vec,
+				&kiocb->ki_iovec);
+	else
+		ret = rw_copy_check_uvector(type,
+				(struct iovec __user *)kiocb->ki_buf,
+				kiocb->ki_nbytes, 1, &kiocb->ki_inline_vec,
+				&kiocb->ki_iovec);
 	if (ret < 0)
 		goto out;
 
@@ -1420,7 +1428,7 @@ static ssize_t aio_setup_single_vector(s
  *	Performs the initial checks and aio retry method
  *	setup for the kiocb at the time of io submission.
  */
-static ssize_t aio_setup_iocb(struct kiocb *kiocb)
+static ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat)
 {
 	struct file *file = kiocb->ki_filp;
 	ssize_t ret = 0;
@@ -1469,7 +1477,7 @@ static ssize_t aio_setup_iocb(struct kio
 		ret = security_file_permission(file, MAY_READ);
 		if (unlikely(ret))
 			break;
-		ret = aio_setup_vectored_rw(READ, kiocb);
+		ret = aio_setup_vectored_rw(READ, kiocb, compat);
 		if (ret)
 			break;
 		ret = -EINVAL;
@@ -1483,7 +1491,7 @@ static ssize_t aio_setup_iocb(struct kio
 		ret = security_file_permission(file, MAY_WRITE);
 		if (unlikely(ret))
 			break;
-		ret = aio_setup_vectored_rw(WRITE, kiocb);
+		ret = aio_setup_vectored_rw(WRITE, kiocb, compat);
 		if (ret)
 			break;
 		ret = -EINVAL;
@@ -1548,7 +1556,8 @@ static void aio_batch_free(struct hlist_
 }
 
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-			 struct iocb *iocb, struct hlist_head *batch_hash)
+			 struct iocb *iocb, struct hlist_head *batch_hash,
+			 bool compat)
 {
 	struct kiocb *req;
 	struct file *file;
@@ -1609,7 +1618,7 @@ static int io_submit_one(struct kioctx *
 	req->ki_left = req->ki_nbytes = iocb->aio_nbytes;
 	req->ki_opcode = iocb->aio_lio_opcode;
 
-	ret = aio_setup_iocb(req);
+	ret = aio_setup_iocb(req, compat);
 
 	if (ret)
 		goto out_put_req;
@@ -1637,20 +1646,8 @@ out_put_req:
 	return ret;
 }
 
-/* sys_io_submit:
- *	Queue the nr iocbs pointed to by iocbpp for processing.  Returns
- *	the number of iocbs queued.  May return -EINVAL if the aio_context
- *	specified by ctx_id is invalid, if nr is < 0, if the iocb at
- *	*iocbpp[0] is not properly initialized, if the operation specified
- *	is invalid for the file descriptor in the iocb.  May fail with
- *	-EFAULT if any of the data structures point to invalid data.  May
- *	fail with -EBADF if the file descriptor specified in the first
- *	iocb is invalid.  May fail with -EAGAIN if insufficient resources
- *	are available to queue any iocbs.  Will return 0 if nr is 0.  Will
- *	fail with -ENOSYS if not implemented.
- */
-SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
-		struct iocb __user * __user *, iocbpp)
+long do_io_submit(aio_context_t ctx_id, long nr,
+		  struct iocb __user *__user * iocbpp, bool compat)
 {
 	struct kioctx *ctx;
 	long ret = 0;
@@ -1687,7 +1684,7 @@ SYSCALL_DEFINE3(io_submit, aio_context_t
 			break;
 		}
 
-		ret = io_submit_one(ctx, user_iocb, &tmp, batch_hash);
+		ret = io_submit_one(ctx, user_iocb, &tmp, batch_hash, compat);
 		if (ret)
 			break;
 	}
@@ -1697,6 +1694,24 @@ SYSCALL_DEFINE3(io_submit, aio_context_t
 	return i ? i : ret;
 }
 
+/* sys_io_submit:
+ *	Queue the nr iocbs pointed to by iocbpp for processing.  Returns
+ *	the number of iocbs queued.  May return -EINVAL if the aio_context
+ *	specified by ctx_id is invalid, if nr is < 0, if the iocb at
+ *	*iocbpp[0] is not properly initialized, if the operation specified
+ *	is invalid for the file descriptor in the iocb.  May fail with
+ *	-EFAULT if any of the data structures point to invalid data.  May
+ *	fail with -EBADF if the file descriptor specified in the first
+ *	iocb is invalid.  May fail with -EAGAIN if insufficient resources
+ *	are available to queue any iocbs.  Will return 0 if nr is 0.  Will
+ *	fail with -ENOSYS if not implemented.
+ */
+SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
+		struct iocb __user * __user *, iocbpp)
+{
+	return do_io_submit(ctx_id, nr, iocbpp, 0);
+}
+
 /* lookup_kiocb
  *	Finds a given iocb for cancellation.
  */
diff -puN fs/compat.c~aio-fix-the-compat-vectored-operations fs/compat.c
--- a/fs/compat.c~aio-fix-the-compat-vectored-operations
+++ a/fs/compat.c
@@ -673,7 +673,7 @@ compat_sys_io_submit(aio_context_t ctx_i
 	iocb64 = compat_alloc_user_space(nr * sizeof(*iocb64));
 	ret = copy_iocb(nr, iocb, iocb64);
 	if (!ret)
-		ret = sys_io_submit(ctx_id, nr, iocb64);
+		ret = do_io_submit(ctx_id, nr, iocb64, 1);
 	return ret;
 }
 
diff -puN include/linux/aio.h~aio-fix-the-compat-vectored-operations include/linux/aio.h
--- a/include/linux/aio.h~aio-fix-the-compat-vectored-operations
+++ a/include/linux/aio.h
@@ -212,6 +212,8 @@ extern void kick_iocb(struct kiocb *iocb
 extern int aio_complete(struct kiocb *iocb, long res, long res2);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
+extern long do_io_submit(aio_context_t ctx_id, long nr,
+			 struct iocb __user *__user * iocbpp, bool compat);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
 static inline int aio_put_req(struct kiocb *iocb) { return 0; }
@@ -219,6 +221,9 @@ static inline void kick_iocb(struct kioc
 static inline int aio_complete(struct kiocb *iocb, long res, long res2) { return 0; }
 struct mm_struct;
 static inline void exit_aio(struct mm_struct *mm) { }
+static inline long do_io_submit(aio_context_t ctx_id, long nr,
+				struct iocb __user * __user * iocbpp,
+				bool compat) { }
 #endif /* CONFIG_AIO */
 
 static inline struct kiocb *list_kiocb(struct list_head *h)
_

Patches currently in -mm which might be from jmoyer@redhat.com are

compat-factor-out-compat_rw_copy_check_uvector-from-compat_do_readv_writev.patch
aio-fix-the-compat-vectored-operations.patch

