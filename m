Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A95484255
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866021; cv=none; b=jwOsUmoBUtILshqwrZzCbt2uv7auwme6v9sVoXgQl/aobYs7eFkMRAB4YJHXcP0pjSx/ShRXVnAxjwAQf9dZ5vATxY8ywPtaOQ0M4p9UAjeniKd4QlnMK7LxltGpDvk+1pCuoN52UUvQoCRjxE7ZAXSysSJl1scwlvxCawh8U5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866021; c=relaxed/simple;
	bh=PD2s2nsQLTWMhPbsq+MoiNjJECBp/kGaxB4PDqLbhX4=;
	h=Date:To:From:Subject:Message-Id; b=lvXABPYOuVeutQCtVbS1uFoN4xO+qcAkJSE7JNcD8S6IN6QhWHxeXVHpX6KBJrLtN4OFMCy9TXu1xk/PY2HaStgZswpOPSbsAqLnyZ73cavKF3iVDCxGOP/tAEAk6DHGeFA6szCsq6DwWzaqRQbGeU5OQ8TIuwc3aasPE5s8WqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nTG3Sfdr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nTG3Sfdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A441F00898;
	Tue, 13 Oct 2026 04:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866016;
	bh=bK+VE5hXU8ONhzivQ+LFajvXB7efCp4X/M3mEQIA5dY=;
	h=Date:To:From:Subject;
	b=nTG3SfdrEZa2QpOE5VThYJHu2IFD3VsINhu2MGzgwxwA6oNMdQZmsfwSJAV2eRTTR
	 kYt69Fjajx6EFLOJlpaJcMb2X0ev/3yvsgBvDS0Mzl29/H7Box+wXIvz+fZKkTIMpF
	 5ccqgF4BgDsFesqfD0122+bx2871qddiZHcDqlmQ=
Date: Mon, 12 Oct 2026 21:33:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kernel-team@meta.com,jgg@ziepe.ca,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agordeev@linux.ibm.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large.patch removed from -mm tree
Message-Id: <20261013043336.71A441F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip collapse_compound_extreme() where the PMD is too large
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: skip collapse_compound_extreme() where the PMD is too large
Date: Sat, 19 Sep 2026 01:24:32 +0100

collapse_compound_extreme() builds a PTE table full of distinct PTE-mapped
compound pages by cycling hpage_pmd_nr fault-time THPs through mremap.  It
therefore needs hpage_pmd_nr PMD-order allocations in a row.  That is fine
at a 2M PMD (4K base pages) or a 32M one (16K).  A 512M PMD -- arm64 with
64K base pages -- makes each of those an order-13 allocation, which the
allocator cannot reliably hand out even once, let alone 8192 times.

The failure is not a quiet one: the case calls ksft_exit_fail_msg(), so
the whole binary stops and every case after it is lost.

Skip the case where the PMD is larger than 32M.  The MADV_COLLAPSE cases
still cover PMD-order collapse on those configurations, and 4K and 16K
PMDs are unaffected.

Link: https://lore.kernel.org/20260919002451.496763-3-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Assisted-by: LLM
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kernel-team@meta.com
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/khugepaged.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -940,6 +940,16 @@ static void collapse_compound_extreme(st
 	void *p;
 	int i;
 
+	/*
+	 * This needs hpage_pmd_nr PMD-order allocations in a row, which the
+	 * allocator will not supply if the PMD is very large.
+	 */
+	if (hpage_pmd_size > (32UL << 20)) {
+		ksft_test_result_skip("%s: PMD too large for fault-time THP construction\n",
+				      __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pages\n");
 	for (i = 0; i < hpage_pmd_nr; i++) {
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
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

