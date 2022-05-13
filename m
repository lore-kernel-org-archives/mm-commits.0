Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA2DC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383794AbiEMTVl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383842AbiEMTVO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFE46274
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDD0162245
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533BDC34113;
        Fri, 13 May 2022 19:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469671;
        bh=ctB2kA9k/vKwnPjnT7nJHGr/z+pKslFRdtWG8Qp+h1A=;
        h=Date:To:From:Subject:From;
        b=p/YARj8QDk5KekaPtUZdl02uurxvFQeqcUHRWMGUn2yPibxGCTO6wfOjGtRCTy0sw
         kExM5UfrR+YdC5LkfRoqWzyA4DBb5HjTOhurOt8z/m/fqz2vMH/qjODgC0zGSlCeRC
         R6nwOr6COzUzNEICVKaJ36TT8u0EhSK8FTJm9Qz0=
Date:   Fri, 13 May 2022 12:21:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch removed from -mm tree
Message-Id: <20220513192111.533BDC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/uffd: enable write protection for shmem & hugetlbfs
has been removed from the -mm tree.  Its filename was
     mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/uffd: enable write protection for shmem & hugetlbfs

We've had all the necessary changes ready for both shmem and hugetlbfs. 
Turn on all the shmem/hugetlbfs switches for userfaultfd-wp.

We can expand UFFD_API_RANGE_IOCTLS_BASIC with _UFFDIO_WRITEPROTECT too
because all existing types now support write protection mode.

Since vma_can_userfault() will be used elsewhere, move into userfaultfd_k.h.

Link: https://lkml.kernel.org/r/20220405014926.15101-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |   21 +++------------------
 include/linux/userfaultfd_k.h    |   20 ++++++++++++++++++++
 include/uapi/linux/userfaultfd.h |   10 ++++++++--
 mm/userfaultfd.c                 |    9 +++------
 4 files changed, 34 insertions(+), 26 deletions(-)

--- a/fs/userfaultfd.c~mm-uffd-enable-write-protection-for-shmem-hugetlbfs
+++ a/fs/userfaultfd.c
@@ -1258,24 +1258,6 @@ static __always_inline int validate_rang
 	return 0;
 }
 
-static inline bool vma_can_userfault(struct vm_area_struct *vma,
-				     unsigned long vm_flags)
-{
-	/* FIXME: add WP support to hugetlbfs and shmem */
-	if (vm_flags & VM_UFFD_WP) {
-		if (is_vm_hugetlb_page(vma) || vma_is_shmem(vma))
-			return false;
-	}
-
-	if (vm_flags & VM_UFFD_MINOR) {
-		if (!(is_vm_hugetlb_page(vma) || vma_is_shmem(vma)))
-			return false;
-	}
-
-	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
-	       vma_is_shmem(vma);
-}
-
 static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 				unsigned long arg)
 {
@@ -1957,6 +1939,9 @@ static int userfaultfd_api(struct userfa
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 	uffdio_api.features &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
 #endif
+#ifndef CONFIG_PTE_MARKER_UFFD_WP
+	uffdio_api.features &= ~UFFD_FEATURE_WP_HUGETLBFS_SHMEM;
+#endif
 	uffdio_api.ioctls = UFFD_API_IOCTLS;
 	ret = -EFAULT;
 	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
--- a/include/linux/userfaultfd_k.h~mm-uffd-enable-write-protection-for-shmem-hugetlbfs
+++ a/include/linux/userfaultfd_k.h
@@ -18,6 +18,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <asm-generic/pgtable_uffd.h>
+#include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
 #define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
@@ -140,6 +141,25 @@ static inline bool userfaultfd_armed(str
 	return vma->vm_flags & __VM_UFFD_FLAGS;
 }
 
+static inline bool vma_can_userfault(struct vm_area_struct *vma,
+				     unsigned long vm_flags)
+{
+	if (vm_flags & VM_UFFD_MINOR)
+		return is_vm_hugetlb_page(vma) || vma_is_shmem(vma);
+
+#ifndef CONFIG_PTE_MARKER_UFFD_WP
+	/*
+	 * If user requested uffd-wp but not enabled pte markers for
+	 * uffd-wp, then shmem & hugetlbfs are not supported but only
+	 * anonymous.
+	 */
+	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
+		return false;
+#endif
+	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
+	    vma_is_shmem(vma);
+}
+
 extern int dup_userfaultfd(struct vm_area_struct *, struct list_head *);
 extern void dup_userfaultfd_complete(struct list_head *);
 
--- a/include/uapi/linux/userfaultfd.h~mm-uffd-enable-write-protection-for-shmem-hugetlbfs
+++ a/include/uapi/linux/userfaultfd.h
@@ -33,7 +33,8 @@
 			   UFFD_FEATURE_THREAD_ID |		\
 			   UFFD_FEATURE_MINOR_HUGETLBFS |	\
 			   UFFD_FEATURE_MINOR_SHMEM |		\
-			   UFFD_FEATURE_EXACT_ADDRESS)
+			   UFFD_FEATURE_EXACT_ADDRESS |		\
+			   UFFD_FEATURE_WP_HUGETLBFS_SHMEM)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -47,7 +48,8 @@
 #define UFFD_API_RANGE_IOCTLS_BASIC		\
 	((__u64)1 << _UFFDIO_WAKE |		\
 	 (__u64)1 << _UFFDIO_COPY |		\
-	 (__u64)1 << _UFFDIO_CONTINUE)
+	 (__u64)1 << _UFFDIO_CONTINUE |		\
+	 (__u64)1 << _UFFDIO_WRITEPROTECT)
 
 /*
  * Valid ioctl command number range with this API is from 0x00 to
@@ -194,6 +196,9 @@ struct uffdio_api {
 	 * UFFD_FEATURE_EXACT_ADDRESS indicates that the exact address of page
 	 * faults would be provided and the offset within the page would not be
 	 * masked.
+	 *
+	 * UFFD_FEATURE_WP_HUGETLBFS_SHMEM indicates that userfaultfd
+	 * write-protection mode is supported on both shmem and hugetlbfs.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -207,6 +212,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_MINOR_HUGETLBFS		(1<<9)
 #define UFFD_FEATURE_MINOR_SHMEM		(1<<10)
 #define UFFD_FEATURE_EXACT_ADDRESS		(1<<11)
+#define UFFD_FEATURE_WP_HUGETLBFS_SHMEM		(1<<12)
 	__u64 features;
 
 	__u64 ioctls;
--- a/mm/userfaultfd.c~mm-uffd-enable-write-protection-for-shmem-hugetlbfs
+++ a/mm/userfaultfd.c
@@ -732,15 +732,12 @@ int mwriteprotect_range(struct mm_struct
 
 	err = -ENOENT;
 	dst_vma = find_dst_vma(dst_mm, start, len);
-	/*
-	 * Make sure the vma is not shared, that the dst range is
-	 * both valid and fully within a single existing vma.
-	 */
-	if (!dst_vma || (dst_vma->vm_flags & VM_SHARED))
+
+	if (!dst_vma)
 		goto out_unlock;
 	if (!userfaultfd_wp(dst_vma))
 		goto out_unlock;
-	if (!vma_is_anonymous(dst_vma))
+	if (!vma_can_userfault(dst_vma, dst_vma->vm_flags))
 		goto out_unlock;
 
 	if (is_vm_hugetlb_page(dst_vma)) {
_

Patches currently in -mm which might be from peterx@redhat.com are


