Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E91530F534
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421688; cv=none; b=Zm9FkfiYY2kSGqwOQYzNRQPu7PmP3sDp+3nQuiAe1IpWXcedpIpwyg74pM8rFVBCuAe4OIUXTNCLq0t3tpvisZx/TemqVyBt8aacB7H96QfdGH73LCvDmxy3FwspuvJlVHYRMpxW2S17Me78lIxzIasfcqwDRTGS6f33b1FRz8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421688; c=relaxed/simple;
	bh=jwG4Y68i0oVxJXS1+uL/Gcwadg+uqvdPYX+fYZ/xypI=;
	h=Date:To:From:Subject:Message-Id; b=W9M9dWVUH2lme4vFCt2sYdst7w+paXyVYyq7r7p8ST463NNduC2RERLI5gFq31VT3YdHH6QnbyLm5Qa/TbGruPY4LtlZrgGJQk0grsTLzkAJoZlXzkbe46RI6iiK6RZs2BAqyMLDAOdwLqK0EtwJ68RrefWIkiv8esjCGpR5VVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VfEokS6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VfEokS6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B994C116C6;
	Fri,  6 Feb 2026 23:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421688;
	bh=jwG4Y68i0oVxJXS1+uL/Gcwadg+uqvdPYX+fYZ/xypI=;
	h=Date:To:From:Subject:From;
	b=VfEokS6YaSHeaGBETZ5kae9rvCgm0RWRzqriU80GVaEWuHqDkJbp+nQbUU3rKGnN1
	 KByJ70hBlyhA0JOP9F66JtcKMDmezOPOb32EZyCcby+36z2ZjpaHUSSuESVvZW64Vs
	 CWvHzCnQ8ML7C4AQ722bI2fyiN0fFY4xAg+FMKQc=
Date: Fri, 06 Feb 2026 15:48:07 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,usamaarif642@gmail.com,songliubraving@fb.com,ryan.roberts@arm.com,riel@surriel.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,kas@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-fix-nr_file_pages-and-nr_shmem-in-collapse_file.patch removed from -mm tree
Message-Id: <20260206234808.2B994C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in collapse_file()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-nr_file_pages-and-nr_shmem-in-collapse_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in collapse_file()
Date: Thu, 29 Jan 2026 20:29:25 -0800

In META's fleet, we observed high-level cgroups showing zero file memcg
stats while their descendants had non-zero values.  Investigation using
drgn revealed that these parent cgroups actually had negative file stats,
aggregated from their children.

This issue became more frequent after deploying thp-always more widely,
pointing to a correlation with THP file collapsing.  The root cause is
that collapse_file() assumes old folios and the new THP belong to the same
node and memcg.  When this assumption breaks, stats become skewed.  The
bug affects not just memcg stats but also per-numa stats, and not just
NR_FILE_PAGES but also NR_SHMEM.

The assumption breaks in scenarios such as:

1. Small folios allocated on one node while the THP gets allocated on a
   different node.

2. A package downloader running in one cgroup populates the page cache,
   while a job in a different cgroup executes the downloaded binary.

3. A file shared between processes in different cgroups, where one
   process faults in the pages and khugepaged (or madvise(COLLAPSE))
   collapses them on behalf of the other.

Fix the accounting by explicitly incrementing stats for the new THP and
decrementing stats for the old folios being replaced.

Link: https://lkml.kernel.org/r/20260130042925.2797946-1-shakeel.butt@linux.dev
Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-nr_file_pages-and-nr_shmem-in-collapse_file
+++ a/mm/khugepaged.c
@@ -2195,16 +2195,13 @@ immap_locked:
 		xas_lock_irq(&xas);
 	}
 
-	if (is_shmem)
+	if (is_shmem) {
+		lruvec_stat_mod_folio(new_folio, NR_SHMEM, HPAGE_PMD_NR);
 		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
-	else
+	} else {
 		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
-
-	if (nr_none) {
-		lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
-		/* nr_none is always 0 for non-shmem. */
-		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
 	}
+	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
 
 	/*
 	 * Mark new_folio as uptodate before inserting it into the
@@ -2238,6 +2235,11 @@ immap_locked:
 	 */
 	list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
 		list_del(&folio->lru);
+		lruvec_stat_mod_folio(folio, NR_FILE_PAGES,
+				      -folio_nr_pages(folio));
+		if (is_shmem)
+			lruvec_stat_mod_folio(folio, NR_SHMEM,
+					      -folio_nr_pages(folio));
 		folio->mapping = NULL;
 		folio_clear_active(folio);
 		folio_clear_unevictable(folio);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


