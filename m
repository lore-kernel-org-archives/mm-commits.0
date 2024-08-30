Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AE31BE856
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725057439; cv=none; b=V32t+If6s075QGZV1evxohBNa1Hl2wHAeAG+/PMYv59FpCrk6EBCI5Xb8Eg20rd5q+M4Ru1rteabmECGZGWHnoBQCcc23z46pLUwPcWtBI7zWK+4EfQT9Elk67PEkAUvZZRjoSadcS/AQXrc3eW/npcyaMVrSHmdefgtB4AMsbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725057439; c=relaxed/simple;
	bh=+YwK0YgrCYUX9A8zHXj3wISO6hXL3kN3qfJglvWjquE=;
	h=Date:To:From:Subject:Message-Id; b=FfpGahBADN7N+tqI54/y4/20AIfPcfnM8VdBUEYV+at24Le24UUnXMh470zgZkngz2wJsP/5z45x3lLY2vcUqCUB3znYNW09/yIcEyeDaJBfDkMFOMFe+FLIdvmaYgyyRvW7i7lhw7ZAhbl2o3DOknhuZMyYB9zYQWZT1Y4YUvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S+Jide2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S+Jide2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BFAC4CEC2;
	Fri, 30 Aug 2024 22:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725057439;
	bh=+YwK0YgrCYUX9A8zHXj3wISO6hXL3kN3qfJglvWjquE=;
	h=Date:To:From:Subject:From;
	b=S+Jide2yBwI2iLcO/u685msU+cZaBX8nMk4XM+vSz67l4xIuHpz+JcRn9wqKhI6cf
	 hhRQu8nDcIqi70kuLlrJ7K6KEnAowtt86EWszSbw0fJA6et1cjbeYrnlewblSwqRhg
	 9XL/jD5fVOsOAMlP2xXN2k+2dcCyg0JaNGKzzei8=
Date: Fri, 30 Aug 2024 15:37:18 -0700
To: mm-commits@vger.kernel.org,zhais@google.com,yuzhao@google.com,willy@infradead.org,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,npache@redhat.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,alexlzhu@fb.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-split-underused-thps.patch added to mm-unstable branch
Message-Id: <20240830223719.41BFAC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: split underused THPs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-split-underused-thps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-split-underused-thps.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm: split underused THPs
Date: Fri, 30 Aug 2024 11:03:39 +0100

This is an attempt to mitigate the issue of running out of memory when THP
is always enabled.  During runtime whenever a THP is being faulted in
(__do_huge_pmd_anonymous_page) or collapsed by khugepaged
(collapse_huge_page), the THP is added to _deferred_list.  Whenever memory
reclaim happens in linux, the kernel runs the deferred_split shrinker
which goes through the _deferred_list.

If the folio was partially mapped, the shrinker attempts to split it.  If
the folio is not partially mapped, the shrinker checks if the THP was
underused, i.e.  how many of the base 4K pages of the entire THP were
zero-filled.  If this number goes above a certain threshold (decided by
/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none), the
shrinker will attempt to split that THP.  Then at remap time, the pages
that were zero-filled are mapped to the shared zeropage, hence saving
memory.

Link: https://lkml.kernel.org/r/20240830100438.3623486-6-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Suggested-by: Rik van Riel <riel@surriel.com>
Co-authored-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexander Zhu <alexlzhu@fb.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuang Zhai <zhais@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    6 +
 include/linux/khugepaged.h                 |    1 
 include/linux/vm_event_item.h              |    1 
 mm/huge_memory.c                           |   60 ++++++++++++++++++-
 mm/khugepaged.c                            |    3 
 mm/vmstat.c                                |    1 
 6 files changed, 69 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-split-underused-thps
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -471,6 +471,12 @@ thp_deferred_split_page
 	splitting it would free up some memory. Pages on split queue are
 	going to be split under memory pressure.
 
+thp_underused_split_page
+	is incremented when a huge page on the split queue was split
+	because it was underused. A THP is underused if the number of
+	zero pages in the THP is above a certain threshold
+	(/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none).
+
 thp_split_pmd
 	is incremented every time a PMD split into table of PTEs.
 	This can happen, for instance, when application calls mprotect() or
--- a/include/linux/khugepaged.h~mm-split-underused-thps
+++ a/include/linux/khugepaged.h
@@ -4,6 +4,7 @@
 
 #include <linux/sched/coredump.h> /* MMF_VM_HUGEPAGE */
 
+extern unsigned int khugepaged_max_ptes_none __read_mostly;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern struct attribute_group khugepaged_attr_group;
 
--- a/include/linux/vm_event_item.h~mm-split-underused-thps
+++ a/include/linux/vm_event_item.h
@@ -105,6 +105,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_SPLIT_PAGE,
 		THP_SPLIT_PAGE_FAILED,
 		THP_DEFERRED_SPLIT_PAGE,
+		THP_UNDERUSED_SPLIT_PAGE,
 		THP_SPLIT_PMD,
 		THP_SCAN_EXCEED_NONE_PTE,
 		THP_SCAN_EXCEED_SWAP_PTE,
--- a/mm/huge_memory.c~mm-split-underused-thps
+++ a/mm/huge_memory.c
@@ -1187,6 +1187,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 		update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm_inc_nr_ptes(vma->vm_mm);
+		deferred_split_folio(folio, false);
 		spin_unlock(vmf->ptl);
 		count_vm_event(THP_FAULT_ALLOC);
 		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
@@ -3652,6 +3653,39 @@ static unsigned long deferred_split_coun
 	return READ_ONCE(ds_queue->split_queue_len);
 }
 
+static bool thp_underused(struct folio *folio)
+{
+	int num_zero_pages = 0, num_filled_pages = 0;
+	void *kaddr;
+	int i;
+
+	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
+		return false;
+
+	for (i = 0; i < folio_nr_pages(folio); i++) {
+		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
+		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
+			num_zero_pages++;
+			if (num_zero_pages > khugepaged_max_ptes_none) {
+				kunmap_local(kaddr);
+				return true;
+			}
+		} else {
+			/*
+			 * Another path for early exit once the number
+			 * of non-zero filled pages exceeds threshold.
+			 */
+			num_filled_pages++;
+			if (num_filled_pages >= HPAGE_PMD_NR - khugepaged_max_ptes_none) {
+				kunmap_local(kaddr);
+				return false;
+			}
+		}
+		kunmap_local(kaddr);
+	}
+	return false;
+}
+
 static unsigned long deferred_split_scan(struct shrinker *shrink,
 		struct shrink_control *sc)
 {
@@ -3689,13 +3723,35 @@ static unsigned long deferred_split_scan
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 
 	list_for_each_entry_safe(folio, next, &list, _deferred_list) {
+		bool did_split = false;
+		bool underused = false;
+
+		if (!folio_test_partially_mapped(folio)) {
+			underused = thp_underused(folio);
+			if (!underused)
+				goto next;
+		}
 		if (!folio_trylock(folio))
 			goto next;
-		/* split_huge_page() removes page from list on success */
-		if (!split_folio(folio))
+		if (!split_folio(folio)) {
+			did_split = true;
+			if (underused)
+				count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
 			split++;
+		}
 		folio_unlock(folio);
 next:
+		/*
+		 * split_folio() removes folio from list on success.
+		 * Only add back to the queue if folio is partially mapped.
+		 * If thp_underused returns false, or if split_folio fails
+		 * in the case it was underused, then consider it used and
+		 * don't add it back to split_queue.
+		 */
+		if (!did_split && !folio_test_partially_mapped(folio)) {
+			list_del_init(&folio->_deferred_list);
+			ds_queue->split_queue_len--;
+		}
 		folio_put(folio);
 	}
 
--- a/mm/khugepaged.c~mm-split-underused-thps
+++ a/mm/khugepaged.c
@@ -85,7 +85,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepage
  *
  * Note that these are only respected if collapse was initiated by khugepaged.
  */
-static unsigned int khugepaged_max_ptes_none __read_mostly;
+unsigned int khugepaged_max_ptes_none __read_mostly;
 static unsigned int khugepaged_max_ptes_swap __read_mostly;
 static unsigned int khugepaged_max_ptes_shared __read_mostly;
 
@@ -1237,6 +1237,7 @@ static int collapse_huge_page(struct mm_
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, address, pmd, _pmd);
 	update_mmu_cache_pmd(vma, address, pmd);
+	deferred_split_folio(folio, false);
 	spin_unlock(pmd_ptl);
 
 	folio = NULL;
--- a/mm/vmstat.c~mm-split-underused-thps
+++ a/mm/vmstat.c
@@ -1385,6 +1385,7 @@ const char * const vmstat_text[] = {
 	"thp_split_page",
 	"thp_split_page_failed",
 	"thp_deferred_split_page",
+	"thp_underused_split_page",
 	"thp_split_pmd",
 	"thp_scan_exceed_none_pte",
 	"thp_scan_exceed_swap_pte",
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

revert-mm-skip-cma-pages-when-they-are-not-available.patch
revert-mm-skip-cma-pages-when-they-are-not-available-update.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch
mm-remove-code-to-handle-same-filled-pages.patch
mm-introduce-a-pageflag-for-partially-mapped-folios.patch
mm-split-underused-thps.patch
mm-add-sysfs-entry-to-disable-splitting-underused-thps.patch

