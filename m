Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E1C3B38A2
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 20:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778532955; cv=none; b=HzVQUoL1BuxBI0S7yJCaeUPMrAHDVtNXKYUVAnp3/Kxy9xBI8+eGw8MKl+kW2sQV/2i53lN0J2kzAYboRBkr6v8IlMFqklyOI6BG0PKvVMzu8npYO+vQF2KYMdPXYDNbhboT3s7Yv0cb+SzPnUCfPneGwqA9mxWqr2NWh86WbDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778532955; c=relaxed/simple;
	bh=EJyBrUeA79DEPITFtpCLjGbdO9aDEUMC9PBlyuwAvms=;
	h=Date:To:From:Subject:Message-Id; b=Qc0XUtwNflZ81Enyx0h5soxDURUOf00ZQmy3MlfBo2+ppnI80j1BpsYBoEQ92LD2/yRcxYXVsUNBj2dVNPCIjzYyDFBcPUPJxK9Ta+X0/vQBleTgKrJoVl9YSB1CKJDmL6rpM5TLpTP5oVH1y0b12treHytvSH8KVcLBr1xK/k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U2ycWziL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U2ycWziL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A785C2BCB0;
	Mon, 11 May 2026 20:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778532954;
	bh=EJyBrUeA79DEPITFtpCLjGbdO9aDEUMC9PBlyuwAvms=;
	h=Date:To:From:Subject:From;
	b=U2ycWziLYWAcKoWnogaVbD/SjKg1NYG/hArsjSkC/PVNi4i+O6oyRFizT/12FGjsq
	 eHGTR8RzXS+zUsCG2gsJtRty0AZ+M6Si35UcXtcQCedxYydS3q7ciVWNgze85CAQfx
	 Wx/K5qlJYYQ3rbkkvsP18jZkrdv7rTqxYanUNp2Y=
Date: Mon, 11 May 2026 13:55:53 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch removed from -mm tree
Message-Id: <20260511205554.8A785C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
Date: Sun, 19 Apr 2026 12:57:38 -0600

Patch series "khugepaged: mTHP support", v16.

This series provides khugepaged with the capability to collapse anonymous
memory regions to mTHPs.

To achieve this we generalize the khugepaged functions to no longer depend
on PMD_ORDER.  Then during the PMD scan, we use a bitmap to track
individual pages that are occupied (!none/zero).  After the PMD scan is
done, we use the bitmap to find the optimal mTHP sizes for the PMD range. 
The restriction on max_ptes_none is removed during the scan, to make sure
we account for the whole PMD range in the bitmap.  When no mTHP size is
enabled, the legacy behavior of khugepaged is maintained.

We currently only support max_ptes_none values of 0 or HPAGE_PMD_NR - 1
(ie 511).  If any other value is specified, the kernel will emit a warning
and no mTHP collapse will be attempted.  If a mTHP collapse is attempted,
but contains swapped out, or shared pages, we don't perform the collapse. 
It is now also possible to collapse to mTHPs without requiring the PMD THP
size to be enabled.  These limitations are to prevent collapse "creep"
behavior.  This prevents constantly promoting mTHPs to the next available
size, which would occur because a collapse introduces more non-zero pages
that would satisfy the promotion condition on subsequent scans.

Patch 1-2:   Generalize hugepage_vma_revalidate and alloc_charge_folio
	     for arbitrary orders.
Patch 3:     Rework max_ptes_* handling into helper functions
Patch 4-5:   Generalize __collapse_huge_page_* and collapse_huge_page
Patch 6:     Skip collapsing mTHP to smaller orders
Patch 7-8:   Add per-order mTHP statistics and tracepoints
Patch 9:     Introduce collapse_allowable_orders helper function
Patch 10-12: Introduce bitmap and mTHP collapse support, fully enabled
Patch 13:    Documentation


This patch (of 13):

For khugepaged to support different mTHP orders, we must generalize this
to check if the PMD is not shared by another VMA and that the order is
enabled.

No functional change in this patch.  Also correct a comment about the
functionality of the revalidation and fix a double space issues.

Link: https://lore.kernel.org/20260419185750.260784-1-npache@redhat.com
Link: https://lore.kernel.org/20260419185750.260784-2-npache@redhat.com
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support
+++ a/mm/khugepaged.c
@@ -902,12 +902,13 @@ static int collapse_find_target_node(str
 
 /*
  * If mmap_lock temporarily dropped, revalidate vma
- * before taking mmap_lock.
+ * after taking the mmap_lock again.
  * Returns enum scan_result value.
  */
 
 static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
-		bool expect_anon, struct vm_area_struct **vmap, struct collapse_control *cc)
+		bool expect_anon, struct vm_area_struct **vmap,
+		struct collapse_control *cc, unsigned int order)
 {
 	struct vm_area_struct *vma;
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
@@ -920,15 +921,16 @@ static enum scan_result hugepage_vma_rev
 	if (!vma)
 		return SCAN_VMA_NULL;
 
+	/* Always check the PMD order to ensure its not shared by another VMA */
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
+	if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, BIT(order)))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
 	 * remapped to file after khugepaged reaquired the mmap_lock.
 	 *
-	 * thp_vma_allowable_order may return true for qualified file
+	 * thp_vma_allowable_orders may return true for qualified file
 	 * vmas.
 	 */
 	if (expect_anon && (!(*vmap)->anon_vma || !vma_is_anonymous(*vmap)))
@@ -1121,7 +1123,8 @@ static enum scan_result collapse_huge_pa
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1155,7 +1158,8 @@ static enum scan_result collapse_huge_pa
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -2858,8 +2862,8 @@ int madvise_collapse(struct vm_area_stru
 			mmap_unlocked = false;
 			*lock_dropped = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
-							 cc);
-			if (result  != SCAN_SUCCEED) {
+							 cc, HPAGE_PMD_ORDER);
+			if (result != SCAN_SUCCEED) {
 				last_fail = result;
 				goto out_nolock;
 			}
_

Patches currently in -mm which might be from npache@redhat.com are

mm-khugepaged-rework-max_ptes_-handling-with-helper-functions.patch
mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse.patch
mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch
mm-khugepaged-improve-tracepoints-for-mthp-orders.patch
mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

