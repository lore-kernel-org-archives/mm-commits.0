From: akpm@linux-foundation.org
Subject: +
 userfaultfd-shmem-allow-registration-of-shared-memory-ranges.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:54:28 -0800
Message-ID: <586d9944.zqtsw9h1VvPARA0k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36192 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937514AbdAEAy3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: allow registration of shared memory ranges
has been added to the -mm tree.  Its filename is
     userfaultfd-shmem-allow-registration-of-shared-memory-ranges.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-shmem-allow-registration-of-shared-memory-ranges.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-shmem-allow-registration-of-shared-memory-ranges.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1065,7 +1065,8 @@ static __always_inline int validate_rang
 
 static inline bool vma_can_userfault(struct vm_area_struct *vma)
 {
-	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma);
+	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
+		vma_is_shmem(vma);
 }
 
 static int userfaultfd_register(struct userfaultfd_ctx *ctx,
@@ -1078,7 +1079,7 @@ static int userfaultfd_register(struct u
 	struct uffdio_register __user *user_uffdio_register;
 	unsigned long vm_flags, new_flags;
 	bool found;
-	bool huge_pages;
+	bool non_anon_pages;
 	unsigned long start, end, vma_end;
 
 	user_uffdio_register = (struct uffdio_register __user *) arg;
@@ -1142,13 +1143,9 @@ static int userfaultfd_register(struct u
 
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
 
@@ -1187,8 +1184,8 @@ static int userfaultfd_register(struct u
 		/*
 		 * Note vmas containing huge pages
 		 */
-		if (is_vm_hugetlb_page(cur))
-			huge_pages = true;
+		if (is_vm_hugetlb_page(cur) || vma_is_shmem(cur))
+			non_anon_pages = true;
 
 		found = true;
 	}
@@ -1259,7 +1256,7 @@ out_unlock:
 		 * userland which ioctls methods are guaranteed to
 		 * succeed on this range.
 		 */
-		if (put_user(huge_pages ? UFFD_API_RANGE_IOCTLS_HPAGE :
+		if (put_user(non_anon_pages ? UFFD_API_RANGE_IOCTLS_BASIC :
 			     UFFD_API_RANGE_IOCTLS,
 			     &user_uffdio_register->ioctls))
 			ret = -EFAULT;
@@ -1319,10 +1316,6 @@ static int userfaultfd_unregister(struct
 
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

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users.patch
userfaultfd-introduce-vma_can_userfault.patch
userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support.patch
userfaultfd-shmem-introduce-vma_is_shmem.patch
userfaultfd-shmem-use-shmem_mcopy_atomic_pte-for-shared-memory.patch
userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults.patch
userfaultfd-shmem-allow-registration-of-shared-memory-ranges.patch
userfaultfd-shmem-add-userfaultfd_shmem-test.patch
userfaultfd-non-cooperative-selftest-introduce-userfaultfd_open.patch
userfaultfd-non-cooperative-selftest-add-ufd-parameter-to-copy_page.patch
userfaultfd-non-cooperative-selftest-add-test-for-fork-madvdontneed-and-remap-events.patch

