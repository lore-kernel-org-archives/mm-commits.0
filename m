Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BFC41C63
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 23:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744932139; cv=none; b=sLbHNGw1islKMa5oP053MmKtM8/CU6YOfWRDA1WNTmlmfVyW2f7SatQZhoWaCXHvYUXh/qjQNaWG43/fdtOnCsmBnX0MQM+NqLa+2grzjT69hO8IfSzctfzhRkAOqaygSh2y/jhvIG/AZCgHcBjNJbs2GeWQAGkyMbf4ghB5SrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744932139; c=relaxed/simple;
	bh=7lPuJrnvBv0drCJSKoVoDMHnYDhnl8Z3GFfStWRzYGg=;
	h=Date:To:From:Subject:Message-Id; b=QNQi9TodYRuuoBKvQ9Fiu/ZdLGUELhGZPkENR9JX0AjAZEH14zQFgjhIbUD9p2ZKMalkrWwtJeT02YGDvsGET4NVsYx0PAuEQEzIj9+xSQpQt/XkZDbC5hkbUqFfOuZUUNRbYDZu4t/YhUcSZkLy5wQy0N3Hb4y0aHuv0JtUbjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sB3jeAkP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sB3jeAkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB76C4CEE4;
	Thu, 17 Apr 2025 23:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744932138;
	bh=7lPuJrnvBv0drCJSKoVoDMHnYDhnl8Z3GFfStWRzYGg=;
	h=Date:To:From:Subject:From;
	b=sB3jeAkP36g7E5NQ+RT6xSh19XrYwijnHoPEE8whuXTaTJVyJOMgiTDTth/tXst/g
	 nDWeEUOUqI21vYudYoiF/JNbb6NyWgj1Tm+dZ3Yqoav/Wo9bZtbaTTh+v0Qb+twhrL
	 WE3S4t42bKa4gUS3ZlN4Veaqsw4ZHNhdcpk1/PCQ=
Date: Thu, 17 Apr 2025 16:22:17 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shuah@kernel.org,ryan.roberts@arm.com,rostedt@goodmis.org,rientjes@google.com,rdunlap@infradead.org,raquini@redhat.com,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,kirill.shutemov@linux.intel.com,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,cl@gentwo.org,catalin.marinas@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch added to mm-new branch
Message-Id: <20250417232218.7AB76C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: generalize hugepage_vma_revalidate for mTHP support
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch

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
Subject: khugepaged: generalize hugepage_vma_revalidate for mTHP support
Date: Wed, 16 Apr 2025 18:02:29 -0600

For khugepaged to support different mTHP orders, we must generalize this
function for arbitrary orders.

No functional change in this patch.

Link: https://lkml.kernel.org/r/20250417000238.74567-4-npache@redhat.com
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
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

 mm/khugepaged.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/khugepaged.c~khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support
+++ a/mm/khugepaged.c
@@ -920,7 +920,7 @@ static int khugepaged_find_target_node(s
 static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 				   bool expect_anon,
 				   struct vm_area_struct **vmap,
-				   struct collapse_control *cc)
+				   struct collapse_control *cc, int order)
 {
 	struct vm_area_struct *vma;
 	unsigned long tva_flags = cc->is_khugepaged ? TVA_ENFORCE_SYSFS : 0;
@@ -932,9 +932,9 @@ static int hugepage_vma_revalidate(struc
 	if (!vma)
 		return SCAN_VMA_NULL;
 
-	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
+	if (!thp_vma_suitable_order(vma, address, order))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_flags, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_flags, order))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1130,7 +1130,7 @@ static int collapse_huge_page(struct mm_
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1164,7 +1164,7 @@ static int collapse_huge_page(struct mm_
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -2790,7 +2790,7 @@ int madvise_collapse(struct vm_area_stru
 			mmap_read_lock(mm);
 			mmap_locked = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
-							 cc);
+							 cc, HPAGE_PMD_ORDER);
 			if (result  != SCAN_SUCCEED) {
 				last_fail = result;
 				goto out_nolock;
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

