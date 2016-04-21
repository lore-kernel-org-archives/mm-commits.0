From: akpm@linux-foundation.org
Subject: [to-be-updated]
 huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd.patch removed from -mm
 tree
Date: Thu, 21 Apr 2016 13:46:12 -0700
Message-ID: <57193c14.C9q0X52gaQzhkrvy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbcDUUqN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 16:46:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, davem@davemloft.net, kirill.shutemov@linux.intel.com, mingo@kernel.org, quning@gmail.com, ralf@linux-mips.org, rientjes@google.com, schwidefsky@de.ibm.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: extend get_user_pages_fast to shmem pmd
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: extend get_user_pages_fast to shmem pmd

The arch-specific get_user_pages_fast() has a gup_huge_pmd() designed to
optimize the refcounting on anonymous THP and hugetlbfs pages, with one
atomic addition to compound head's common refcount.  That optimization
must be avoided on huge tmpfs team pages, which use normal separate page
refcounting.  We could combine the PageTeam and PageCompound cases into a
single simple loop, but would lose the compound optimization that way.

One cannot go through these functions without wondering why some arches
(x86, mips) like to SetPageReferenced, while the rest do not: an x86
optimization that missed being propagated to the other architectures?  No,
see commit 8ee53820edfd ("thp: mmu_notifier_test_young"): it's a KVM GRU
EPT thing, maybe not useful beyond x86.  I've just followed the
established practice in each architecture.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/gup.c  |   15 ++++++++++++++-
 arch/s390/mm/gup.c  |   19 ++++++++++++++++++-
 arch/sparc/mm/gup.c |   19 ++++++++++++++++++-
 arch/x86/mm/gup.c   |   15 ++++++++++++++-
 mm/gup.c            |   19 ++++++++++++++++++-
 5 files changed, 82 insertions(+), 5 deletions(-)

diff -puN arch/mips/mm/gup.c~huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd arch/mips/mm/gup.c
--- a/arch/mips/mm/gup.c~huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd
+++ a/arch/mips/mm/gup.c
@@ -81,9 +81,22 @@ static int gup_huge_pmd(pmd_t pmd, unsig
 	VM_BUG_ON(pte_special(pte));
 	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 
-	refs = 0;
 	head = pte_page(pte);
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+
+	if (PageTeam(head)) {
+		/* Handle a huge tmpfs team with normal refcounting. */
+		do {
+			get_page(page);
+			SetPageReferenced(page);
+			pages[*nr] = page;
+			(*nr)++;
+			page++;
+		} while (addr += PAGE_SIZE, addr != end);
+		return 1;
+	}
+
+	refs = 0;
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
diff -puN arch/s390/mm/gup.c~huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd arch/s390/mm/gup.c
--- a/arch/s390/mm/gup.c~huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd
+++ a/arch/s390/mm/gup.c
@@ -66,9 +66,26 @@ static inline int gup_huge_pmd(pmd_t *pm
 		return 0;
 	VM_BUG_ON(!pfn_valid(pmd_val(pmd) >> PAGE_SHIFT));
 
-	refs = 0;
 	head = pmd_page(pmd);
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+
+	if (PageTeam(head)) {
+		/* Handle a huge tmpfs team with normal refcounting. */
+		do {
+			if (!page_cache_get_speculative(page))
+				return 0;
+			if (unlikely(pmd_val(pmd) != pmd_val(*pmdp))) {
+				put_page(page);
+				return 0;
+			}
+			pages[*nr] = page;
+			(*nr)++;
+			page++;
+		} while (addr += PAGE_SIZE, addr != end);
+		return 1;
+	}
+
+	refs = 0;
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
diff -puN arch/sparc/mm/gup.c~huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd arch/sparc/mm/gup.c
--- a/arch/sparc/mm/gup.c~huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd
+++ a/arch/sparc/mm/gup.c
@@ -77,9 +77,26 @@ static int gup_huge_pmd(pmd_t *pmdp, pmd
 	if (write && !pmd_write(pmd))
 		return 0;
 
-	refs = 0;
 	head = pmd_page(pmd);
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+
+	if (PageTeam(head)) {
+		/* Handle a huge tmpfs team with normal refcounting. */
+		do {
+			if (!page_cache_get_speculative(page))
+				return 0;
+			if (unlikely(pmd_val(pmd) != pmd_val(*pmdp))) {
+				put_page(page);
+				return 0;
+			}
+			pages[*nr] = page;
+			(*nr)++;
+			page++;
+		} while (addr += PAGE_SIZE, addr != end);
+		return 1;
+	}
+
+	refs = 0;
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
diff -puN arch/x86/mm/gup.c~huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd
+++ a/arch/x86/mm/gup.c
@@ -196,9 +196,22 @@ static noinline int gup_huge_pmd(pmd_t p
 	/* hugepages are never "special" */
 	VM_BUG_ON(pmd_flags(pmd) & _PAGE_SPECIAL);
 
-	refs = 0;
 	head = pmd_page(pmd);
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+
+	if (PageTeam(head)) {
+		/* Handle a huge tmpfs team with normal refcounting. */
+		do {
+			get_page(page);
+			SetPageReferenced(page);
+			pages[*nr] = page;
+			(*nr)++;
+			page++;
+		} while (addr += PAGE_SIZE, addr != end);
+		return 1;
+	}
+
+	refs = 0;
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
diff -puN mm/gup.c~huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd mm/gup.c
--- a/mm/gup.c~huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd
+++ a/mm/gup.c
@@ -1246,9 +1246,26 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 	if (write && !pmd_write(orig))
 		return 0;
 
-	refs = 0;
 	head = pmd_page(orig);
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+
+	if (PageTeam(head)) {
+		/* Handle a huge tmpfs team with normal refcounting. */
+		do {
+			if (!page_cache_get_speculative(page))
+				return 0;
+			if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
+				put_page(page);
+				return 0;
+			}
+			pages[*nr] = page;
+			(*nr)++;
+			page++;
+		} while (addr += PAGE_SIZE, addr != end);
+		return 1;
+	}
+
+	refs = 0;
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
_

Patches currently in -mm which might be from hughd@google.com are

huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
arch-fix-has_transparent_hugepage.patch
huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages.patch
huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks.patch
huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings.patch
huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages.patch
huge-tmpfs-proc-pid-smaps-show-shmemhugepages.patch
huge-tmpfs-recovery-framework-for-reconstituting-huge-pages.patch
huge-tmpfs-recovery-shmem_recovery_populate-to-fill-huge-page.patch
huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd.patch
huge-tmpfs-recovery-shmem_recovery_swapin-to-read-from-swap.patch
huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch
huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch
huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch

