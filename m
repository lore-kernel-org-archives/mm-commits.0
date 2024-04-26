Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6EB7604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103983; cv=none; b=i4edBzCgi0C6uE3Y/DnOycUOkyhSpbB8vvB7X1fkOc71vQ4X4OTaeq0VfI/c8BPBc9ZELTiH4AwDp+4D+7619oNLR+lKtnuHFitYL5ijbIjceLUi/fGIAL6R/1nAvFSmPdE+6tbZQwlydxTgF09KdmqPPZdYbqh++eFxLSKKGww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103983; c=relaxed/simple;
	bh=u9bTfX/4Xj4F4QaxxPqh1fChPeiHnD3FDpdE11oDe94=;
	h=Date:To:From:Subject:Message-Id; b=XwqpuFyvO2UL/RxEW9gQuzBnSphncLOGk8LgGyFe+NSJqjDtWq1I0DRPAea4fgm3lA3iPsMUDipHWFvCNwL+qZtGP6DgYOYLA6/9f+Pa99kmUi2xeSInKHmB7uNjrpowxd6defG9xDcVvGJNENFaA2V1uNYCYqhkn/lCAH3WWMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sLKwvba1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sLKwvba1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E389AC113CD;
	Fri, 26 Apr 2024 03:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103983;
	bh=u9bTfX/4Xj4F4QaxxPqh1fChPeiHnD3FDpdE11oDe94=;
	h=Date:To:From:Subject:From;
	b=sLKwvba1ns+HF7EoSADoQJBYF010But5pQ+bcX2txi9s/n5Iq1M48oHB0BuIVkRYy
	 kSliitHREDbxKggg/dJPftlk72FlPH7rCrnPVdiYnMlxJTAGxd31P7qIVJ/2uMTjjH
	 i7wuGG03TomkljgyhnTpi2yK+GRtDVz/wbHoF/Us=
Date: Thu, 25 Apr 2024 20:59:42 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,hughd@google.com,hanchuanhua@oppo.com,david@redhat.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch removed from -mm tree
Message-Id: <20240426035942.E389AC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hold PTL from the first PTE while reclaiming a large folio
has been removed from the -mm tree.  Its filename was
     mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: hold PTL from the first PTE while reclaiming a large folio
Date: Wed, 6 Mar 2024 22:52:19 +1300

Within try_to_unmap_one(), page_vma_mapped_walk() races with other PTE
modifications preceded by pte clear.  While iterating over PTEs of a large
folio, it only starts acquiring PTL from the first valid (present) PTE. 
PTE modifications can temporarily set PTEs to pte_none.  Consequently, the
initial PTEs of a large folio might be skipped in try_to_unmap_one().

For example, for an anon folio, if we skip PTE0, we may have PTE0 which is
still present, while PTE1 ~ PTE(nr_pages - 1) are swap entries after
try_to_unmap_one().

So folio will be still mapped, the folio fails to be reclaimed and is put
back to LRU in this round.

This also breaks up PTEs optimization such as CONT-PTE on this large folio
and may lead to accident folio_split() afterwards.  And since a part of
PTEs are now swap entries, accessing those parts will introduce overhead -
do_swap_page.  Although the kernel can withstand all of the above issues,
the situation still seems quite awkward and warrants making it more ideal.

The same race also occurs with small folios, but they have only one PTE,
thus, it won't be possible for them to be partially unmapped.

This patch holds PTL from PTE0, allowing us to avoid reading PTE values
that are in the process of being transformed.  With stable PTE values, we
can ensure that this large folio is either completely reclaimed or that
all PTEs remain untouched in this round.

A corner case is that if we hold PTL from PTE0 and most initial PTEs have
been really unmapped before that, we may increase the duration of holding
PTL.  Thus we only apply this optimization to folios which are still
entirely mapped (not in deferred_split list).

[akpm@linux-foundation.org: rewrap comment, per Matthew]
Link: https://lkml.kernel.org/r/20240306095219.71086-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/vmscan.c~mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio
+++ a/mm/vmscan.c
@@ -1257,6 +1257,20 @@ retry:
 
 			if (folio_test_pmd_mappable(folio))
 				flags |= TTU_SPLIT_HUGE_PMD;
+			/*
+			 * Without TTU_SYNC, try_to_unmap will only begin to
+			 * hold PTL from the first present PTE within a large
+			 * folio. Some initial PTEs might be skipped due to
+			 * races with parallel PTE writes in which PTEs can be
+			 * cleared temporarily before being written new present
+			 * values. This will lead to a large folio is still
+			 * mapped while some subpages have been partially
+			 * unmapped after try_to_unmap; TTU_SYNC helps
+			 * try_to_unmap acquire PTL from the first PTE,
+			 * eliminating the influence of temporary PTE values.
+			 */
+			if (folio_test_large(folio) && list_empty(&folio->_deferred_list))
+				flags |= TTU_SYNC;
 
 			try_to_unmap(folio, flags);
 			if (folio_mapped(folio)) {
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters.patch
mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch
mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi.patch
mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi-fix.patch
mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback.patch

