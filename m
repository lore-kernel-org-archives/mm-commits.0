Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A351C32EB
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 07:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150139; cv=none; b=bxvUoDZQeRqOeBs1eut8ynUuC+0vlO1Q1UseN+iT3FvoOrIDQp46mz0aEEjMCd9oB1i7OBCHk1qvCLWiR5SyuVKxYakdbjK1q3FBg580EeFOYN8S1d+7KX8AabRiwAC2ny2wdt2HGO2nTLFpT1/eF/FwNt0B8AJsJid3KiCsyFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150139; c=relaxed/simple;
	bh=aKjLnM6O/wTPeqfwWXr4Rk/TI2U5zXaQuhEkG1yVXgI=;
	h=Date:To:From:Subject:Message-Id; b=ocry6du5Sg0o3ZYyX/RKdHBYIyzPEhaYguREo7TAuC5IQpq+D1C57f48BgQ4/G6Sc559G0VI1CJu4o3rPPy1OBXuBwJF/vfGDWk8BJoFtojua9VJY3xO7/BJeUis5FF/b3CrHojoct7S1gjJSO2bG6hwMsxRsZufwtRiKDNZtOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vgRTqG+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vgRTqG+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B8DC4CEC3;
	Thu, 17 Oct 2024 07:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150139;
	bh=aKjLnM6O/wTPeqfwWXr4Rk/TI2U5zXaQuhEkG1yVXgI=;
	h=Date:To:From:Subject:From;
	b=vgRTqG+V4VTWbLN5nIbX3qi4neGzJq+VconswfLMrj0+Mz1B0GX3QtZwbODITD/0Z
	 EAp4RtdPFk+l5bC1cWBnLx428sTGrzsRCxnj9OV+i3cG07fkpQHUeSFpI/VhBFGWQW
	 dEucvV+m6ZQKViUHp0eOo+v+Gdd4I3F3G++Rswlg=
Date: Thu, 17 Oct 2024 00:28:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-khugepaged-fix-the-incorrect-statistics-when-collapsing-large-file-folios.patch removed from -mm tree
Message-Id: <20241017072859.63B8DC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: fix the incorrect statistics when collapsing large file folios
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-the-incorrect-statistics-when-collapsing-large-file-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: khugepaged: fix the incorrect statistics when collapsing large file folios
Date: Mon, 14 Oct 2024 18:24:44 +0800

Khugepaged already supports collapsing file large folios (including shmem
mTHP) by commit 7de856ffd007 ("mm: khugepaged: support shmem mTHP
collapse"), and the control parameters in khugepaged:
'khugepaged_max_ptes_swap' and 'khugepaged_max_ptes_none', still compare
based on PTE granularity to determine whether a file collapse is needed. 
However, the statistics for 'present' and 'swap' in
hpage_collapse_scan_file() do not take into account the large folios,
which may lead to incorrect judgments regarding the
khugepaged_max_ptes_swap/none parameters, resulting in unnecessary file
collapses.

To fix this issue, take into account the large folios' statistics for
'present' and 'swap' variables in the hpage_collapse_scan_file().

Link: https://lkml.kernel.org/r/c76305d96d12d030a1a346b50503d148364246d2.1728901391.git.baolin.wang@linux.alibaba.com
Fixes: 7de856ffd007 ("mm: khugepaged: support shmem mTHP collapse")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-the-incorrect-statistics-when-collapsing-large-file-folios
+++ a/mm/khugepaged.c
@@ -2252,7 +2252,7 @@ static int hpage_collapse_scan_file(stru
 			continue;
 
 		if (xa_is_value(folio)) {
-			++swap;
+			swap += 1 << xas_get_order(&xas);
 			if (cc->is_khugepaged &&
 			    swap > khugepaged_max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
@@ -2299,7 +2299,7 @@ static int hpage_collapse_scan_file(stru
 		 * is just too costly...
 		 */
 
-		present++;
+		present += folio_nr_pages(folio);
 
 		if (need_resched()) {
 			xas_pause(&xas);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-fix-khugepaged-activation-policy-for-shmem.patch

