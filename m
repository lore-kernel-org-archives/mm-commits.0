Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFBA522F
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 23:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757547232; cv=none; b=cAvCM1KqnshJykS98O1RRg6pmySsdHAGdjaIC8NOllzPqdDFuXQN5LXXNyKhYekO3A63iLgaglNSR44xXohFtUBjAn3+uE5Nl2re2TPWROtesm4FfJZdtfeiGyu9AYuOjCexIq1Km95kZOHOlAgEQCm1pSifQtEU/8EINYZjhrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757547232; c=relaxed/simple;
	bh=hchajqsbPuqus/+1DdiSif1L5H+TN343pAlSRqB1RGE=;
	h=Date:To:From:Subject:Message-Id; b=L24n4T/tbqHKLIWdFJyrVkUKllEelZXg7osR+hhKdyM2GC8R6wAKMuzmaqulwzarglWsCAhrcJle9Gdxgt7PcGwXYl63tZxE10PB2EAbDXZg60TsD9k3LZpjMrFGy6SLmxgjG07c2hZF1RwMny/SKpFoNywZKCddlNlg16CbsEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CriFEdqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CriFEdqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0A9C4CEEB;
	Wed, 10 Sep 2025 23:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757547231;
	bh=hchajqsbPuqus/+1DdiSif1L5H+TN343pAlSRqB1RGE=;
	h=Date:To:From:Subject:From;
	b=CriFEdqQLsokrtstVG3Y1fr5kUwHiFVFu3rZmW9xwvpnFURK7H0kSVfshkJPPzATK
	 Z9OLgbCdHSTruvTR2uMJ5SzW5V2qRvs1Wr+Ae9qwq2jTYE+6KDhKeODsHTp0tGH94n
	 Ld86YOY0WmTUGKe0cx3oo2Ov2ugAHY3QaWzdhgXM=
Date: Wed, 10 Sep 2025 16:33:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch added to mm-unstable branch
Message-Id: <20250910233351.BC0A9C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugeltb: check NUMA_NO_NODE in only_alloc_fresh_hugetlb_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugeltb: check NUMA_NO_NODE in only_alloc_fresh_hugetlb_folio()
Date: Wed, 10 Sep 2025 21:39:58 +0800

Move the NUMA_NO_NODE check out of buddy and gigantic folio allocation to
cleanup code a bit, also this will avoid NUMA_NO_NODE passed as 'nid' to
node_isset() in alloc_buddy_hugetlb_folio().

Link: https://lkml.kernel.org/r/20250910133958.301467-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
 	if (order_is_gigantic(order))
 		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
 	else
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch
mm-hugetlb-convert-to-account_new_hugetlb_folio.patch
mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch
mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch
mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch

