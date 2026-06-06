Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892542AEE1
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 00:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780706402; cv=none; b=ZS3d+cjQphjz0GQ1ZIl+Cr+W/op9FjwtTyGriFLDxPOwe94Iv59NOu3mzObwC7gOjQw/s8Oy83sh87YJl+6RFRHved+lLp1P960SQaBDFmZbBepwD9tzZCNBZT1oKgY9t3RNdTks2lU2EuVfFdxfBUZHDRY+0N963zRj87baEWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780706402; c=relaxed/simple;
	bh=O6d7gUGhVNUghyuyQyEYK4ffq21jv/+CEVhLCW+LmiQ=;
	h=Date:To:From:Subject:Message-Id; b=Dtn/J6/wexRmaOCqiJ+q+O3CjpZJcYB+7OvhyNXBQsvsRurR5bHnQJvKg8BcqPvLHRv3h1IFQ5xVz1404qSOgycHsugk0p71VEzCFY++jpFPDbkX0ya4/5XWuDPujOLYShLOYMC3sxPGNRoMHnzKAjKEtMr3juD8PJZsy63eUQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XveByt3w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XveByt3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3037E1F00893;
	Sat,  6 Jun 2026 00:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780706401;
	bh=R8B2XtzVmJIPJNQcAfUchCqL10XVbJYBhjbtr4NY54w=;
	h=Date:To:From:Subject;
	b=XveByt3wifnPAmlUmQ6m+eLvmxEBfv0UrFr/6O2GK0O+cwjT88KTsdUwPiK5uVqMG
	 iqUBjgkfwyOfH7Eck0TdJhF1PlZSOzKbNracZqq6xbraJhuEMktqZVzIWeiDVam+Xh
	 IVHKqa15rlixKNrz0LjdvXSqDDR8IfDtxzsAZRHE=
Date: Fri, 05 Jun 2026 17:40:00 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch added to mm-unstable branch
Message-Id: <20260606004001.3037E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: avoid unnecessary mTHP collapse attempts
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: avoid unnecessary mTHP collapse attempts
Date: Fri, 5 Jun 2026 10:14:19 -0600

There are cases where, if an attempted collapse fails, all subsequent
orders are guaranteed to also fail.  Avoid these collapse attempts by
bailing out early.

Link: https://lore.kernel.org/20260605161422.213817-13-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <lance.yang@linux.dev>
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
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts
+++ a/mm/khugepaged.c
@@ -1504,6 +1504,7 @@ static enum scan_result mthp_collapse(st
 			collapse_address = address + offset * PAGE_SIZE;
 			ret = collapse_huge_page(mm, collapse_address, referenced,
 						 unmapped, cc, order);
+
 			switch (ret) {
 			/* Cases where we continue to next collapse candidate */
 			case SCAN_SUCCEED:
@@ -1514,6 +1515,18 @@ static enum scan_result mthp_collapse(st
 			/* Cases where lower orders might still succeed */
 			case SCAN_ALLOC_HUGE_PAGE_FAIL:
 				alloc_failed = true;
+				fallthrough;
+			case SCAN_LACK_REFERENCED_PAGE:
+			case SCAN_EXCEED_NONE_PTE:
+			case SCAN_EXCEED_SWAP_PTE:
+			case SCAN_EXCEED_SHARED_PTE:
+			case SCAN_PAGE_LOCK:
+			case SCAN_PAGE_COUNT:
+			case SCAN_PAGE_NULL:
+			case SCAN_DEL_PAGE_LRU:
+			case SCAN_PTE_NON_PRESENT:
+			case SCAN_PTE_UFFD_WP:
+			case SCAN_PAGE_LAZYFREE:
 				last_result = ret;
 				goto next_order;
 			/* Cases where no further collapse is possible */
_

Patches currently in -mm which might be from npache@redhat.com are

mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
mm-khugepaged-rework-max_ptes_-handling-with-helper-functions.patch
mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse.patch
mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch
mm-khugepaged-improve-tracepoints-for-mthp-orders.patch
mm-khugepaged-introduce-collapse_possible_orders-helper-functions.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

