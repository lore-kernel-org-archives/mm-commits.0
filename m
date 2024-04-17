Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37433AC01
	for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2024 20:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713385847; cv=none; b=MTXuW0GCqQsAsIeum0f+OfU6dP6wzzRR2xDIIpWQicxgmxvOFLRbh6Ku2sCvBLZoKsLZ5f0YgnxfIoc6jerxbBtUxXjlHgufj+QIz9z0b4Hi3WqbzEnG0wU77OWGjTGulpyYIjpiFatGXjb6L2xnBdRk5E7TAnfTgIFAA9V3Q+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713385847; c=relaxed/simple;
	bh=J7WzgHfQcSrCWM9wZSs4mbbtDU5pTKBmjBJVDer5eOA=;
	h=Date:To:From:Subject:Message-Id; b=ZY2MSrl/XhrCuYvR+sPIbLlCCS28eZa+Ys6yCv/pbJk73EsxYYoz68A5Mo5NwlNAl3xp9HV9expMqExK5J/jAyiAqG8G2IJeBVuHUihpWdvrq/vDyVaoJ949zu7dQz370MVvs9HKtynhEnpaXn7pZxA2xkfqwBL4Ez5ThHHG3+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zrzzCM6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zrzzCM6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CB5C072AA;
	Wed, 17 Apr 2024 20:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713385847;
	bh=J7WzgHfQcSrCWM9wZSs4mbbtDU5pTKBmjBJVDer5eOA=;
	h=Date:To:From:Subject:From;
	b=zrzzCM6S0unas61V/M3X1Kbj45pQaVd2315mTxnrO9xzL4Kb1SKVmTX4YyE4lyyc+
	 hMt/jhLCjrGgzBuBr4EiiHu+YwMUwSttVo7kTBEyzATn0oor/WiHdRzIIx7cGdVC6J
	 EF0Kjz1Dbq8zuYuosZyekKfdRWv1zzj6S0EES2mk=
Date: Wed, 17 Apr 2024 13:30:46 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,nadav.amit@gmail.com,david@redhat.com,axelrasmussen@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_table_check-support-userfault-wr-protect-entries.patch removed from -mm tree
Message-Id: <20240417203047.22CB5C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_table_check: support userfault wr-protect entries
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-support-userfault-wr-protect-entries.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/page_table_check: support userfault wr-protect entries
Date: Mon, 15 Apr 2024 16:52:59 -0400

Allow page_table_check hooks to check over userfaultfd wr-protect criteria
upon pgtable updates.  The rule is no co-existence allowed for any
writable flag against userfault wr-protect flag.

This should be better than c2da319c2e, where we used to only sanitize such
issues during a pgtable walk, but when hitting such issue we don't have a
good chance to know where does that writable bit came from [1], so that
even the pgtable walk exposes a kernel bug (which is still helpful on
triaging) but not easy to track and debug.

Now we switch to track the source.  It's much easier too with the recent
introduction of page table check.

There are some limitations with using the page table check here for
userfaultfd wr-protect purpose:

  - It is only enabled with explicit enablement of page table check configs
  and/or boot parameters, but should be good enough to track at least
  syzbot issues, as syzbot should enable PAGE_TABLE_CHECK[_ENFORCED] for
  x86 [1].  We used to have DEBUG_VM but it's now off for most distros,
  while distros also normally not enable PAGE_TABLE_CHECK[_ENFORCED], which
  is similar.

  - It conditionally works with the ptep_modify_prot API.  It will be
  bypassed when e.g. XEN PV is enabled, however still work for most of the
  rest scenarios, which should be the common cases so should be good
  enough.

  - Hugetlb check is a bit hairy, as the page table check cannot identify
  hugetlb pte or normal pte via trapping at set_pte_at(), because of the
  current design where hugetlb maps every layers to pte_t... For example,
  the default set_huge_pte_at() can invoke set_pte_at() directly and lose
  the hugetlb context, treating it the same as a normal pte_t. So far it's
  fine because we have huge_pte_uffd_wp() always equals to pte_uffd_wp() as
  long as supported (x86 only).  It'll be a bigger problem when we'll
  define _PAGE_UFFD_WP differently at various pgtable levels, because then
  one huge_pte_uffd_wp() per-arch will stop making sense first.. as of now
  we can leave this for later too.

This patch also removes commit c2da319c2e altogether, as we have something
better now.

[1] https://lore.kernel.org/all/000000000000dce0530615c89210@google.com/

Link: https://lkml.kernel.org/r/20240415205259.2535077-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   18 -----------------
 mm/page_table_check.c          |   32 ++++++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 18 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-support-userfault-wr-protect-entries
+++ a/arch/x86/include/asm/pgtable.h
@@ -388,23 +388,7 @@ static inline pte_t pte_wrprotect(pte_t
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static inline int pte_uffd_wp(pte_t pte)
 {
-	bool wp = pte_flags(pte) & _PAGE_UFFD_WP;
-
-#ifdef CONFIG_DEBUG_VM
-	/*
-	 * Having write bit for wr-protect-marked present ptes is fatal,
-	 * because it means the uffd-wp bit will be ignored and write will
-	 * just go through.
-	 *
-	 * Use any chance of pgtable walking to verify this (e.g., when
-	 * page swapped out or being migrated for all purposes). It means
-	 * something is already wrong.  Tell the admin even before the
-	 * process crashes. We also nail it with wrong pgtable setup.
-	 */
-	WARN_ON_ONCE(wp && pte_write(pte));
-#endif
-
-	return wp;
+	return pte_flags(pte) & _PAGE_UFFD_WP;
 }
 
 static inline pte_t pte_mkuffd_wp(pte_t pte)
--- a/mm/page_table_check.c~mm-page_table_check-support-userfault-wr-protect-entries
+++ a/mm/page_table_check.c
@@ -7,6 +7,8 @@
 #include <linux/kstrtox.h>
 #include <linux/mm.h>
 #include <linux/page_table_check.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
 
 #undef pr_fmt
 #define pr_fmt(fmt)	"page_table_check: " fmt
@@ -182,6 +184,23 @@ void __page_table_check_pud_clear(struct
 }
 EXPORT_SYMBOL(__page_table_check_pud_clear);
 
+/* Whether the swap entry cached writable information */
+static inline bool swap_cached_writable(swp_entry_t entry)
+{
+	unsigned type = swp_type(entry);
+
+	return type == SWP_DEVICE_EXCLUSIVE_WRITE ||
+	    type == SWP_MIGRATION_WRITE;
+}
+
+static inline void __page_table_check_pte(pte_t pte)
+{
+	if (pte_present(pte) && pte_uffd_wp(pte))
+		WARN_ON_ONCE(pte_write(pte));
+	else if (is_swap_pte(pte) && pte_swp_uffd_wp(pte))
+		WARN_ON_ONCE(swap_cached_writable(pte_to_swp_entry(pte)));
+}
+
 void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
 		unsigned int nr)
 {
@@ -190,18 +209,29 @@ void __page_table_check_ptes_set(struct
 	if (&init_mm == mm)
 		return;
 
-	for (i = 0; i < nr; i++)
+	for (i = 0; i < nr; i++) {
+		__page_table_check_pte(pte);
 		__page_table_check_pte_clear(mm, ptep_get(ptep + i));
+	}
 	if (pte_user_accessible_page(pte))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
 EXPORT_SYMBOL(__page_table_check_ptes_set);
 
+static inline void __page_table_check_pmd(pmd_t pmd)
+{
+	if (pmd_present(pmd) && pmd_uffd_wp(pmd))
+		WARN_ON_ONCE(pmd_write(pmd));
+	else if (is_swap_pmd(pmd) && pmd_swp_uffd_wp(pmd))
+		WARN_ON_ONCE(swap_cached_writable(pmd_to_swp_entry(pmd)));
+}
+
 void __page_table_check_pmd_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd)
 {
 	if (&init_mm == mm)
 		return;
 
+	__page_table_check_pmd(pmd);
 	__page_table_check_pmd_clear(mm, *pmdp);
 	if (pmd_user_accessible_page(pmd)) {
 		page_table_check_set(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT,
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hmm-process-pud-swap-entry-without-pud_huge.patch
mm-gup-cache-p4d-in-follow_p4d_mask.patch
mm-gup-check-p4d-presence-before-going-on.patch
mm-x86-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-arm-use-macros-to-define-pmd-pud-helpers.patch
mm-arm-redefine-pmd_huge-with-pmd_leaf.patch
mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions.patch
mm-powerpc-redefine-pxd_huge-with-pxd_leaf.patch
mm-gup-merge-pxd-huge-mapping-checks.patch
mm-treewide-replace-pxd_huge-with-pxd_leaf.patch
mm-treewide-remove-pxd_huge.patch
mm-arm-remove-pmd_thp_or_huge.patch
mm-document-pxd_leaf-api.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation-fix.patch
mm-kconfig-config_pgtable_has_huge_leaves.patch
mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static.patch
mm-make-hpage_pxd_-macros-even-if-thp.patch
mm-introduce-vma_pgtable_walk_beginend.patch
mm-arch-provide-pud_pfn-fallback.patch
mm-arch-provide-pud_pfn-fallback-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch
mm-gup-refactor-record_subpages-to-find-1st-small-page.patch
mm-gup-handle-hugetlb-for-no_page_table.patch
mm-gup-cache-pudp-in-follow_pud_mask.patch
mm-gup-handle-huge-pud-for-follow_pud_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask-fix.patch
mm-gup-handle-hugepd-for-follow_page.patch
mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch

