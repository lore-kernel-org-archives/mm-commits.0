Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C93716D9D4
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718740623; cv=none; b=QqjX0/HSvX2lpvFHNK4VGAYd0qbkjvbaEahzfsROKk56yROMHaIhCYM73Isjo2rHEB92kChclp7lYQtTG7DzGvaasEtvSkQwTPupaBSX38cvVItLNW9aeKy1ruDOhYNUEDDO5mjVpT8DqaYVlLJUquYQWMYM30z7m55VoDqaYms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718740623; c=relaxed/simple;
	bh=laL1y8s4PiJTOnsOs9kM2tSJOJ7wNQxFvn6P48L17CI=;
	h=Date:To:From:Subject:Message-Id; b=SaFpVtJuf3jjfGyDRlriRZI4oY+Ct9wKESdlqoOxL5W8DfzL8bmqhS/JekrafChV+ZuzjLEsFtgEn+lzZyyCpPHzwg4NRpjYzzAlVoxo7unC8glN9EEFhb76uOkI3MtqXxMNkcr0Rkb8idqT+cNUXBrQDAR30O4jTpZgEEc2LOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KNAEtgGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KNAEtgGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0134BC3277B;
	Tue, 18 Jun 2024 19:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718740623;
	bh=laL1y8s4PiJTOnsOs9kM2tSJOJ7wNQxFvn6P48L17CI=;
	h=Date:To:From:Subject:From;
	b=KNAEtgGa6RNPsFNzHjj5sFjcz3FP9XXXCVgT+Y7tCQbd8ORoewAFCD2pxVJ9syC9i
	 BxenYMk6be7GdSiD/IA1mHjTrcrs/yMwPu5ruhYNeepiIvjsiw/MmMuviFf9+RoWhd
	 z4dyD51cRzTk3CSNzNKMCZwfZdSLwYP/7hz/7+cg=
Date: Tue, 18 Jun 2024 12:57:02 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-rename-pages_per_huge_page-to-nr_pages.patch added to mm-unstable branch
Message-Id: <20240618195703.0134BC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory: rename pages_per_huge_page to nr_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-rename-pages_per_huge_page-to-nr_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-rename-pages_per_huge_page-to-nr_pages.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: rename pages_per_huge_page to nr_pages
Date: Tue, 18 Jun 2024 17:12:42 +0800

Since the callers are converted to use nr_pages naming, use it inside too.

Link: https://lkml.kernel.org/r/20240618091242.2140164-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/memory.c~mm-memory-rename-pages_per_huge_page-to-nr_pages
+++ a/mm/memory.c
@@ -6376,23 +6376,23 @@ EXPORT_SYMBOL(__might_fault);
  * cache lines hot.
  */
 static inline int process_huge_page(
-	unsigned long addr_hint, unsigned int pages_per_huge_page,
+	unsigned long addr_hint, unsigned int nr_pages,
 	int (*process_subpage)(unsigned long addr, int idx, void *arg),
 	void *arg)
 {
 	int i, n, base, l, ret;
 	unsigned long addr = addr_hint &
-		~(((unsigned long)pages_per_huge_page << PAGE_SHIFT) - 1);
+		~(((unsigned long)nr_pages << PAGE_SHIFT) - 1);
 
 	/* Process target subpage last to keep its cache lines hot */
 	might_sleep();
 	n = (addr_hint - addr) / PAGE_SIZE;
-	if (2 * n <= pages_per_huge_page) {
+	if (2 * n <= nr_pages) {
 		/* If target subpage in first half of huge page */
 		base = 0;
 		l = n;
 		/* Process subpages at the end of huge page */
-		for (i = pages_per_huge_page - 1; i >= 2 * n; i--) {
+		for (i = nr_pages - 1; i >= 2 * n; i--) {
 			cond_resched();
 			ret = process_subpage(addr + i * PAGE_SIZE, i, arg);
 			if (ret)
@@ -6400,8 +6400,8 @@ static inline int process_huge_page(
 		}
 	} else {
 		/* If target subpage in second half of huge page */
-		base = pages_per_huge_page - 2 * (pages_per_huge_page - n);
-		l = pages_per_huge_page - n;
+		base = nr_pages - 2 * (nr_pages - n);
+		l = nr_pages - n;
 		/* Process subpages at the begin of huge page */
 		for (i = 0; i < base; i++) {
 			cond_resched();
@@ -6431,12 +6431,12 @@ static inline int process_huge_page(
 }
 
 static void clear_gigantic_page(struct folio *folio, unsigned long addr,
-				unsigned int pages_per_huge_page)
+				unsigned int nr_pages)
 {
 	int i;
 
 	might_sleep();
-	for (i = 0; i < pages_per_huge_page; i++) {
+	for (i = 0; i < nr_pages; i++) {
 		cond_resched();
 		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
 	}
@@ -6466,15 +6466,15 @@ void folio_zero_user(struct folio *folio
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
-				     unsigned long addr,
-				     struct vm_area_struct *vma,
-				     unsigned int pages_per_huge_page)
+				   unsigned long addr,
+				   struct vm_area_struct *vma,
+				   unsigned int nr_pages)
 {
 	int i;
 	struct page *dst_page;
 	struct page *src_page;
 
-	for (i = 0; i < pages_per_huge_page; i++) {
+	for (i = 0; i < nr_pages; i++) {
 		dst_page = folio_page(dst, i);
 		src_page = folio_page(src, i);
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch
mm-refactor-folio_undo_large_rmappable.patch
mm-memcontrol-remove-page_memcg.patch
rmap-remove-define_page_vma_walk.patch
mm-migrate-simplify-__buffer_migrate_folio.patch
mm-migrate_device-use-a-newfolio-in-__migrate_device_pages.patch
mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy.patch
mm-migrate-remove-migrate_folio_extra.patch
mm-remove-migrate_sync_no_copy-mode.patch
fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
mm-remove-page_maybe_dma_pinned-fix.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch
mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poison-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch
mm-memory-convert-clear_huge_page-to-folio_zero_user.patch
mm-memory-use-folio-in-struct-copy_subpage_arg.patch
mm-memory-improve-copy_user_large_folio.patch
mm-memory-rename-pages_per_huge_page-to-nr_pages.patch

