From: akpm@linux-foundation.org
Subject: + hugetlb-replace-bug-with-build_bug-for-dummy-definitions.patch added to -mm tree
Date: Tue, 22 Nov 2011 12:09:45 -0800
Message-ID: <201111222009.pAMK9kWM003171@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:38680 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab1KVUJu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 15:09:50 -0500
Received: by wwe5 with SMTP id 5so21963wwe.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 12:09:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.daney@cavium.com, dm.n9107@gmail.com, ralf@linux-mips.org, rientjes@google.com


The patch titled
     Subject: hugetlb: replace BUG() with BUILD_BUG() for dummy definitions
has been added to the -mm tree.  Its filename is
     hugetlb-replace-bug-with-build_bug-for-dummy-definitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Daney <david.daney@cavium.com>
Subject: hugetlb: replace BUG() with BUILD_BUG() for dummy definitions

The file linux/hugetlb.h has many places where dummy symbols were defined
so that the main source code would contain fewer:

    #ifdef CONFIG_HUGETLBFS

or

    #ifdef CONFIG_TRANSPARENT_HUGEPAGE

If there were any misuse of these symbols, the only symptom would be an
OOPS at runtime.  Change the BUG() to BUILD_BUG() to catch any such abuse
at compile time instead.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: David Rientjes <rientjes@google.com>
Cc: DM <dm.n9107@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    8 ++++----
 include/linux/hugetlb.h |   14 +++++++-------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/huge_mm.h~hugetlb-replace-bug-with-build_bug-for-dummy-definitions include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~hugetlb-replace-bug-with-build_bug-for-dummy-definitions
+++ a/include/linux/huge_mm.h
@@ -145,10 +145,10 @@ static inline struct page *compound_tran
 	}
 	return page;
 }
-#else /* CONFIG_TRANSPARENT_HUGEPAGE */
-#define HPAGE_PMD_SHIFT ({ BUG(); 0; })
-#define HPAGE_PMD_MASK ({ BUG(); 0; })
-#define HPAGE_PMD_SIZE ({ BUG(); 0; })
+#else /* !CONFIG_TRANSPARENT_HUGEPAGE */
+#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
+#define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
+#define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
 
 #define hpage_nr_pages(x) 1
 
diff -puN include/linux/hugetlb.h~hugetlb-replace-bug-with-build_bug-for-dummy-definitions include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-replace-bug-with-build_bug-for-dummy-definitions
+++ a/include/linux/hugetlb.h
@@ -85,11 +85,11 @@ static inline unsigned long hugetlb_tota
 	return 0;
 }
 
-#define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUG(); 0; })
+#define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUILD_BUG(); 0; })
 #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
-#define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
-#define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
-#define unmap_hugepage_range(vma, start, end, page)	BUG()
+#define copy_hugetlb_page_range(src, dst, vma)	({ BUILD_BUG(); 0; })
+#define hugetlb_prefault(mapping, vma)		({ BUILD_BUG(); 0; })
+#define unmap_hugepage_range(vma, start, end, page)	BUILD_BUG()
 static inline void hugetlb_report_meminfo(struct seq_file *m)
 {
 }
@@ -100,8 +100,8 @@ static inline void hugetlb_report_meminf
 #define pmd_huge(x)	0
 #define pud_huge(x)	0
 #define is_hugepage_only_range(mm, addr, len)	0
-#define hugetlb_free_pgd_range(tlb, addr, end, floor, ceiling) ({BUG(); 0; })
-#define hugetlb_fault(mm, vma, addr, flags)	({ BUG(); 0; })
+#define hugetlb_free_pgd_range(tlb, addr, end, f, c) ({BUILD_BUG(); 0; })
+#define hugetlb_fault(mm, vma, addr, flags)	({ BUILD_BUG(); 0; })
 #define huge_pte_offset(mm, address)	0
 #define dequeue_hwpoisoned_huge_page(page)	0
 static inline void copy_huge_page(struct page *dst, struct page *src)
@@ -186,7 +186,7 @@ static inline void set_file_hugepages(st
 #else /* !CONFIG_HUGETLBFS */
 
 #define is_file_hugepages(file)			0
-#define set_file_hugepages(file)		BUG()
+#define set_file_hugepages(file)		BUILD_BUG()
 static inline struct file *hugetlb_file_setup(const char *name, size_t size,
 		vm_flags_t acctflag, struct user_struct **user, int creat_flags)
 {
_
Subject: Subject: hugetlb: replace BUG() with BUILD_BUG() for dummy definitions

Patches currently in -mm which might be from david.daney@cavium.com are

origin.patch
linux-next.patch
kernelh-add-build_bug-macro.patch
hugetlb-replace-bug-with-build_bug-for-dummy-definitions.patch

