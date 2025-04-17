Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFD841C63
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 23:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744932143; cv=none; b=J0dhdc8V30W1eAvyOug5IGWHrI2aOjiNEZ4qcaQiyoKw5WgehTAfosm5GSnC5qWtXLubK1ytHjIH1Q79ctimZoaBvQ/Rn7MbVc7blDWeBcGQ4i/z3rKyl/zna2W6hhGfo0s+QInDUpjbi1/qnf6/o3I7Jyk2okKB9Kqc9NspM5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744932143; c=relaxed/simple;
	bh=iyQD5O0Yc6lPQUvAjiYl8ziyRqMSvnHoxGl5zPfZwEQ=;
	h=Date:To:From:Subject:Message-Id; b=c7VIcupeXwwpOvADXw1An2lu57cfXtx+4dQ9ka9iL/nVbSYi0hW8Kyy+lOBtQjU5sFvT/hj6yw2rykBA1OTd3wEwxxu0GJ6z0GNcdQ/+rXOVDsdfbOZUoAet6YvgRrUtTiInPRPHIPM40ZPvIcUQt2XCpapD6DfVEtzMoInJJq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qR72U1KH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qR72U1KH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087FDC4CEE4;
	Thu, 17 Apr 2025 23:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744932143;
	bh=iyQD5O0Yc6lPQUvAjiYl8ziyRqMSvnHoxGl5zPfZwEQ=;
	h=Date:To:From:Subject:From;
	b=qR72U1KHr+rytMtuq549pPvKIdBZEVJu5597XeSrLRTXhEDUhO0nsowrXcbqu9ib5
	 ubkzb0brwScwSJNWVSGlG7JqixxEYcT6le9V5JIuFa/FpfkgfFiZ0jrOsDmmIUhuuc
	 oQVffhJViTZ5jfRFcb8nBEDJFmFwR6X7bVf7n6zs=
Date: Thu, 17 Apr 2025 16:22:22 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shuah@kernel.org,ryan.roberts@arm.com,rostedt@goodmis.org,rientjes@google.com,rdunlap@infradead.org,raquini@redhat.com,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,kirill.shutemov@linux.intel.com,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,cl@gentwo.org,catalin.marinas@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-introduce-khugepaged_scan_bitmap-for-mthp-support.patch added to mm-new branch
Message-Id: <20250417232223.087FDC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: introduce khugepaged_scan_bitmap for mTHP support
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-introduce-khugepaged_scan_bitmap-for-mthp-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-introduce-khugepaged_scan_bitmap-for-mthp-support.patch

This patch will later appear in the mm-new branch at
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
From: Nico Pache <npache@redhat.com>
Subject: khugepaged: introduce khugepaged_scan_bitmap for mTHP support
Date: Wed, 16 Apr 2025 18:02:32 -0600

khugepaged scans PMD ranges for potential collapse to a hugepage.  To add
mTHP support we use this scan to instead record chunks of utilized
sections of the PMD.

khugepaged_scan_bitmap uses a stack struct to recursively scan a bitmap
that represents chunks of utilized regions.  We can then determine what
mTHP size fits best and in the following patch, we set this bitmap while
scanning the PMD.

max_ptes_none is used as a scale to determine how "full" an order must be
before being considered for collapse.

When attempting to collapse an order that has its order set to "always"
lets always collapse to that order in a greedy manner without considering
the number of bits set.

Link: https://lkml.kernel.org/r/20250417000238.74567-7-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Reported-by:Takashi Iwai <tiwai@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/khugepaged.h |    4 +
 mm/khugepaged.c            |   94 +++++++++++++++++++++++++++++++----
 2 files changed, 89 insertions(+), 9 deletions(-)

--- a/include/linux/khugepaged.h~khugepaged-introduce-khugepaged_scan_bitmap-for-mthp-support
+++ a/include/linux/khugepaged.h
@@ -1,6 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LINUX_KHUGEPAGED_H
 #define _LINUX_KHUGEPAGED_H
+#define KHUGEPAGED_MIN_MTHP_ORDER	2
+#define KHUGEPAGED_MIN_MTHP_NR	(1<<KHUGEPAGED_MIN_MTHP_ORDER)
+#define MAX_MTHP_BITMAP_SIZE  (1 << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))
+#define MTHP_BITMAP_SIZE  (1 << (HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER))
 
 extern unsigned int khugepaged_max_ptes_none __read_mostly;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
--- a/mm/khugepaged.c~khugepaged-introduce-khugepaged_scan_bitmap-for-mthp-support
+++ a/mm/khugepaged.c
@@ -94,6 +94,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_s
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
+struct scan_bit_state {
+	u8 order;
+	u16 offset;
+};
+
 struct collapse_control {
 	bool is_khugepaged;
 
@@ -102,6 +107,18 @@ struct collapse_control {
 
 	/* nodemask for allocation fallback */
 	nodemask_t alloc_nmask;
+
+	/*
+	 * bitmap used to collapse mTHP sizes.
+	 * 1bit = order KHUGEPAGED_MIN_MTHP_ORDER mTHP
+	 */
+	DECLARE_BITMAP(mthp_bitmap, MAX_MTHP_BITMAP_SIZE);
+	DECLARE_BITMAP(mthp_bitmap_temp, MAX_MTHP_BITMAP_SIZE);
+	struct scan_bit_state mthp_bitmap_stack[MAX_MTHP_BITMAP_SIZE];
+};
+
+struct collapse_control khugepaged_collapse_control = {
+	.is_khugepaged = true,
 };
 
 /**
@@ -851,10 +868,6 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-struct collapse_control khugepaged_collapse_control = {
-	.is_khugepaged = true,
-};
-
 static bool khugepaged_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
@@ -1118,7 +1131,8 @@ static int alloc_charge_folio(struct fol
 
 static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 			      int referenced, int unmapped,
-			      struct collapse_control *cc)
+			      struct collapse_control *cc, bool *mmap_locked,
+				  u8 order, u16 offset)
 {
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
@@ -1137,8 +1151,12 @@ static int collapse_huge_page(struct mm_
 	 * The allocation can take potentially a long time if it involves
 	 * sync compaction, and we do not need to hold the mmap_lock during
 	 * that. We will recheck the vma after taking it again in write mode.
+	 * If collapsing mTHPs we may have already released the read_lock.
 	 */
-	mmap_read_unlock(mm);
+	if (*mmap_locked) {
+		mmap_read_unlock(mm);
+		*mmap_locked = false;
+	}
 
 	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
@@ -1273,12 +1291,72 @@ static int collapse_huge_page(struct mm_
 out_up_write:
 	mmap_write_unlock(mm);
 out_nolock:
+	*mmap_locked = false;
 	if (folio)
 		folio_put(folio);
 	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
 	return result;
 }
 
+// Recursive function to consume the bitmap
+static int khugepaged_scan_bitmap(struct mm_struct *mm, unsigned long address,
+			int referenced, int unmapped, struct collapse_control *cc,
+			bool *mmap_locked, unsigned long enabled_orders)
+{
+	u8 order, next_order;
+	u16 offset, mid_offset;
+	int num_chunks;
+	int bits_set, threshold_bits;
+	int top = -1;
+	int collapsed = 0;
+	int ret;
+	struct scan_bit_state state;
+	bool is_pmd_only = (enabled_orders == (1 << HPAGE_PMD_ORDER));
+
+	cc->mthp_bitmap_stack[++top] = (struct scan_bit_state)
+		{ HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER, 0 };
+
+	while (top >= 0) {
+		state = cc->mthp_bitmap_stack[top--];
+		order = state.order + KHUGEPAGED_MIN_MTHP_ORDER;
+		offset = state.offset;
+		num_chunks = 1 << (state.order);
+		// Skip mTHP orders that are not enabled
+		if (!test_bit(order, &enabled_orders))
+			goto next;
+
+		// copy the relavant section to a new bitmap
+		bitmap_shift_right(cc->mthp_bitmap_temp, cc->mthp_bitmap, offset,
+				  MTHP_BITMAP_SIZE);
+
+		bits_set = bitmap_weight(cc->mthp_bitmap_temp, num_chunks);
+		threshold_bits = (HPAGE_PMD_NR - khugepaged_max_ptes_none - 1)
+				>> (HPAGE_PMD_ORDER - state.order);
+
+		//Check if the region is "almost full" based on the threshold
+		if (bits_set > threshold_bits || is_pmd_only
+			|| test_bit(order, &huge_anon_orders_always)) {
+			ret = collapse_huge_page(mm, address, referenced, unmapped, cc,
+					mmap_locked, order, offset * KHUGEPAGED_MIN_MTHP_NR);
+			if (ret == SCAN_SUCCEED) {
+				collapsed += (1 << order);
+				continue;
+			}
+		}
+
+next:
+		if (state.order > 0) {
+			next_order = state.order - 1;
+			mid_offset = offset + (num_chunks / 2);
+			cc->mthp_bitmap_stack[++top] = (struct scan_bit_state)
+				{ next_order, mid_offset };
+			cc->mthp_bitmap_stack[++top] = (struct scan_bit_state)
+				{ next_order, offset };
+			}
+	}
+	return collapsed;
+}
+
 static int khugepaged_scan_pmd(struct mm_struct *mm,
 				   struct vm_area_struct *vma,
 				   unsigned long address, bool *mmap_locked,
@@ -1445,9 +1523,7 @@ out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
 		result = collapse_huge_page(mm, address, referenced,
-					    unmapped, cc);
-		/* collapse_huge_page will return with the mmap_lock released */
-		*mmap_locked = false;
+					    unmapped, cc, mmap_locked, HPAGE_PMD_ORDER, 0);
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, &folio->page, writable, referenced,
_

Patches currently in -mm which might be from npache@redhat.com are

introduce-khugepaged_collapse_single_pmd-to-unify-khugepaged-and-madvise_collapse.patch
khugepaged-rename-hpage_collapse_-to-khugepaged_.patch
khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
khugepaged-introduce-khugepaged_scan_bitmap-for-mthp-support.patch
khugepaged-add-mthp-support.patch
khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
khugepaged-improve-tracepoints-for-mthp-orders.patch
khugepaged-add-per-order-mthp-khugepaged-stats.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch
mm-defer-thp-insertion-to-khugepaged.patch
mm-document-mthp-defer-usage.patch
khugepaged-add-defer-option-to-mthp-options.patch
selftests-mm-add-defer-to-thp-setting-parser.patch

