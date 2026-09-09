Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EB1381AFF
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 06:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936870; cv=none; b=jH4RE28zx482Hsx2tGSFSiP8sMSMn147outSR6ejMh9ChA81Tv1VHw8/vx7I3KVE50VGbIxP8DJZAi1feZrqHg+Nupz6L0yYa5e9mdTLJhowBhjag+D5h9ql3PJi292IzrH8fKVk3UJR2d25tt/dFbMmPtftXq1er2QzJd5mw4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936870; c=relaxed/simple;
	bh=W5vMRO/wEoE7oAwzvwC2HVWRuaH7B6korbDmGYKAMFE=;
	h=Date:To:From:Subject:Message-Id; b=TKDJ/92N3pSWu0Ek6X3sKQjTgRFk/EZUAq0lYSzy44V6ZKeUpryBb2Qbhyj1oiNaxh2yp+p7b9K/c+ohl2QaKFlLESgatdXlZr9+mXs/fxRTejIKjqKAGtS807PaV9wfcifopD6exS2Df3ouBNY+NOW3/DwqMe1QHG/d0bkJgd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lYGotZ2m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lYGotZ2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0761F00A3D;
	Wed,  9 Sep 2026 06:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788936869;
	bh=xXe1HTBVBkTC2WV+qkK5ErR8n5YwiKFNSMt/df2sYXM=;
	h=Date:To:From:Subject;
	b=lYGotZ2mjF93b2yL5p+sDhi6G0n29b305OiVqyXdQGIHQZYPMtAsE3o2DHVAHIrH5
	 8yvN8lFyisf3Ay3JFAvreQe1st5Q4ggoGbZKtKy+2/8AFU/FDKZQhCk5cnqQ8yoyNV
	 9tjo1iBsWpWfHBdbFEybg3DXNBN63ik5/EoryQcQ=
Date: Tue, 08 Sep 2026 23:54:28 -0700
To: mm-commits@vger.kernel.org,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-fix-folio-is-used-after-folio_put-unlock.patch removed from -mm tree
Message-Id: <20260909065429.4E0761F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: fix folio is used after folio_put/unlock()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-folio-is-used-after-folio_put-unlock.patch

This patch was dropped because an updated version will be issued

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

x86-mm-fix-pmd_modify-dropping-the-dirty-bit.patch

