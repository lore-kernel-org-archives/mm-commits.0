From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:14:04 -0800
Message-ID: <58af509c.yZUiz4YrqNpPJUb0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751265AbdBWVOs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:14:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dan.carpenter@oracle.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, hughd@google.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: fix __mcopy_atomic_hugetlb retry/error processing
has been removed from the -mm tree.  Its filename was
     userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: userfaultfd: hugetlbfs: fix __mcopy_atomic_hugetlb retry/error processing

The new routine copy_huge_page_from_user() uses kmap_atomic() to map
PAGE_SIZE pages.  However, this prevents page faults in the subsequent
call to copy_from_user().  This is OK in the case where the routine is
copied with mmap_sema held.  However, in another case we want to allow
page faults.  So, add a new argument allow_pagefault to indicate if the
routine should allow page faults.

[dan.carpenter@oracle.com: unmap the correct pointer]
  Link: http://lkml.kernel.org/r/20170113082608.GA3548@mwanda
[akpm@linux-foundation.org: kunmap() takes a page*, per Hugh]
Link: http://lkml.kernel.org/r/20161216144821.5183-20-aarcange@redhat.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hugh Dickins <hughd@google.com>
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
@@ -2426,7 +2426,8 @@ extern void copy_user_huge_page(struct p
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
@@ -3973,7 +3973,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 
 		ret = copy_huge_page_from_user(page,
 						(const void __user *) src_addr,
-						pages_per_huge_page(h));
+						pages_per_huge_page(h), false);
 
 		/* fallback to copy_from_user outside mmap_sem */
 		if (unlikely(ret)) {
diff -puN mm/memory.c~userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing mm/memory.c
--- a/mm/memory.c~userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing
+++ a/mm/memory.c
@@ -4155,7 +4155,8 @@ void copy_user_huge_page(struct page *ds
 
 long copy_huge_page_from_user(struct page *dst_page,
 				const void __user *usr_src,
-				unsigned int pages_per_huge_page)
+				unsigned int pages_per_huge_page,
+				bool allow_pagefault)
 {
 	void *src = (void *)usr_src;
 	void *page_kaddr;
@@ -4163,11 +4164,17 @@ long copy_huge_page_from_user(struct pag
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
+			kunmap(dst_page + i);
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


