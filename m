Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D86B7641D
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423502; cv=none; b=Q8Xz/AvG71lsvLeeoSGjjpkFX0ajRGn3bkvOqLVCGrOwQDGH2bVnXPOc8c0QkQMf4wYEK/DG7A6/CpwiuQqqM5PZaskDkgj2vXL9gW56cUldPu/WV4eVyOhjNFmSM/jPrr6d9+NnXz7x+Di15Qz10LN3UcWlUsy5iUMjXVG3Yao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423502; c=relaxed/simple;
	bh=+C5S5F1/yfOPmW1AxW/7A+PcdGNm0mVL59jtAxFNego=;
	h=Date:To:From:Subject:Message-Id; b=gwt1STPdlqAYUFv6xsnh+cGq/kEwzyfQ2nMzLmnAyAC5Jwqkea0hwemx3/0cYSAZ19jBRJqgzhGwRmc7HHjlCHV5BaqbdNcX6hsb4bwE8l2WJHlmAB7iJ0pGy++DD0m3l6g68+0LlC8J7S81Ut4eP4rKcRYaRdGzfy/tfoLUtbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wvZVkkF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wvZVkkF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86AFC4CEC2;
	Wed,  4 Sep 2024 04:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423502;
	bh=+C5S5F1/yfOPmW1AxW/7A+PcdGNm0mVL59jtAxFNego=;
	h=Date:To:From:Subject:From;
	b=wvZVkkF3EpetRNEV7C6vF7awUdKqxQLHyUErIjW67zRjDy6Gl4wwXDVjN25byrbsS
	 2IgszB8HIz1OWsM1P/LPyG1Cn2mJryUBsbSeUXyIPRvaIX8WOyz+WOek2JWs5NTYVX
	 nNRhfYJEw0VSB+07ApkJhVrekC6S98n7khzlNBLs=
Date: Tue, 03 Sep 2024 21:18:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-support-shmem-mthp-copy.patch removed from -mm tree
Message-Id: <20240904041821.E86AFC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: support shmem mTHP copy
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-support-shmem-mthp-copy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: khugepaged: support shmem mTHP copy
Date: Tue, 20 Aug 2024 17:49:15 +0800

Iterate each subpage in the large folio to copy, as preparation for
supporting shmem mTHP collapse.

Link: https://lkml.kernel.org/r/222d615b7c837eabb47a238126c5fdeff8aa5283.1724140601.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-support-shmem-mthp-copy
+++ a/mm/khugepaged.c
@@ -2056,17 +2056,22 @@ xa_unlocked:
 	index = start;
 	dst = folio_page(new_folio, 0);
 	list_for_each_entry(folio, &pagelist, lru) {
+		int i, nr_pages = folio_nr_pages(folio);
+
 		while (index < folio->index) {
 			clear_highpage(dst);
 			index++;
 			dst++;
 		}
-		if (copy_mc_highpage(dst, folio_page(folio, 0)) > 0) {
-			result = SCAN_COPY_MC;
-			goto rollback;
+
+		for (i = 0; i < nr_pages; i++) {
+			if (copy_mc_highpage(dst, folio_page(folio, i)) > 0) {
+				result = SCAN_COPY_MC;
+				goto rollback;
+			}
+			index++;
+			dst++;
 		}
-		index++;
-		dst++;
 	}
 	while (index < end) {
 		clear_highpage(dst);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


