Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0239C43219
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1845644AbiDFB6B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346941AbiDEUeI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:34:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0B3FD6EE
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D4B8619BF
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4538C385A1;
        Tue,  5 Apr 2022 20:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189839;
        bh=swoSdg3v5BA8Iw0OQv47T2Q/KKPOLMQ/RpxsXOBJuiY=;
        h=Date:To:From:Subject:From;
        b=kDB1xqgotj4HLkAgAUR2JHi8q63c6ygf53btq+WeGEtdZqMxiP4CBHvrtTwvlZCqm
         pfLu8ADpB5VmXsGoRTBfxDzQBhhO6jM+Z/nWs2O9Gmz8Ta9nOoPZAF1CWKNP7cw8PF
         2eb/5sJLRc5iMitZjy44ZtoV4YWh11HX6nrnCadU=
Date:   Tue, 05 Apr 2022 13:17:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch added to -mm tree
Message-Id: <20220405201718.E4538C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/uffd: enable write protection for shmem & hugetlbfs
has been added to the -mm tree.  Its filename is
     mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1257,24 +1257,6 @@ static __always_inline int validate_rang
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
@@ -1956,6 +1938,9 @@ static int userfaultfd_api(struct userfa
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

mm-introduce-pte_marker-swap-entry.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-uffd-pte_marker_uffd_wp.patch
mm-shmem-take-care-of-uffdio_copy_mode_wp.patch
mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch
mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed.patch
mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem.patch
mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch
mm-shmem-handle-uffd-wp-during-fork.patch
mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch
mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch
mm-hugetlb-take-care-of-uffdio_copy_mode_wp.patch
mm-hugetlb-handle-uffdio_writeprotect.patch
mm-hugetlb-handle-pte-markers-in-page-faults.patch
mm-hugetlb-allow-uffd-wr-protect-none-ptes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch

