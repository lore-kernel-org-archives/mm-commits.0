Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F31F364BC;
	Wed,  7 Aug 2024 20:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723061307; cv=none; b=UI7tP8vk6VEX6itIcxMqEJnTg/v9WxgAqtLRqcMvVOy2GoPfsLxYHhDqHmONs/6zdOBM075RqZkKi5GeYoe+dDenVxla5JfuG9oMz4zPuA1CI33n7j0bENq/VrsscI0J+yuLOsYmQy3SQzXruEWjgDI3P02v4evErPh9VohL9Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723061307; c=relaxed/simple;
	bh=GLNy3yjspMbyTas/Azh6ziIn5M1IF2HniBflUl4zhe4=;
	h=Date:To:From:Subject:Message-Id; b=pmAS70EvMxfect4E1Gc+MEYHt2q460JpDlvDcPQ+TyTgQfUE1nbuOiP4iFhniFWplMjWSfM24zQDXzrlPPVMy9SVkjxcw7PkVb8WHLKpNjujMdpSMHhok7sPMTowXJGtbfXVDXxtc6IBbLHCiWlxxv/oHMEK2otbyGP0rKmRMUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=alpODUpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="alpODUpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8333DC32781;
	Wed,  7 Aug 2024 20:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723061306;
	bh=GLNy3yjspMbyTas/Azh6ziIn5M1IF2HniBflUl4zhe4=;
	h=Date:To:From:Subject:From;
	b=alpODUpy5HFryEsMzaNLEetukQ/ES6q2JZAhyS0m4ScTYrsVudFYKQ9zMiGkN1aho
	 3FD7kR04WPUggtK4UQq9r9YjR0WiQANRGZc3JLDdQLAsfq6u4yTbhAWn6ZMZK6qUP/
	 74zIPI40w9kE5aW/9VBve5JA+hjwJxMsreOOJp7c=
Date: Wed, 07 Aug 2024 13:08:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch added to mm-hotfixes-unstable branch
Message-Id: <20240807200826.8333DC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix hugetlb vs. core-mm PT locking
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: fix hugetlb vs. core-mm PT locking
Date: Thu, 1 Aug 2024 22:47:48 +0200

We recently made GUP's common page table walking code to also walk hugetlb
VMAs without most hugetlb special-casing, preparing for the future of
having less hugetlb-specific page table walking code in the codebase. 
Turns out that we missed one page table locking detail: page table locking
for hugetlb folios that are not mapped using a single PMD/PUD.

Assume we have hugetlb folio that spans multiple PTEs (e.g., 64 KiB
hugetlb folios on arm64 with 4 KiB base page size).  GUP, as it walks the
page tables, will perform a pte_offset_map_lock() to grab the PTE table
lock.

However, hugetlb that concurrently modifies these page tables would
actually grab the mm->page_table_lock: with USE_SPLIT_PTE_PTLOCKS, the
locks would differ.  Something similar can happen right now with hugetlb
folios that span multiple PMDs when USE_SPLIT_PMD_PTLOCKS.

This issue can be reproduced [1], for example triggering:

[ 3105.936100] ------------[ cut here ]------------
[ 3105.939323] WARNING: CPU: 31 PID: 2732 at mm/gup.c:142 try_grab_folio+0x11c/0x188
[ 3105.944634] Modules linked in: [...]
[ 3105.974841] CPU: 31 PID: 2732 Comm: reproducer Not tainted 6.10.0-64.eln141.aarch64 #1
[ 3105.980406] Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20240524-4.fc40 05/24/2024
[ 3105.986185] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 3105.991108] pc : try_grab_folio+0x11c/0x188
[ 3105.994013] lr : follow_page_pte+0xd8/0x430
[ 3105.996986] sp : ffff80008eafb8f0
[ 3105.999346] x29: ffff80008eafb900 x28: ffffffe8d481f380 x27: 00f80001207cff43
[ 3106.004414] x26: 0000000000000001 x25: 0000000000000000 x24: ffff80008eafba48
[ 3106.009520] x23: 0000ffff9372f000 x22: ffff7a54459e2000 x21: ffff7a546c1aa978
[ 3106.014529] x20: ffffffe8d481f3c0 x19: 0000000000610041 x18: 0000000000000001
[ 3106.019506] x17: 0000000000000001 x16: ffffffffffffffff x15: 0000000000000000
[ 3106.024494] x14: ffffb85477fdfe08 x13: 0000ffff9372ffff x12: 0000000000000000
[ 3106.029469] x11: 1fffef4a88a96be1 x10: ffff7a54454b5f0c x9 : ffffb854771b12f0
[ 3106.034324] x8 : 0008000000000000 x7 : ffff7a546c1aa980 x6 : 0008000000000080
[ 3106.038902] x5 : 00000000001207cf x4 : 0000ffff9372f000 x3 : ffffffe8d481f000
[ 3106.043420] x2 : 0000000000610041 x1 : 0000000000000001 x0 : 0000000000000000
[ 3106.047957] Call trace:
[ 3106.049522]  try_grab_folio+0x11c/0x188
[ 3106.051996]  follow_pmd_mask.constprop.0.isra.0+0x150/0x2e0
[ 3106.055527]  follow_page_mask+0x1a0/0x2b8
[ 3106.058118]  __get_user_pages+0xf0/0x348
[ 3106.060647]  faultin_page_range+0xb0/0x360
[ 3106.063651]  do_madvise+0x340/0x598

Let's make huge_pte_lockptr() effectively use the same PT locks as any
core-mm page table walker would.  Add ptep_lockptr() to obtain the PTE
page table lock using a pte pointer -- unfortunately we cannot convert
pte_lockptr() because virt_to_page() doesn't work with kmap'ed page tables
we can have with CONFIG_HIGHPTE.

Handle CONFIG_PGTABLE_LEVELS correctly by checking in reverse order, such
that when e.g., CONFIG_PGTABLE_LEVELS==2 with
PGDIR_SIZE==P4D_SIZE==PUD_SIZE==PMD_SIZE will work as expected.  Document
why that works.

There is one ugly case: powerpc 8xx, whereby we have an 8 MiB hugetlb
folio being mapped using two PTE page tables.  While hugetlb wants to take
the PMD table lock, core-mm would grab the PTE table lock of one of both
PTE page tables.  In such corner cases, we have to make sure that both
locks match, which is (fortunately!) currently guaranteed for 8xx as it
does not support SMP and consequently doesn't use split PT locks.

[1] https://lore.kernel.org/all/1bbfcc7f-f222-45a5-ac44-c5a1381c596d@redhat.com/

Link: https://lkml.kernel.org/r/20240801204748.99107-1-david@redhat.com
Fixes: 9cb28da54643 ("mm/gup: handle hugetlb in the generic follow_page_mask code")
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   33 ++++++++++++++++++++++++++++++---
 include/linux/mm.h      |   11 +++++++++++
 2 files changed, 41 insertions(+), 3 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking
+++ a/include/linux/hugetlb.h
@@ -944,10 +944,37 @@ static inline bool htlb_allow_alloc_fall
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 					   struct mm_struct *mm, pte_t *pte)
 {
-	if (huge_page_size(h) == PMD_SIZE)
+	const unsigned long size = huge_page_size(h);
+
+	VM_WARN_ON(size == PAGE_SIZE);
+
+	/*
+	 * hugetlb must use the exact same PT locks as core-mm page table
+	 * walkers would. When modifying a PTE table, hugetlb must take the
+	 * PTE PT lock, when modifying a PMD table, hugetlb must take the PMD
+	 * PT lock etc.
+	 *
+	 * The expectation is that any hugetlb folio smaller than a PMD is
+	 * always mapped into a single PTE table and that any hugetlb folio
+	 * smaller than a PUD (but at least as big as a PMD) is always mapped
+	 * into a single PMD table.
+	 *
+	 * If that does not hold for an architecture, then that architecture
+	 * must disable split PT locks such that all *_lockptr() functions
+	 * will give us the same result: the per-MM PT lock.
+	 *
+	 * Note that with e.g., CONFIG_PGTABLE_LEVELS=2 where
+	 * PGDIR_SIZE==P4D_SIZE==PUD_SIZE==PMD_SIZE, we'd use pud_lockptr()
+	 * and core-mm would use pmd_lockptr(). However, in such configurations
+	 * split PMD locks are disabled -- they don't make sense on a single
+	 * PGDIR page table -- and the end result is the same.
+	 */
+	if (size >= PUD_SIZE)
+		return pud_lockptr(mm, (pud_t *) pte);
+	else if (size >= PMD_SIZE || IS_ENABLED(CONFIG_HIGHPTE))
 		return pmd_lockptr(mm, (pmd_t *) pte);
-	VM_BUG_ON(huge_page_size(h) == PAGE_SIZE);
-	return &mm->page_table_lock;
+	/* pte_alloc_huge() only applies with !CONFIG_HIGHPTE */
+	return ptep_lockptr(mm, pte);
 }
 
 #ifndef hugepages_supported
--- a/include/linux/mm.h~mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking
+++ a/include/linux/mm.h
@@ -2920,6 +2920,13 @@ static inline spinlock_t *pte_lockptr(st
 	return ptlock_ptr(page_ptdesc(pmd_page(*pmd)));
 }
 
+static inline spinlock_t *ptep_lockptr(struct mm_struct *mm, pte_t *pte)
+{
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_HIGHPTE));
+	BUILD_BUG_ON(MAX_PTRS_PER_PTE * sizeof(pte_t) > PAGE_SIZE);
+	return ptlock_ptr(virt_to_ptdesc(pte));
+}
+
 static inline bool ptlock_init(struct ptdesc *ptdesc)
 {
 	/*
@@ -2944,6 +2951,10 @@ static inline spinlock_t *pte_lockptr(st
 {
 	return &mm->page_table_lock;
 }
+static inline spinlock_t *ptep_lockptr(struct mm_struct *mm, pte_t *pte)
+{
+	return &mm->page_table_lock;
+}
 static inline void ptlock_cache_init(void) {}
 static inline bool ptlock_init(struct ptdesc *ptdesc) { return true; }
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
_

Patches currently in -mm which might be from david@redhat.com are

mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch
mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch
mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch
mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch
mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch
mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch
mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch
mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch
mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch
mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix.patch
s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch
s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch
mm-remove-follow_page.patch
mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch
mm-rmap-minimize-folio-_nr_pages_mapped-updates-when-batching-pte-unmapping.patch

