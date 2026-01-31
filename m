Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC6C239E79
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 21:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769893923; cv=none; b=UI3lNxQLA+O3CBDAWpGk9B2NkkhlVzq3ezf9+fOP0I8clcc8L41thVKBPqA469E4tyB8jLmkt1GJSAG5IHBc0GbqBKWhPT+So8Z/Jaw363QajKI5hp+LX8DLA9tofVHz4PWjpuouMNZ256QWB8KPYDE74HW1S2w1iReP1b+jaZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769893923; c=relaxed/simple;
	bh=3L0bs5aALnWuI4saIBiNcghz39gGeejTnHTfzVPf/eU=;
	h=Date:To:From:Subject:Message-Id; b=ClmCNpjky7j45fdeR9MxNz0uph/DyJCO71H+QcMZ1yJH8x7JSpHaC/32sLjoJrTfvIOIgFtZSk3T0LrLW6g+D3X28GZcf4u4VrXSSsJMU2jOVBrTDoR2fGU99npq/gNW/pkLx4x4+ojMofKMDjlS/3AsLHoD9QlrMS6vfrx5HUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EjP0XkSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EjP0XkSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C23DC4CEF1;
	Sat, 31 Jan 2026 21:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769893923;
	bh=3L0bs5aALnWuI4saIBiNcghz39gGeejTnHTfzVPf/eU=;
	h=Date:To:From:Subject:From;
	b=EjP0XkSzVirIVMgvfrbkdZ1uNWnHhHBjEi4DMZxf+u/Elz+UkgqVGN8QfnXAIMQCA
	 dZEr8V4mC+umMco34vqDK63Ze8sWtZYc0RhOMZiMTYFpsJa/Bj2KBujiL2V3lnZjGC
	 Uj0TjiApdQYImneKQMwavaVXJAXp7kzm7QvbEySs=
Date: Sat, 31 Jan 2026 13:12:02 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,usamaarif642@gmail.com,songliubraving@fb.com,ryan.roberts@arm.com,riel@surriel.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,kas@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-nr_file_pages-and-nr_shmem-in-collapse_file.patch added to mm-hotfixes-unstable branch
Message-Id: <20260131211203.5C23DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in collapse_file()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-fix-nr_file_pages-and-nr_shmem-in-collapse_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-nr_file_pages-and-nr_shmem-in-collapse_file.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: David Hildenbrand <david@kernel.org>
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
@@ -2194,16 +2194,13 @@ immap_locked:
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
@@ -2237,6 +2234,11 @@ immap_locked:
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

mm-khugepaged-fix-nr_file_pages-and-nr_shmem-in-collapse_file.patch

