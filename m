From: akpm@linux-foundation.org
Subject: + thp-handle-errors-in-hugepage_init-properly.patch added to -mm
 tree
Date: Thu, 26 Mar 2015 12:50:47 -0700
Message-ID: <55146317.x0KGVRUnwC4cg4Ad%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbbCZTus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Mar 2015 15:50:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: handle errors in hugepage_init() properly
has been added to the -mm tree.  Its filename is
     thp-handle-errors-in-hugepage_init-properly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-handle-errors-in-hugepage_init-properly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-handle-errors-in-hugepage_init-properly.patch

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
Subject: thp: handle errors in hugepage_init() properly

We miss error-handling in few cases hugepage_init(). Let's fix that.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff -puN mm/huge_memory.c~thp-handle-errors-in-hugepage_init-properly mm/huge_memory.c
--- a/mm/huge_memory.c~thp-handle-errors-in-hugepage_init-properly
+++ a/mm/huge_memory.c
@@ -67,6 +67,7 @@ static unsigned int khugepaged_max_ptes_
 
 static int khugepaged(void *none);
 static int khugepaged_slab_init(void);
+static void khugepaged_slab_exit(void);
 
 #define MM_SLOTS_HASH_BITS 10
 static __read_mostly DEFINE_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
@@ -634,13 +635,15 @@ static int __init hugepage_init(void)
 
 	err = hugepage_init_sysfs(&hugepage_kobj);
 	if (err)
-		return err;
+		goto err_sysfs;
 
 	err = khugepaged_slab_init();
 	if (err)
-		goto out;
+		goto err_slab;
 
-	register_shrinker(&huge_zero_page_shrinker);
+	err = register_shrinker(&huge_zero_page_shrinker);
+	if (err)
+		goto err_hzp_shrinker;
 
 	/*
 	 * By default disable transparent hugepages on smaller systems,
@@ -650,11 +653,18 @@ static int __init hugepage_init(void)
 	if (totalram_pages < (512 << (20 - PAGE_SHIFT)))
 		transparent_hugepage_flags = 0;
 
-	start_khugepaged();
+	err = start_khugepaged();
+	if (err)
+		goto err_khugepaged;
 
 	return 0;
-out:
+err_khugepaged:
+	unregister_shrinker(&huge_zero_page_shrinker);
+err_hzp_shrinker:
+	khugepaged_slab_exit();
+err_slab:
 	hugepage_exit_sysfs(hugepage_kobj);
+err_sysfs:
 	return err;
 }
 subsys_initcall(hugepage_init);
@@ -1974,6 +1984,11 @@ static int __init khugepaged_slab_init(v
 	return 0;
 }
 
+static void __init khugepaged_slab_exit(void)
+{
+	kmem_cache_destroy(mm_slot_cache);
+}
+
 static inline struct mm_slot *alloc_mm_slot(void)
 {
 	if (!mm_slot_cache)	/* initialization failed */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
alpha-expose-number-of-page-table-levels-on-kconfig-level.patch
arm64-expose-number-of-page-table-levels-on-kconfig-level.patch
arm-expose-number-of-page-table-levels-on-kconfig-level.patch
ia64-expose-number-of-page-table-levels-on-kconfig-level.patch
m68k-mark-pmd-folded-and-expose-number-of-page-table-levels.patch
mips-expose-number-of-page-table-levels-on-kconfig-level.patch
parisc-expose-number-of-page-table-levels-on-kconfig-level.patch
powerpc-expose-number-of-page-table-levels-on-kconfig-level.patch
s390-expose-number-of-page-table-levels.patch
sh-expose-number-of-page-table-levels.patch
sparc-expose-number-of-page-table-levels.patch
tile-expose-number-of-page-table-levels.patch
um-expose-number-of-page-table-levels.patch
x86-expose-number-of-page-table-levels-on-kconfig-level.patch
mm-define-default-pgtable_levels-to-two.patch
mm-do-not-add-nr_pmds-into-mm_struct-if-pmd-is-folded.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
thp-handle-errors-in-hugepage_init-properly.patch
linux-next.patch

