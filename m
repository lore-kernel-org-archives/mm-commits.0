Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BFB1E877
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712783335; cv=none; b=i+9q0aIVbsSYVSw7aAp7OY+Rtz5D63Z2iX7mzsf95P/AfR0GWArhciFXEmb18Ebd0kGRPiWUdSSYIKmzpYndcKvYRykSSBYS3j5nM6z8w4P8/tIrzmo6CLtYhVPfZNzhEFQJBgHm+39icSIeCLW7oUaMRqg2Yao85RqkP9Hio+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712783335; c=relaxed/simple;
	bh=igaBvzGcy08gs1W66FiXmsuPnHiBVbqFKQCCLHVEtcI=;
	h=Date:To:From:Subject:Message-Id; b=pyDSK2qk/9SNYFLborDhVlN7cT4VL7QkqnnyOM/O5myZqDpZUBD1qiEaIx8jEIvU5I10D7D/WIzl+MWNRMgvhobFlFpKhVtAarS4N7izn+KFJH8Bh39/4/OKMxlbPEt2yvXxSXyPYnVu3OHrAeIAGyt3L+WNylJInmuxqI/EWLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k8vCgPbs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k8vCgPbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75190C433C7;
	Wed, 10 Apr 2024 21:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712783334;
	bh=igaBvzGcy08gs1W66FiXmsuPnHiBVbqFKQCCLHVEtcI=;
	h=Date:To:From:Subject:From;
	b=k8vCgPbsezxtxg145XuVxwqWIJ8E/xkJTdhd9/OmND9fWcKHMrvbf8kQaaicKCf4X
	 55HoqXULpXZReZAvs8K1daq1aLMyYHXuUOqzfDqI59Uou6d2tQRACLdDBfn+YOumFv
	 1y5SRd23uk84YG4cCRYiN1fgEhNPTJMz1h7IQs+o=
Date: Wed, 10 Apr 2024 14:08:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,ryan.roberts@arm.com,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,hanchuanhua@oppo.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-per-order-mthp-swpin_refault-counter.patch added to mm-unstable branch
Message-Id: <20240410210854.75190C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add per-order mTHP swpin_refault counter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-per-order-mthp-swpin_refault-counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-per-order-mthp-swpin_refault-counter.patch

This patch will later appear in the mm-unstable branch at
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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: add per-order mTHP swpin_refault counter
Date: Tue, 9 Apr 2024 20:26:31 +1200

Currently, we are handling the scenario where we've hit a large folio in
the swapcache, and the reclaiming process for this large folio is still
ongoing.

Link: https://lkml.kernel.org/r/20240409082631.187483-6-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    1 +
 mm/huge_memory.c        |    2 ++
 mm/memory.c             |    1 +
 3 files changed, 4 insertions(+)

--- a/include/linux/huge_mm.h~mm-add-per-order-mthp-swpin_refault-counter
+++ a/include/linux/huge_mm.h
@@ -269,6 +269,7 @@ enum mthp_stat_item {
 	MTHP_STAT_ANON_ALLOC_FALLBACK,
 	MTHP_STAT_ANON_SWPOUT,
 	MTHP_STAT_ANON_SWPOUT_FALLBACK,
+	MTHP_STAT_ANON_SWPIN_REFAULT,
 	__MTHP_STAT_COUNT
 };
 
--- a/mm/huge_memory.c~mm-add-per-order-mthp-swpin_refault-counter
+++ a/mm/huge_memory.c
@@ -556,12 +556,14 @@ DEFINE_MTHP_STAT_ATTR(anon_alloc, MTHP_S
 DEFINE_MTHP_STAT_ATTR(anon_alloc_fallback, MTHP_STAT_ANON_ALLOC_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(anon_swpout, MTHP_STAT_ANON_SWPOUT);
 DEFINE_MTHP_STAT_ATTR(anon_swpout_fallback, MTHP_STAT_ANON_SWPOUT_FALLBACK);
+DEFINE_MTHP_STAT_ATTR(anon_swpin_refault, MTHP_STAT_ANON_SWPIN_REFAULT);
 
 static struct attribute *stats_attrs[] = {
 	&anon_alloc_attr.attr,
 	&anon_alloc_fallback_attr.attr,
 	&anon_swpout_attr.attr,
 	&anon_swpout_fallback_attr.attr,
+	&anon_swpin_refault_attr.attr,
 	NULL,
 };
 
--- a/mm/memory.c~mm-add-per-order-mthp-swpin_refault-counter
+++ a/mm/memory.c
@@ -4164,6 +4164,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		nr_pages = nr;
 		entry = folio->swap;
 		page = &folio->page;
+		count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_SWPIN_REFAULT);
 	}
 
 check_pte:
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

arm64-mm-swap-support-thp_swap-on-hardware-with-mte.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch
mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch
mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters.patch
mm-add-per-order-mthp-anon_alloc-and-anon_alloc_fallback-counters-fix.patch
mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch
mm-swap_pte_batch-add-an-output-argument-to-reture-if-all-swap-entries-are-exclusive.patch
mm-add-per-order-mthp-swpin_refault-counter.patch

