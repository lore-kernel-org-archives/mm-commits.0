Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8EA768E7
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423499; cv=none; b=MWkhrSpW29LAHobCEAybeFKtlbakb/vT3MK8nIxEF3IiLI8VwRhtcjp8M1gKmE9X2NtcVP8xiUw/8J/05gxM8AAw72UeprXThZgpCKLd/IjwBQKop5QfAlhG4Cz78LzMpuDF76noyq3TSyrRJ1nXgNuswYG+D8wXovRiomJrHrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423499; c=relaxed/simple;
	bh=RCP171e2+6YKfN153AKu7en2ohDFZPEccB2g4JpKqrc=;
	h=Date:To:From:Subject:Message-Id; b=r4yKHSK7+mkM/aUsy4znlMoO1ru+HQESGgS/r9peqDx/wFLHL2f50hmR/AREa4PALCjjwPM3PMR6l2/TfTmb264aB3exYY9Cs8WIDHS33WcA653jtS3JJqwtA+7QgZzGtLkgOWgkvvWLEy6gMN6Z7OLVAPsWigz9yzbpDdmstRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wRmmt/Fs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wRmmt/Fs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C6FC4CEC2;
	Wed,  4 Sep 2024 04:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423499;
	bh=RCP171e2+6YKfN153AKu7en2ohDFZPEccB2g4JpKqrc=;
	h=Date:To:From:Subject:From;
	b=wRmmt/FsvvFo1L2euJchR6INQNEryUAgeK9UkzCTviPFl4aJbPJRobUvviB5y0qGe
	 mbwRSKtHc0FQNE6KqtYejIqUsaIJ8TXXGnvZHGwGGDlHri+iK+GTFw1KgxKI0Xojpy
	 Mhy5jlGhsyqNabc5Krt6UJoKxzClN2CEoeGxF6EA=
Date: Tue, 03 Sep 2024 21:18:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios.patch removed from -mm tree
Message-Id: <20240904041819.B1C6FC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: expand the is_refcount_suitable() to support file folios
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: khugepaged: expand the is_refcount_suitable() to support file folios
Date: Tue, 20 Aug 2024 17:49:13 +0800

Patch series "support shmem mTHP collapse", v2.

Shmem already supports mTHP allocation[1], and this patchset adds support
for shmem mTHP collapse, as well as adding relevant test cases.


This patch (of 5):

Expand the is_refcount_suitable() to support reference checks for file
folios, as preparation for supporting shmem mTHP collapse.

Link: https://lkml.kernel.org/r/cover.1724140601.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/eae4cb3195ebbb654bfb7967cb7261d4e4e7c7fa.1724140601.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios
+++ a/mm/khugepaged.c
@@ -546,12 +546,14 @@ static void release_pte_pages(pte_t *pte
 
 static bool is_refcount_suitable(struct folio *folio)
 {
-	int expected_refcount;
+	int expected_refcount = folio_mapcount(folio);
 
-	expected_refcount = folio_mapcount(folio);
-	if (folio_test_swapcache(folio))
+	if (!folio_test_anon(folio) || folio_test_swapcache(folio))
 		expected_refcount += folio_nr_pages(folio);
 
+	if (folio_test_private(folio))
+		expected_refcount++;
+
 	return folio_ref_count(folio) == expected_refcount;
 }
 
@@ -2285,8 +2287,7 @@ static int hpage_collapse_scan_file(stru
 			break;
 		}
 
-		if (folio_ref_count(folio) !=
-		    1 + folio_mapcount(folio) + folio_test_private(folio)) {
+		if (!is_refcount_suitable(folio)) {
 			result = SCAN_PAGE_COUNT;
 			break;
 		}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


