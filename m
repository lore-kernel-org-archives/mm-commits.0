Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0DE51EE1A
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 18:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791915964; cv=none; b=fSqzl3GvT/Wm3yAvFsfO96n2cqmHo6RYTZv3a8b08YWTLYHHKRmM1wIDThRnxwBolyrgSDHOYyykDCnwbd8d4HKbsH2OGqbcBRhj41M2oHyu1LzYZ6/W/RcSMKuBIdGfbgeywBv41E3pZ1wuYwmOxoP3J3rn2q9D4y3WWr9GMts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791915964; c=relaxed/simple;
	bh=IyBwdzzfv1fYWRS5O3lucsqFA3pppJzZymSwtPNHLXE=;
	h=Date:To:From:Subject:Message-Id; b=W2h6LrNZY+9AYk/kku9pnI0hKTCCaZxsOC0vFwEIjGOEqEsubyzX4f46tzFlR/qg2Oj740u1zYMkent1LRdLp9T/nHIiFft+chj1oRCiV5vBtzoKnjZOKN/up/KwOKQwSwksHRkOjrGq/NFsgFmdcyTEMVMPU+DSax8YMl34pR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ObbKWgCX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ObbKWgCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EEA1F00893;
	Tue, 13 Oct 2026 18:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791915963;
	bh=T/gEMFUNcFuNNUAwn9rPHTaw/umJIVF5FLn3K4rxBl4=;
	h=Date:To:From:Subject;
	b=ObbKWgCXlgfMbMNf8SunLALNYuQv356xCk+czGGu6qEMPL/g87kSuZRSNNXyBTACU
	 n6iZ4Oc7ltXh6sDu6d45gJ3qAEFTPyGvTXopFxp0WoZIOuz4G9NdR4p/iG4PPQ6yU8
	 exoEol1o7htrH8r1mvQaA66esTxiNcr6DRJ66anY=
Date: Tue, 13 Oct 2026 11:26:02 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch removed from -mm tree
Message-Id: <20261013182603.19EEA1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: count collapses where khugepaged makes them
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/khugepaged: count collapses where khugepaged makes them
Date: Mon, 28 Sep 2026 11:06:16 +0100

collapse_single_pmd() bumps khugepaged_pages_collapsed for its caller, and
tests cc->is_khugepaged to know whether it should: the counter belongs to
the daemon, and MADV_COLLAPSE must not touch it.

The daemon sees every result of every collapse it asks for, so it can keep
its own counter without the shared path testing who called.

Link: https://lore.kernel.org/20260928100630.21870-3-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
---

 mm/khugepaged.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-count-collapses-where-khugepaged-makes-them
+++ a/mm/khugepaged.c
@@ -2845,10 +2845,8 @@ static enum scan_result collapse_single_
 
 	mmap_assert_locked(mm);
 
-	if (vma_is_anonymous(vma)) {
-		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
-		goto end;
-	}
+	if (vma_is_anonymous(vma))
+		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
 
 	file = get_file(vma->vm_file);
 	pgoff = linear_page_index(vma, addr);
@@ -2884,9 +2882,6 @@ retry:
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
 	}
-end:
-	if (cc->is_khugepaged && result == SCAN_SUCCEED)
-		++khugepaged_pages_collapsed;
 	return result;
 }
 
@@ -2963,6 +2958,8 @@ static void collapse_scan_mm_slot(unsign
 
 			*result = collapse_single_pmd(khugepaged_scan.address,
 						      vma, &lock_dropped, cc);
+			if (*result == SCAN_SUCCEED)
+				khugepaged_pages_collapsed++;
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			if (lock_dropped)
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

