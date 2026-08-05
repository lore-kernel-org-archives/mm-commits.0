Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7901C36196A;
	Wed,  5 Aug 2026 03:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785898980; cv=none; b=iV3obtpZmCxi4ztQHn8w9zSDnzgAIm+JCJOQo98k4kUGOkqE3HHB1emQeMKPHBNUemTAygo9W8OLrN6AgWnDKc5AvKZ2xvb90XEz8vMWOfAcGanq74UL18zwnjcphjdZq5ksJFDQR9ahC1QxN+FswdQgvphqO9pqT5ZiIUnb0qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785898980; c=relaxed/simple;
	bh=gmmwKJPYSQR8vsJrhYGLy7l42KbsnCaFPBVNhQDfhCs=;
	h=Date:To:From:Subject:Message-Id; b=eGQp7uO4/4z8Uwo6xCOJS/vrKwwTJgLkfKG/ie5esgmVMToCMzXU2BpbjYswfOYlMSI/GAZbej1Oijf4E/YUAf+8PnCxLOqAmNdWjU00jFicO7fSqYeB1BQXmjWysirjY9f55WzX/icJUqDzTmFYCIxEATys7SqNpOPsUDLiUFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KMZXO2iN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KMZXO2iN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5C01F00A3A;
	Wed,  5 Aug 2026 03:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785898978;
	bh=jGV8EWzZNF3a2hLfwZKA4LufDsw8PjIWZuUZEUfs9kE=;
	h=Date:To:From:Subject;
	b=KMZXO2iNbwUJxLfSUZ1EJQez+Id7bnFLgCSPoXpU2YM2IvVIYHCFJTOPKBEapixPy
	 HDbdzmswQlNrvRObVjQB/0qL/GIBH1O6IttnRpzuouPoyYLs9syb0fLR3mgyJxRUVi
	 T7eNQo2qhRwlCEJEnLItBN5NVCXqOYDfWRAF77tA=
Date: Tue, 04 Aug 2026 20:02:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,uqbarz@gmail.com,stable@vger.kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,npache@redhat.com,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,hughd@google.com,hare@suse.de,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-separate-out-config_persistent_huge_zero_folio-logic.patch removed from -mm tree
Message-Id: <20260805030257.DC5C01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: separate out CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-separate-out-config_persistent_huge_zero_folio-logic.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/huge_memory: separate out CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic
Date: Thu, 30 Jul 2026 11:55:48 +0100

Rather than mixing the refcounted and non-refcounted
CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic, separate the two out cleanly so
it is clear what happens when this configuration option is set and what
happens when it is not.

Introduce HUGE_ZERO_UNSET_PFN to abstract the ~0UL assignment, only
introduce the refcount, lock and shrinker if
!CONFIG_PERSISTENT_HUGE_ZERO_FOLIO, abstract initialisation and teardown,
abstract the huge zero folio allocation from refcounting.

Also change a BUG_ON() to WARN_ON_ONCE() while we're at it.

No functional change intended.

Link: https://lore.kernel.org/20260730-fix-refcounted-huge-zero-v2-2-c5d8a41b317f@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Fixes: 3b77e8c8cde5 ("mm/thp: make is_huge_zero_pmd() safe and quicker")
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Hengbin Zhang <uqbarz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |  160 ++++++++++++++++++++++++++-------------------
 1 file changed, 94 insertions(+), 66 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-separate-out-config_persistent_huge_zero_folio-logic
+++ a/mm/huge_memory.c
@@ -78,10 +78,15 @@ static unsigned long deferred_split_scan
 					 struct shrink_control *sc);
 static bool split_underused_thp = true;
 
+#define HUGE_ZERO_UNSET_PFN (~0UL)
+struct folio *huge_zero_folio __read_mostly;
+unsigned long huge_zero_pfn __read_mostly = HUGE_ZERO_UNSET_PFN;
+#ifndef CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
 static atomic_t huge_zero_refcount;
 static DEFINE_SPINLOCK(huge_zero_lock);
-struct folio *huge_zero_folio __read_mostly;
-unsigned long huge_zero_pfn __read_mostly = ~0UL;
+static struct shrinker *huge_zero_folio_shrinker;
+#endif
+
 unsigned long huge_anon_orders_always __read_mostly;
 unsigned long huge_anon_orders_madvise __read_mostly;
 unsigned long huge_anon_orders_inherit __read_mostly;
@@ -223,23 +228,58 @@ unsigned long __thp_vma_allowable_orders
 	return orders;
 }
 
-static bool get_huge_zero_folio(void)
+static struct folio *alloc_huge_zero_folio(void)
 {
 	struct folio *zero_folio;
 
-	/* Paired with atomic_set_release(). */
-	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
-		return true;
-
 	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
 				 ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
 	if (!zero_folio) {
 		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
-		return false;
+		return NULL;
+	}
+	folio_clear_large_rmappable(zero_folio); /* Explicitly not rmappable. */
+	return zero_folio;
+}
+
+#ifdef CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
+static int __init huge_zero_init(void)
+{
+	huge_zero_folio = alloc_huge_zero_folio();
+	if (!huge_zero_folio) {
+		pr_warn("Allocating persistent huge zero folio failed\n");
+	} else {
+		huge_zero_pfn = folio_pfn(huge_zero_folio);
+		count_vm_event(THP_ZERO_PAGE_ALLOC);
 	}
-	/* Ensure zero folio won't have large_rmappable flag set. */
-	folio_clear_large_rmappable(zero_folio);
+	return 0;
+}
+
+static void __init huge_zero_shrinker_exit(void)
+{
+}
+
+struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
+{
+	return huge_zero_folio;
+}
+
+void mm_put_huge_zero_folio(struct mm_struct *mm)
+{
+}
+#else
+static bool get_huge_zero_folio(void)
+{
+	struct folio *zero_folio;
+
+	/* Paired with atomic_set_release(). */
+	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
+		return true;
+
+	zero_folio = alloc_huge_zero_folio();
+	if (unlikely(!zero_folio))
+		return false;
 
 	/* Paired with critical section in shrink_huge_zero_folio_scan(). */
 	spin_lock(&huge_zero_lock);
@@ -266,33 +306,7 @@ static void put_huge_zero_folio(void)
 	 * Counter should never go to zero here. Only shrinker can put
 	 * last reference.
 	 */
-	BUG_ON(atomic_dec_and_test(&huge_zero_refcount));
-}
-
-struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
-{
-	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
-		return huge_zero_folio;
-
-	if (mm_flags_test(MMF_HUGE_ZERO_FOLIO, mm))
-		return READ_ONCE(huge_zero_folio);
-
-	if (!get_huge_zero_folio())
-		return NULL;
-
-	if (mm_flags_test_and_set(MMF_HUGE_ZERO_FOLIO, mm))
-		put_huge_zero_folio();
-
-	return READ_ONCE(huge_zero_folio);
-}
-
-void mm_put_huge_zero_folio(struct mm_struct *mm)
-{
-	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO))
-		return;
-
-	if (mm_flags_test(MMF_HUGE_ZERO_FOLIO, mm))
-		put_huge_zero_folio();
+	WARN_ON_ONCE(atomic_dec_and_test(&huge_zero_refcount));
 }
 
 static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
@@ -316,14 +330,53 @@ static unsigned long shrink_huge_zero_fo
 		zero_folio = huge_zero_folio;
 		VM_WARN_ON_ONCE(!zero_folio);
 		WRITE_ONCE(huge_zero_folio, NULL);
-		WRITE_ONCE(huge_zero_pfn, ~0UL);
+		WRITE_ONCE(huge_zero_pfn, HUGE_ZERO_UNSET_PFN);
 	}
 
 	folio_put(zero_folio);
 	return HPAGE_PMD_NR;
 }
 
-static struct shrinker *huge_zero_folio_shrinker;
+static int __init huge_zero_init(void)
+{
+	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
+	if (!huge_zero_folio_shrinker) {
+		shrinker_free(deferred_split_shrinker);
+		list_lru_destroy(&deferred_split_lru);
+		return -ENOMEM;
+	}
+
+	huge_zero_folio_shrinker->count_objects = shrink_huge_zero_folio_count;
+	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
+	shrinker_register(huge_zero_folio_shrinker);
+	return 0;
+}
+
+static void __init huge_zero_shrinker_exit(void)
+{
+	shrinker_free(huge_zero_folio_shrinker);
+}
+
+struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
+{
+	if (mm_flags_test(MMF_HUGE_ZERO_FOLIO, mm))
+		return READ_ONCE(huge_zero_folio);
+
+	if (!get_huge_zero_folio())
+		return NULL;
+
+	if (mm_flags_test_and_set(MMF_HUGE_ZERO_FOLIO, mm))
+		put_huge_zero_folio();
+
+	return READ_ONCE(huge_zero_folio);
+}
+
+void mm_put_huge_zero_folio(struct mm_struct *mm)
+{
+	if (mm_flags_test(MMF_HUGE_ZERO_FOLIO, mm))
+		put_huge_zero_folio();
+}
+#endif /* CONFIG_PERSISTENT_HUGE_ZERO_FOLIO */
 
 #ifdef CONFIG_SYSFS
 static ssize_t enabled_show(struct kobject *kobj,
@@ -987,39 +1040,14 @@ static int __init thp_shrinker_init(void
 	deferred_split_shrinker->scan_objects = deferred_split_scan;
 	shrinker_register(deferred_split_shrinker);
 
-	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO)) {
-		/*
-		 * Bump the reference of the huge_zero_folio and do not
-		 * initialize the shrinker.
-		 *
-		 * huge_zero_folio will always be NULL on failure. We assume
-		 * that get_huge_zero_folio() will most likely not fail as
-		 * thp_shrinker_init() is invoked early on during boot.
-		 */
-		if (!get_huge_zero_folio())
-			pr_warn("Allocating persistent huge zero folio failed\n");
-		return 0;
-	}
-
-	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
-	if (!huge_zero_folio_shrinker) {
-		shrinker_free(deferred_split_shrinker);
-		list_lru_destroy(&deferred_split_lru);
-		return -ENOMEM;
-	}
-
-	huge_zero_folio_shrinker->count_objects = shrink_huge_zero_folio_count;
-	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
-	shrinker_register(huge_zero_folio_shrinker);
-
-	return 0;
+	return huge_zero_init();
 }
 
 static void __init thp_shrinker_exit(void)
 {
-	shrinker_free(huge_zero_folio_shrinker);
 	shrinker_free(deferred_split_shrinker);
 	list_lru_destroy(&deferred_split_lru);
+	huge_zero_shrinker_exit();
 }
 
 static int __init hugepage_init(void)
_

Patches currently in -mm which might be from ljs@kernel.org are

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch
mm-introduce-linear_virt_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-virtual-page-index.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

