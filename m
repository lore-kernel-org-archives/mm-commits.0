From: akpm@linux-foundation.org
Subject: +
 mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code-define-hpage_pmd_-constants-as-build_bug-if-thp.patch added to -mm tree
Date: Mon, 17 Jun 2013 15:33:31 -0700
Message-ID: <51bf8ebb.1r5BaCWr0udE5dY9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3FQWdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jun 2013 18:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, david@gibson.dropbear.id.au, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code-define-hpage_pmd_-constants-as-build_bug-if-thp.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,david@gibson.dropbear.id.au
From: akpm@linux-foundation.org
Date: Mon, 17 Jun 2013 15:33:31 -0700


The patch titled
     Subject: thp: define HPAGE_PMD_* constants as BUILD_BUG() if !THP
has been added to the -mm tree.  Its filename is
     mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code-define-hpage_pmd_-constants-as-build_bug-if-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: define HPAGE_PMD_* constants as BUILD_BUG() if !THP

Currently, HPAGE_PMD_* constans rely on PMD_SHIFT regardless of
CONFIG_TRANSPARENT_HUGEPAGE.  PMD_SHIFT is not defined everywhere (e.g. 
arm nommu case).

It means we can't use anything like this in generic code:

        if (PageTransHuge(page))
                zero_huge_user(page, 0, HPAGE_PMD_SIZE);
        else
                clear_highpage(page);

For !THP case, PageTransHuge() is 0 and compiler can eliminate
zero_huge_user() call.  But it still need to be valid C expression, means
HPAGE_PMD_SIZE has to expand to something compiler can understand.

Previously, HPAGE_PMD_* were defined to BUILD_BUG() for !THP. Let's come
back to it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/huge_mm.h~mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code-define-hpage_pmd_-constants-as-build_bug-if-thp include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code-define-hpage_pmd_-constants-as-build_bug-if-thp
+++ a/include/linux/huge_mm.h
@@ -58,11 +58,12 @@ extern pmd_t *page_check_address_pmd(str
 
 #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
 #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define HPAGE_PMD_SHIFT PMD_SHIFT
 #define HPAGE_PMD_SIZE	((1UL) << HPAGE_PMD_SHIFT)
 #define HPAGE_PMD_MASK	(~(HPAGE_PMD_SIZE - 1))
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 
 #define transparent_hugepage_enabled(__vma)				\
@@ -180,6 +181,9 @@ extern int do_huge_pmd_numa_page(struct
 				unsigned long addr, pmd_t pmd, pmd_t *pmdp);
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
+#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
+#define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
+#define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
 
 #define hpage_nr_pages(x) 1
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code-define-hpage_pmd_-constants-as-build_bug-if-thp.patch
fs-fs-writebackc-make-wb_do_writeback-as-static.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch

