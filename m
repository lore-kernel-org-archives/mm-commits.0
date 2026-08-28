Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419AB3A9DA2;
	Fri, 28 Aug 2026 17:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787939609; cv=none; b=lAdJaMpRPdM9ewtQlwR4bW1/gbFfT66YkpSC6foSWQObQ2bxsLUzuiPyzbBI5+WJo+qvHjNJm+B4aZAfmB14stXzcOHn+FF+rM27UNz1Ug42gie/24LoMAzcn7ugiXKQTH84ANa2KxSJKpXvtHPNOLpf0ukRQAw4MkeoU67gXNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787939609; c=relaxed/simple;
	bh=kqUZJGesjqLOGE0OnnvnVs6UIaEzluoX0RmjWm/1rPg=;
	h=Date:To:From:Subject:Message-Id; b=Ee55J1zLg8En9jNJlqTSs7lhybjnYlz+hSqgrGfSRydVUMnrxHEDoQOZMT09ZyvJhf2tGN1Q1DUD71ssi1oXh4ICX+vcJcHS68noucDVkmFzeINGrC9+06GObgmlLlUeykVWV8vSBQo2L96xoSF+OpqTE0L0stiM2aftqPMq6u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RR9j3r/L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RR9j3r/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2B81F000E9;
	Fri, 28 Aug 2026 17:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787939607;
	bh=T9mvozqe6ox4n8Pq0cTNiCzZfPRTNsAZ92MuVXTQfd8=;
	h=Date:To:From:Subject;
	b=RR9j3r/LnOx4acdIGKcioggU+xQchzsRx/lmWmenhmWyD0jAEe87DRcO+u01LE/wu
	 4LR8hJTiXHJap/jn5HG0w2XWsHfVsEnsBnj92z/YuBY6P8uB/0rYsh6Sk3pmiYO0GC
	 sClmalwp7+ynj/GQAK8j6U1X5tLP1USPu4mlrRuw=
Date: Fri, 28 Aug 2026 10:53:27 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,stable@vger.kernel.org,ryan.roberts@arm.com,ljs@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-folio-is-used-after-folio_put-unlock.patch added to mm-new branch
Message-Id: <20260828175327.AF2B81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: fix folio is used after folio_put/unlock()
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-fix-folio-is-used-after-folio_put-unlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-folio-is-used-after-folio_put-unlock.patch

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
From: Vernon Yang <yanglincheng@kylinos.cn>
Subject: mm: khugepaged: fix folio is used after folio_put/unlock()
Date: Fri, 28 Aug 2026 13:59:26 +0800

On the rollback path, folio_put() has already dropped the last reference
of new_folio.  On the success path, new_folio is already unlocked and can
be freed concurrently.  The trace_mm_khugepaged_collapse_file() is left
with a dangling folio pointer.

So using the folio_pfn() before dropping the reference, closing
use-after-free window.

Link: https://lore.kernel.org/20260828055926.346744-4-vernon2gm@gmail.com
Fixes: 4c9473e87e75 ("mm/khugepaged: add tracepoint to collapse_file()")
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    6 +++---
 mm/khugepaged.c                    |    4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-fix-folio-is-used-after-folio_put-unlock
+++ a/include/trace/events/huge_memory.h
@@ -211,10 +211,10 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 );
 
 TRACE_EVENT(mm_khugepaged_collapse_file,
-	TP_PROTO(struct mm_struct *mm, struct folio *new_folio, pgoff_t index,
+	TP_PROTO(struct mm_struct *mm, unsigned long new_pfn, pgoff_t index,
 			unsigned long addr, bool is_shmem, struct file *file,
 			int nr, int result),
-	TP_ARGS(mm, new_folio, index, addr, is_shmem, file, nr, result),
+	TP_ARGS(mm, new_pfn, index, addr, is_shmem, file, nr, result),
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(unsigned long, hpfn)
@@ -228,7 +228,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->hpfn = new_folio ? folio_pfn(new_folio) : -1;
+		__entry->hpfn = new_pfn;
 		__entry->index = index;
 		__entry->addr = addr;
 		__entry->is_shmem = is_shmem;
--- a/mm/khugepaged.c~mm-khugepaged-fix-folio-is-used-after-folio_put-unlock
+++ a/mm/khugepaged.c
@@ -2256,6 +2256,7 @@ static enum scan_result collapse_file(st
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
+	unsigned long new_pfn = -1;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -2275,6 +2276,7 @@ static enum scan_result collapse_file(st
 	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out;
+	new_pfn = folio_pfn(new_folio);
 
 	mapping_set_update(&xas, mapping);
 
@@ -2678,7 +2680,7 @@ rollback:
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
+	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
 }
 
_

Patches currently in -mm which might be from yanglincheng@kylinos.cn are

mm-khugepaged-fix-swap-entry-value-to-folio_pfn.patch
mm-khugepaged-fix-folio-is-used-after-pte_unmap_unlock.patch
mm-khugepaged-fix-folio-is-used-after-folio_put-unlock.patch

