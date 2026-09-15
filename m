Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93D233F58B;
	Tue, 15 Sep 2026 06:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789453979; cv=none; b=m9OlrjpteEL16OfBxCFGJ02laXXPWpILtN9eF/knwlXulTGLu3EJZ/O02a5iHxczpsDNTiRwgkoObaXXZoN+ubcIAk5jz3n7GbPfjurP7kHV8nykChOw3m9Kv/lwFFRLIQbiTs1yH54T+dLspltTNJP44gcz7WlyUbuvqF5+kaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789453979; c=relaxed/simple;
	bh=XDIBKee2ih47Hhh2OCaF3AJfh9RssxjIG0IQIj/aXLo=;
	h=Date:To:From:Subject:Message-Id; b=p4lB19/TNdFLibC1JZcC+yOs4hCrm5OEZQg/PCVueei81Jn07ei3y7eUQJVTfG4SujcGQvvkfLS623lgvzQT6qBLtiX0Im+3NHLptmCRKMEnvhsdx407Plw12aFeh3LSnQimGRkz7SkPUgoCsjoT5ZOPduvl5oO2gVOAQqOR0KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eztsVct8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eztsVct8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4497B1F000FF;
	Tue, 15 Sep 2026 06:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789453977;
	bh=mXLIxQYlw9AGMjpu/G7Y9Z00Vlod80mQCMF6/5pW8cc=;
	h=Date:To:From:Subject;
	b=eztsVct8/1G/7jsZHxbmUD87WMqaJJGTympHdpzQfuv9mJJ7Hb29USTvRR7n7FQ+z
	 UTfKipsrNe40fPaWIrNlN36WLra/kA/r4ftXqO3ney6goNx+9T2z9A16cv361O2iUK
	 jGf8KiijjqbH/QZJbshJWbFWYG5ermJJw/sM1Ruk=
Date: Mon, 14 Sep 2026 23:32:56 -0700
To: mm-commits@vger.kernel.org,wangjiexun@tinylab.org,vbabka@kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch added to mm-new branch
Message-Id: <20260915063257.4497B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: reclaim isolated folios if PTE restart fails
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch

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
Subject: mm/madvise: reclaim isolated folios if PTE restart fails
Date: Sat, 12 Sep 2026 07:08:32 -0400

MADV_PAGEOUT collects isolated folios on a local list before reclaiming
them after the PTE walk.  The reschedule path drops the PTE lock and then
restarts the mapping with pte_offset_map_lock().

A concurrent operation can remove or replace the PTE table while the lock
is dropped, causing pte_offset_map_lock() to return NULL.  Returning
directly in that case bypasses reclaim_pages(), leaving the collected
folios off the LRU with elevated references.

Route the failure through the existing cleanup path so any isolated folios
are reclaimed or put back.

Simplest userland pseudo-code reproducer:

p = mmap(PMD_SIZE, ANONYMOUS);
touch_every_page(p, PMD_SIZE);
parallel {
   while (1) madvise(p, PMD_SIZE, MADV_PAGEOUT);
   while (1) {
       madvise(p, PMD_SIZE, MADV_DONTNEED);
       touch_every_page(p, PMD_SIZE);
   }
}

Reproduced in qemu trivially with some explicit widening of the race window.

Link: https://lore.kernel.org/20260912110832.3203902-1-gourry@gourry.net
Fixes: b2f557a21bc8 ("mm/madvise: add cond_resched() in madvise_cold_or_pageout_pte_range()")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260821150912.183976-1-gourry@gourry.net
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jiexun Wang <wangjiexun@tinylab.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/madvise.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-reclaim-isolated-folios-if-pte-restart-fails
+++ a/mm/madvise.c
@@ -463,7 +463,7 @@ regular_folio:
 restart:
 	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (!start_pte)
-		return 0;
+		goto out;
 	flush_tlb_batched_pending(mm);
 	lazy_mmu_mode_enable();
 	for (; addr < end; pte += nr, addr += nr * PAGE_SIZE) {
@@ -567,6 +567,7 @@ restart:
 			folio_deactivate(folio);
 	}
 
+out:
 	if (start_pte) {
 		lazy_mmu_mode_disable();
 		pte_unmap_unlock(start_pte, ptl);
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
mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch

