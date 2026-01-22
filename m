Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54888322B7D
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 01:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769044787; cv=none; b=nep87le2IGBoF9hQq06pa5LgjOuM47S7QGVsfPTZg/YF8sbqGvaQ0iLeZ0cSkqI3mrEpoAwVb031BzjRbSkuhMtfucXioSOf0IpnIp3NrfSXQ8OM/WNB65OO1cHgWaLCZ/wn3cEXx0sJEcZCMNvOHZcVdQGTgnCgC2UAuuFWSRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769044787; c=relaxed/simple;
	bh=xn5FWlAVrtT/lEQeYSJcySGeeEE3lnMOcI+rqs/w1KI=;
	h=Date:To:From:Subject:Message-Id; b=ARYzl9EGoOjpBuS8T3YGnG5RayjWh4VK4zRmL+NGeUUDY6sagn3P3FiQQqjCfow4GYwbRsUL5QNvPypWcQWDWklU8Rl9hxBOFd4iBVHEP2pGGURIs4TYsnoTDjhCqip9Hm+v06enBYC4qG/qkL4SmlMo9Tx3Toh4hIjOicDn+rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rG4i8Jt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rG4i8Jt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A87C4CEF1;
	Thu, 22 Jan 2026 01:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769044786;
	bh=xn5FWlAVrtT/lEQeYSJcySGeeEE3lnMOcI+rqs/w1KI=;
	h=Date:To:From:Subject:From;
	b=rG4i8Jt91vP0N0mNyLYPxO6lM5S2P4eLAUsf5N47+JvoSIiOkPm+5hy6lQwDI15c1
	 efyDkIMjHoRDizBhXinCPL78b6KewgkkqRPdA6N9QHh39G2hye71PpArdBa9ZHH+fR
	 Oc9GyPWDuAJakfWnT86yjg4iZXwxXXGjJgqA73+w=
Date: Wed, 21 Jan 2026 17:19:46 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,catalin.marinas@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-rmap-support-batched-unmapping-for-file-large-folios-fix-2.patch removed from -mm tree
Message-Id: <20260122011946.C3A87C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix uffd-wp bit loss when batching file folio unmapping
has been removed from the -mm tree.  Its filename was
     mm-rmap-support-batched-unmapping-for-file-large-folios-fix-2.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm: fix uffd-wp bit loss when batching file folio unmapping
Date: Fri, 16 Jan 2026 13:57:21 +0530

The recently added file folio unmap batching support forgets to update
pte_install_uffd_wp_if_needed(), which still updates a single pte.  We end
up jumping to the end of the folio in page_vma_mapped_walk(), thus setting
the uffd-wp marker only on a single pte in the batch.  Fix this by passing
nr_pages into the function, and set the uffd-wp marker on all ptes.

Note that, since the nr_pages passed to this function is always derived by
some sort of batching, it is guaranteed that the set of old ptevals of the
batch have uffd-wp bit on all ptes or no ptes, therefore it is safe to
derive the value of the local variable "arm_uffd_pte" from only the
particular pteval passed to this function, but apply the result on all
ptes of the batch.

Use set_pte_at() in a loop to set the markers - we cannot use set_ptes()
as that will increment the PFN, but we don't have any PFN to update here.

The userspace visible effect of the bug is inaccuracy observed by
workloads relying on uffd-wp regions to install their own pages.

Link: https://lkml.kernel.org/r/20260116082721.275178-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    7 ++++---
 mm/memory.c               |   14 +-------------
 mm/rmap.c                 |    2 +-
 3 files changed, 6 insertions(+), 17 deletions(-)

--- a/include/linux/mm_inline.h~mm-rmap-support-batched-unmapping-for-file-large-folios-fix-2
+++ a/include/linux/mm_inline.h
@@ -568,7 +568,7 @@ static inline pte_marker copy_pte_marker
  */
 static inline bool
 pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
-			      pte_t *pte, pte_t pteval)
+			      pte_t *pte, pte_t pteval, unsigned int nr_pages)
 {
 	bool arm_uffd_pte = false;
 
@@ -599,8 +599,9 @@ pte_install_uffd_wp_if_needed(struct vm_
 		arm_uffd_pte = true;
 
 	if (unlikely(arm_uffd_pte)) {
-		set_pte_at(vma->vm_mm, addr, pte,
-			   make_pte_marker(PTE_MARKER_UFFD_WP));
+		for (int i = 0; i < nr_pages; ++i, ++pte, addr += PAGE_SIZE)
+			set_pte_at(vma->vm_mm, addr, pte,
+				make_pte_marker(PTE_MARKER_UFFD_WP));
 		return true;
 	}
 
--- a/mm/memory.c~mm-rmap-support-batched-unmapping-for-file-large-folios-fix-2
+++ a/mm/memory.c
@@ -1607,8 +1607,6 @@ zap_install_uffd_wp_if_needed(struct vm_
 			      unsigned long addr, pte_t *pte, int nr,
 			      struct zap_details *details, pte_t pteval)
 {
-	bool was_installed = false;
-
 	if (!uffd_supports_wp_marker())
 		return false;
 
@@ -1619,17 +1617,7 @@ zap_install_uffd_wp_if_needed(struct vm_
 	if (zap_drop_markers(details))
 		return false;
 
-	for (;;) {
-		/* the PFN in the PTE is irrelevant. */
-		if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
-			was_installed = true;
-		if (--nr == 0)
-			break;
-		pte++;
-		addr += PAGE_SIZE;
-	}
-
-	return was_installed;
+	return pte_install_uffd_wp_if_needed(vma, addr, pte, pteval, nr);
 }
 
 static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
--- a/mm/rmap.c~mm-rmap-support-batched-unmapping-for-file-large-folios-fix-2
+++ a/mm/rmap.c
@@ -2176,7 +2176,7 @@ static bool try_to_unmap_one(struct foli
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
+		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval, nr_pages);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
_

Patches currently in -mm which might be from dev.jain@arm.com are


