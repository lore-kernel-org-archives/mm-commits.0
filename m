Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC2D2F691D
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025820; cv=none; b=ms8nu72b8lGQpYolPOmLgHGH02K8YDdCBCk8qV40uMw5cBH8rVw/Zkna7VK8PTdPo6J+bcFdA9bwPxd3hVZN4WkCE9A3bq8b9aaZWARXhY7yQW3QBvoZCBUmR3sP0t6yc4Q4RviNmum7VQKad4cl704iUzmfbZnu1iQgTW6ni4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025820; c=relaxed/simple;
	bh=j/+1vCjDvnfGGyRMqaRLXe97A+kP9qC5El02brDdPxI=;
	h=Date:To:From:Subject:Message-Id; b=N+f44D1sZ9nLvsexvH+fGRqIAk3ohpWd5DtYAnVAtLynDRYL9d0iuvDQpum8e1bzupBFrlFxIrLB9kq6kUsu39uKyMkKNY1dI2G723nkiZWC4XC+4K560KuNilmhgtfcxafBVsoxsn7xd+llk0hJsJDwKZpfnY1zSOcRvkmvBmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I1EgTqs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I1EgTqs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E04AC4CEF1;
	Mon, 24 Nov 2025 23:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025820;
	bh=j/+1vCjDvnfGGyRMqaRLXe97A+kP9qC5El02brDdPxI=;
	h=Date:To:From:Subject:From;
	b=I1EgTqs/y18K1omFHM7hFwy6BzfOWk+8+hH7NtWoU3nGLCVuI3ms0VGJXrHiEnXuF
	 d8YQAqQiCHSGFDyjJfLJmHDND7s9XvbEV7ZXl0NMhagGy/yvlIJsARNCKGF5O1H5nN
	 6xugt3hTHPlTyqXt2M+1i4uPWr1Ml/Vrr3/cUDD0=
Date: Mon, 24 Nov 2025 15:10:19 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,willy@infradead.org,weixugc@google.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,svens@linux.ibm.com,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,peterx@redhat.com,pasha.tatashin@soleen.com,osalvador@suse.de,nphamcs@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@suse.com,matthew.brost@intel.com,linmiaohe@huawei.com,liam.howlett@oracle.com,leon@kernel.org,lance.yang@linux.dev,kasong@tencent.com,joshua.hahnjy@gmail.com,jgg@ziepe.ca,jannh@google.com,jack@suse.cz,imbrenda@linux.ibm.com,hughd@google.com,hca@linux.ibm.com,gourry@gourry.net,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,dev.jain@arm.com,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,brauner@kernel.org,borntraeger@linux.ibm.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,arnd@arndb.de,apopple@nvidia.com,agordeev@linux.ibm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-avoid-unnecessary-use-of-is_swap_pmd.patch removed from -mm tree
Message-Id: <20251124231020.6E04AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: avoid unnecessary use of is_swap_pmd()
has been removed from the -mm tree.  Its filename was
     mm-avoid-unnecessary-use-of-is_swap_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: avoid unnecessary use of is_swap_pmd()
Date: Mon, 10 Nov 2025 22:21:25 +0000

PMD 'non-swap' swap entries are currently used for PMD-level migration
entries and device private entries.

To add to the confusion in this terminology we use is_swap_pmd() in an
inconsistent way similar to how is_swap_pte() was being used - sometimes
adopting the convention that !pmd_none(), !pmd_present() implies PMD 'swap'
entry, sometimes not.

This patch handles the low-hanging fruit of cases where we can simply
substitute other predicates for is_swap_pmd().

No functional change intended.

Link: https://lkml.kernel.org/r/8a1704b36a009c18032d5bea4cb68e71448fbbe5.1762812360.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |   15 +++++++++--
 include/linux/swapops.h |   16 ++++++++++--
 mm/huge_memory.c        |    4 ++-
 mm/memory.c             |   50 +++++++++++++++++++++-----------------
 mm/page_table_check.c   |   12 ++++++---
 5 files changed, 65 insertions(+), 32 deletions(-)

--- a/fs/proc/task_mmu.c~mm-avoid-unnecessary-use-of-is_swap_pmd
+++ a/fs/proc/task_mmu.c
@@ -1059,10 +1059,12 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	bool present = false;
 	struct folio *folio;
 
+	if (pmd_none(*pmd))
+		return;
 	if (pmd_present(*pmd)) {
 		page = vm_normal_page_pmd(vma, addr, *pmd);
 		present = true;
-	} else if (unlikely(thp_migration_supported() && is_swap_pmd(*pmd))) {
+	} else if (unlikely(thp_migration_supported())) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 
 		if (is_pfn_swap_entry(entry))
@@ -2000,6 +2002,9 @@ static int pagemap_pmd_range_thp(pmd_t *
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
 
+	if (pmd_none(pmd))
+		goto populate_pagemap;
+
 	if (pmd_present(pmd)) {
 		page = pmd_page(pmd);
 
@@ -2010,7 +2015,7 @@ static int pagemap_pmd_range_thp(pmd_t *
 			flags |= PM_UFFD_WP;
 		if (pm->show_pfn)
 			frame = pmd_pfn(pmd) + idx;
-	} else if (thp_migration_supported() && is_swap_pmd(pmd)) {
+	} else if (thp_migration_supported()) {
 		swp_entry_t entry = pmd_to_swp_entry(pmd);
 		unsigned long offset;
 
@@ -2037,6 +2042,7 @@ static int pagemap_pmd_range_thp(pmd_t *
 			flags |= PM_FILE;
 	}
 
+populate_pagemap:
 	for (; addr != end; addr += PAGE_SIZE, idx++) {
 		u64 cur_flags = flags;
 		pagemap_entry_t pme;
@@ -2399,6 +2405,9 @@ static unsigned long pagemap_thp_categor
 {
 	unsigned long categories = PAGE_IS_HUGE;
 
+	if (pmd_none(pmd))
+		return categories;
+
 	if (pmd_present(pmd)) {
 		struct page *page;
 
@@ -2416,7 +2425,7 @@ static unsigned long pagemap_thp_categor
 			categories |= PAGE_IS_PFNZERO;
 		if (pmd_soft_dirty(pmd))
 			categories |= PAGE_IS_SOFT_DIRTY;
-	} else if (is_swap_pmd(pmd)) {
+	} else {
 		swp_entry_t swp;
 
 		categories |= PAGE_IS_SWAPPED;
--- a/include/linux/swapops.h~mm-avoid-unnecessary-use-of-is_swap_pmd
+++ a/include/linux/swapops.h
@@ -509,7 +509,13 @@ static inline pmd_t swp_entry_to_pmd(swp
 
 static inline int is_pmd_migration_entry(pmd_t pmd)
 {
-	return is_swap_pmd(pmd) && is_migration_entry(pmd_to_swp_entry(pmd));
+	swp_entry_t entry;
+
+	if (pmd_present(pmd))
+		return 0;
+
+	entry = pmd_to_swp_entry(pmd);
+	return is_migration_entry(entry);
 }
 #else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
@@ -557,7 +563,13 @@ static inline int is_pmd_migration_entry
  */
 static inline int is_pmd_device_private_entry(pmd_t pmd)
 {
-	return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
+	swp_entry_t entry;
+
+	if (pmd_present(pmd))
+		return 0;
+
+	entry = pmd_to_swp_entry(pmd);
+	return is_device_private_entry(entry);
 }
 
 #else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
--- a/mm/huge_memory.c~mm-avoid-unnecessary-use-of-is_swap_pmd
+++ a/mm/huge_memory.c
@@ -2354,9 +2354,11 @@ static pmd_t move_soft_dirty_pmd(pmd_t p
 
 static pmd_t clear_uffd_wp_pmd(pmd_t pmd)
 {
+	if (pmd_none(pmd))
+		return pmd;
 	if (pmd_present(pmd))
 		pmd = pmd_clear_uffd_wp(pmd);
-	else if (is_swap_pmd(pmd))
+	else
 		pmd = pmd_swp_clear_uffd_wp(pmd);
 
 	return pmd;
--- a/mm/memory.c~mm-avoid-unnecessary-use-of-is_swap_pmd
+++ a/mm/memory.c
@@ -1376,6 +1376,7 @@ copy_pmd_range(struct vm_area_struct *ds
 		next = pmd_addr_end(addr, end);
 		if (is_swap_pmd(*src_pmd) || pmd_trans_huge(*src_pmd)) {
 			int err;
+
 			VM_BUG_ON_VMA(next-addr != HPAGE_PMD_SIZE, src_vma);
 			err = copy_huge_pmd(dst_mm, src_mm, dst_pmd, src_pmd,
 					    addr, dst_vma, src_vma);
@@ -6340,35 +6341,40 @@ retry_pud:
 	if (pmd_none(*vmf.pmd) &&
 	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
 		ret = create_huge_pmd(&vmf);
-		if (!(ret & VM_FAULT_FALLBACK))
+		if (ret & VM_FAULT_FALLBACK)
+			goto fallback;
+		else
 			return ret;
-	} else {
-		vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
+	}
 
-		if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
-			if (is_pmd_device_private_entry(vmf.orig_pmd))
-				return do_huge_pmd_device_private(&vmf);
+	vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
+	if (pmd_none(vmf.orig_pmd))
+		goto fallback;
+
+	if (unlikely(!pmd_present(vmf.orig_pmd))) {
+		if (is_pmd_device_private_entry(vmf.orig_pmd))
+			return do_huge_pmd_device_private(&vmf);
 
-			if (is_pmd_migration_entry(vmf.orig_pmd))
-				pmd_migration_entry_wait(mm, vmf.pmd);
+		if (is_pmd_migration_entry(vmf.orig_pmd))
+			pmd_migration_entry_wait(mm, vmf.pmd);
+		return 0;
+	}
+	if (pmd_trans_huge(vmf.orig_pmd)) {
+		if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma))
+			return do_huge_pmd_numa_page(&vmf);
+
+		if ((flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) &&
+		    !pmd_write(vmf.orig_pmd)) {
+			ret = wp_huge_pmd(&vmf);
+			if (!(ret & VM_FAULT_FALLBACK))
+				return ret;
+		} else {
+			huge_pmd_set_accessed(&vmf);
 			return 0;
 		}
-		if (pmd_trans_huge(vmf.orig_pmd)) {
-			if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma))
-				return do_huge_pmd_numa_page(&vmf);
-
-			if ((flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) &&
-			    !pmd_write(vmf.orig_pmd)) {
-				ret = wp_huge_pmd(&vmf);
-				if (!(ret & VM_FAULT_FALLBACK))
-					return ret;
-			} else {
-				huge_pmd_set_accessed(&vmf);
-				return 0;
-			}
-		}
 	}
 
+fallback:
 	return handle_pte_fault(&vmf);
 }
 
--- a/mm/page_table_check.c~mm-avoid-unnecessary-use-of-is_swap_pmd
+++ a/mm/page_table_check.c
@@ -215,10 +215,14 @@ EXPORT_SYMBOL(__page_table_check_ptes_se
 
 static inline void page_table_check_pmd_flags(pmd_t pmd)
 {
-	if (pmd_present(pmd) && pmd_uffd_wp(pmd))
-		WARN_ON_ONCE(pmd_write(pmd));
-	else if (is_swap_pmd(pmd) && pmd_swp_uffd_wp(pmd))
-		WARN_ON_ONCE(swap_cached_writable(pmd_to_swp_entry(pmd)));
+	if (pmd_present(pmd)) {
+		if (pmd_uffd_wp(pmd))
+			WARN_ON_ONCE(pmd_write(pmd));
+	} else if (pmd_swp_uffd_wp(pmd)) {
+		swp_entry_t entry = pmd_to_swp_entry(pmd);
+
+		WARN_ON_ONCE(swap_cached_writable(entry));
+	}
 }
 
 void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


