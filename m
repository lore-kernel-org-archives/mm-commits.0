Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86156431A49;
	Wed, 15 Jul 2026 18:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139831; cv=none; b=LygEDYbHXOrNrGOwEyhFyLzQKeIMBeW0PGI0UDaeHnzAe4ZdMre8EcHwyNFb/VxztdnE65eWFxzgsBc88phTo67FH6Crf1qwkqYDdpgbDvsaELLrWWSyg63znDOkCIsGmFZx4RcxmZ8nonsCoPgICpsqEuEdHZAbhNs7+CeCZt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139831; c=relaxed/simple;
	bh=Xs9H4DVAMBmAWKv0Ma4YA8jy3I9MMh+4fRAnLdfl394=;
	h=Date:To:From:Subject:Message-Id; b=uIEMsMHx6c22v1kmU2Z0xgVfO1uP/R6HIRHGy6mMVHoi00HhLkWUKeTKGS1N5iFQm90uaJGAU/2+okzprAIwhQi7bOBoKGiSWoSI27Q2VqzMWv0c0A4dXEHEfNy6C7nEAsOotNRbXpe/UwxX9B5x+HUayFcSTJU6xT38k7Yo7ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FPh3QMb+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FPh3QMb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4841F00A3A;
	Wed, 15 Jul 2026 18:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784139827;
	bh=Qo+FqmMAhcgr6RzlH1jZHYlT/AbqpN1nuEIbxlbmxZM=;
	h=Date:To:From:Subject;
	b=FPh3QMb+HICXDAMB5ojsLKjUntm+6P0itfx6hIGFwZo//LLL1AjqidvLZHC2kVA39
	 ZHgDeYDAZ/jAGoTg/5e7WJIBKug9lNwquk6gribcC9utgFCcp7N1ShyVR3/A0/h91U
	 cSZ/ni5Eks1ikvfRtwLNPvUvYHUF2Hk67Zh9jahs=
Date: Wed, 15 Jul 2026 11:23:46 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,sashiko-bot@kernel.org,rppt@kernel.org,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-fix-pagemap_scan-written-state-for-pmd-holes.patch added to mm-hotfixes-unstable branch
Message-Id: <20260715182346.EA4841F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-task_mmu-fix-pagemap_scan-written-state-for-pmd-holes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-fix-pagemap_scan-written-state-for-pmd-holes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes
Date: Wed, 15 Jul 2026 15:42:33 +0100

PAGEMAP_SCAN reports an unpopulated PTE in a uffd-wp VMA as written, but a
range with no page table at all -- a PMD hole -- is skipped:
pagemap_scan_pte_hole() tests p->cur_vma_category, which never carries
PAGE_IS_WRITTEN, so the hole is neither reported nor (under
PM_SCAN_WP_MATCHING) armed.

In a uffd-wp VMA, WP_UNPOPULATED installs uffd-wp markers when protecting
a range, allocating page tables as needed, so an unpopulated slot is
treated as written -- see the pte_none() handling in
pagemap_page_category().  A missing marker therefore means the range was
zapped, e.g.  via MADV_DONTNEED.  This applies to anon and shmem VMAs.

An anonymous THP is write-protected in place as a huge PMD, so a full-PMD
MADV_DONTNEED clears it to pmd_none -- a hole with no page table -- and
pagemap_scan_pte_hole() misses it.  For a MAP_PRIVATE|MAP_ANON mapping
MADV_DONTNEED has fill-with-zeros semantics, so a write-tracking
checkpoint/migration tool (e.g.  CRIU) treats the range as unchanged and
keeps its previous contents; after restore or live migration the process
reads stale data instead of zeroes -- data corruption.

Report a hole in a non-hugetlb uffd-wp VMA as written, matching the
pte_none handling in pagemap_page_category(); the existing
PM_SCAN_WP_MATCHING path then arms it via uffd_wp_range().

hugetlb is excluded: pagemap_hugetlb_category() reports an empty hugetlb
entry (huge_pte_none) as not-written, unlike pagemap_page_category(),
which reports pte_none as written.  pagemap_scan_pte_hole() fires for a
hugetlb slot only when it has no page table; keeping that not-written
matches how an allocated-but-empty hugetlb entry reads, so the hole and
the empty-entry cases agree within the VMA.

Link: https://lore.kernel.org/20260715144234.442721-2-kirill@shutemov.name
Fixes: 2bad466cc9d9 ("mm/uffd: UFFD_FEATURE_WP_UNPOPULATED")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260707151349.92143-1-kirill@shutemov.name
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>
Assisted-by: Claude:claude-fable-5
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-fix-pagemap_scan-written-state-for-pmd-holes
+++ a/fs/proc/task_mmu.c
@@ -3049,12 +3049,28 @@ static int pagemap_scan_pte_hole(unsigne
 {
 	struct pagemap_scan_private *p = walk->private;
 	struct vm_area_struct *vma = walk->vma;
+	unsigned long categories;
 	int ret, err;
 
-	if (!vma || !pagemap_scan_is_interesting_page(p->cur_vma_category, p))
+	if (!vma)
 		return 0;
 
-	ret = pagemap_scan_output(p->cur_vma_category, p, addr, &end);
+	/*
+	 * In a uffd-wp VMA an unpopulated range is treated as written:
+	 * uffd-wp registration populates page tables and installs markers
+	 * with WP_UNPOPULATED, so a missing marker means the range was
+	 * zapped. See the pte_none() handling in pagemap_page_category().
+	 *
+	 * hugetlb differs, see pagemap_hugetlb_category().
+	 */
+	categories = p->cur_vma_category;
+	if (userfaultfd_wp(vma) && !is_vm_hugetlb_page(vma))
+		categories |= PAGE_IS_WRITTEN;
+
+	if (!pagemap_scan_is_interesting_page(categories, p))
+		return 0;
+
+	ret = pagemap_scan_output(categories, p, addr, &end);
 	if (addr == end)
 		return ret;
 
_

Patches currently in -mm which might be from kas@kernel.org are

fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes.patch
mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch
fs-proc-task_mmu-fix-pagemap_scan-written-state-for-pmd-holes.patch
mm-decouple-protnone-helpers-from-config_numa_balancing.patch
mm-rename-uffd-wp-pte-bit-macros-to-uffd.patch
mm-rename-uffd-wp-pte-accessors-to-uffd.patch
userfaultfd-test-uffd-vma-flags-through-the-vma_flags_t-api.patch
mm-add-vm_uffd_rwp-vma-flag.patch
mm-add-mm_cp_uffd_rwp-change_protection-flag.patch
mm-preserve-rwp-marker-across-pte-rewrites.patch
mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup.patch
userfaultfd-add-uffdio_register_mode_rwp-and-uffdio_rwprotect-plumbing.patch
mm-userfaultfd-add-rwp-fault-delivery-and-expose-uffdio_register_mode_rwp.patch
mm-pagemap-add-page_is_accessed-for-rwp-tracking.patch
userfaultfd-add-uffd_feature_rwp_async-for-async-fault-resolution.patch
userfaultfd-add-uffdio_set_mode-for-runtime-sync-async-toggle.patch
selftests-mm-add-userfaultfd-rwp-tests.patch
documentation-userfaultfd-document-rwp-working-set-tracking.patch
selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes.patch

