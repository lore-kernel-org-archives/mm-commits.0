Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9234C36DA1A
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027611; cv=none; b=nsI7pr9qd1e4SiQoQJlEGMHv125CznqMwf2Og0osboM0ib2DNlUmJ4c2PTp15Z8YXvo8bvs7wC61t/JLuW40RpEcsBPftIlsU5vp83u1hK1gNuxFwLojRHOJ7TBn8oawSPstN4NnWMTCk5dtHeAIXBr9c9kF//6JQRzyjBGSvE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027611; c=relaxed/simple;
	bh=2vEdHZf76HWVoizhSTP6QR/25gi01E6jMc8vnJ1UTuc=;
	h=Date:To:From:Subject:Message-Id; b=DthYOn0wmuaLNiw//XRdjiutFSU03Dpi+71kYZT54oRuLJRQvfSmtD7/lFeeZL1j8ldbyD9ZHTrz6fKmuBPdhdEYFew3/S0Xgt77gXB4tYTGAY87eK6zKacqHPCjMxWyKxWVcMdHNmuxfxMaHnPHnHBTQAYtd78gLnYiWkwBLLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EUXUb5qc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EUXUb5qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662921F00893;
	Fri, 29 May 2026 04:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027610;
	bh=tQgnp6OIG4fLuqYEJMm3iEmebVuPsKRculZSTOeIZKs=;
	h=Date:To:From:Subject;
	b=EUXUb5qc5e583nCCUeD+hXfZBiAUsQZEEoSJoMUZt5G/8KueR0SyeUF1Q1xpjpbjP
	 S+nR9xGcGfRMIWKIq8RLRj8Cn7Wtb2PxVsqhzPU8yomb1to5ef81K4dwrIbBqkaLST
	 aPBIUPr4Tpuomthp7OO3rywxhkwRsGwHAGY3kPqM=
Date: Thu, 28 May 2026 21:06:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-use-align-helpers-for-pmd-alignment.patch removed from -mm tree
Message-Id: <20260529040650.662921F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: use ALIGN helpers for PMD alignment
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-use-align-helpers-for-pmd-alignment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/khugepaged: use ALIGN helpers for PMD alignment
Date: Thu, 9 Apr 2026 09:43:22 +0800

PMD alignment in khugepaged is currently implemented using a mix of
rounding helpers and open-coded bitmask operations.

Use ALIGN() and ALIGN_DOWN() consistently for PMD-sized address range
alignment, matching the preferred style for address and size handling.

No functional change intended.

Link: https://lore.kernel.org/20260409014323.2385982-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Liu Ye <liuye@kylinos.cn>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-align-helpers-for-pmd-alignment
+++ a/mm/khugepaged.c
@@ -2528,8 +2528,8 @@ static void collapse_scan_mm_slot(unsign
 			cc->progress++;
 			continue;
 		}
-		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
-		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
+		hstart = ALIGN(vma->vm_start, HPAGE_PMD_SIZE);
+		hend = ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE);
 		if (khugepaged_scan.address > hend) {
 			cc->progress++;
 			continue;
@@ -2845,8 +2845,8 @@ int madvise_collapse(struct vm_area_stru
 	mmgrab(mm);
 	lru_add_drain_all();
 
-	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
-	hend = end & HPAGE_PMD_MASK;
+	hstart = ALIGN(start, HPAGE_PMD_SIZE);
+	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-khugepaged-fix-inconsistent-mmf_vm_hugepage-flag-due-to-allocation-failure-order.patch
tools-mm-page-types-fix-typo-in-madvise-error-message.patch
tools-mm-page-types-fix-ternary-operator-precedence-in-sigbus-handler.patch
tools-mm-page-types-fix-kpageflags-option-argument-in-getopt_long.patch
mm-memory-failure-remove-hugetlb-output-parameter-from-try_memory_failure_hugetlb.patch

