Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A74335546
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025826; cv=none; b=u5nUAvmOZ+Go2oaBxuXKcqIjlmM3chc970/Bn/2M1QaNm/he9/B20R/XrkzjR2gUIAC0NdtZ4WAIsddgCI0t7oqhnxoMIzrS9rrkVhwl3cNXbbhOJ/iYeb/LGX0v0kCyglC2FdI2pVLmvfPiSt8ylYVQIFQWYPnFQszHWWXSQOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025826; c=relaxed/simple;
	bh=BZj143/y9OldPVoPOh4+tJQUM8b8+BRw3vSlm9voeXM=;
	h=Date:To:From:Subject:Message-Id; b=q7vEFq4nMF9W7gN2OAdtBUqVndf+P0psENjEpVyyB8G+MAz5itGWT18e8AHbyHL7BsezGSzuRWKC37tFO+hGkv+mE9GQPW/GPlYxujHcbI051kUmVZoT/1OMZa4Gc0mbcrPGAtmBcsQM2NGnJ+ETLdcQ7fVnA3BQ88nGO3uDjbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NerDSwOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NerDSwOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA4FC4CEF1;
	Mon, 24 Nov 2025 23:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025826;
	bh=BZj143/y9OldPVoPOh4+tJQUM8b8+BRw3vSlm9voeXM=;
	h=Date:To:From:Subject:From;
	b=NerDSwOYXbQ6ebzaX30jJkGJxlSYNOM5yqJACSTnOlKn31yLb1F9QULt/d7rzM8lR
	 iQAeZh5n1KLb5jIuPRgCf13CQmTKJTyWClA3ZyqrPPqUQzuey4TiCZP0TtVlTi3wbT
	 1Ykg2x6/08yFlmjRaisADkBvSECkpxN3/G9RxU2c=
Date: Mon, 24 Nov 2025 15:10:25 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,willy@infradead.org,weixugc@google.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,svens@linux.ibm.com,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,peterx@redhat.com,pasha.tatashin@soleen.com,osalvador@suse.de,nphamcs@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@suse.com,matthew.brost@intel.com,linmiaohe@huawei.com,liam.howlett@oracle.com,leon@kernel.org,lance.yang@linux.dev,kasong@tencent.com,joshua.hahnjy@gmail.com,jgg@ziepe.ca,jannh@google.com,jack@suse.cz,imbrenda@linux.ibm.com,hughd@google.com,hca@linux.ibm.com,gourry@gourry.net,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,dev.jain@arm.com,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,brauner@kernel.org,borntraeger@linux.ibm.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,arnd@arndb.de,apopple@nvidia.com,agordeev@linux.ibm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-pmd_is_huge-and-use-where-appropriate.patch removed from -mm tree
Message-Id: <20251124231026.7CA4FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce pmd_is_huge() and use where appropriate
has been removed from the -mm tree.  Its filename was
     mm-introduce-pmd_is_huge-and-use-where-appropriate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: introduce pmd_is_huge() and use where appropriate
Date: Mon, 10 Nov 2025 22:21:29 +0000

The leaf entry PMD case is confusing as only migration entries and device
private entries are valid at PMD level, not true swap entries.

We repeatedly perform checks of the form is_swap_pmd() || pmd_trans_huge()
which is itself confusing - it implies that leaf entries at PMD level
exist and are different from huge entries.

Address this confusion by introduced pmd_is_huge() which checks for either
case.  Sadly due to header dependency issues (huge_mm.h is included very
early on in headers and cannot really rely on much else) we cannot use
pmd_is_valid_softleaf() here.

However since these are the only valid, handled cases the function is
still achieving what it intends to do.

We then replace all instances of is_swap_pmd() || pmd_trans_huge() with
pmd_is_huge() invocations and adjust logic accordingly to accommodate
this.

No functional change intended.

Link: https://lkml.kernel.org/r/00f79db3b15293cac8f7040a48d69c52d00117e4.1762812360.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

 include/linux/huge_mm.h |   39 ++++++++++++++++++++++++++++++++++----
 include/linux/swapops.h |    6 +++++
 mm/huge_memory.c        |    3 +-
 mm/memory.c             |    4 +--
 mm/mprotect.c           |    2 -
 mm/mremap.c             |    2 -
 6 files changed, 47 insertions(+), 9 deletions(-)

--- a/include/linux/huge_mm.h~mm-introduce-pmd_is_huge-and-use-where-appropriate
+++ a/include/linux/huge_mm.h
@@ -419,10 +419,36 @@ void deferred_split_folio(struct folio *
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
 
+/**
+ * pmd_is_huge() - Is this PMD either a huge PMD entry or a software leaf entry?
+ * @pmd: The PMD to check.
+ *
+ * A huge PMD entry is a non-empty entry which is present and marked huge or a
+ * software leaf entry. This check be performed without the appropriate locks
+ * held, in which case the condition should be rechecked after they are
+ * acquired.
+ *
+ * Returns: true if this PMD is huge, false otherwise.
+ */
+static inline bool pmd_is_huge(pmd_t pmd)
+{
+	if (pmd_present(pmd)) {
+		return pmd_trans_huge(pmd);
+	} else if (!pmd_none(pmd)) {
+		/*
+		 * Non-present PMDs must be valid huge non-present entries. We
+		 * cannot assert that here due to header dependency issues.
+		 */
+		return true;
+	}
+
+	return false;
+}
+
 #define split_huge_pmd(__vma, __pmd, __address)				\
 	do {								\
 		pmd_t *____pmd = (__pmd);				\
-		if (is_swap_pmd(*____pmd) || pmd_trans_huge(*____pmd))	\
+		if (pmd_is_huge(*____pmd))				\
 			__split_huge_pmd(__vma, __pmd, __address,	\
 					 false);			\
 	}  while (0)
@@ -469,10 +495,10 @@ static inline int is_swap_pmd(pmd_t pmd)
 static inline spinlock_t *pmd_trans_huge_lock(pmd_t *pmd,
 		struct vm_area_struct *vma)
 {
-	if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd))
+	if (pmd_is_huge(*pmd))
 		return __pmd_trans_huge_lock(pmd, vma);
-	else
-		return NULL;
+
+	return NULL;
 }
 static inline spinlock_t *pud_trans_huge_lock(pud_t *pud,
 		struct vm_area_struct *vma)
@@ -743,6 +769,11 @@ static inline struct folio *get_persiste
 {
 	return NULL;
 }
+
+static inline bool pmd_is_huge(pmd_t pmd)
+{
+	return false;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline int split_folio_to_list_to_order(struct folio *folio,
--- a/include/linux/swapops.h~mm-introduce-pmd_is_huge-and-use-where-appropriate
+++ a/include/linux/swapops.h
@@ -471,6 +471,12 @@ static inline pmd_t swp_entry_to_pmd(swp
 }
 
 #else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
+		struct page *page)
+{
+	BUILD_BUG();
+}
+
 static inline void remove_migration_pmd(struct page_vma_mapped_walk *pvmw,
 		struct page *new)
 {
--- a/mm/huge_memory.c~mm-introduce-pmd_is_huge-and-use-where-appropriate
+++ a/mm/huge_memory.c
@@ -2735,8 +2735,9 @@ unlock_ptls:
 spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma)
 {
 	spinlock_t *ptl;
+
 	ptl = pmd_lock(vma->vm_mm, pmd);
-	if (likely(is_swap_pmd(*pmd) || pmd_trans_huge(*pmd)))
+	if (likely(pmd_is_huge(*pmd)))
 		return ptl;
 	spin_unlock(ptl);
 	return NULL;
--- a/mm/memory.c~mm-introduce-pmd_is_huge-and-use-where-appropriate
+++ a/mm/memory.c
@@ -1374,7 +1374,7 @@ copy_pmd_range(struct vm_area_struct *ds
 	src_pmd = pmd_offset(src_pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (is_swap_pmd(*src_pmd) || pmd_trans_huge(*src_pmd)) {
+		if (pmd_is_huge(*src_pmd)) {
 			int err;
 
 			VM_BUG_ON_VMA(next-addr != HPAGE_PMD_SIZE, src_vma);
@@ -1917,7 +1917,7 @@ static inline unsigned long zap_pmd_rang
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd)) {
+		if (pmd_is_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				__split_huge_pmd(vma, pmd, addr, false);
 			else if (zap_huge_pmd(tlb, vma, pmd, addr)) {
--- a/mm/mprotect.c~mm-introduce-pmd_is_huge-and-use-where-appropriate
+++ a/mm/mprotect.c
@@ -474,7 +474,7 @@ again:
 			goto next;
 
 		_pmd = pmdp_get_lockless(pmd);
-		if (is_swap_pmd(_pmd) || pmd_trans_huge(_pmd)) {
+		if (pmd_is_huge(_pmd)) {
 			if ((next - addr != HPAGE_PMD_SIZE) ||
 			    pgtable_split_needed(vma, cp_flags)) {
 				__split_huge_pmd(vma, pmd, addr, false);
--- a/mm/mremap.c~mm-introduce-pmd_is_huge-and-use-where-appropriate
+++ a/mm/mremap.c
@@ -850,7 +850,7 @@ unsigned long move_page_tables(struct pa
 		if (!new_pmd)
 			break;
 again:
-		if (is_swap_pmd(*old_pmd) || pmd_trans_huge(*old_pmd)) {
+		if (pmd_is_huge(*old_pmd)) {
 			if (extent == HPAGE_PMD_SIZE &&
 			    move_pgt_entry(pmc, HPAGE_PMD, old_pmd, new_pmd))
 				continue;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


