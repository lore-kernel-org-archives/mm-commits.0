Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6444F3242BD
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465711; cv=none; b=XiDpwHq9fdXIC+d1oTBszkVURDgbtmdGxzzbDrzS/dn2wn5p+oWh5Xmwo74kpo5zg9xI9hrtRozeGRaLhiUMl3exbsXYbtI1SzLr4elnJe3UKS+iggNJPo69OknnQZymMZ+eTX5cG/mIu+uwZk0vWqbRZAvw2AMXuor2fh8K5AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465711; c=relaxed/simple;
	bh=EDhG8e11GSx/MflzSlcZjuWm8hcI+PizVvANQRMTLlk=;
	h=Date:To:From:Subject:Message-Id; b=IVtwUTPQ27yXFDtVr9UviI7d6wyXLgNrZf8Y4qhq4gIhvBwRajQ3HHISyhIisdEJjXzhTTdnVV1+J74BAKNyR0D5ulKq8PZgoZKdmWBu6gnqFAQqx6PhCs1MlQ4nb2AZKpo6PNg5F8MRMfb0Ok/2dvt/pLQ06MJLTVRAp/ydUso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H86WCjuh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H86WCjuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029111F000E9;
	Fri, 31 Jul 2026 02:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465710;
	bh=gq99wTj+ZZCdzty5rmr6QIq68sVYRmgHTHzwjTs3LIY=;
	h=Date:To:From:Subject;
	b=H86WCjuhjaBi7CIVmvLGcYFnmcHKkDzhybIh0ROUlYFfLlBSm7orV5+HiPzTB8vr+
	 dIKcSoICr763jsEGTZ3RQ0zZZOsqCmTke0yeNnzQ1dKYyTKwogEjoVsh1v3FPMfyCd
	 lbjXV19Koo8D0Ljhwrx0MnLSaxM84IdIgEvLdpJw=
Date: Thu, 30 Jul 2026 19:41:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,willy@infradead.org,vbabka@kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,riel@surriel.com,nphamcs@gmail.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,alex@ghiti.fr,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-extract-mm_prepare_for_swap_entries-helper.patch removed from -mm tree
Message-Id: <20260731024150.029111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: extract mm_prepare_for_swap_entries() helper
has been removed from the -mm tree.  Its filename was
     mm-extract-mm_prepare_for_swap_entries-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: extract mm_prepare_for_swap_entries() helper
Date: Mon, 6 Jul 2026 04:42:04 -0700

When a swap entry is installed in a page table, the mm must be added to
init_mm.mmlist so that swapoff can find and unuse its swap entries.  This
double-checked locking pattern is currently open-coded in
try_to_unmap_one() and copy_nonpresent_pte().

Move it into mm_prepare_for_swap_entries() in mm/internal.h and convert
both callers so it can be reused by upcoming PMD-level swap entry code
paths that also need to register the mm with swapoff.

copy_nonpresent_pte() previously inserted into &src_mm->mmlist rather than
&init_mm.mmlist, but the insertion point is irrelevant, mmlist is a
circular list and swapoff walks it entirely from init_mm.mmlist, so only
membership matters, not position.

Link: https://lore.kernel.org/20260706114320.1643046-3-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   10 ++++++++++
 mm/memory.c   |    9 +--------
 mm/rmap.c     |    7 +------
 3 files changed, 12 insertions(+), 14 deletions(-)

--- a/mm/internal.h~mm-extract-mm_prepare_for_swap_entries-helper
+++ a/mm/internal.h
@@ -1955,4 +1955,14 @@ static inline int get_sysctl_max_map_cou
 bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
 		   unsigned long npages);
 
+static inline void mm_prepare_for_swap_entries(struct mm_struct *mm)
+{
+	if (list_empty(&mm->mmlist)) {
+		spin_lock(&mmlist_lock);
+		if (list_empty(&mm->mmlist))
+			list_add(&mm->mmlist, &init_mm.mmlist);
+		spin_unlock(&mmlist_lock);
+	}
+}
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/memory.c~mm-extract-mm_prepare_for_swap_entries-helper
+++ a/mm/memory.c
@@ -953,14 +953,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 		if (swap_dup_entry_direct(entry) < 0)
 			return -EIO;
 
-		/* make sure dst_mm is on swapoff's mmlist. */
-		if (unlikely(list_empty(&dst_mm->mmlist))) {
-			spin_lock(&mmlist_lock);
-			if (list_empty(&dst_mm->mmlist))
-				list_add(&dst_mm->mmlist,
-						&src_mm->mmlist);
-			spin_unlock(&mmlist_lock);
-		}
+		mm_prepare_for_swap_entries(dst_mm);
 		/* Mark the swap entry as shared. */
 		if (pte_swp_exclusive(orig_pte)) {
 			pte = pte_swp_clear_exclusive(orig_pte);
--- a/mm/rmap.c~mm-extract-mm_prepare_for_swap_entries-helper
+++ a/mm/rmap.c
@@ -2304,12 +2304,7 @@ static bool try_to_unmap_one(struct foli
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
-			if (list_empty(&mm->mmlist)) {
-				spin_lock(&mmlist_lock);
-				if (list_empty(&mm->mmlist))
-					list_add(&mm->mmlist, &init_mm.mmlist);
-				spin_unlock(&mmlist_lock);
-			}
+			mm_prepare_for_swap_entries(mm);
 			dec_mm_counter(mm, MM_ANONPAGES);
 			inc_mm_counter(mm, MM_SWAPENTS);
 			swp_pte = swp_entry_to_pte(entry);
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-mempolicy-skip-non-present-pmds-when-queueing-folios.patch
mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch
mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch
mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch
mm-vmscan-reduce-lru_lock-contention-via-vmstat-derived-scan-balance-cost.patch

