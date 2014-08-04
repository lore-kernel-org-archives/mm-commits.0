From: akpm@linux-foundation.org
Subject: + mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
 added to -mm tree
Date: Mon, 04 Aug 2014 15:33:43 -0700
Message-ID: <53e00a47.v4Ur+5ofsi0WwToi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:59055 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaHDWdo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2014 18:33:44 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so23881oif.4
        for <mm-commits@vger.kernel.org>; Mon, 04 Aug 2014 15:33:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, akpm@linux-foundation.org, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove unused argument of follow_huge_(pmd|pud)
has been added to the -mm tree.  Its filename is
     mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb: remove unused argument of follow_huge_(pmd|pud)

There is no implementation of follow_huge_pmd() which actually uses the
fourth argument "write".  So let's zap it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/hugetlbpage.c    |    2 +-
 arch/metag/mm/hugetlbpage.c   |    2 +-
 arch/mips/mm/hugetlbpage.c    |    2 +-
 arch/powerpc/mm/hugetlbpage.c |    2 +-
 arch/s390/mm/hugetlbpage.c    |    2 +-
 arch/sh/mm/hugetlbpage.c      |    2 +-
 arch/sparc/mm/hugetlbpage.c   |    2 +-
 arch/tile/mm/hugetlbpage.c    |    4 ++--
 arch/x86/mm/hugetlbpage.c     |    2 +-
 include/linux/hugetlb.h       |    8 ++++----
 mm/gup.c                      |    2 +-
 mm/hugetlb.c                  |   11 ++++-------
 12 files changed, 19 insertions(+), 22 deletions(-)

diff -puN arch/ia64/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -115,7 +115,7 @@ int pud_huge(pud_t pud)
 }
 
 struct page *
-follow_huge_pmd(struct mm_struct *mm, unsigned long address, pmd_t *pmd, int write)
+follow_huge_pmd(struct mm_struct *mm, unsigned long address, pmd_t *pmd)
 {
 	return NULL;
 }
diff -puN arch/metag/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud arch/metag/mm/hugetlbpage.c
--- a/arch/metag/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud
+++ a/arch/metag/mm/hugetlbpage.c
@@ -111,7 +111,7 @@ int pud_huge(pud_t pud)
 }
 
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-			     pmd_t *pmd, int write)
+			     pmd_t *pmd)
 {
 	return NULL;
 }
diff -puN arch/mips/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud arch/mips/mm/hugetlbpage.c
--- a/arch/mips/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud
+++ a/arch/mips/mm/hugetlbpage.c
@@ -86,7 +86,7 @@ int pud_huge(pud_t pud)
 
 struct page *
 follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd, int write)
+		pmd_t *pmd)
 {
 	struct page *page;
 
diff -puN arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -700,7 +700,7 @@ follow_huge_addr(struct mm_struct *mm, u
 
 struct page *
 follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd, int write)
+		pmd_t *pmd)
 {
 	BUG();
 	return NULL;
diff -puN arch/s390/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud arch/s390/mm/hugetlbpage.c
--- a/arch/s390/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud
+++ a/arch/s390/mm/hugetlbpage.c
@@ -221,7 +221,7 @@ int pud_huge(pud_t pud)
 }
 
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-			     pmd_t *pmdp, int write)
+			     pmd_t *pmdp)
 {
 	struct page *page;
 
diff -puN arch/sh/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud arch/sh/mm/hugetlbpage.c
--- a/arch/sh/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud
+++ a/arch/sh/mm/hugetlbpage.c
@@ -84,7 +84,7 @@ int pud_huge(pud_t pud)
 }
 
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-			     pmd_t *pmd, int write)
+			     pmd_t *pmd)
 {
 	return NULL;
 }
diff -puN arch/sparc/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud arch/sparc/mm/hugetlbpage.c
--- a/arch/sparc/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -232,7 +232,7 @@ int pud_huge(pud_t pud)
 }
 
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-			     pmd_t *pmd, int write)
+			     pmd_t *pmd)
 {
 	return NULL;
 }
diff -puN arch/tile/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud arch/tile/mm/hugetlbpage.c
--- a/arch/tile/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud
+++ a/arch/tile/mm/hugetlbpage.c
@@ -167,7 +167,7 @@ int pud_huge(pud_t pud)
 }
 
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-			     pmd_t *pmd, int write)
+			     pmd_t *pmd)
 {
 	struct page *page;
 
@@ -178,7 +178,7 @@ struct page *follow_huge_pmd(struct mm_s
 }
 
 struct page *follow_huge_pud(struct mm_struct *mm, unsigned long address,
-			     pud_t *pud, int write)
+			     pud_t *pud)
 {
 	struct page *page;
 
diff -puN arch/x86/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud
+++ a/arch/x86/mm/hugetlbpage.c
@@ -54,7 +54,7 @@ int pud_huge(pud_t pud)
 
 struct page *
 follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd, int write)
+		pmd_t *pmd)
 {
 	return NULL;
 }
diff -puN include/linux/hugetlb.h~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud
+++ a/include/linux/hugetlb.h
@@ -99,9 +99,9 @@ int huge_pmd_unshare(struct mm_struct *m
 struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
 			      int write);
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-				pmd_t *pmd, int write);
+				pmd_t *pmd);
 struct page *follow_huge_pud(struct mm_struct *mm, unsigned long address,
-				pud_t *pud, int write);
+				pud_t *pud);
 struct page *follow_huge_pmd_lock(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmd, int flags);
 int pmd_huge(pmd_t pmd);
@@ -135,8 +135,8 @@ static inline void hugetlb_report_meminf
 static inline void hugetlb_show_meminfo(void)
 {
 }
-#define follow_huge_pmd(mm, addr, pmd, write)	NULL
-#define follow_huge_pud(mm, addr, pud, write)	NULL
+#define follow_huge_pmd(mm, addr, pmd)	NULL
+#define follow_huge_pud(mm, addr, pud)	NULL
 #define follow_huge_pmd_lock(vma, addr, pmd, flags)	NULL
 #define prepare_hugepage_range(file, addr, len)	(-EINVAL)
 #define pmd_huge(x)	0
diff -puN mm/gup.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud mm/gup.c
--- a/mm/gup.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud
+++ a/mm/gup.c
@@ -165,7 +165,7 @@ struct page *follow_page_mask(struct vm_
 	if (pud_huge(*pud) && vma->vm_flags & VM_HUGETLB) {
 		if (flags & FOLL_GET)
 			return NULL;
-		page = follow_huge_pud(mm, address, pud, flags & FOLL_WRITE);
+		page = follow_huge_pud(mm, address, pud);
 		return page;
 	}
 	if (unlikely(pud_bad(*pud)))
diff -puN mm/hugetlb.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud
+++ a/mm/hugetlb.c
@@ -3660,8 +3660,7 @@ pte_t *huge_pte_offset(struct mm_struct
 }
 
 struct page *
-follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd, int write)
+follow_huge_pmd(struct mm_struct *mm, unsigned long address, pmd_t *pmd)
 {
 	struct page *page;
 
@@ -3672,8 +3671,7 @@ follow_huge_pmd(struct mm_struct *mm, un
 }
 
 struct page *
-follow_huge_pud(struct mm_struct *mm, unsigned long address,
-		pud_t *pud, int write)
+follow_huge_pud(struct mm_struct *mm, unsigned long address, pud_t *pud)
 {
 	struct page *page;
 
@@ -3687,8 +3685,7 @@ follow_huge_pud(struct mm_struct *mm, un
 
 /* Can be overriden by architectures */
 struct page * __weak
-follow_huge_pud(struct mm_struct *mm, unsigned long address,
-	       pud_t *pud, int write)
+follow_huge_pud(struct mm_struct *mm, unsigned long address, pud_t *pud)
 {
 	BUG();
 	return NULL;
@@ -3705,7 +3702,7 @@ struct page *follow_huge_pmd_lock(struct
 	if (flags & FOLL_GET)
 		ptl = huge_pte_lock(hstate_vma(vma), vma->vm_mm, (pte_t *)pmd);
 
-	page = follow_huge_pmd(vma->vm_mm, address, pmd, flags & FOLL_WRITE);
+	page = follow_huge_pmd(vma->vm_mm, address, pmd);
 
 	if (flags & FOLL_GET) {
 		/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
mm-update-the-description-for-madvise_remove.patch
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
hwpoison-fix-race-with-changing-page-during-offlining-v2.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages.patch
mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages-fix.patch
mm-softdirty-respect-vm_softdirty-in-pte-holes.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

