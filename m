From: akpm@linux-foundation.org
Subject: [merged] thp-handle-errors-in-hugepage_init-properly.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:21 -0700
Message-ID: <552fe8c5.QsJbIz3/nHUBEyXU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbbDPQqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: handle errors in hugepage_init() properly
has been removed from the -mm tree.  Its filename was
     thp-handle-errors-in-hugepage_init-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
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
linux-next.patch

