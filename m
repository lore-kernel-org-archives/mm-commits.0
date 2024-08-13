Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B590EA953
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 20:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723579990; cv=none; b=iJsDsytaG6JSnNuEDVLkGOZpTh510qM4vSzvhZbLAl3E37GzrOsxu7O42SYpQoXU7n0ZNHa8i9Zf1+86uLtiSdplFrbKM/MKf0Fjr83jmDtTnIN9dmwYpWYcdKhYvWH+zA8qFW9+IuzSjKbu1fti9upfCQwWML+mt9QmZH1KeCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723579990; c=relaxed/simple;
	bh=4NYktQ4+OZTt0VvUoKbq/wwR87QUe00TT2Fuok7+/tc=;
	h=Date:To:From:Subject:Message-Id; b=I4t43i+kI/d6Bs5Wy8CghFjZ4a4JmVRU0cEfkn1KBEu2T27in83AQCB+EnjEltLUmZzimAfmKVGNgCnxkcJ7AXwLdtvm/6GkoFjPA1e09oBwWx9XvkhiI17gXpcAtsZTj4tvbszIGCX9Hfjg9MysrCNZ4sabGKk/e4Z70h6TXZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J5ielByI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J5ielByI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37415C32782;
	Tue, 13 Aug 2024 20:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723579990;
	bh=4NYktQ4+OZTt0VvUoKbq/wwR87QUe00TT2Fuok7+/tc=;
	h=Date:To:From:Subject:From;
	b=J5ielByIhGu6fiOdgrceJDBZ17UqB1M1sszNkHGYC8YrShLV1A/2f1l9KqVt2Vls/
	 ByHygbzucbTP7jf0ZE2L2WmP0Y3EJaH05ZLXNp8ot4YVNRpxo1f2kna+KQ4EYhc4BR
	 84Xr9l7vO84xia1pSUinDTnZc0DgA5VeX8iXrsdI=
Date: Tue, 13 Aug 2024 13:13:09 -0700
To: mm-commits@vger.kernel.org,zhais@google.com,yuzhao@google.com,willy@infradead.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,alexlzhu@fb.com,ak@linux.intel.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-split-underutilized-thps.patch added to mm-unstable branch
Message-Id: <20240813201310.37415C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: split underutilized THPs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-split-underutilized-thps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-split-underutilized-thps.patch

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
Subject: mm: split underutilized THPs
Date: Tue, 13 Aug 2024 13:02:48 +0100

This is an attempt to mitigate the issue of running out of memory when THP
is always enabled.  During runtime whenever a THP is being faulted in
(__do_huge_pmd_anonymous_page) or collapsed by khugepaged
(collapse_huge_page), the THP is added to _deferred_list.  Whenever memory
reclaim happens in linux, the kernel runs the deferred_split shrinker
which goes through the _deferred_list.

If the folio was partially mapped, the shrinker attempts to split it.  If
the folio is not partially mapped, the shrinker checks if the THP was
underutilized, i.e.  how many of the base 4K pages of the entire THP were
zero-filled.  If this number goes above a certain threshold (decided by
/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none), the
shrinker will attempt to split that THP.  Then at remap time, the pages
that were zero-filled are mapped to the shared zeropage, hence saving
memory.

Link: https://lkml.kernel.org/r/20240813120328.1275952-6-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Suggested-by: Rik van Riel <riel@surriel.com>
Co-authored-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexander Zhu <alexlzhu@fb.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuang Zhai <zhais@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    6 +
 include/linux/khugepaged.h                 |    1 
 include/linux/vm_event_item.h              |    1 
 mm/huge_memory.c                           |   76 +++++++++++++++++--
 mm/khugepaged.c                            |    3 
 mm/vmstat.c                                |    1 
 6 files changed, 80 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-split-underutilized-thps
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -447,6 +447,12 @@ thp_deferred_split_page
 	splitting it would free up some memory. Pages on split queue are
 	going to be split under memory pressure.
 
+thp_underutilized_split_page
+	is incremented when a huge page on the split queue was split
+	because it was underutilized. A THP is underutilized if the
+	number of zero pages in the THP is above a certain threshold
+	(/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none).
+
 thp_split_pmd
 	is incremented every time a PMD split into table of PTEs.
 	This can happen, for instance, when application calls mprotect() or
--- a/include/linux/khugepaged.h~mm-split-underutilized-thps
+++ a/include/linux/khugepaged.h
@@ -4,6 +4,7 @@
 
 #include <linux/sched/coredump.h> /* MMF_VM_HUGEPAGE */
 
+extern unsigned int khugepaged_max_ptes_none __read_mostly;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern struct attribute_group khugepaged_attr_group;
 
--- a/include/linux/vm_event_item.h~mm-split-underutilized-thps
+++ a/include/linux/vm_event_item.h
@@ -105,6 +105,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_SPLIT_PAGE,
 		THP_SPLIT_PAGE_FAILED,
 		THP_DEFERRED_SPLIT_PAGE,
+		THP_UNDERUTILIZED_SPLIT_PAGE,
 		THP_SPLIT_PMD,
 		THP_SCAN_EXCEED_NONE_PTE,
 		THP_SCAN_EXCEED_SWAP_PTE,
--- a/mm/huge_memory.c~mm-split-underutilized-thps
+++ a/mm/huge_memory.c
@@ -1087,6 +1087,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 		update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm_inc_nr_ptes(vma->vm_mm);
+		deferred_split_folio(folio, false);
 		spin_unlock(vmf->ptl);
 		count_vm_event(THP_FAULT_ALLOC);
 		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
@@ -3515,6 +3516,39 @@ static unsigned long deferred_split_coun
 	return READ_ONCE(ds_queue->split_queue_len);
 }
 
+static bool thp_underutilized(struct folio *folio)
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
@@ -3548,17 +3582,45 @@ static unsigned long deferred_split_scan
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 
 	list_for_each_entry_safe(folio, next, &list, _deferred_list) {
+		bool did_split = false;
+		bool underutilized = false;
+
+		if (folio_test_partially_mapped(folio))
+			goto split;
+		underutilized = thp_underutilized(folio);
+		if (underutilized)
+			goto split;
+		continue;
+split:
 		if (!folio_trylock(folio))
-			goto next;
-		/* split_huge_page() removes page from list on success */
-		if (!split_folio(folio))
-			split++;
+			continue;
+		did_split = !split_folio(folio);
 		folio_unlock(folio);
-next:
-		folio_put(folio);
+		if (did_split) {
+			/* Splitting removed folio from the list, drop reference here */
+			folio_put(folio);
+			if (underutilized)
+				count_vm_event(THP_UNDERUTILIZED_SPLIT_PAGE);
+			split++;
+		}
 	}
+
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-	list_splice_tail(&list, &ds_queue->split_queue);
+	/*
+	 * Only add back to the queue if folio is partially mapped.
+	 * If thp_underutilized returns false, or if split_folio fails in
+	 * the case it was underutilized, then consider it used and don't
+	 * add it back to split_queue.
+	 */
+	list_for_each_entry_safe(folio, next, &list, _deferred_list) {
+		if (folio_test_partially_mapped(folio))
+			list_move(&folio->_deferred_list, &ds_queue->split_queue);
+		else {
+			list_del_init(&folio->_deferred_list);
+			ds_queue->split_queue_len--;
+		}
+		folio_put(folio);
+	}
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 
 	/*
--- a/mm/khugepaged.c~mm-split-underutilized-thps
+++ a/mm/khugepaged.c
@@ -85,7 +85,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepage
  *
  * Note that these are only respected if collapse was initiated by khugepaged.
  */
-static unsigned int khugepaged_max_ptes_none __read_mostly;
+unsigned int khugepaged_max_ptes_none __read_mostly;
 static unsigned int khugepaged_max_ptes_swap __read_mostly;
 static unsigned int khugepaged_max_ptes_shared __read_mostly;
 
@@ -1235,6 +1235,7 @@ static int collapse_huge_page(struct mm_
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, address, pmd, _pmd);
 	update_mmu_cache_pmd(vma, address, pmd);
+	deferred_split_folio(folio, false);
 	spin_unlock(pmd_ptl);
 
 	folio = NULL;
--- a/mm/vmstat.c~mm-split-underutilized-thps
+++ a/mm/vmstat.c
@@ -1386,6 +1386,7 @@ const char * const vmstat_text[] = {
 	"thp_split_page",
 	"thp_split_page_failed",
 	"thp_deferred_split_page",
+	"thp_underutilized_split_page",
 	"thp_split_pmd",
 	"thp_scan_exceed_none_pte",
 	"thp_scan_exceed_swap_pte",
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-introduce-a-pageflag-for-partially-mapped-folios.patch
mm-split-underutilized-thps.patch
mm-add-sysfs-entry-to-disable-splitting-underutilized-thps.patch

