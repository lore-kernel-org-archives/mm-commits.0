From: akpm@linux-foundation.org
Subject: [patch 078/142] userfaultfd: shmem: allow registration of shared
 memory ranges
Date: Wed, 22 Feb 2017 15:43:40 -0800
Message-ID: <58ae222c.nb3tgDiGuJNcC8hL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934171AbdBVXnl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:43:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com

From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: shmem: allow registration of shared memory ranges

Expand the userfaultfd_register/unregister routines to allow shared memory
VMAs.  Currently, there is no UFFDIO_ZEROPAGE and write-protection support
for shared memory VMAs, which is reflected in ioctl methods supported by
uffdio_register.

Link: http://lkml.kernel.org/r/20161216144821.5183-34-aarcange@redhat.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                         |   21 +++++++--------------
 include/uapi/linux/userfaultfd.h         |    2 +-
 tools/testing/selftests/vm/userfaultfd.c |    2 +-
 3 files changed, 9 insertions(+), 16 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-shmem-allow-registration-of-shared-memory-ranges fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-shmem-allow-registration-of-shared-memory-ranges
+++ a/fs/userfaultfd.c
@@ -1098,7 +1098,8 @@ static __always_inline int validate_rang
 
 static inline bool vma_can_userfault(struct vm_area_struct *vma)
 {
-	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma);
+	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
+		vma_is_shmem(vma);
 }
 
 static int userfaultfd_register(struct userfaultfd_ctx *ctx,
@@ -1111,7 +1112,7 @@ static int userfaultfd_register(struct u
 	struct uffdio_register __user *user_uffdio_register;
 	unsigned long vm_flags, new_flags;
 	bool found;
-	bool huge_pages;
+	bool non_anon_pages;
 	unsigned long start, end, vma_end;
 
 	user_uffdio_register = (struct uffdio_register __user *) arg;
@@ -1175,13 +1176,9 @@ static int userfaultfd_register(struct u
 
 	/*
 	 * Search for not compatible vmas.
-	 *
-	 * FIXME: this shall be relaxed later so that it doesn't fail
-	 * on tmpfs backed vmas (in addition to the current allowance
-	 * on anonymous vmas).
 	 */
 	found = false;
-	huge_pages = false;
+	non_anon_pages = false;
 	for (cur = vma; cur && cur->vm_start < end; cur = cur->vm_next) {
 		cond_resched();
 
@@ -1220,8 +1217,8 @@ static int userfaultfd_register(struct u
 		/*
 		 * Note vmas containing huge pages
 		 */
-		if (is_vm_hugetlb_page(cur))
-			huge_pages = true;
+		if (is_vm_hugetlb_page(cur) || vma_is_shmem(cur))
+			non_anon_pages = true;
 
 		found = true;
 	}
@@ -1292,7 +1289,7 @@ out_unlock:
 		 * userland which ioctls methods are guaranteed to
 		 * succeed on this range.
 		 */
-		if (put_user(huge_pages ? UFFD_API_RANGE_IOCTLS_HPAGE :
+		if (put_user(non_anon_pages ? UFFD_API_RANGE_IOCTLS_BASIC :
 			     UFFD_API_RANGE_IOCTLS,
 			     &user_uffdio_register->ioctls))
 			ret = -EFAULT;
@@ -1352,10 +1349,6 @@ static int userfaultfd_unregister(struct
 
 	/*
 	 * Search for not compatible vmas.
-	 *
-	 * FIXME: this shall be relaxed later so that it doesn't fail
-	 * on tmpfs backed vmas (in addition to the current allowance
-	 * on anonymous vmas).
 	 */
 	found = false;
 	ret = -EINVAL;
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-shmem-allow-registration-of-shared-memory-ranges include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-shmem-allow-registration-of-shared-memory-ranges
+++ a/include/uapi/linux/userfaultfd.h
@@ -30,7 +30,7 @@
 	((__u64)1 << _UFFDIO_WAKE |		\
 	 (__u64)1 << _UFFDIO_COPY |		\
 	 (__u64)1 << _UFFDIO_ZEROPAGE)
-#define UFFD_API_RANGE_IOCTLS_HPAGE		\
+#define UFFD_API_RANGE_IOCTLS_BASIC		\
 	((__u64)1 << _UFFDIO_WAKE |		\
 	 (__u64)1 << _UFFDIO_COPY)
 
diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-shmem-allow-registration-of-shared-memory-ranges tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-shmem-allow-registration-of-shared-memory-ranges
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -129,7 +129,7 @@ static void allocate_area(void **alloc_a
 
 #else /* HUGETLB_TEST */
 
-#define EXPECTED_IOCTLS		UFFD_API_RANGE_IOCTLS_HPAGE
+#define EXPECTED_IOCTLS		UFFD_API_RANGE_IOCTLS_BASIC
 
 static int release_pages(char *rel_area)
 {
_
