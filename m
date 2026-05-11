Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAD33B5314
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 21:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778533547; cv=none; b=O0lFRkeNOdjasOKAe49FBsnmFuh7BR9CU496Cu4O6nFk69OU0215+Usp9Gs7slshG5QQuqINI/5v+IJ700LeiKJdDoB+0AWlu81C2+o3jfU9r314cYCZpW0mwo7i16olwY+uyJV+kNL1Eldwii4lbeiz/hXZSovmFtOBiRVxyHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778533547; c=relaxed/simple;
	bh=7i4wcuB/hn7NEAP4qjiIoFQP8BybupQYw0dYXHnEVAc=;
	h=Date:To:From:Subject:Message-Id; b=BHTM4Fd/pSE7wQw/vCQSd+6eZueYbSJNByK0PQMpfXc2atHkWIbkWoVscKqK5MnNZaa6P1ezJ5LKkWTHwycQS64dH2NEbTo+iHB0Xy4UP4SMHrztJlEm9DEHhA9Aqok0TYgy0kOCb95XPWdSAvyvQqVJ7uXSQ0POzWcivM7ZUAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dFR4WRcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dFR4WRcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B56C2BCF5;
	Mon, 11 May 2026 21:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778533547;
	bh=7i4wcuB/hn7NEAP4qjiIoFQP8BybupQYw0dYXHnEVAc=;
	h=Date:To:From:Subject:From;
	b=dFR4WRcFTZop9KnNZyoVfayQ1FIYU2FPFnTpEgmhdzMWXYUovXb3RTIBZArli7azi
	 4VxTCy70GUDKNts339Ea5Fnw3BHQ21FYKAKE26m4yzg4aOQi9d4gx3B/PVFFphjxEL
	 MAvqLj7JURGrydm8ct1ENutX2OKwisyqEiVLbvRo=
Date: Mon, 11 May 2026 14:05:46 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch added to mm-new branch
Message-Id: <20260511210547.71B56C2BCF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: avoid unnecessary mTHP collapse attempts
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Mon, 11 May 2026 12:58:12 -0600

There are cases where, if an attempted collapse fails, all subsequent
orders are guaranteed to also fail.  Avoid these collapse attempts by
bailing out early.

Link: https://lore.kernel.org/20260511185817.686831-13-npache@redhat.com
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

 mm/khugepaged.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts
+++ a/mm/khugepaged.c
@@ -1531,9 +1531,31 @@ static int mthp_collapse(struct mm_struc
 			collapse_address = address + offset * PAGE_SIZE;
 			ret = collapse_huge_page(mm, collapse_address, referenced,
 						 unmapped, cc, order);
-			if (ret == SCAN_SUCCEED) {
+
+			switch (ret) {
+			/* Cases where we continue to next collapse candidate */
+			case SCAN_SUCCEED:
 				collapsed += nr_ptes;
+				fallthrough;
+			case SCAN_PTE_MAPPED_HUGEPAGE:
 				continue;
+			/* Cases where lower orders might still succeed */
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
+			case SCAN_ALLOC_HUGE_PAGE_FAIL:
+			case SCAN_PAGE_LAZYFREE:
+				goto next_order;
+			/* Cases where no further collapse is possible */
+			default:
+				return collapsed;
 			}
 		}
 
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
mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

