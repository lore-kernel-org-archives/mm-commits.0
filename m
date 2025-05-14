Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9293028EC
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 02:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747190005; cv=none; b=fH0PMVJtKJqOpsr7SPuldRkDwTIXho2fWPRK+Wouk9EFiS4zUfiD4h7G+p1J6m9t6oIyiBwJZfLkE+kh0eibWFK+H0tWgyyGcc0jL9NR3pmsRp141LstYzLuViqRF2I9h6pZzc4qCfb0tIoFyHydG+0sGP+HjO+d2hCINpSoKZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747190005; c=relaxed/simple;
	bh=SUbelSYJbUwYCrDdNc3ClxYazllEuXBl2cryLGwMTQs=;
	h=Date:To:From:Subject:Message-Id; b=Gw02S+VZ/6BT9O0JvcPq4kf94IySYnN9z1SG4finwl/R3JV2gRlhsNyNl1Vwm/HiOjCGggw7OoG91E65c/c6cpJUczWIqF7WxPYraVVnAFrb0WJufwqxUbWMaAR71M/ahG1cL5VylWwW1fRiWnrxGQSFWQU5aj5KjATvTehElVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CxtkDPkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CxtkDPkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D436DC4CEE4;
	Wed, 14 May 2025 02:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747190004;
	bh=SUbelSYJbUwYCrDdNc3ClxYazllEuXBl2cryLGwMTQs=;
	h=Date:To:From:Subject:From;
	b=CxtkDPkFJuEaStl6WI85Pup1GW2/wwoWUwlYwuhYQB6WCK9XNOXiRBuK9FHGlySV5
	 IZMcXajKcAkkXzO/QzK9ID/6xUH0jwBvzJnybvuknFta/kY3xNnpK4vrm/obVRD+Q1
	 hUL7ak2iU+nBWFlDos1G6idR+OP2VA7hXUzyTVsQ=
Date: Tue, 13 May 2025 19:33:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-decouple-shmem-and-file-folios-collapse.patch added to mm-new branch
Message-Id: <20250514023324.D436DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: decouple SHMEM and file folios' collapse
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-decouple-shmem-and-file-folios-collapse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-decouple-shmem-and-file-folios-collapse.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm: khugepaged: decouple SHMEM and file folios' collapse
Date: Tue, 13 May 2025 14:56:35 +0800

Originally, the file pages collapse was intended for tmpfs/shmem to merge
into THP in the background.  However, now not only tmpfs/shmem can support
large folios, but some other file systems (such as XFS, erofs ...) also
support large folios.  Therefore, it is time to decouple the support of
file folios collapse from SHMEM.

Link: https://lkml.kernel.org/r/ce5c2314e0368cf34bda26f9bacf01c982d4da17.1747119309.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/khugepaged.h |    8 --------
 mm/Kconfig                 |    2 +-
 mm/khugepaged.c            |   13 ++-----------
 3 files changed, 3 insertions(+), 20 deletions(-)

--- a/include/linux/khugepaged.h~mm-khugepaged-decouple-shmem-and-file-folios-collapse
+++ a/include/linux/khugepaged.h
@@ -15,16 +15,8 @@ extern void khugepaged_enter_vma(struct
 				 unsigned long vm_flags);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
-#ifdef CONFIG_SHMEM
 extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 				   bool install_pmd);
-#else
-static inline int collapse_pte_mapped_thp(struct mm_struct *mm,
-					  unsigned long addr, bool install_pmd)
-{
-	return 0;
-}
-#endif
 
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
--- a/mm/Kconfig~mm-khugepaged-decouple-shmem-and-file-folios-collapse
+++ a/mm/Kconfig
@@ -898,7 +898,7 @@ config THP_SWAP
 
 config READ_ONLY_THP_FOR_FS
 	bool "Read-only THP for filesystems (EXPERIMENTAL)"
-	depends on TRANSPARENT_HUGEPAGE && SHMEM
+	depends on TRANSPARENT_HUGEPAGE
 
 	help
 	  Allow khugepaged to put read-only file-backed pages in THP.
--- a/mm/khugepaged.c~mm-khugepaged-decouple-shmem-and-file-folios-collapse
+++ a/mm/khugepaged.c
@@ -1464,7 +1464,6 @@ static void collect_mm_slot(struct khuge
 	}
 }
 
-#ifdef CONFIG_SHMEM
 /* folio must be locked, and mmap_lock must be held */
 static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
 			pmd_t *pmdp, struct folio *folio, struct page *page)
@@ -2353,14 +2352,6 @@ static int hpage_collapse_scan_file(stru
 	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
 	return result;
 }
-#else
-static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
-				    struct file *file, pgoff_t start,
-				    struct collapse_control *cc)
-{
-	BUILD_BUG();
-}
-#endif
 
 static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 					    struct collapse_control *cc)
@@ -2436,7 +2427,7 @@ skip:
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
-			if (IS_ENABLED(CONFIG_SHMEM) && !vma_is_anonymous(vma)) {
+			if (!vma_is_anonymous(vma)) {
 				struct file *file = get_file(vma->vm_file);
 				pgoff_t pgoff = linear_page_index(vma,
 						khugepaged_scan.address);
@@ -2782,7 +2773,7 @@ int madvise_collapse(struct vm_area_stru
 		mmap_assert_locked(mm);
 		memset(cc->node_load, 0, sizeof(cc->node_load));
 		nodes_clear(cc->alloc_nmask);
-		if (IS_ENABLED(CONFIG_SHMEM) && !vma_is_anonymous(vma)) {
+		if (!vma_is_anonymous(vma)) {
 			struct file *file = get_file(vma->vm_file);
 			pgoff_t pgoff = linear_page_index(vma, addr);
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-mincore-use-pte_batch_bint-to-batch-process-large-folios.patch
mm-khugepaged-convert-set_huge_pmd-to-take-a-folio.patch
mm-convert-do_set_pmd-to-take-a-folio.patch
mm-khugepaged-decouple-shmem-and-file-folios-collapse.patch

