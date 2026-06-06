Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EDF27453
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 00:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780704809; cv=none; b=DdEE5hIMX7A8+CU30GNYHg2RQSxxqokiek9yR0uzTo7qphHfB60O9FEYVoZFjCZBZhA8J1My+p/4px9RJhS5lqodO3k6DbPAjpUGKfe1wQfxBRQI8gg2d5DsdZ7DL7XSxEAcX5QucqwkMyDGmlrtl5HdEKMWmK8+pZEzjsTX4J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780704809; c=relaxed/simple;
	bh=qX0jMJnymm55NGANlD8KD6s74GwVDcB2tTT5Q9kOUAU=;
	h=Date:To:From:Subject:Message-Id; b=Xy0EohaieM39Blxcf4hCsorZgVyRh2LGfYAGxshVqiRAqtQyzOFucdvz4zlupNWmG7EL+9zEMj/O945kAjh0J1nwmoonPZEj8jILOdpMrjD675TLGanTqdsKnObPUlf7tvs2aS/Tm/JIsKWnJr/54tXlsoxALq5USYMXZ/IJO/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SXI+X3Bx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SXI+X3Bx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88861F00893;
	Sat,  6 Jun 2026 00:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780704807;
	bh=cUjjJ5PEdZ/X9neuzlyRiUInLbbJ1TRCfl45OmvFKew=;
	h=Date:To:From:Subject;
	b=SXI+X3Bxp/UM7qCRa6hmv3O/suR5P7Oi+tQtk+DHqrcvpkygHfHZfv78zr6sh14n9
	 pOLwQbSKlF9zUJ30kdrc7KVsdC13GfRjG4DakpJ1YgCSi4h/k4+q5tibQ13Cgc5TSt
	 S/orOsFY7bbV2LSzuEpNWi5vUSu0/F6MSefSvkjQ=
Date: Fri, 05 Jun 2026 17:13:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support-fix.patch removed from -mm tree
Message-Id: <20260606001327.B88861F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cleanup collapse_max_ptes_none
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support-fix.patch

This patch was dropped because it was folded into mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: cleanup collapse_max_ptes_none
Date: Tue May 26 05:40:03 2026 -0600

make max_ptes_none a const and cleanup the pr_warn_once

Link: https://lore.kernel.org/b5fa19c5-4b3e-40b8-8e78-fc31169a7a79@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
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

 mm/khugepaged.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support-fix
+++ a/mm/khugepaged.c
@@ -360,7 +360,7 @@ static bool pte_none_or_zero(pte_t pte)
 static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order)
 {
-	unsigned int max_ptes_none = khugepaged_max_ptes_none;
+	const unsigned int max_ptes_none = khugepaged_max_ptes_none;
 
 	if (vma && userfaultfd_armed(vma))
 		return 0;
@@ -376,14 +376,13 @@ static unsigned int collapse_max_ptes_no
 	 */
 	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
 		return (1 << order) - 1;
-	if (!max_ptes_none)
-		return 0;
 	/*
 	 * For mTHP collapse of values other than 0 or KHUGEPAGED_MAX_PTES_LIMIT,
 	 * emit a warning and return 0.
 	 */
-	pr_warn_once("mTHP collapse does not support max_ptes_none values"
-		     " other than 0 or %u, defaulting to 0.\n",
+	if (max_ptes_none)
+		pr_warn_once("mTHP collapse does not support max_ptes_none"
+		     " values other than 0 or %u, defaulting to 0.\n",
 		     KHUGEPAGED_MAX_PTES_LIMIT);
 	return 0;
 }
_

Patches currently in -mm which might be from npache@redhat.com are

mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
mm-khugepaged-rework-max_ptes_-handling-with-helper-functions.patch
mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix.patch
mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch
mm-khugepaged-improve-tracepoints-for-mthp-orders.patch
mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-introduce-mthp-collapse-support-fix.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse-fix.patch

