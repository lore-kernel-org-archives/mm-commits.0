Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768AC3EA66
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 00:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780705010; cv=none; b=LztKxBxh2WukZz6Lwe4YWq6D5+TNeQA0svInOVJyu/ySDVZ0Ds/722/yIeNEdXhFgtW1yd9tJhXpw0rRl3gPkXrtlOuzyuDSGC62xt8Orn/WgxgO5gUa3PrINlZ72aAO3tW4h8r3garwXQcKZ5pYz+/lGU+R/649SCFyzHS9HtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780705010; c=relaxed/simple;
	bh=kHty6fajgcZpaEmwV+QvjURzoSza6HYn0jFtKnt3odg=;
	h=Date:To:From:Subject:Message-Id; b=tcXaJ/A1gddjDicCG6uXdFYbdmRzxCXwvAlqJ+DtbX0BM961fN8EpZS9zC6Uc4apYTPi6F9IPfH9aW0FG4Xw03KBmH1f2Qtg8DK5hISShvNWHOGoHLZLirqHPf0YDJ2jqMEpqI8V1VzaxbRHXv+g9DNCIiM8f4ciOttD5CjmLD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xadXfEub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xadXfEub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA9A1F00893;
	Sat,  6 Jun 2026 00:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780705009;
	bh=c8yJT0CGNN5096z2I9Y/UkrXZOXns9zf0dZzYb4B0F0=;
	h=Date:To:From:Subject;
	b=xadXfEubiICsq3bekd3v6TniK/FmbCbYpMlEQfbbdXQqRjcMyuI4ZfVvtlQBweF3h
	 BO9xytx2RHwOo6wl0pbIcYp9GytmGXS53y/ZIsc7RTPVJq1uNt0n1kLMM74KlpLiMl
	 RqreQJk9a1XxLkZ9Nln/Z9rPCdpt3zqyYcxsKCuI=
Date: Fri, 05 Jun 2026 17:16:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] documentation-mm-update-the-admin-guide-for-mthp-collapse-fix.patch removed from -mm tree
Message-Id: <20260606001649.1DA9A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: add back note and edit doc about khugepaged limits
has been removed from the -mm tree.  Its filename was
     documentation-mm-update-the-admin-guide-for-mthp-collapse-fix.patch

This patch was dropped because it was folded into documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: add back note and edit doc about khugepaged limits
Date: Tue May 26 07:47:42 2026 -0600

Link: https://lore.kernel.org/b457f6e9-ae12-4e1f-8484-f3043ca62276@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~documentation-mm-update-the-admin-guide-for-mthp-collapse-fix
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -265,6 +265,11 @@ support the following arguments::
 Khugepaged controls
 -------------------
 
+.. note::
+   khugepaged currently only searches for opportunities to collapse file/shmem
+   to PMD-sized THP. Only anonymous memory will attempt to collapse to other THP
+   sizes.
+
 khugepaged runs usually at low frequency so while one may not want to
 invoke defrag algorithms synchronously during the page faults, it
 should be worth invoking defrag at least in khugepaged. However it's
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
mm-khugepaged-introduce-mthp-collapse-support-fix.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

