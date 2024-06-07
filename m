Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E2A15380A
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 20:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717793958; cv=none; b=hLUWJTbNJSLD/CjdOS8h8A++hAofnhv+I94siFnu2w72ns/8T1aSE9V/VABVVbqn0Slk9RhGYSNzN2hjEVPiMhmvcI5P1rCNFvPn4HnLlmmPnmU4J56g2znDJkRs/Dsy9iRwwLOEq0xVXvBbwD0S0TDcPqazQ94ltI7fhda2oeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717793958; c=relaxed/simple;
	bh=2jMZuSQp4Po0AbbBSKteqyIKbFOBglJt7IjJHHU6fl8=;
	h=Date:To:From:Subject:Message-Id; b=SdFu+ilATRAweP/ZHBZWfBcPBWw3w0DhMm39q8hy1M7lyz2zp1SJ6jzsugRghNmA5/CnQu1p7Vk9dreM6UjhyKx4s7UpMGA2rj7T3rcztu53Misvngb2yx0b/eYO/GzmQcRWMIgdV8qXRIfH4eSbCeCjf4e4eMiHJ4lMJCk/V7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aWzjecIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aWzjecIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178A7C2BBFC;
	Fri,  7 Jun 2024 20:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717793958;
	bh=2jMZuSQp4Po0AbbBSKteqyIKbFOBglJt7IjJHHU6fl8=;
	h=Date:To:From:Subject:From;
	b=aWzjecIfrhDl2lPUiRtos+4QeXHxFL5KUFSerswqtDChYYe1YjrZ+d1YCQy8lGG69
	 T09l9bDzd/U9VXcA7M/wPyX0Y585Lp/XRZyhLrS0akAdLsFF/ud7KZLQ7I51JIYSWZ
	 JUr1h3FsslHwfkyUdCtyh+BK8QB4L7cddNWvYtPg=
Date: Fri, 07 Jun 2024 13:59:17 -0700
To: mm-commits@vger.kernel.org,kirill.shutemov@linux.intel.com,ioworker0@gmail.com,corbet@lwn.net,adobriyan@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch added to mm-unstable branch
Message-Id: <20240607205918.178A7C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: don't indicate PM_MMAP_EXCLUSIVE without PM_PRESENT
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/task_mmu: don't indicate PM_MMAP_EXCLUSIVE without PM_PRESENT
Date: Fri, 7 Jun 2024 14:23:53 +0200

Relying on the mapcount for non-present PTEs that reference pages doesn't
make any sense: they are not accounted in the mapcount, so page_mapcount()
== 1 won't return the result we actually want to know.

While we don't check the mapcount for migration entries already, we could
end up checking it for swap, hwpoison, device exclusive, ...  entries,
which we really shouldn't.

There is one exception: device private entries, which we consider
fake-present (e.g., incremented the mapcount).  But we won't care about
that for now for PM_MMAP_EXCLUSIVE, because indicating PM_SWAP for them
although they are fake-present already sounds suspiciously wrong.

Let's never indicate PM_MMAP_EXCLUSIVE without PM_PRESENT.

Link: https://lkml.kernel.org/r/20240607122357.115423-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present
+++ a/fs/proc/task_mmu.c
@@ -1415,7 +1415,6 @@ static pagemap_entry_t pte_to_pagemap_en
 {
 	u64 frame = 0, flags = 0;
 	struct page *page = NULL;
-	bool migration = false;
 
 	if (pte_present(pte)) {
 		if (pm->show_pfn)
@@ -1447,7 +1446,6 @@ static pagemap_entry_t pte_to_pagemap_en
 			    (offset << MAX_SWAPFILES_SHIFT);
 		}
 		flags |= PM_SWAP;
-		migration = is_migration_entry(entry);
 		if (is_pfn_swap_entry(entry))
 			page = pfn_swap_entry_to_page(entry);
 		if (pte_marker_entry_uffd_wp(entry))
@@ -1456,7 +1454,7 @@ static pagemap_entry_t pte_to_pagemap_en
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
-	if (page && !migration && page_mapcount(page) == 1)
+	if (page && (flags & PM_PRESENT) && page_mapcount(page) == 1)
 		flags |= PM_MMAP_EXCLUSIVE;
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
@@ -1473,7 +1471,6 @@ static int pagemap_pmd_range(pmd_t *pmdp
 	pte_t *pte, *orig_pte;
 	int err = 0;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool migration = false;
 
 	ptl = pmd_trans_huge_lock(pmdp, vma);
 	if (ptl) {
@@ -1517,14 +1514,13 @@ static int pagemap_pmd_range(pmd_t *pmdp
 			if (pmd_swp_uffd_wp(pmd))
 				flags |= PM_UFFD_WP;
 			VM_BUG_ON(!is_pmd_migration_entry(pmd));
-			migration = is_migration_entry(entry);
 			page = pfn_swap_entry_to_page(entry);
 		}
 #endif
 
 		if (page && !PageAnon(page))
 			flags |= PM_FILE;
-		if (page && !migration && page_mapcount(page) == 1)
+		if (page && (flags & PM_PRESENT) && page_mapcount(page) == 1)
 			flags |= PM_MMAP_EXCLUSIVE;
 
 		for (; addr != end; addr += PAGE_SIZE) {
_

Patches currently in -mm which might be from david@redhat.com are

revert-mm-init_mlocked_on_free_v3.patch
mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch
fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch
fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch
fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch
fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch

