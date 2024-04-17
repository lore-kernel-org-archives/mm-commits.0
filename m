Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDFE171A1
	for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2024 21:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390166; cv=none; b=OvYmpKtVYJ2if5t08aVdI13tDUP58UQhTenFwaZe6Z5HVzNYk1XMOe8ceZC8xoOY/LExmtcBV1llcysLQbvhKxFzK0m0q4/L+ZYjfKr/My10h4+IPoH+1g8KSxkKTpPVpDsOxbDYJlXNEAxbGv/xQuh7pdx/nre/F5NPeJn1B6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390166; c=relaxed/simple;
	bh=jxdhZh3ckwZfaKrFTftjDA/NCXWZpm8qncdh2LP/Ups=;
	h=Date:To:From:Subject:Message-Id; b=kRS82lynrjXhWkKEQJymNAXUUGIlaJU27eSOczZfW3Y19fmuOJ9a+AjflyS+N5KfZjqH8NDCpwGDO7jlIszjDGG6qJYsQYS1HDYX+vzC24ET77Nv/Ir/Exfk29hObnunj75kI72qUNVerB8S6nLRMBnSEwYXdJVkD3uDRItxGFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uA/ERxXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uA/ERxXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE441C072AA;
	Wed, 17 Apr 2024 21:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713390166;
	bh=jxdhZh3ckwZfaKrFTftjDA/NCXWZpm8qncdh2LP/Ups=;
	h=Date:To:From:Subject:From;
	b=uA/ERxXF3z2y6mzlrdY7LD8LNr+L7MmcQazqd1ilzQqGr5pVObKaNJBgoyrIoiRtP
	 Nnp60BrhiTVBka8S/RkH+9rQJQ9WcvBeeLN7RbSU93zDaIShWpRkxYCfk/ptoBCMHp
	 ruigxCfSahFju2YRws0vlizb/m5djWswSWspnp6Y=
Date: Wed, 17 Apr 2024 14:42:45 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,nadav.amit@gmail.com,david@redhat.com,axelrasmussen@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-support-userfault-wr-protect-entries.patch added to mm-unstable branch
Message-Id: <20240417214245.EE441C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: support userfault wr-protect entries
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_table_check-support-userfault-wr-protect-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-support-userfault-wr-protect-entries.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/page_table_check: support userfault wr-protect entries
Date: Wed, 17 Apr 2024 17:25:49 -0400

Allow page_table_check hooks to check over userfaultfd wr-protect criteria
upon pgtable updates.  The rule is no co-existance allowed for any
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

Link: https://lkml.kernel.org/r/20240417212549.2766883-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/page_table_check.rst |    9 ++++++-
 arch/x86/include/asm/pgtable.h        |   18 --------------
 mm/page_table_check.c                 |   30 ++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 18 deletions(-)

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
--- a/Documentation/mm/page_table_check.rst~mm-page_table_check-support-userfault-wr-protect-entries
+++ a/Documentation/mm/page_table_check.rst
@@ -14,7 +14,7 @@ Page table check performs extra verifica
 accessible from the userspace by getting their page table entries (PTEs PMDs
 etc.) added into the table.
 
-In case of detected corruption, the kernel is crashed. There is a small
+In case of most detected corruption, the kernel is crashed. There is a small
 performance and memory overhead associated with the page table check. Therefore,
 it is disabled by default, but can be optionally enabled on systems where the
 extra hardening outweighs the performance costs. Also, because page table check
@@ -22,6 +22,13 @@ is synchronous, it can help with debuggi
 by crashing kernel at the time wrong mapping occurs instead of later which is
 often the case with memory corruptions bugs.
 
+It can also be used to do page table entry checks over various flags, dump
+warnings when illegal combinations of entry flags are detected.  Currently,
+userfaultfd is the only user of such to sanity check wr-protect bit against
+any writable flags.  Illegal flag combinations will not directly cause data
+corruption in this case immediately, but that will cause read-only data to
+be writable, leading to corrupt when the page content is later modified.
+
 Double mapping detection logic
 ==============================
 
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
@@ -182,6 +184,22 @@ void __page_table_check_pud_clear(struct
 }
 EXPORT_SYMBOL(__page_table_check_pud_clear);
 
+/* Whether the swap entry cached writable information */
+static inline bool swap_cached_writable(swp_entry_t entry)
+{
+	return is_writable_device_exclusive_entry(entry) ||
+	    is_writable_device_private_entry(entry) ||
+	    is_writable_migration_entry(entry);
+}
+
+static inline void page_table_check_pte_flags(pte_t pte)
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
@@ -190,6 +208,8 @@ void __page_table_check_ptes_set(struct
 	if (&init_mm == mm)
 		return;
 
+	page_table_check_pte_flags(pte);
+
 	for (i = 0; i < nr; i++)
 		__page_table_check_pte_clear(mm, ptep_get(ptep + i));
 	if (pte_user_accessible_page(pte))
@@ -197,11 +217,21 @@ void __page_table_check_ptes_set(struct
 }
 EXPORT_SYMBOL(__page_table_check_ptes_set);
 
+static inline void page_table_check_pmd_flags(pmd_t pmd)
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
 
+	page_table_check_pmd_flags(pmd);
+
 	__page_table_check_pmd_clear(mm, *pmdp);
 	if (pmd_user_accessible_page(pmd)) {
 		page_table_check_set(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT,
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-missing-hugetlb_lock-for-resv-uncharge.patch
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
mm-always-initialise-folio-_deferred_list-fix.patch
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
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

