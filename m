From: akpm@linux-foundation.org
Subject: + aio-vfs-cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector.patch added to -mm tree
Date: Thu, 19 Apr 2012 12:27:04 -0700
Message-ID: <20120419192704.AA2B4A055E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:52171 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab2DST1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Apr 2012 15:27:08 -0400
Received: by wgbdt11 with SMTP id dt11so478141wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Apr 2012 12:27:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cyeoh@au1.ibm.com, oleg@redhat.com, yeohc@au1.ibm.com


The patch titled
     Subject: aio/vfs: cleanup of rw_copy_check_uvector() and compat_rw_copy_check_uvector()
has been added to the -mm tree.  Its filename is
     aio-vfs-cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christopher Yeoh <cyeoh@au1.ibm.com>
Subject: aio/vfs: cleanup of rw_copy_check_uvector() and compat_rw_copy_check_uvector()

A cleanup of rw_copy_check_uvector and compat_rw_copy_check_uvector after
changes made to support CMA in an earlier patch.

Rather than having an additional check_access parameter to these
functions, the first paramater type is overloaded to allow the caller to
specify CHECK_IOVEC_ONLY which means check that the contents of the iovec
are valid, but do not check the memory that they point to.  This is used
by process_vm_readv/writev where we need to validate that a iovec passed
to the syscall is valid but do not want to check the memory that it points
to at this point because it refers to an address space in another process.

Signed-off-by: Chris Yeoh <yeohc@au1.ibm.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c               |    4 ++--
 fs/compat.c            |    6 +++---
 fs/read_write.c        |    7 +++----
 include/linux/compat.h |    3 +--
 include/linux/fs.h     |   12 ++++++++++--
 mm/process_vm_access.c |   16 ++++++++--------
 security/keys/compat.c |    2 +-
 security/keys/keyctl.c |    2 +-
 8 files changed, 29 insertions(+), 23 deletions(-)

diff -puN fs/aio.c~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector fs/aio.c
--- a/fs/aio.c~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector
+++ a/fs/aio.c
@@ -1436,13 +1436,13 @@ static ssize_t aio_setup_vectored_rw(int
 		ret = compat_rw_copy_check_uvector(type,
 				(struct compat_iovec __user *)kiocb->ki_buf,
 				kiocb->ki_nbytes, 1, &kiocb->ki_inline_vec,
-				&kiocb->ki_iovec, 1);
+				&kiocb->ki_iovec);
 	else
 #endif
 		ret = rw_copy_check_uvector(type,
 				(struct iovec __user *)kiocb->ki_buf,
 				kiocb->ki_nbytes, 1, &kiocb->ki_inline_vec,
-				&kiocb->ki_iovec, 1);
+				&kiocb->ki_iovec);
 	if (ret < 0)
 		goto out;
 
diff -puN fs/compat.c~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector fs/compat.c
--- a/fs/compat.c~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector
+++ a/fs/compat.c
@@ -532,7 +532,7 @@ out:
 ssize_t compat_rw_copy_check_uvector(int type,
 		const struct compat_iovec __user *uvector, unsigned long nr_segs,
 		unsigned long fast_segs, struct iovec *fast_pointer,
-		struct iovec **ret_pointer, int check_access)
+		struct iovec **ret_pointer)
 {
 	compat_ssize_t tot_len;
 	struct iovec *iov = *ret_pointer = fast_pointer;
@@ -579,7 +579,7 @@ ssize_t compat_rw_copy_check_uvector(int
 		}
 		if (len < 0)	/* size_t not fitting in compat_ssize_t .. */
 			goto out;
-		if (check_access &&
+		if (type >= 0 &&
 		    !access_ok(vrfy_dir(type), compat_ptr(buf), len)) {
 			ret = -EFAULT;
 			goto out;
@@ -1094,7 +1094,7 @@ static ssize_t compat_do_readv_writev(in
 		goto out;
 
 	tot_len = compat_rw_copy_check_uvector(type, uvector, nr_segs,
-					       UIO_FASTIOV, iovstack, &iov, 1);
+					       UIO_FASTIOV, iovstack, &iov);
 	if (tot_len == 0) {
 		ret = 0;
 		goto out;
diff -puN fs/read_write.c~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector fs/read_write.c
--- a/fs/read_write.c~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector
+++ a/fs/read_write.c
@@ -633,8 +633,7 @@ ssize_t do_loop_readv_writev(struct file
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			      unsigned long nr_segs, unsigned long fast_segs,
 			      struct iovec *fast_pointer,
-			      struct iovec **ret_pointer,
-			      int check_access)
+			      struct iovec **ret_pointer)
 {
 	unsigned long seg;
 	ssize_t ret;
@@ -690,7 +689,7 @@ ssize_t rw_copy_check_uvector(int type, 
 			ret = -EINVAL;
 			goto out;
 		}
-		if (check_access
+		if (type >= 0
 		    && unlikely(!access_ok(vrfy_dir(type), buf, len))) {
 			ret = -EFAULT;
 			goto out;
@@ -723,7 +722,7 @@ static ssize_t do_readv_writev(int type,
 	}
 
 	ret = rw_copy_check_uvector(type, uvector, nr_segs,
-				    ARRAY_SIZE(iovstack), iovstack, &iov, 1);
+				    ARRAY_SIZE(iovstack), iovstack, &iov);
 	if (ret <= 0)
 		goto out;
 
diff -puN include/linux/compat.h~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector include/linux/compat.h
--- a/include/linux/compat.h~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector
+++ a/include/linux/compat.h
@@ -577,8 +577,7 @@ extern ssize_t compat_rw_copy_check_uvec
 		const struct compat_iovec __user *uvector,
 		unsigned long nr_segs,
 		unsigned long fast_segs, struct iovec *fast_pointer,
-		struct iovec **ret_pointer,
-		int check_access);
+		struct iovec **ret_pointer);
 
 extern void __user *compat_alloc_user_space(unsigned long len);
 
diff -puN include/linux/fs.h~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector include/linux/fs.h
--- a/include/linux/fs.h~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector
+++ a/include/linux/fs.h
@@ -173,6 +173,15 @@ struct inodes_stat_t {
 #define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FUA)
 #define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
 
+
+/*
+ * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
+ * that indicates that they should check the contents of the iovec are
+ * valid, but not check the memory that the iovec elements
+ * points too.
+ */
+#define CHECK_IOVEC_ONLY -1
+
 #define SEL_IN		1
 #define SEL_OUT		2
 #define SEL_EX		4
@@ -1673,8 +1682,7 @@ struct seq_file;
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			      unsigned long nr_segs, unsigned long fast_segs,
 			      struct iovec *fast_pointer,
-			      struct iovec **ret_pointer,
-			      int check_access);
+			      struct iovec **ret_pointer);
 
 extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
diff -puN mm/process_vm_access.c~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector mm/process_vm_access.c
--- a/mm/process_vm_access.c~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector
+++ a/mm/process_vm_access.c
@@ -371,15 +371,15 @@ static ssize_t process_vm_rw(pid_t pid,
 	/* Check iovecs */
 	if (vm_write)
 		rc = rw_copy_check_uvector(WRITE, lvec, liovcnt, UIO_FASTIOV,
-					   iovstack_l, &iov_l, 1);
+					   iovstack_l, &iov_l);
 	else
 		rc = rw_copy_check_uvector(READ, lvec, liovcnt, UIO_FASTIOV,
-					   iovstack_l, &iov_l, 1);
+					   iovstack_l, &iov_l);
 	if (rc <= 0)
 		goto free_iovecs;
 
-	rc = rw_copy_check_uvector(READ, rvec, riovcnt, UIO_FASTIOV,
-				   iovstack_r, &iov_r, 0);
+	rc = rw_copy_check_uvector(CHECK_IOVEC_ONLY, rvec, riovcnt, UIO_FASTIOV,
+				   iovstack_r, &iov_r);
 	if (rc <= 0)
 		goto free_iovecs;
 
@@ -438,16 +438,16 @@ compat_process_vm_rw(compat_pid_t pid,
 	if (vm_write)
 		rc = compat_rw_copy_check_uvector(WRITE, lvec, liovcnt,
 						  UIO_FASTIOV, iovstack_l,
-						  &iov_l, 1);
+						  &iov_l);
 	else
 		rc = compat_rw_copy_check_uvector(READ, lvec, liovcnt,
 						  UIO_FASTIOV, iovstack_l,
-						  &iov_l, 1);
+						  &iov_l);
 	if (rc <= 0)
 		goto free_iovecs;
-	rc = compat_rw_copy_check_uvector(READ, rvec, riovcnt,
+	rc = compat_rw_copy_check_uvector(CHECK_IOVEC_ONLY, rvec, riovcnt,
 					  UIO_FASTIOV, iovstack_r,
-					  &iov_r, 0);
+					  &iov_r);
 	if (rc <= 0)
 		goto free_iovecs;
 
diff -puN security/keys/compat.c~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector security/keys/compat.c
--- a/security/keys/compat.c~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector
+++ a/security/keys/compat.c
@@ -38,7 +38,7 @@ long compat_keyctl_instantiate_key_iov(
 
 	ret = compat_rw_copy_check_uvector(WRITE, _payload_iov, ioc,
 					   ARRAY_SIZE(iovstack),
-					   iovstack, &iov, 1);
+					   iovstack, &iov);
 	if (ret < 0)
 		return ret;
 	if (ret == 0)
diff -puN security/keys/keyctl.c~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector security/keys/keyctl.c
--- a/security/keys/keyctl.c~cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector
+++ a/security/keys/keyctl.c
@@ -1079,7 +1079,7 @@ long keyctl_instantiate_key_iov(key_seri
 		goto no_payload;
 
 	ret = rw_copy_check_uvector(WRITE, _payload_iov, ioc,
-				    ARRAY_SIZE(iovstack), iovstack, &iov, 1);
+				    ARRAY_SIZE(iovstack), iovstack, &iov);
 	if (ret < 0)
 		return ret;
 	if (ret == 0)
_
Subject: Subject: aio/vfs: cleanup of rw_copy_check_uvector() and compat_rw_copy_check_uvector()

Patches currently in -mm which might be from cyeoh@au1.ibm.com are

aio-vfs-cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector.patch

