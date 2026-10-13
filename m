Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733FD481256;
	Tue, 13 Oct 2026 04:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865926; cv=none; b=qMb5lMlVDJHn4Trx4W0Sqf0uE0uEKyVnIOEBL6Qtsg3aBOMG2ar/g1uRHWMoWejW2IVOlK4HDUxheMkN8J/XBWgNyCQ9yvRer8eZSxTYt9pia6ZEaTwp8Z2mZkF2HJYheCXAd+t2lgBEGL96gkPZaRZyHvQ7Hbn9l04CrHRjde4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865926; c=relaxed/simple;
	bh=zHR1qwGciEnfAq1GlhqD+mc8z85FZ8dB7XbWdFpKvqk=;
	h=Date:To:From:Subject:Message-Id; b=Yx2aF1dhXgeYjJs9/5amAXRCjohp3d/ybPWcTqNT3+hOHe49WlnebmmLrK+02/+RSRbxYpuFcadbqkUWg1EcYDDLj83ANNUkEw5DOl3yZVqfKM6Ab1aUH1NriCZcnyYl/PCQphwnWk00NerRYMLHuS/YgYqo/uEz0MQs+7qgy3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gp2HQNhq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gp2HQNhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B601F00893;
	Tue, 13 Oct 2026 04:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865925;
	bh=R3N1AEyWXK4K2pbeLNvRY+ybGXYAgW/7hOpB9k3TtRY=;
	h=Date:To:From:Subject;
	b=gp2HQNhqrH4aNUMVWMciSpMlarD+0ic6UO/sxyLsuREPR3+EgOGCjxnqwgBL8Zwyt
	 roqydjdP8iojBkbl7eUCfj5ilwWuLwJfA7YQDNoi5spndBoGm0sA80cT7TBmAVj25K
	 N+alg/6pjz4BwGZ2pJ/qxXYvF1No7kwLWk0/hsW4=
Date: Mon, 12 Oct 2026 21:32:04 -0700
To: mm-commits@vger.kernel.org,wangjiexun@tinylab.org,vbabka@kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch removed from -mm tree
Message-Id: <20261013043205.13B601F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: reclaim isolated folios if PTE restart fails
has been removed from the -mm tree.  Its filename was
     mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

This results in a permanent memory leak.  nr_isolated_anon increases
reliably and does not decrease when the process dies.

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
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jiexun Wang <wangjiexun@tinylab.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/madvise.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-reclaim-isolated-folios-if-pte-restart-fails
+++ a/mm/madvise.c
@@ -462,7 +462,7 @@ regular_folio:
 restart:
 	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (!start_pte)
-		return 0;
+		goto out;
 	flush_tlb_batched_pending(mm);
 	lazy_mmu_mode_enable();
 	for (; addr < end; pte += nr, addr += nr * PAGE_SIZE) {
@@ -566,6 +566,7 @@ restart:
 			folio_deactivate(folio);
 	}
 
+out:
 	if (start_pte) {
 		lazy_mmu_mode_disable();
 		pte_unmap_unlock(start_pte, ptl);
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch

