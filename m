Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B0B38A9A2
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898325; cv=none; b=aomHeQgjY3GBeuWhP8KNrrztUTXHZc1cidMktpAkDRK0eqTg01iqCbcL5LyOFhPUU4nU6oCIgIl5smzn/T87S4QHqXTQO7q9LfEo3WJcdOECVvDMOKJbUydtgp2wUO7Hg1hxDbF0cBv3+/QxkFBuWLlxYzA9VKC57V1Iy2tzcS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898325; c=relaxed/simple;
	bh=ZcRIqqFUw0IBUiPAEUHXBs7GK9asgkh0OxpSAPFsKfA=;
	h=Date:To:From:Subject:Message-Id; b=kK6zGltoY0YUNtgdJgMsTudLrFCyW9Mu55Whj2dsVd9PLsmoBT1+9Y6+vQJ5g+HwhaEu00CaeZoFQar4A2U0qCSrY5lHlApYAczaTOSG1aSvEmCsus+OdGajipUsDmokPcxa1CQfXSMFgY3enVoiHg4SvlAdxyllxG5I9tXFR0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DFqBtQ2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DFqBtQ2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EA7C4CEF1;
	Sat, 31 Jan 2026 22:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898325;
	bh=ZcRIqqFUw0IBUiPAEUHXBs7GK9asgkh0OxpSAPFsKfA=;
	h=Date:To:From:Subject:From;
	b=DFqBtQ2+wYdc2Xp8WOwYAsSYW5IHbZXL0i29FF3qVLcUZ4b+lFBsXKifnZmEJn4+7
	 RHdd0iK9BH7COH3HGXi5hpVd9TiOzduo2BKKFmxUtktl23O3mdPfz49qHvvxPQR2Qt
	 i3as6z/ZC6tSZI9fvj8IAK3KP5c5NnAj2h/W2BcM=
Date: Sat, 31 Jan 2026 14:25:24 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init.patch removed from -mm tree
Message-Id: <20260131222525.20EA7C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb_cma: mark hugetlb_cma{_only} as __ro_after_init
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb_cma: mark hugetlb_cma{_only} as __ro_after_init
Date: Mon, 12 Jan 2026 23:09:54 +0800

hugetlb_cma and hugetlb_cma_only are initialized once during init and
never changed.

Link: https://lkml.kernel.org/r/20260112150954.1802953-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init
+++ a/mm/hugetlb_cma.c
@@ -13,9 +13,9 @@
 #include "hugetlb_cma.h"
 
 
-static struct cma *hugetlb_cma[MAX_NUMNODES];
+static struct cma *hugetlb_cma[MAX_NUMNODES] __ro_after_init;
 static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
-static bool hugetlb_cma_only;
+static bool hugetlb_cma_only __ro_after_init;
 static unsigned long hugetlb_cma_size __ro_after_init;
 
 void hugetlb_cma_free_frozen_folio(struct folio *folio)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


