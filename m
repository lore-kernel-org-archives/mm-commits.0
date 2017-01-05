From: akpm@linux-foundation.org
Subject: +
 userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:53:58 -0800
Message-ID: <586d9926.TZYajWPhflPWorSA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36196 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937159AbdAEAyW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: fix __mcopy_atomic_hugetlb retry/error processing
has been added to the -mm tree.  Its filename is
     userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing.patch

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
Subject: userfaultfd: hugetlbfs: fix __mcopy_atomic_hugetlb retry/error processing

The new routine copy_huge_page_from_user() uses kmap_atomic() to map
PAGE_SIZE pages.  However, this prevents page faults in the subsequent
call to copy_from_user().  This is OK in the case where the routine is
copied with mmap_sema held.  However, in another case we want to allow
page faults.  So, add a new argument allow_pagefault to indicate if the
routine should allow page faults.

Link: http://lkml.kernel.org/r/20161216144821.5183-20-aarcange@redhat.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 mm/hugetlb.c       |    2 +-
 mm/memory.c        |   13 ++++++++++---
 mm/userfaultfd.c   |    2 +-
 4 files changed, 14 insertions(+), 6 deletions(-)

diff -puN include/linux/mm.h~userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing include/linux/mm.h
--- a/include/linux/mm.h~userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing
+++ a/include/linux/mm.h
@@ -2398,7 +2398,8 @@ extern void copy_user_huge_page(struct p
 				unsigned int pages_per_huge_page);
 extern long copy_huge_page_from_user(struct page *dst_page,
 				const void __user *usr_src,
-				unsigned int pages_per_huge_page);
+				unsigned int pages_per_huge_page,
+				bool allow_pagefault);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 extern struct page_ext_operations debug_guardpage_ops;
diff -puN mm/hugetlb.c~userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing mm/hugetlb.c
--- a/mm/hugetlb.c~userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing
+++ a/mm/hugetlb.c
@@ -3954,7 +3954,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 
 		ret = copy_huge_page_from_user(page,
 						(const void __user *) src_addr,
-						pages_per_huge_page(h));
+						pages_per_huge_page(h), false);
 
 		/* fallback to copy_from_user outside mmap_sem */
 		if (unlikely(ret)) {
diff -puN mm/memory.c~userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing mm/memory.c
--- a/mm/memory.c~userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing
+++ a/mm/memory.c
@@ -4158,7 +4158,8 @@ void copy_user_huge_page(struct page *ds
 
 long copy_huge_page_from_user(struct page *dst_page,
 				const void __user *usr_src,
-				unsigned int pages_per_huge_page)
+				unsigned int pages_per_huge_page,
+				bool allow_pagefault)
 {
 	void *src = (void *)usr_src;
 	void *page_kaddr;
@@ -4166,11 +4167,17 @@ long copy_huge_page_from_user(struct pag
 	unsigned long ret_val = pages_per_huge_page * PAGE_SIZE;
 
 	for (i = 0; i < pages_per_huge_page; i++) {
-		page_kaddr = kmap_atomic(dst_page + i);
+		if (allow_pagefault)
+			page_kaddr = kmap(dst_page + i);
+		else
+			page_kaddr = kmap_atomic(dst_page + i);
 		rc = copy_from_user(page_kaddr,
 				(const void __user *)(src + i * PAGE_SIZE),
 				PAGE_SIZE);
-		kunmap_atomic(page_kaddr);
+		if (allow_pagefault)
+			kunmap(page_kaddr);
+		else
+			kunmap_atomic(page_kaddr);
 
 		ret_val -= (PAGE_SIZE - rc);
 		if (rc)
diff -puN mm/userfaultfd.c~userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing
+++ a/mm/userfaultfd.c
@@ -274,7 +274,7 @@ retry:
 
 			err = copy_huge_page_from_user(page,
 						(const void __user *)src_addr,
-						pages_per_huge_page(h));
+						pages_per_huge_page(h), true);
 			if (unlikely(err)) {
 				err = -EFAULT;
 				goto out;
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

