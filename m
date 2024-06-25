Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4190E143759
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291612; cv=none; b=u+jyLF5irwUJKq/Vl6N0/N4IQ/EqbI0kzonrvVPybXUvQn/yirCEBnxvgOCsC+7cEEqBnHiclmaY28CIABrOk/Doo6441TeWseE2guqtNAJyhvIPdOKJGaOY9sYU/WHUBKHeaV0UpPUulDDxKjrQ5Xw2EgOKWxCWa9+/9zE3Tv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291612; c=relaxed/simple;
	bh=OPi5qhj3mhSqcagJDJrEOXdBiupcM7wbTzSZaPh2hfw=;
	h=Date:To:From:Subject:Message-Id; b=XWo4W4Zqt59sfmbfoIjatciyOlhORQWFFBO9gsrnoLLTAs+yS40cGz4CmBN6yQPqSEySqbrWc1imxmTQfafCtwCdRKbx+1LI13sEjvxu/ef95Ytg0KiBMGnTADN8UcwgYHq+buFwMHP3DmCZGCxCHZi/v6uXYDMwRb4JkhXiH7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HBF9fTtp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HBF9fTtp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8364C32782;
	Tue, 25 Jun 2024 05:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291611;
	bh=OPi5qhj3mhSqcagJDJrEOXdBiupcM7wbTzSZaPh2hfw=;
	h=Date:To:From:Subject:From;
	b=HBF9fTtp3yZ0fzJn49WYNnB95FFA8ipiVd04Inod7gSasUzcsW6m/pVvxh5hIHn1d
	 e4S+7AXzeA+vz/H+OEiGYqfNgeerxsNj7lRcT2USxcJ3v6EyOZeDm5LAt6wqFfaPX7
	 7yET2bSrRSvO6jiQmpeEXdG7owcIM5b77kH9FwdQ=
Date: Mon, 24 Jun 2024 22:00:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,rafael@kernel.org,pavel@ucw.cz,len.brown@intel.com,khalid.aziz@oracle.com,kasong@tencent.com,hughd@google.com,hch@infradead.org,hannes@cmpxchg.org,hanchuanhua@oppo.com,david@redhat.com,davem@davemloft.net,chrisl@kernel.org,baolin.wang@linux.alibaba.com,andreas@gaisler.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch removed from -mm tree
Message-Id: <20240625050011.B8364C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce arch_do_swap_page_nr() which allows restore metadata for nr pages
has been removed from the -mm tree.  Its filename was
     mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4308,7 +4308,8 @@ vm_fault_t do_swap_page(struct vm_fault
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

mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-3.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2.patch
mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch

