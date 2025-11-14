Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF2018EFD1
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 23:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763163754; cv=none; b=Z7ndg0B1q4RwMvipI+L4ikfd7kHQPZvlujBTgl0V6auFHdcob4FM0m/HF7p74N/mj9f2zyv1h30qnVSP0Ow5Fw0p8jcYUPc9QfzLia4i1kAepRJYdmyhPxZzeSoJ3YAFTJB+vFu0NIc1gusQ61VhGIS61USTnp1pUz9/6l6pHBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763163754; c=relaxed/simple;
	bh=DrGnGtpFRKiDr0camXC7WrKXOfGy8cbB+RNRAdyvRFk=;
	h=Date:To:From:Subject:Message-Id; b=KNh6S7HOG3eiaaX/2i2DqaBLDevMVgsuwBNdqZ3D3Dp3IgsyQIEXpcHcKWs8e8ajbuwddo8UMBtZuloAntmK89m7tHTDs4De0ym9ywlzOHKVW23ro9lRn0kVHOK308WoUfBSSb9bEAKEBt6qlk/WGcCTtmsTRuVMyNFfFaIJj3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ircdx8GI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ircdx8GI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931EDC4AF09;
	Fri, 14 Nov 2025 23:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763163753;
	bh=DrGnGtpFRKiDr0camXC7WrKXOfGy8cbB+RNRAdyvRFk=;
	h=Date:To:From:Subject:From;
	b=Ircdx8GIDjJaJ6mMUQoTI4aOQH1sqY1WWfC5lArVQC1wcJFAVaJ7eojzl71xPmzU+
	 LNu9RR2XBMwd4/zDH/4TKE+Xhv/wnoAb0rK1oYgW+kRunGrLDPT8+moiNirArWbJyj
	 GToAND7X9kzII90bracyGUx0gWrV4u7HIpXr1KGw=
Date: Fri, 14 Nov 2025 15:42:32 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-remove-redundant-clearing-of-struct-collapse_control.patch added to mm-new branch
Message-Id: <20251114234233.931EDC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: remove redundant clearing of struct collapse_control
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-remove-redundant-clearing-of-struct-collapse_control.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-remove-redundant-clearing-of-struct-collapse_control.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/khugepaged: remove redundant clearing of struct collapse_control
Date: Fri, 14 Nov 2025 03:00:26 +0000

Patch series "unify PMD scan results and remove redundant cleanup", v2.

This small series addresses two minor cleanup opportunities in the
hugepage collapse logic.

The initial motivation arose during a code review of madvise_collapse(),
where it was noted that the function was missing a handler for
SCAN_PMD_NONE.  This oversight exposed the inconsistent handling of
SCAN_PMD_NULL and SCAN_PMD_NONE.

Since both scan results are functionally identical (they indicate the
absence of a PTE table), the primary patch unifies them into a single,
clearer identifier, SCAN_NO_PTE_TABLE.

The series also takes the opportunity to remove a redundant clearing of
the struct collapse_control.


This patch (of 3):

The structure struct collapse_control is being unnecessarily cleared twice
during the huge page collapse process.

Both hpage_collapse_scan_file() and hpage_collapse_scan_pmd() currently
perform a clear operation on this structure.

Remove the redundant clear operation.

Link: https://lkml.kernel.org/r/20251114030028.7035-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20251114030028.7035-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-remove-redundant-clearing-of-struct-collapse_control
+++ a/mm/khugepaged.c
@@ -2803,8 +2803,6 @@ int madvise_collapse(struct vm_area_stru
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
 		mmap_assert_locked(mm);
-		memset(cc->node_load, 0, sizeof(cc->node_load));
-		nodes_clear(cc->alloc_nmask);
 		if (!vma_is_anonymous(vma)) {
 			struct file *file = get_file(vma->vm_file);
 			pgoff_t pgoff = linear_page_index(vma, addr);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-huge_memory-avoid-reinvoking-folio_test_anon.patch
mm-huge_memory-update-folio-stat-after-successful-split.patch
mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch
mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch
mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-introduce-enum-split_type-for-clarity.patch
mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported.patch
mm-khugepaged-remove-redundant-clearing-of-struct-collapse_control.patch
mm-khugepaged-continue-to-collapse-on-scan_pmd_none.patch
mm-khugepaged-unify-scan_pmd_none-and-scan_pmd_null-into-scan_no_pte_table.patch

