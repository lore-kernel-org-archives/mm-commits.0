From: akpm@linux-foundation.org
Subject: +
 userfaultfd-hugetlbfs-allow-registration-of-ranges-containing-huge-pages.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:54:03 -0800
Message-ID: <586d992b.EaBQtRQ1ep108hLg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36232 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937490AbdAEAyW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: allow registration of ranges containing huge pages
has been added to the -mm tree.  Its filename is
     userfaultfd-hugetlbfs-allow-registration-of-ranges-containing-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-hugetlbfs-allow-registration-of-ranges-containing-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-hugetlbfs-allow-registration-of-ranges-containing-huge-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: userfaultfd: hugetlbfs: allow registration of ranges containing huge pages

Expand the userfaultfd_register/unregister routines to allow VM_HUGETLB
vmas.  huge page alignment checking is performed after a VM_HUGETLB vma is
encountered.

Also, since there is no UFFDIO_ZEROPAGE support for huge pages do not
return that as a valid ioctl method for huge page ranges.

Link: http://lkml.kernel.org/r/20161216144821.5183-22-aarcange@redhat.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |   55 ++++++++++++++++++++++++++---
 include/uapi/linux/userfaultfd.h |    3 +
 2 files changed, 53 insertions(+), 5 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-hugetlbfs-allow-registration-of-ranges-containing-huge-pages fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-hugetlbfs-allow-registration-of-ranges-containing-huge-pages
+++ a/fs/userfaultfd.c
@@ -27,6 +27,7 @@
 #include <linux/mempolicy.h>
 #include <linux/ioctl.h>
 #include <linux/security.h>
+#include <linux/hugetlb.h>
 
 static struct kmem_cache *userfaultfd_ctx_cachep __read_mostly;
 
@@ -1025,6 +1026,7 @@ static int userfaultfd_register(struct u
 	struct uffdio_register __user *user_uffdio_register;
 	unsigned long vm_flags, new_flags;
 	bool found;
+	bool huge_pages;
 	unsigned long start, end, vma_end;
 
 	user_uffdio_register = (struct uffdio_register __user *) arg;
@@ -1076,6 +1078,17 @@ static int userfaultfd_register(struct u
 		goto out_unlock;
 
 	/*
+	 * If the first vma contains huge pages, make sure start address
+	 * is aligned to huge page size.
+	 */
+	if (is_vm_hugetlb_page(vma)) {
+		unsigned long vma_hpagesize = vma_kernel_pagesize(vma);
+
+		if (start & (vma_hpagesize - 1))
+			goto out_unlock;
+	}
+
+	/*
 	 * Search for not compatible vmas.
 	 *
 	 * FIXME: this shall be relaxed later so that it doesn't fail
@@ -1083,6 +1096,7 @@ static int userfaultfd_register(struct u
 	 * on anonymous vmas).
 	 */
 	found = false;
+	huge_pages = false;
 	for (cur = vma; cur && cur->vm_start < end; cur = cur->vm_next) {
 		cond_resched();
 
@@ -1091,8 +1105,21 @@ static int userfaultfd_register(struct u
 
 		/* check not compatible vmas */
 		ret = -EINVAL;
-		if (!vma_is_anonymous(cur))
+		if (!vma_is_anonymous(cur) && !is_vm_hugetlb_page(cur))
 			goto out_unlock;
+		/*
+		 * If this vma contains ending address, and huge pages
+		 * check alignment.
+		 */
+		if (is_vm_hugetlb_page(cur) && end <= cur->vm_end &&
+		    end > cur->vm_start) {
+			unsigned long vma_hpagesize = vma_kernel_pagesize(cur);
+
+			ret = -EINVAL;
+
+			if (end & (vma_hpagesize - 1))
+				goto out_unlock;
+		}
 
 		/*
 		 * Check that this vma isn't already owned by a
@@ -1105,6 +1132,12 @@ static int userfaultfd_register(struct u
 		    cur->vm_userfaultfd_ctx.ctx != ctx)
 			goto out_unlock;
 
+		/*
+		 * Note vmas containing huge pages
+		 */
+		if (is_vm_hugetlb_page(cur))
+			huge_pages = true;
+
 		found = true;
 	}
 	BUG_ON(!found);
@@ -1116,7 +1149,7 @@ static int userfaultfd_register(struct u
 	do {
 		cond_resched();
 
-		BUG_ON(!vma_is_anonymous(vma));
+		BUG_ON(!vma_is_anonymous(vma) && !is_vm_hugetlb_page(vma));
 		BUG_ON(vma->vm_userfaultfd_ctx.ctx &&
 		       vma->vm_userfaultfd_ctx.ctx != ctx);
 
@@ -1174,7 +1207,8 @@ out_unlock:
 		 * userland which ioctls methods are guaranteed to
 		 * succeed on this range.
 		 */
-		if (put_user(UFFD_API_RANGE_IOCTLS,
+		if (put_user(huge_pages ? UFFD_API_RANGE_IOCTLS_HPAGE :
+			     UFFD_API_RANGE_IOCTLS,
 			     &user_uffdio_register->ioctls))
 			ret = -EFAULT;
 	}
@@ -1221,6 +1255,17 @@ static int userfaultfd_unregister(struct
 		goto out_unlock;
 
 	/*
+	 * If the first vma contains huge pages, make sure start address
+	 * is aligned to huge page size.
+	 */
+	if (is_vm_hugetlb_page(vma)) {
+		unsigned long vma_hpagesize = vma_kernel_pagesize(vma);
+
+		if (start & (vma_hpagesize - 1))
+			goto out_unlock;
+	}
+
+	/*
 	 * Search for not compatible vmas.
 	 *
 	 * FIXME: this shall be relaxed later so that it doesn't fail
@@ -1242,7 +1287,7 @@ static int userfaultfd_unregister(struct
 		 * provides for more strict behavior to notice
 		 * unregistration errors.
 		 */
-		if (!vma_is_anonymous(cur))
+		if (!vma_is_anonymous(cur) && !is_vm_hugetlb_page(cur))
 			goto out_unlock;
 
 		found = true;
@@ -1256,7 +1301,7 @@ static int userfaultfd_unregister(struct
 	do {
 		cond_resched();
 
-		BUG_ON(!vma_is_anonymous(vma));
+		BUG_ON(!vma_is_anonymous(vma) && !is_vm_hugetlb_page(vma));
 
 		/*
 		 * Nothing to do: this vma is already registered into this
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-hugetlbfs-allow-registration-of-ranges-containing-huge-pages include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-hugetlbfs-allow-registration-of-ranges-containing-huge-pages
+++ a/include/uapi/linux/userfaultfd.h
@@ -29,6 +29,9 @@
 	((__u64)1 << _UFFDIO_WAKE |		\
 	 (__u64)1 << _UFFDIO_COPY |		\
 	 (__u64)1 << _UFFDIO_ZEROPAGE)
+#define UFFD_API_RANGE_IOCTLS_HPAGE		\
+	((__u64)1 << _UFFDIO_WAKE |		\
+	 (__u64)1 << _UFFDIO_COPY)
 
 /*
  * Valid ioctl command number range with this API is from 0x00 to
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

userfaultfd-hugetlbfs-add-copy_huge_page_from_user-for-hugetlb-userfaultfd-support.patch
userfaultfd-hugetlbfs-add-hugetlb_mcopy_atomic_pte-for-userfaultfd-support.patch
userfaultfd-hugetlbfs-add-__mcopy_atomic_hugetlb-for-huge-page-uffdio_copy.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing.patch
userfaultfd-hugetlbfs-add-userfaultfd-hugetlb-hook.patch
userfaultfd-hugetlbfs-allow-registration-of-ranges-containing-huge-pages.patch
userfaultfd-hugetlbfs-add-userfaultfd_hugetlb-test.patch
userfaultfd-hugetlbfs-userfaultfd_huge_must_wait-for-hugepmd-ranges.patch
userfaultfd-hugetlbfs-reserve-count-on-error-in-__mcopy_atomic_hugetlb.patch

