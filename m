Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481EF158A0F
	for <mm-commits@vger.kernel.org>; Tue,  9 Apr 2024 21:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712697379; cv=none; b=R06GylhccM81yfmJuixsUzlae24Fl0BGTNEKa7/zdJI8r/p5Lo0K0nWknLZQeRhPv3cyNYRO5mtSRYZnzKwJTBt5tsTQoQGEWhGReFnfm95QGEw4sWTkaHyMDwe/A5k6I3bgGUdgNcTlJ3a3fqsiDVMt71KG0Kd+Kb3O210HXQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712697379; c=relaxed/simple;
	bh=72ygdK5lIh4IDUuCdPbeH0dy/aFzcGpxA2ua+uu9BxM=;
	h=Date:To:From:Subject:Message-Id; b=skYxmFe1sJQFCQGlJJwCs4/Ot1SWd3DewVU+AdNrQ8o6yY5vIkeQ/bwCWnctMF2hrLppaXUck2gWxbgFwxwBVvNSo5Uz8P914w4YmKcmZy3tMFgi3jcruTWUunhsw78SVsrzKmG30Y2QhVrG4EoCyiNfVAoa+U2Qbluhiw73neA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KwfnWsgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KwfnWsgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C01C433C7;
	Tue,  9 Apr 2024 21:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712697378;
	bh=72ygdK5lIh4IDUuCdPbeH0dy/aFzcGpxA2ua+uu9BxM=;
	h=Date:To:From:Subject:From;
	b=KwfnWsghfswcL55ZcSvNX4EnYmLhDvSrb058xMwqj18XcHn8XLWw5Snre/Ue3pqnz
	 pKtDgi5oekiT+Iqk/Dje+Lu2HX/oqqpAOBAEUYp+4RUm1xCNuBy5JI/4qJ48FU3Qnv
	 3gHqxYAposaa6X1DwyMu7M0Zs3BqJPC3pvAR83oo=
Date: Tue, 09 Apr 2024 14:16:17 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,mhocko@suse.com,ioworker0@gmail.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache-fix.patch added to mm-unstable branch
Message-Id: <20240409211618.A2C01C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: FIXUP: mm: swap: free_swap_and_cache_nr() as batched free_swap_and_cache()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache-fix.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: FIXUP: mm: swap: free_swap_and_cache_nr() as batched free_swap_and_cache()
Date: Tue, 9 Apr 2024 12:18:40 +0100

Fix a build warning on parisc [1] due to their implementation of
__swp_entry_to_pte() not correctly putting the macro args in parenthisis. 
But it turns out that a bunch of other arches are also faulty in this
regard.

I'm also adding an extra statement to the documentation for
pte_next_swp_offset() as suggested by David.

[1] https://lore.kernel.org/all/202404091749.ScNPJ8j4-lkp@intel.com/

Link: https://lkml.kernel.org/r/20240409111840.3173122-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/internal.h~mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache-fix
+++ a/mm/internal.h
@@ -194,7 +194,8 @@ static inline int folio_pte_batch(struct
 
 /**
  * pte_next_swp_offset - Increment the swap entry offset field of a swap pte.
- * @pte: The initial pte state; is_swap_pte(pte) must be true.
+ * @pte: The initial pte state; is_swap_pte(pte) must be true and
+ *	 non_swap_entry() must be false.
  *
  * Increments the swap offset, while maintaining all other fields, including
  * swap type, and any swp pte bits. The resulting pte is returned.
@@ -203,7 +204,7 @@ static inline pte_t pte_next_swp_offset(
 {
 	swp_entry_t entry = pte_to_swp_entry(pte);
 	pte_t new = __swp_entry_to_pte(__swp_entry(swp_type(entry),
-						   swp_offset(entry) + 1));
+						   (swp_offset(entry) + 1)));
 
 	if (pte_swp_soft_dirty(pte))
 		new = pte_swp_mksoft_dirty(new);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags.patch
mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache.patch
mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache-fix.patch
mm-swap-simplify-struct-percpu_cluster.patch
mm-swap-update-get_swap_pages-to-take-folio-order.patch
mm-swap-allow-storage-of-all-mthp-orders.patch
mm-vmscan-avoid-split-during-shrink_folio_list.patch
mm-madvise-avoid-split-during-madv_pageout-and-madv_cold.patch

