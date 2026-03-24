Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A81F363091
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388587; cv=none; b=eXcVX3ajs+j2MQgxUMQeYqtZpQhE523BlTbQ0iEwzEFj+aFoZj9QQjRC3qrjlfCvkHl0KDr5rLiKH/T+hWQIjDMEDS0jHDPuRa2OFvw703zfUTrCkSLFUe33RCDlApcYIbB3kvOlW4VisYhw/P45fg+i8PPkiaRFcInB4m1+r10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388587; c=relaxed/simple;
	bh=HcPBd25rtRYz6pv61CFgUOLUl0aBBVRvXRtTHiAaS8w=;
	h=Date:To:From:Subject:Message-Id; b=N1g5CJImmn10kly6ByJKz3vJ5QLfcaE9wrHkZaLeo0KT2obITFUhpO0SJC1HPgWjEAT8w7M6DI/Ox6d5phLQ/WhbAWMHCukRzx2Zy/xMPERTvIUhaosy4hxasanRUTG4zURwEnSuRJUAM5LD68PYdyCX/SIPDMBjpEsLq0sOFh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=awy3TojV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="awy3TojV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD5AC19424;
	Tue, 24 Mar 2026 21:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388587;
	bh=HcPBd25rtRYz6pv61CFgUOLUl0aBBVRvXRtTHiAaS8w=;
	h=Date:To:From:Subject:From;
	b=awy3TojVe62f14FyPE1k2ofy7pCFHYh6qTT+4p/k8yH4Mw+pCtNRI3CvWzPxBWDce
	 owrVvc6tdd1ebd+IrCJxiE3tLZ3usDJC+FAexyp8Iq/Jd/ZKtItnbCcaOs/w0A+85k
	 p55QPGk3YmHqKbcnYFAOIQjQJK2hFLsqs1vQtyeE=
Date: Tue, 24 Mar 2026 14:43:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-refine-scan-progress-number.patch removed from -mm tree
Message-Id: <20260324214307.5FD5AC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: refine scan progress number
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-refine-scan-progress-number.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vernon Yang <yanglincheng@kylinos.cn>
Subject: mm: khugepaged: refine scan progress number
Date: Sat, 21 Feb 2026 17:39:16 +0800

Currently, each scan always increases "progress" by HPAGE_PMD_NR,
even if only scanning a single PTE/PMD entry.

- When only scanning a sigle PTE entry, let me provide a detailed
  example:

static int hpage_collapse_scan_pmd()
{
	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
	     _pte++, addr += PAGE_SIZE) {
		pte_t pteval = ptep_get(_pte);
		...
		if (pte_uffd_wp(pteval)) { <-- first scan hit
			result = SCAN_PTE_UFFD_WP;
			goto out_unmap;
		}
	}
}

During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
directly.  In practice, only one PTE is scanned before termination.  Here,
"progress += 1" reflects the actual number of PTEs scanned, but previously
"progress += HPAGE_PMD_NR" always.

- When the memory has been collapsed to PMD, let me provide a detailed
  example:

The following data is traced by bpftrace on a desktop system.  After the
system has been left idle for 10 minutes upon booting, a lot of
SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan by
khugepaged.

From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
following statuses were observed, with frequency mentioned next to them:

SCAN_SUCCEED          : 1
SCAN_EXCEED_SHARED_PTE: 2
SCAN_PMD_MAPPED       : 142
SCAN_NO_PTE_TABLE     : 178
total progress size   : 674 MB
Total time            : 419 seconds, include khugepaged_scan_sleep_millisecs

The khugepaged_scan list save all task that support collapse into
hugepage, as long as the task is not destroyed, khugepaged will not remove
it from the khugepaged_scan list.  This exist a phenomenon where task has
already collapsed all memory regions into hugepage, but khugepaged
continues to scan it, which wastes CPU time and invalid, and due to
khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
scanning a large number of invalid task, so scanning really valid task is
later.

After applying this patch, when the memory is either SCAN_PMD_MAPPED or
SCAN_NO_PTE_TABLE, just skip it, as follow:

SCAN_EXCEED_SHARED_PTE: 2
SCAN_PMD_MAPPED       : 147
SCAN_NO_PTE_TABLE     : 173
total progress size   : 45 MB
Total time            : 20 seconds

SCAN_PTE_MAPPED_HUGEPAGE is the same, for detailed data, refer to
https://lore.kernel.org/linux-mm/4qdu7owpmxfh3ugsue775fxarw5g2gcggbxdf5psj75nnu7z2u@cv2uu2yocaxq

Link: https://lkml.kernel.org/r/20260221093918.1456187-3-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (arm) <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-refine-scan-progress-number
+++ a/mm/khugepaged.c
@@ -68,7 +68,10 @@ enum scan_result {
 static struct task_struct *khugepaged_thread __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);
 
-/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
+/*
+ * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
+ * every 10 second.
+ */
 static unsigned int khugepaged_pages_to_scan __read_mostly;
 static unsigned int khugepaged_pages_collapsed;
 static unsigned int khugepaged_full_scans;
@@ -1231,7 +1234,8 @@ out_nolock:
 }
 
 static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
+		struct vm_area_struct *vma, unsigned long start_addr,
+		bool *mmap_locked, unsigned int *cur_progress,
 		struct collapse_control *cc)
 {
 	pmd_t *pmd;
@@ -1247,19 +1251,27 @@ static enum scan_result hpage_collapse_s
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
-	if (result != SCAN_SUCCEED)
+	if (result != SCAN_SUCCEED) {
+		if (cur_progress)
+			*cur_progress = 1;
 		goto out;
+	}
 
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
+		if (cur_progress)
+			*cur_progress = 1;
 		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}
 
 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
+		if (cur_progress)
+			*cur_progress += 1;
+
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
@@ -2279,8 +2291,9 @@ out:
 	return result;
 }
 
-static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
-		struct file *file, pgoff_t start, struct collapse_control *cc)
+static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
+		unsigned long addr, struct file *file, pgoff_t start,
+		unsigned int *cur_progress, struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
@@ -2370,6 +2383,12 @@ static enum scan_result hpage_collapse_s
 		}
 	}
 	rcu_read_unlock();
+	if (cur_progress) {
+		if (result == SCAN_PTE_MAPPED_HUGEPAGE)
+			*cur_progress = 1;
+		else
+			*cur_progress = HPAGE_PMD_NR;
+	}
 
 	if (result == SCAN_SUCCEED) {
 		if (cc->is_khugepaged &&
@@ -2448,6 +2467,7 @@ static unsigned int khugepaged_scan_mm_s
 
 		while (khugepaged_scan.address < hend) {
 			bool mmap_locked = true;
+			unsigned int cur_progress = 0;
 
 			cond_resched();
 			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
@@ -2464,7 +2484,8 @@ static unsigned int khugepaged_scan_mm_s
 				mmap_read_unlock(mm);
 				mmap_locked = false;
 				*result = hpage_collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff, cc);
+					khugepaged_scan.address, file, pgoff,
+					&cur_progress, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
@@ -2478,7 +2499,8 @@ static unsigned int khugepaged_scan_mm_s
 				}
 			} else {
 				*result = hpage_collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked, cc);
+					khugepaged_scan.address, &mmap_locked,
+					&cur_progress, cc);
 			}
 
 			if (*result == SCAN_SUCCEED)
@@ -2486,7 +2508,7 @@ static unsigned int khugepaged_scan_mm_s
 
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			progress += HPAGE_PMD_NR;
+			progress += cur_progress;
 			if (!mmap_locked)
 				/*
 				 * We released mmap_lock so break loop.  Note
@@ -2809,7 +2831,7 @@ retry:
 			mmap_locked = false;
 			*lock_dropped = true;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+							  NULL, cc);
 
 			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
 			    mapping_can_writeback(file->f_mapping)) {
@@ -2824,7 +2846,7 @@ retry:
 			fput(file);
 		} else {
 			result = hpage_collapse_scan_pmd(mm, vma, addr,
-							 &mmap_locked, cc);
+							 &mmap_locked, NULL, cc);
 		}
 		if (!mmap_locked)
 			*lock_dropped = true;
_

Patches currently in -mm which might be from yanglincheng@kylinos.cn are


