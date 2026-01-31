Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1734938A734
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898324; cv=none; b=o/xEWwjlunzsZMN0KF4Qm2Ssb9ed8KA5F6k9B8a2m2C341icat0sQVQun4r91Fy4J5Xi5324VWU2NLbDOPgOH8njV/LnMWpg6jMZjLFFcs4WeqZzSz7GGcTzTZyufXbgZx5ItbaDmAPBRF9Q8d2p2qcqr1qCr1XJi9ajmy3udU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898324; c=relaxed/simple;
	bh=Xpmxc2MVzy7Bv+YFMy/m0EWWWYJp58RhDJ6PF1djgbg=;
	h=Date:To:From:Subject:Message-Id; b=FFRZFZuKcCs47q0UQd6hnaqG4zjOKjiTspCd8w+94hgT06agYg8NzT2+aCR/72AjWN2zsff5ahCY1Z5vsiSH4xmo7uc4cS9lqEqyWLunmJQT0QQpbQ20dvufNZYrrjhqn2kWXg6l36YUsgDNIJYw+ZVkhwZfKi9M7Qa7/rlTirk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mhWRiaXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mhWRiaXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4997C4CEF1;
	Sat, 31 Jan 2026 22:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898324;
	bh=Xpmxc2MVzy7Bv+YFMy/m0EWWWYJp58RhDJ6PF1djgbg=;
	h=Date:To:From:Subject:From;
	b=mhWRiaXk564DyXf+RzbYVtgBeO3lEohTGB0Ui0YSWSzTWbJ9+pYw9jye9vdDEg6b7
	 ereIxyXdubJSav66hkdxWQeC3SuS85jiT6s4rUYe0zPPzZ1nDeoEUcCbbtso35WsQE
	 DR+7GtI5SUDpAaP+yEYNnxKEx7CzR0eP88IDplms=
Date: Sat, 31 Jan 2026 14:25:23 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio.patch removed from -mm tree
Message-Id: <20260131222523.E4997C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb_cma: optimize hugetlb_cma_alloc_frozen_folio()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb_cma: optimize hugetlb_cma_alloc_frozen_folio()
Date: Mon, 12 Jan 2026 23:09:53 +0800

Check hugetlb_cma_size which helps to avoid unnecessary gfp check or
nodemask traversal.

Link: https://lkml.kernel.org/r/20260112150954.1802953-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio
+++ a/mm/hugetlb_cma.c
@@ -16,7 +16,7 @@
 static struct cma *hugetlb_cma[MAX_NUMNODES];
 static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 static bool hugetlb_cma_only;
-static unsigned long hugetlb_cma_size __initdata;
+static unsigned long hugetlb_cma_size __ro_after_init;
 
 void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
@@ -31,6 +31,9 @@ struct folio *hugetlb_cma_alloc_frozen_f
 	struct folio *folio;
 	struct page *page = NULL;
 
+	if (!hugetlb_cma_size)
+		return NULL;
+
 	if (hugetlb_cma[nid])
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


