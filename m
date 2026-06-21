Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6202E25783A
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782066746; cv=none; b=BIwBbhNnr2pmRZFV4btVKIujw/YyE00CH7fCe/86b+0QTx3sy0qknRcyUwIk+gG1nHh/CuFxg6eRY5IZx7xqOVPTzMQFjddrUgRROQ1nukwKFu1UCWd0tepIBX+c29WFZP4PLnK9LYnxQJO1j+9Wq+f2ksZaucb87ivGFjfwV74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782066746; c=relaxed/simple;
	bh=j4ApojX3yD5d9hWz9LMbseI2s0WAkoCZuJouj6bGiKQ=;
	h=Date:To:From:Subject:Message-Id; b=Co3XKstARfQwHeIal3OQKOQlQIvsATY8pA81rJhGI5AJb3rYJpXrrwZbWy4pgY3MO6BgPRlCsio2u3Nd15bfqBmOUxZcOZck7GD0WPhju9VPM+I+QDI8OS1EBf0xFg36IQsijWD5GD4PJe1brmAayqQs2hDMxoe7GI75UvbQfnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yEt3eN7s reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yEt3eN7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA2A1F000E9;
	Sun, 21 Jun 2026 18:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782066745;
	bh=zwwMSsRYTDvzagDdZLxxcM7w8fMv1Y3iyR1jBcC9KG0=;
	h=Date:To:From:Subject;
	b=yEt3eN7s+cqW/WLVKK5xCF9+v+5+UiSxcAgBumE6CsrV2u6OGgtpsf3BKIhi6lL7G
	 bY6ABPAXQt7B2S1e2dGFKFtq6zgb4+w8rC83kLIqQBISxlqgo8+ALdCXlAzun7RR6O
	 cn3ITJr4jxMp8NnQlDhNmHHL5T/oXYqKHBB4dK4k=
Date: Sun, 21 Jun 2026 11:32:24 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ying.huang@linux.alibaba.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@suse.cz,usama.arif@linux.dev,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shivankg@amd.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,richard.weiyang@gmail.com,rdunlap@infradead.org,raquini@redhat.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,jack@suse.cz,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,bagasdotme@gmail.co
 m,apopple@nvidia.com,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch removed from -mm tree
Message-Id: <20260621183224.EAA2A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
Date: Fri, 5 Jun 2026 10:14:08 -0600

Patch series "khugepaged: add mTHP collapse support", v19.

The following series provides khugepaged with the capability to collapse
anonymous memory regions to mTHPs.

To achieve this we generalize the khugepaged functions to no longer depend
on PMD_ORDER.  Then during the PMD scan, we use a bitmap to track
individual pages that are occupied (!none/zero).  After the PMD scan is
done, we use the bitmap to find the optimal mTHP sizes for the PMD range. 
The restriction on max_ptes_none is removed during the scan, to make sure
we account for the whole PMD range in the bitmap.  When no mTHP size is
enabled, the legacy behavior of khugepaged is maintained.

We currently only support max_ptes_none values of 0 or HPAGE_PMD_NR - 1
(ie 511).  If any other value is specified, the kernel will emit a warning
and mTHP collapse will default to max_ptes_none=0.  If a mTHP collapse is
attempted, but contains swapped out, or shared pages, we don't perform the
collapse.

It is now also possible to collapse to mTHPs without requiring the PMD THP
size to be enabled.  These limitations are to prevent collapse "creep"
behavior.  This prevents constantly promoting mTHPs to the next available
size, which would occur because a collapse introduces more non-zero pages
that would satisfy the promotion condition on subsequent scans.

Patch 1-2:   Generalize hugepage_vma_revalidate and alloc_charge_folio
             for arbitrary orders.
Patch 3:     Rework max_ptes_* handling into helper functions
Patch 4:     Generalize __collapse_huge_page_* for mTHP support
Patch 5:     Require collapse_huge_page to enter/exit with the lock dropped
Patch 6:     Generalize collapse_huge_page for mTHP collapse
Patch 7:     Skip collapsing mTHP to smaller orders
Patch 8-9:   Add per-order mTHP statistics and tracepoints
Patch 10:    Introduce collapse_possible_orders helper functions
Patch 11-13: Introduce bitmap and mTHP collapse support, fully enabled
Patch 14:    Documentation

Testing:
- Built for x86_64, aarch64, ppc64le, and s390x
- ran all arches on test suites provided by the kernel-tests project
- internal testing suites: functional testing and performance testing
- selftests mm
- I created a test script that I used to push khugepaged to its limits
   while monitoring a number of stats and tracepoints. The code is
   available here[1] (Run in legacy mode for these changes and set mthp
   sizes to inherit)
   The summary from my testings was that there was no significant
   regression noticed through this test. In some cases my changes had
   better collapse latencies, and was able to scan more pages in the same
   amount of time/work, but for the most part the results were consistent.
- redis testing. I did some testing with these changes along with my defer
  changes (see followup [2] post for more details). We've decided to get
  the mTHP changes merged first before attempting the defer series.
- some basic testing on 64k page size.
- lots of general use.


This patch (of 14):

For khugepaged to support different mTHP orders, we must generalize this
to check if the PMD is not shared by another VMA and that the order is
enabled.

We cannot collapse VMA regions that do not span the full PMD.  This is due
to the potential of the PMD being shared by another VMA which leaves us
vulnerable to race conditions if neighboring VMAs are resized.  Always
check the PMD order here to ensure its not shared by another VMA.  We'd
need to lock all VMAs in the PMD range to support this which may lead to
increased lock contention and code complexity.

No functional change in this patch.  Also correct a comment about the
functionality of the revalidation and fix a double space issues.

Link: https://lore.kernel.org/20260605161422.213817-1-npache@redhat.com
Link: https://lore.kernel.org/20260605161422.213817-2-npache@redhat.com
Link: https://gitlab.com/npache/khugepaged_mthp_test [1]
Link: https://lore.kernel.org/lkml/20250515033857.132535-1-npache@redhat.com/ [2]
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
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
Cc: Liam R. Howlett <liam@infradead.org>
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
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support
+++ a/mm/khugepaged.c
@@ -905,12 +905,13 @@ static int collapse_find_target_node(str
 
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
@@ -923,15 +924,22 @@ static enum scan_result hugepage_vma_rev
 	if (!vma)
 		return SCAN_VMA_NULL;
 
+	/*
+	 * We cannot collapse VMA regions that do not span the full PMD. This is
+	 * due to the potential of the PMD being shared by another VMA leaving
+	 * us vulnerable to a race condition. Always check the PMD order here to
+	 * ensure its not shared by another VMA. We'd need to lock all VMAs in
+	 * the PMD range to support this.
+	 */
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
@@ -1129,7 +1137,8 @@ static enum scan_result collapse_huge_pa
 	}
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1163,7 +1172,8 @@ static enum scan_result collapse_huge_pa
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -2866,8 +2876,8 @@ int madvise_collapse(struct vm_area_stru
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


