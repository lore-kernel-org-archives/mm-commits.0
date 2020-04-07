From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 045/166] userfaultfd: wp: add the writeprotect API
 to userfaultfd ioctl
Date: Mon, 06 Apr 2020 20:06:12 -0700
Message-ID: <20200407030612.R3vUoi03p%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbgDGDGP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:06:15 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, linux-mm@kvack.org, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, riel@redhat.com, rppt@linux.vnet.ibm.com, shli@fb.com, torvalds@linux-foundation.org, xemul@openvz.org

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: wp: add the writeprotect API to userfaultfd ioctl

Introduce the new uffd-wp APIs for userspace.

Firstly, we'll allow to do UFFDIO_REGISTER with write protection tracking
using the new UFFDIO_REGISTER_MODE_WP flag.  Note that this flag can
co-exist with the existing UFFDIO_REGISTER_MODE_MISSING, in which case the
userspace program can not only resolve missing page faults, and at the
same time tracking page data changes along the way.

Secondly, we introduced the new UFFDIO_WRITEPROTECT API to do page level
write protection tracking.  Note that we will need to register the memory
region with UFFDIO_REGISTER_MODE_WP before that.

[peterx@redhat.com: write up the commit message]
[peterx@redhat.com: remove useless block, write commit message, check against
 VM_MAYWRITE rather than VM_WRITE when register]
Link: http://lkml.kernel.org/r/20200220163112.11409-14-peterx@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Martin Cracauer <cracauer@cons.org>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Maya Gokhale <gokhale2@llnl.gov>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |   82 +++++++++++++++++++++++------
 include/uapi/linux/userfaultfd.h |   23 ++++++++
 2 files changed, 89 insertions(+), 16 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-wp-add-the-writeprotect-api-to-userfaultfd-ioctl
+++ a/fs/userfaultfd.c
@@ -314,8 +314,11 @@ static inline bool userfaultfd_must_wait
 	if (!pmd_present(_pmd))
 		goto out;
 
-	if (pmd_trans_huge(_pmd))
+	if (pmd_trans_huge(_pmd)) {
+		if (!pmd_write(_pmd) && (reason & VM_UFFD_WP))
+			ret = true;
 		goto out;
+	}
 
 	/*
 	 * the pmd is stable (as in !pmd_trans_unstable) so we can re-read it
@@ -328,6 +331,8 @@ static inline bool userfaultfd_must_wait
 	 */
 	if (pte_none(*pte))
 		ret = true;
+	if (!pte_write(*pte) && (reason & VM_UFFD_WP))
+		ret = true;
 	pte_unmap(pte);
 
 out:
@@ -1287,10 +1292,13 @@ static __always_inline int validate_rang
 	return 0;
 }
 
-static inline bool vma_can_userfault(struct vm_area_struct *vma)
+static inline bool vma_can_userfault(struct vm_area_struct *vma,
+				     unsigned long vm_flags)
 {
-	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
-		vma_is_shmem(vma);
+	/* FIXME: add WP support to hugetlbfs and shmem */
+	return vma_is_anonymous(vma) ||
+		((is_vm_hugetlb_page(vma) || vma_is_shmem(vma)) &&
+		 !(vm_flags & VM_UFFD_WP));
 }
 
 static int userfaultfd_register(struct userfaultfd_ctx *ctx,
@@ -1322,15 +1330,8 @@ static int userfaultfd_register(struct u
 	vm_flags = 0;
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MISSING)
 		vm_flags |= VM_UFFD_MISSING;
-	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_WP) {
+	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_WP)
 		vm_flags |= VM_UFFD_WP;
-		/*
-		 * FIXME: remove the below error constraint by
-		 * implementing the wprotect tracking mode.
-		 */
-		ret = -EINVAL;
-		goto out;
-	}
 
 	ret = validate_range(mm, &uffdio_register.range.start,
 			     uffdio_register.range.len);
@@ -1380,7 +1381,7 @@ static int userfaultfd_register(struct u
 
 		/* check not compatible vmas */
 		ret = -EINVAL;
-		if (!vma_can_userfault(cur))
+		if (!vma_can_userfault(cur, vm_flags))
 			goto out_unlock;
 
 		/*
@@ -1408,6 +1409,8 @@ static int userfaultfd_register(struct u
 			if (end & (vma_hpagesize - 1))
 				goto out_unlock;
 		}
+		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE))
+			goto out_unlock;
 
 		/*
 		 * Check that this vma isn't already owned by a
@@ -1437,7 +1440,7 @@ static int userfaultfd_register(struct u
 	do {
 		cond_resched();
 
-		BUG_ON(!vma_can_userfault(vma));
+		BUG_ON(!vma_can_userfault(vma, vm_flags));
 		BUG_ON(vma->vm_userfaultfd_ctx.ctx &&
 		       vma->vm_userfaultfd_ctx.ctx != ctx);
 		WARN_ON(!(vma->vm_flags & VM_MAYWRITE));
@@ -1575,7 +1578,7 @@ static int userfaultfd_unregister(struct
 		 * provides for more strict behavior to notice
 		 * unregistration errors.
 		 */
-		if (!vma_can_userfault(cur))
+		if (!vma_can_userfault(cur, cur->vm_flags))
 			goto out_unlock;
 
 		found = true;
@@ -1589,7 +1592,7 @@ static int userfaultfd_unregister(struct
 	do {
 		cond_resched();
 
-		BUG_ON(!vma_can_userfault(vma));
+		BUG_ON(!vma_can_userfault(vma, vma->vm_flags));
 
 		/*
 		 * Nothing to do: this vma is already registered into this
@@ -1802,6 +1805,50 @@ out:
 	return ret;
 }
 
+static int userfaultfd_writeprotect(struct userfaultfd_ctx *ctx,
+				    unsigned long arg)
+{
+	int ret;
+	struct uffdio_writeprotect uffdio_wp;
+	struct uffdio_writeprotect __user *user_uffdio_wp;
+	struct userfaultfd_wake_range range;
+
+	if (READ_ONCE(ctx->mmap_changing))
+		return -EAGAIN;
+
+	user_uffdio_wp = (struct uffdio_writeprotect __user *) arg;
+
+	if (copy_from_user(&uffdio_wp, user_uffdio_wp,
+			   sizeof(struct uffdio_writeprotect)))
+		return -EFAULT;
+
+	ret = validate_range(ctx->mm, &uffdio_wp.range.start,
+			     uffdio_wp.range.len);
+	if (ret)
+		return ret;
+
+	if (uffdio_wp.mode & ~(UFFDIO_WRITEPROTECT_MODE_DONTWAKE |
+			       UFFDIO_WRITEPROTECT_MODE_WP))
+		return -EINVAL;
+	if ((uffdio_wp.mode & UFFDIO_WRITEPROTECT_MODE_WP) &&
+	     (uffdio_wp.mode & UFFDIO_WRITEPROTECT_MODE_DONTWAKE))
+		return -EINVAL;
+
+	ret = mwriteprotect_range(ctx->mm, uffdio_wp.range.start,
+				  uffdio_wp.range.len, uffdio_wp.mode &
+				  UFFDIO_WRITEPROTECT_MODE_WP,
+				  &ctx->mmap_changing);
+	if (ret)
+		return ret;
+
+	if (!(uffdio_wp.mode & UFFDIO_WRITEPROTECT_MODE_DONTWAKE)) {
+		range.start = uffdio_wp.range.start;
+		range.len = uffdio_wp.range.len;
+		wake_userfault(ctx, &range);
+	}
+	return ret;
+}
+
 static inline unsigned int uffd_ctx_features(__u64 user_features)
 {
 	/*
@@ -1883,6 +1930,9 @@ static long userfaultfd_ioctl(struct fil
 	case UFFDIO_ZEROPAGE:
 		ret = userfaultfd_zeropage(ctx, arg);
 		break;
+	case UFFDIO_WRITEPROTECT:
+		ret = userfaultfd_writeprotect(ctx, arg);
+		break;
 	}
 	return ret;
 }
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-wp-add-the-writeprotect-api-to-userfaultfd-ioctl
+++ a/include/uapi/linux/userfaultfd.h
@@ -52,6 +52,7 @@
 #define _UFFDIO_WAKE			(0x02)
 #define _UFFDIO_COPY			(0x03)
 #define _UFFDIO_ZEROPAGE		(0x04)
+#define _UFFDIO_WRITEPROTECT		(0x06)
 #define _UFFDIO_API			(0x3F)
 
 /* userfaultfd ioctl ids */
@@ -68,6 +69,8 @@
 				      struct uffdio_copy)
 #define UFFDIO_ZEROPAGE		_IOWR(UFFDIO, _UFFDIO_ZEROPAGE,	\
 				      struct uffdio_zeropage)
+#define UFFDIO_WRITEPROTECT	_IOWR(UFFDIO, _UFFDIO_WRITEPROTECT, \
+				      struct uffdio_writeprotect)
 
 /* read() structure */
 struct uffd_msg {
@@ -232,4 +235,24 @@ struct uffdio_zeropage {
 	__s64 zeropage;
 };
 
+struct uffdio_writeprotect {
+	struct uffdio_range range;
+/*
+ * UFFDIO_WRITEPROTECT_MODE_WP: set the flag to write protect a range,
+ * unset the flag to undo protection of a range which was previously
+ * write protected.
+ *
+ * UFFDIO_WRITEPROTECT_MODE_DONTWAKE: set the flag to avoid waking up
+ * any wait thread after the operation succeeds.
+ *
+ * NOTE: Write protecting a region (WP=1) is unrelated to page faults,
+ * therefore DONTWAKE flag is meaningless with WP=1.  Removing write
+ * protection (WP=0) in response to a page fault wakes the faulting
+ * task unless DONTWAKE is set.
+ */
+#define UFFDIO_WRITEPROTECT_MODE_WP		((__u64)1<<0)
+#define UFFDIO_WRITEPROTECT_MODE_DONTWAKE	((__u64)1<<1)
+	__u64 mode;
+};
+
 #endif /* _LINUX_USERFAULTFD_H */
_
