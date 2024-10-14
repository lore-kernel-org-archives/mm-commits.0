Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681491D9A46
	for <mm-commits@vger.kernel.org>; Mon, 14 Oct 2024 23:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728949150; cv=none; b=fxOtUtA0ixQqAdu6CXeavCnT5BdRQpOYE8CbLiUUYRyt9Z1LotTdt+g+cbGth9zKYx9V6fOZueFBsWKS8Hp6ERkBsoM7mqrQVyo5lGRFSH96/F8G+MGl2q/OFbUh7TmWv7auBewZ6v9rbsUWMIzoJzbXscUrDJ8DJJkp9G8Zek0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728949150; c=relaxed/simple;
	bh=kzovRS7ZrJEsBt8wli056WSYlXd0Ojya9tiYhk3dt3E=;
	h=Date:To:From:Subject:Message-Id; b=OrO810jxEUWFdqg/jVSrnQ+tD53xi4RdYRIYTcb35yrs1zaGTWqOWnvgjLsv7OkyJRptVRBzfIofvo+BMGu2CjPn6cqCFZZK568xiAVEYTY9BH2PgKA5b90YIrB5PoQjwfJE2Uyv/cigDfZAKFmQyexdZqpdTRmmPmIywcn6zWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eDLAu6HN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eDLAu6HN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9222C4CEC3;
	Mon, 14 Oct 2024 23:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728949150;
	bh=kzovRS7ZrJEsBt8wli056WSYlXd0Ojya9tiYhk3dt3E=;
	h=Date:To:From:Subject:From;
	b=eDLAu6HNVLlIkZ1X2S4CEca8kAdBHGpA9fD7ObLWWBJl59y3ewce9hP0JSoGZbN6+
	 tfodq2w9CVKODUY86fvF7KlI8h6MeWQ1uMF9JKvBpLpLW+PTvHIJWybUkRZ8+XOo6p
	 IMqzXCtcdBwQUmFZk31Ckhy62MkyzhrnNnb094tk=
Date: Mon, 14 Oct 2024 16:39:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-the-incorrect-statistics-when-collapsing-large-file-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20241014233909.E9222C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: fix the incorrect statistics when collapsing large file folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-fix-the-incorrect-statistics-when-collapsing-large-file-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-the-incorrect-statistics-when-collapsing-large-file-folios.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-khugepaged-fix-the-incorrect-statistics-when-collapsing-large-file-folios.patch
mm-shmem-fix-khugepaged-activation-policy-for-shmem.patch

