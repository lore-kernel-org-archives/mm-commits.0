From: akpm@linux-foundation.org
Subject: [patch 061/142] userfaultfd: hugetlbfs: add
 copy_huge_page_from_user for hugetlb userfaultfd support
Date: Wed, 22 Feb 2017 15:42:49 -0800
Message-ID: <58ae21f9.dxL8pf9rTn5xYoVL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48526 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934662AbdBVXnA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:43:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mike.kravetz@oracle.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, xemul@parallels.com

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: userfaultfd: hugetlbfs: add copy_huge_page_from_user for hugetlb userfaultfd support

userfaultfd UFFDIO_COPY allows user level code to copy data to a page at
fault time.  The data is copied from user space to a newly allocated huge
page.  The new routine copy_huge_page_from_user performs this copy.

Link: http://lkml.kernel.org/r/20161216144821.5183-17-aarcange@redhat.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +++
 mm/memory.c        |   25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff -puN include/linux/mm.h~userfaultfd-hugetlbfs-add-copy_huge_page_from_user-for-hugetlb-userfaultfd-support include/linux/mm.h
--- a/include/linux/mm.h~userfaultfd-hugetlbfs-add-copy_huge_page_from_user-for-hugetlb-userfaultfd-support
+++ a/include/linux/mm.h
@@ -2424,6 +2424,9 @@ extern void clear_huge_page(struct page
 extern void copy_user_huge_page(struct page *dst, struct page *src,
 				unsigned long addr, struct vm_area_struct *vma,
 				unsigned int pages_per_huge_page);
+extern long copy_huge_page_from_user(struct page *dst_page,
+				const void __user *usr_src,
+				unsigned int pages_per_huge_page);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 extern struct page_ext_operations debug_guardpage_ops;
diff -puN mm/memory.c~userfaultfd-hugetlbfs-add-copy_huge_page_from_user-for-hugetlb-userfaultfd-support mm/memory.c
--- a/mm/memory.c~userfaultfd-hugetlbfs-add-copy_huge_page_from_user-for-hugetlb-userfaultfd-support
+++ a/mm/memory.c
@@ -4152,6 +4152,31 @@ void copy_user_huge_page(struct page *ds
 		copy_user_highpage(dst + i, src + i, addr + i*PAGE_SIZE, vma);
 	}
 }
+
+long copy_huge_page_from_user(struct page *dst_page,
+				const void __user *usr_src,
+				unsigned int pages_per_huge_page)
+{
+	void *src = (void *)usr_src;
+	void *page_kaddr;
+	unsigned long i, rc = 0;
+	unsigned long ret_val = pages_per_huge_page * PAGE_SIZE;
+
+	for (i = 0; i < pages_per_huge_page; i++) {
+		page_kaddr = kmap_atomic(dst_page + i);
+		rc = copy_from_user(page_kaddr,
+				(const void __user *)(src + i * PAGE_SIZE),
+				PAGE_SIZE);
+		kunmap_atomic(page_kaddr);
+
+		ret_val -= (PAGE_SIZE - rc);
+		if (rc)
+			break;
+
+		cond_resched();
+	}
+	return ret_val;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #if USE_SPLIT_PTE_PTLOCKS && ALLOC_SPLIT_PTLOCKS
_
