Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F9E2EA72B
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 23:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756857175; cv=none; b=R8Kqt2vdF62u+sdidhHSoEvA2X7ZI/GwhUXUcJH+mnZogbIkoHLuQ5hrICWGBXgLnGT3/bWej7x8sz05jETK5co2Q7vJFNmufkYrP/sdNw16l1Qky/RgcTcGJGmzJC1razAMZ1MByM9mUQPuoME64+LZqbXVwcgiX9rEOGmvQcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756857175; c=relaxed/simple;
	bh=FGKn/+/E3CPDZ2Wr5MM1GUHGGMWSoArfRwcg27CFnCA=;
	h=Date:To:From:Subject:Message-Id; b=s3F4BuyIo4c2251KD2rRxCb34Ois7F7CHSjZlza+htOvQV1SpQ1HhKiABD/C5xIJYRV2focgdZc+orxz2muJARcn/aWPaHWK3+/YL35SuUymv4zzZcTTTZfsXvGMNZQQiqbrNaaRRMCGWDGOy5kNh4mZYmi1jSktNpoYgEoE1Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Zl3gbT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Zl3gbT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C5BC4CEED;
	Tue,  2 Sep 2025 23:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756857175;
	bh=FGKn/+/E3CPDZ2Wr5MM1GUHGGMWSoArfRwcg27CFnCA=;
	h=Date:To:From:Subject:From;
	b=1Zl3gbT5hTlB1/HKKLuQSpQd8N0iY9ORSCa6vDQbwJN6C15hLSmCol9mdmRHiTRGH
	 rGu8h0481fYVMYz55WEt48dteks46f/dH0P3YVPEcNWERT+EKignTXSkwUgq2u5fro
	 ocEFesfN1XhxmDY8DFBhLpgPLwRI0n6FFI38O0j0=
Date: Tue, 02 Sep 2025 16:52:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch added to mm-new branch
Message-Id: <20250902235255.54C5BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugeltb: check NUMA_NO_NODE in only_alloc_fresh_hugetlb_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugeltb: check NUMA_NO_NODE in only_alloc_fresh_hugetlb_folio()
Date: Tue, 2 Sep 2025 20:48:16 +0800

Move the NUMA_NO_NODE check out of buddy and gigantic folio allocation to
cleanup code a bit, also this will avoid NUMA_NO_NODE passed as 'nid' to
node_isset() in alloc_buddy_hugetlb_folio().

Link: https://lkml.kernel.org/r/20250902124820.3081488-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -1479,8 +1479,6 @@ static struct folio *alloc_gigantic_foli
 	struct folio *folio;
 	bool retried = false;
 
-	if (nid == NUMA_NO_NODE)
-		nid = numa_mem_id();
 retry:
 	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
 	if (!folio) {
@@ -1942,8 +1940,6 @@ static struct folio *alloc_buddy_hugetlb
 		alloc_try_hard = false;
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
-	if (nid == NUMA_NO_NODE)
-		nid = numa_mem_id();
 
 	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
 
@@ -1979,6 +1975,9 @@ static struct folio *only_alloc_fresh_hu
 	struct folio *folio;
 	int order = huge_page_order(h);
 
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+
 	if (order > MAX_PAGE_ORDER)
 		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
 	else
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch
mm-hugetlb-convert-to-account_new_hugetlb_folio.patch
mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch
mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch
mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch
mm-page_alloc-add-alloc_contig_frozen_pages.patch
mm-cma-add-alloc-flags-for-__cma_alloc.patch
mm-cma-add-__cma_release.patch
mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch

