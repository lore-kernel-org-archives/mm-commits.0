From: akpm@linux-foundation.org
Subject: [patch 066/142] userfaultfd: hugetlbfs: allow registration of
 ranges containing huge pages
Date: Wed, 22 Feb 2017 15:43:04 -0800
Message-ID: <58ae2208.jVi0x4uWoyw9OIVX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933983AbdBVXnK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:43:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mike.kravetz@oracle.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, rppt@linux.vnet.ibm.com, xemul@parallels.com

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
 
@@ -1058,6 +1059,7 @@ static int userfaultfd_register(struct u
 	struct uffdio_register __user *user_uffdio_register;
 	unsigned long vm_flags, new_flags;
 	bool found;
+	bool huge_pages;
 	unsigned long start, end, vma_end;
 
 	user_uffdio_register = (struct uffdio_register __user *) arg;
@@ -1109,6 +1111,17 @@ static int userfaultfd_register(struct u
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
@@ -1116,6 +1129,7 @@ static int userfaultfd_register(struct u
 	 * on anonymous vmas).
 	 */
 	found = false;
+	huge_pages = false;
 	for (cur = vma; cur && cur->vm_start < end; cur = cur->vm_next) {
 		cond_resched();
 
@@ -1124,8 +1138,21 @@ static int userfaultfd_register(struct u
 
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
@@ -1138,6 +1165,12 @@ static int userfaultfd_register(struct u
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
@@ -1149,7 +1182,7 @@ static int userfaultfd_register(struct u
 	do {
 		cond_resched();
 
-		BUG_ON(!vma_is_anonymous(vma));
+		BUG_ON(!vma_is_anonymous(vma) && !is_vm_hugetlb_page(vma));
 		BUG_ON(vma->vm_userfaultfd_ctx.ctx &&
 		       vma->vm_userfaultfd_ctx.ctx != ctx);
 
@@ -1207,7 +1240,8 @@ out_unlock:
 		 * userland which ioctls methods are guaranteed to
 		 * succeed on this range.
 		 */
-		if (put_user(UFFD_API_RANGE_IOCTLS,
+		if (put_user(huge_pages ? UFFD_API_RANGE_IOCTLS_HPAGE :
+			     UFFD_API_RANGE_IOCTLS,
 			     &user_uffdio_register->ioctls))
 			ret = -EFAULT;
 	}
@@ -1254,6 +1288,17 @@ static int userfaultfd_unregister(struct
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
@@ -1275,7 +1320,7 @@ static int userfaultfd_unregister(struct
 		 * provides for more strict behavior to notice
 		 * unregistration errors.
 		 */
-		if (!vma_is_anonymous(cur))
+		if (!vma_is_anonymous(cur) && !is_vm_hugetlb_page(cur))
 			goto out_unlock;
 
 		found = true;
@@ -1289,7 +1334,7 @@ static int userfaultfd_unregister(struct
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
