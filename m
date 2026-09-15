Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059C838AC75;
	Tue, 15 Sep 2026 04:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789447805; cv=none; b=gvmC/p34v0pHWENKMNJz5Mh68pPKO3MOQRXYsVUTkW9Kn56ASR7GXqmw3tlrwPuADC45VUqcTDMP687b5FLsoK8yxxgGiVpdJm8FbQBAcb+xcOFCvDNlqb56GUDFRx/5ByoilTje4zU0f+xSHx+n901UvTzPfBHRI1KxKsxGFDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789447805; c=relaxed/simple;
	bh=TzyRZL+V0z/kpT3qq0mKVdZ0Uum0CuldLTmmlm7sEo8=;
	h=Date:To:From:Subject:Message-Id; b=DgF24GwgVKKEBrkOZnAzP1vfvq2js/kJ0LgzFB4eEu3Ojvg4O6o17snhXyDski6xtx7IskZoFO+K1DmO7kAVflmfUICMCAsQGzp85ZAjXq30mBfnd5L5xzlFLZnw/ounkzALizLS+DqPPi48WQl5+G/WKY8i9poWLl4ZcA+zaq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r0pTFch2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r0pTFch2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAF41F000FF;
	Tue, 15 Sep 2026 04:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789447803;
	bh=t3XS3u+iEoIxfloVXwl4UdV97GNtiwhXVGFz4U9t6Zg=;
	h=Date:To:From:Subject;
	b=r0pTFch2h+LnqENFtQkp4k5O2nCYbwOk2168irK+yuuOv7B03cjqr/GZDImDh+NIo
	 UgAD1hunLaGNGM0tw+end2a3tmg3+j7b7fDFr2GDD5LT9qxVX6zSOB/l3/wM7aAHql
	 6lNNMk7mWS6m/OjIP1nNuu+Ejzg5y21LqEzPUwrg=
Date: Mon, 14 Sep 2026 21:50:03 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,pfalcato@suse.de,peterx@redhat.com,ljs@kernel.org,liam@infradead.org,jgg@ziepe.ca,jannh@google.com,david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch added to mm-new branch
Message-Id: <20260915045003.8CAF41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc/task_mmu: handle special PMDs in clear_refs and pagemap
has been added to the -mm mm-new branch.  Its filename is
     proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Gregory Price <gourry@gourry.net>
Subject: proc/task_mmu: handle special PMDs in clear_refs and pagemap
Date: Sat, 12 Sep 2026 08:28:22 -0400

mshv_vtl_low can install a special PMD from a PFN supplied in the mmap file
offset.  That PFN need not have a memmap entry.  Reading /proc/PID/pagemap
or writing /proc/PID/clear_refs for such a mapping oopses the kernel.

With a test driver mapping the PFN at the 1 TiB mark:

  echo 1 > /proc/self/clear_refs

  BUG: unable to handle page fault for address: fffffb5b80000008
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  RIP: 0010:clear_refs_pte_range+0xb1/0x1e0
  Call Trace:
   walk_pgd_range+0x50a/0xad0
   __walk_page_range+0x6a/0x1d0
   walk_page_range_mm_unsafe+0x193/0x230
   clear_refs_write+0x18e/0x3f0

  pread(pagemap_fd, buf, 512 * 8, addr / PAGE_SIZE * 8)

  BUG: unable to handle page fault for address: fffff57840000008
  RIP: 0010:pagemap_pmd_range+0x3cf/0x6b0
  Call Trace:
   walk_pgd_range+0x50a/0xad0
   __walk_page_range+0x6a/0x1d0
   walk_page_range_mm_unsafe+0x193/0x230
   pagemap_read+0x1dc/0x350

clear_refs_pte_range() passes the PMD to pmd_folio(), while
pagemap_pmd_range_thp() uses pmd_page() followed by page_folio().

Both paths assume the PFN has a struct page and dereference bad address.

Use vm_normal_folio_pmd() and vm_normal_page_pmd() so clear_refs skips
folio operations and pagemap skips folio-derived flags for special PMDs.
This matches the PTE paths, which already use vm_normal_folio() and
vm_normal_page().

User-facing notes:
 - Pagemap still reports PM_PRESENT and the PFN to a CAP_SYS_ADMIN reader.

 - For a special PMD backed by a valid memmap entry and for the huge
   zero PMD, PM_FILE changes from set to clear.

 - PM_MMAP_EXCLUSIVE is already clear in both cases.

 - The output for an anonymous THP is unchanged.

Tested in QEMU with the test driver on broken and fixed kernels.  Both proc
operations oops before the fix and return 0 after it.

Link: https://lore.kernel.org/20260912122822.3348978-1-gourry@gourry.net
Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
Signed-off-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260912034833.2952750-1-gourry%40gourry.net
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org> # v6.19+
---

 fs/proc/task_mmu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap
+++ a/fs/proc/task_mmu.c
@@ -1673,7 +1673,9 @@ static int clear_refs_pte_range(pmd_t *p
 		if (!pmd_present(*pmd))
 			goto out;
 
-		folio = pmd_folio(*pmd);
+		folio = vm_normal_folio_pmd(vma, addr, *pmd);
+		if (!folio)
+			goto out;
 
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
@@ -1993,7 +1995,7 @@ static int pagemap_pmd_range_thp(pmd_t *
 		goto populate_pagemap;
 
 	if (pmd_present(pmd)) {
-		page = pmd_page(pmd);
+		page = vm_normal_page_pmd(vma, addr, pmd);
 
 		flags |= PM_PRESENT;
 		if (pmd_soft_dirty(pmd))
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-mempolicy-take-a-cpuset-cookie-for-the-interleave-node-count.patch
mm-mempolicy-use-srcu-for-the-weighted-interleave-state.patch
mm-mempolicy-stop-copying-the-nodemask-in-the-interleave-paths.patch
mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd.patch
mm-madvise-skip-zone-device-folios-in-cold-pageout-pmd-range.patch
mm-mempolicy-skip-zone-device-folios-when-queueing-folios.patch
mm-memory_hotplug-factor-out-node_is_memoryless.patch
mm-mempolicy-use-vm_normal_folio_pmd-in-queue_folios_pmd.patch
mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch
mm-refactor-find_next_best_node-to-find_next_best_node_in.patch
mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists.patch
proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch

