From: akpm@linux-foundation.org
Subject: +
 mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast.patch added
 to -mm tree
Date: Thu, 22 Jan 2015 15:12:12 -0800
Message-ID: <54c183cc.+xt4pDsxWk6t6/w1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbbAVXMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 18:12:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, pfeiner@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: use get_user_pages_unlocked within get_user_pages_fast
has been added to the -mm tree.  Its filename is
     mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: gup: use get_user_pages_unlocked within get_user_pages_fast

This allows the get_user_pages_fast slow path to release the mmap_sem
before blocking.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/gup.c  |    8 +++-----
 arch/s390/mm/gup.c  |    6 ++----
 arch/sh/mm/gup.c    |    6 ++----
 arch/sparc/mm/gup.c |    6 ++----
 arch/x86/mm/gup.c   |    7 +++----
 mm/gup.c            |    6 ++----
 mm/util.c           |   10 ++--------
 7 files changed, 16 insertions(+), 33 deletions(-)

diff -puN arch/mips/mm/gup.c~mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast arch/mips/mm/gup.c
--- a/arch/mips/mm/gup.c~mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast
+++ a/arch/mips/mm/gup.c
@@ -301,11 +301,9 @@ slow_irqon:
 	start += nr << PAGE_SHIFT;
 	pages += nr;
 
-	down_read(&mm->mmap_sem);
-	ret = get_user_pages(current, mm, start,
-				(end - start) >> PAGE_SHIFT,
-				write, 0, pages, NULL);
-	up_read(&mm->mmap_sem);
+	ret = get_user_pages_unlocked(current, mm, start,
+				      (end - start) >> PAGE_SHIFT,
+				      write, 0, pages);
 
 	/* Have to be a bit careful with return values */
 	if (nr > 0) {
diff -puN arch/s390/mm/gup.c~mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast arch/s390/mm/gup.c
--- a/arch/s390/mm/gup.c~mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast
+++ a/arch/s390/mm/gup.c
@@ -235,10 +235,8 @@ int get_user_pages_fast(unsigned long st
 	/* Try to get the remaining pages with get_user_pages */
 	start += nr << PAGE_SHIFT;
 	pages += nr;
-	down_read(&mm->mmap_sem);
-	ret = get_user_pages(current, mm, start,
-			     nr_pages - nr, write, 0, pages, NULL);
-	up_read(&mm->mmap_sem);
+	ret = get_user_pages_unlocked(current, mm, start,
+			     nr_pages - nr, write, 0, pages);
 	/* Have to be a bit careful with return values */
 	if (nr > 0)
 		ret = (ret < 0) ? nr : ret + nr;
diff -puN arch/sh/mm/gup.c~mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast arch/sh/mm/gup.c
--- a/arch/sh/mm/gup.c~mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast
+++ a/arch/sh/mm/gup.c
@@ -257,10 +257,8 @@ slow_irqon:
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		down_read(&mm->mmap_sem);
-		ret = get_user_pages(current, mm, start,
-			(end - start) >> PAGE_SHIFT, write, 0, pages, NULL);
-		up_read(&mm->mmap_sem);
+		ret = get_user_pages_unlocked(current, mm, start,
+			(end - start) >> PAGE_SHIFT, write, 0, pages);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff -puN arch/sparc/mm/gup.c~mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast arch/sparc/mm/gup.c
--- a/arch/sparc/mm/gup.c~mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast
+++ a/arch/sparc/mm/gup.c
@@ -249,10 +249,8 @@ slow:
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		down_read(&mm->mmap_sem);
-		ret = get_user_pages(current, mm, start,
-			(end - start) >> PAGE_SHIFT, write, 0, pages, NULL);
-		up_read(&mm->mmap_sem);
+		ret = get_user_pages_unlocked(current, mm, start,
+			(end - start) >> PAGE_SHIFT, write, 0, pages);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff -puN arch/x86/mm/gup.c~mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast
+++ a/arch/x86/mm/gup.c
@@ -388,10 +388,9 @@ slow_irqon:
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		down_read(&mm->mmap_sem);
-		ret = get_user_pages(current, mm, start,
-			(end - start) >> PAGE_SHIFT, write, 0, pages, NULL);
-		up_read(&mm->mmap_sem);
+		ret = get_user_pages_unlocked(current, mm, start,
+					      (end - start) >> PAGE_SHIFT,
+					      write, 0, pages);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff -puN mm/gup.c~mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast mm/gup.c
--- a/mm/gup.c~mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast
+++ a/mm/gup.c
@@ -1243,10 +1243,8 @@ int get_user_pages_fast(unsigned long st
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		down_read(&mm->mmap_sem);
-		ret = get_user_pages(current, mm, start,
-				     nr_pages - nr, write, 0, pages, NULL);
-		up_read(&mm->mmap_sem);
+		ret = get_user_pages_unlocked(current, mm, start,
+					      nr_pages - nr, write, 0, pages);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff -puN mm/util.c~mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast mm/util.c
--- a/mm/util.c~mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast
+++ a/mm/util.c
@@ -240,14 +240,8 @@ int __weak get_user_pages_fast(unsigned
 				int nr_pages, int write, struct page **pages)
 {
 	struct mm_struct *mm = current->mm;
-	int ret;
-
-	down_read(&mm->mmap_sem);
-	ret = get_user_pages(current, mm, start, nr_pages,
-					write, 0, pages, NULL);
-	up_read(&mm->mmap_sem);
-
-	return ret;
+	return get_user_pages_unlocked(current, mm, start, nr_pages,
+				       write, 0, pages);
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
mm-thp-allocate-transparent-hugepages-on-local-node.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked.patch
mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags.patch
mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast.patch
mm-gup-use-get_user_pages_unlocked.patch
mm-gup-kvm-use-get_user_pages_unlocked.patch

