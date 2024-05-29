Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E93522A
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 19:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717010442; cv=none; b=Zsh9NzcEgE41WPwWfwUUYj83o6w6O4hicQtb1gNfwWNO8HEvUSvyfi4mQe0BHAgo39gLL3n8lawDnckV69eeGic0MD6jRKRvqyky/58OJM4xFd9vXb7bx4ZYglhNC6qFLD0m7gZSFq53oVe9n8e12AXh6koUUodpREE4AI1dznU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717010442; c=relaxed/simple;
	bh=up7TR/St03OnosAOGdDKAOKpSKPBX8HQj/z/X/GpO5g=;
	h=Date:To:From:Subject:Message-Id; b=WlVTKaVtlkYjN+lpRRRCTcPVUOOvMryL913wx18qlYXWR+DU/ArdsQt3twSkVNEY7kIHqJGddJKsksZhUdZQQioEThAdnOJ+/FSWyHivZz1F9DgxKTRtUk0IVOiG8EH3PiK4lAzw2KjeKi1kRzY3WMKRnxg4rvzqt3dR04LX35s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jNNssCPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jNNssCPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F44C113CC;
	Wed, 29 May 2024 19:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717010442;
	bh=up7TR/St03OnosAOGdDKAOKpSKPBX8HQj/z/X/GpO5g=;
	h=Date:To:From:Subject:From;
	b=jNNssCPvkATQU2aYiERrkkPEs7VAFv7hr5CFuwS1wenjBBC20NnInZXpOxkl5Zg7x
	 JGaXKSV+DvZvBqDZL1Q/wJkVKw7QFlqicFcmD67YBDqGcsm4hJuL0y36gsdYisy3qn
	 hhrgqNsbE31eDM/NYNnYP7hPhdYvjEeseeTDVbQM=
Date: Wed, 29 May 2024 12:20:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,rafael@kernel.org,pavel@ucw.cz,len.brown@intel.com,khalid.aziz@oracle.com,kasong@tencent.com,hughd@google.com,hch@infradead.org,hannes@cmpxchg.org,hanchuanhua@oppo.com,david@redhat.com,davem@davemloft.net,chrisl@kernel.org,baolin.wang@linux.alibaba.com,andreas@gaisler.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch added to mm-unstable branch
Message-Id: <20240529192041.E8F44C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce arch_do_swap_page_nr() which allows restore metadata for nr pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch

This patch will later appear in the mm-unstable branch at
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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: introduce arch_do_swap_page_nr() which allows restore metadata for nr pages
Date: Wed, 29 May 2024 20:28:22 +1200

Should do_swap_page() have the capability to directly map a large folio,
metadata restoration becomes necessary for a specified number of pages
denoted as nr.  It's important to highlight that metadata restoration is
solely required by the SPARC platform, which, however, does not enable
THP_SWAP.  Consequently, in the present kernel configuration, there exists
no practical scenario where users necessitate the restoration of nr
metadata.  Platforms implementing THP_SWAP might invoke this function with
nr values exceeding 1, subsequent to do_swap_page() successfully mapping
an entire large folio.  Nonetheless, their arch_do_swap_page_nr()
functions remain empty.

Link: https://lkml.kernel.org/r/20240529082824.150954-5-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   24 +++++++++++++++++++-----
 mm/memory.c             |    3 ++-
 2 files changed, 21 insertions(+), 6 deletions(-)

--- a/include/linux/pgtable.h~mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages
+++ a/include/linux/pgtable.h
@@ -1089,6 +1089,15 @@ static inline int pgd_same(pgd_t pgd_a,
 })
 
 #ifndef __HAVE_ARCH_DO_SWAP_PAGE
+static inline void arch_do_swap_page_nr(struct mm_struct *mm,
+				     struct vm_area_struct *vma,
+				     unsigned long addr,
+				     pte_t pte, pte_t oldpte,
+				     int nr)
+{
+
+}
+#else
 /*
  * Some architectures support metadata associated with a page. When a
  * page is being swapped out, this metadata must be saved so it can be
@@ -1097,12 +1106,17 @@ static inline int pgd_same(pgd_t pgd_a,
  * page as metadata for the page. arch_do_swap_page() can restore this
  * metadata when a page is swapped back in.
  */
-static inline void arch_do_swap_page(struct mm_struct *mm,
-				     struct vm_area_struct *vma,
-				     unsigned long addr,
-				     pte_t pte, pte_t oldpte)
+static inline void arch_do_swap_page_nr(struct mm_struct *mm,
+					struct vm_area_struct *vma,
+					unsigned long addr,
+					pte_t pte, pte_t oldpte,
+					int nr)
 {
-
+	for (int i = 0; i < nr; i++) {
+		arch_do_swap_page(vma->vm_mm, vma, addr + i * PAGE_SIZE,
+				pte_advance_pfn(pte, i),
+				pte_advance_pfn(oldpte, i));
+	}
 }
 #endif
 
--- a/mm/memory.c~mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages
+++ a/mm/memory.c
@@ -4314,7 +4314,8 @@ vm_fault_t do_swap_page(struct vm_fault
 	VM_BUG_ON(!folio_test_anon(folio) ||
 			(pte_write(pte) && !PageAnonExclusive(page)));
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
-	arch_do_swap_page(vma->vm_mm, vma, vmf->address, pte, vmf->orig_pte);
+	arch_do_swap_page_nr(vma->vm_mm, vma, vmf->address,
+			pte, vmf->orig_pte, 1);
 
 	folio_unlock(folio);
 	if (folio != swapcache && swapcache) {
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-huge_mm-fix-undefined-reference-to-mthp_stats-for-config_sysfs=n.patch
mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes.patch
mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch
mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch
mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch

