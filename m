Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E64615E5BB
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718740616; cv=none; b=nD9qya6sQgw5AfmkJ1jaOusgqonErwpWfRbssSl3ZbYxB1kkMBykQYUTdP7i0+8noGuCMmkW+bMG1UOCoP/mCKeKRDL+MWk4dZOSvIBFcZ0hkOLAKNq1ILdRAPS9zUFRsAYfxdMINok7gmHo2gqfRpEumB9H2KHRuLzyfQpjMd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718740616; c=relaxed/simple;
	bh=9XwW5wuroOrLMwRAD1BsiChaTRqIuUIu5k6SA6M0DX0=;
	h=Date:To:From:Subject:Message-Id; b=lswz+7KcdeO9mUelL6hulago6T2Sp15h6qfLEjwF1TmVQDKMdHZHUxen4sbqscbvBJ4n8t015sGVRs2wmb8aI1QQrRcaflG75GfmbvUooslKmGaa9TUaX7SLrI681eHf4DyoemX07Sec7s7w3oHy0t1hX99YLNGgMdNEYtc7ELw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fvh5alUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fvh5alUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A828EC3277B;
	Tue, 18 Jun 2024 19:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718740615;
	bh=9XwW5wuroOrLMwRAD1BsiChaTRqIuUIu5k6SA6M0DX0=;
	h=Date:To:From:Subject:From;
	b=Fvh5alUUuMAvlqHkHnBQjgFRP9CcoZR3TucDv2H19BEtwpVThR6UXGBZ27wrDd7Jk
	 IUWPCzHZuJaQkWyTKiA9d7oSWcioszzg/aCUf0nMepX/OquOlZsD3MVHBBkSWoL85G
	 8RA8HLSLclGKRE0kZZhByciSoIYpWlXwKK5b/yDQ=
Date: Tue, 18 Jun 2024 12:56:55 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-convert-clear_huge_page-to-folio_zero_user.patch added to mm-unstable branch
Message-Id: <20240618195655.A828EC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory: convert clear_huge_page() to folio_zero_user()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-convert-clear_huge_page-to-folio_zero_user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-convert-clear_huge_page-to-folio_zero_user.patch

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
Subject: mm: memory: convert clear_huge_page() to folio_zero_user()
Date: Tue, 18 Jun 2024 17:12:39 +0800

Patch series "mm: improve clear and copy user folio", v2.

Some folio conversions.  An improvement is to move address alignment into
the caller as it is only needed if we don't know which address will be
accessed when clearing/copying user folios.


This patch (of 4):

Replace clear_huge_page() with folio_zero_user(), and take a folio
instead of a page. Directly get number of pages by folio_nr_pages()
to remove pages_per_huge_page argument, furthermore, move the address
alignment from folio_zero_user() to the callers since the alignment
is only needed when we don't know which address will be accessed.

Link: https://lkml.kernel.org/r/20240618091242.2140164-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240618091242.2140164-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 include/linux/mm.h   |    4 +---
 mm/huge_memory.c     |    4 ++--
 mm/hugetlb.c         |    3 +--
 mm/memory.c          |   34 ++++++++++++++++------------------
 5 files changed, 21 insertions(+), 26 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-memory-convert-clear_huge_page-to-folio_zero_user
+++ a/fs/hugetlbfs/inode.c
@@ -892,7 +892,7 @@ static long hugetlbfs_fallocate(struct f
 			error = PTR_ERR(folio);
 			goto out;
 		}
-		clear_huge_page(&folio->page, addr, pages_per_huge_page(h));
+		folio_zero_user(folio, ALIGN_DOWN(addr, hpage_size));
 		__folio_mark_uptodate(folio);
 		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
--- a/include/linux/mm.h~mm-memory-convert-clear_huge_page-to-folio_zero_user
+++ a/include/linux/mm.h
@@ -4078,9 +4078,7 @@ enum mf_action_page_type {
 };
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
-extern void clear_huge_page(struct page *page,
-			    unsigned long addr_hint,
-			    unsigned int pages_per_huge_page);
+void folio_zero_user(struct folio *folio, unsigned long addr_hint);
 int copy_user_large_folio(struct folio *dst, struct folio *src,
 			  unsigned long addr_hint,
 			  struct vm_area_struct *vma);
--- a/mm/huge_memory.c~mm-memory-convert-clear_huge_page-to-folio_zero_user
+++ a/mm/huge_memory.c
@@ -943,10 +943,10 @@ static vm_fault_t __do_huge_pmd_anonymou
 		goto release;
 	}
 
-	clear_huge_page(page, vmf->address, HPAGE_PMD_NR);
+	folio_zero_user(folio, vmf->address);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
-	 * clear_huge_page writes become visible before the set_pmd_at()
+	 * folio_zero_user writes become visible before the set_pmd_at()
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
--- a/mm/hugetlb.c~mm-memory-convert-clear_huge_page-to-folio_zero_user
+++ a/mm/hugetlb.c
@@ -6300,8 +6300,7 @@ static vm_fault_t hugetlb_no_page(struct
 				ret = 0;
 			goto out;
 		}
-		clear_huge_page(&folio->page, vmf->real_address,
-				pages_per_huge_page(h));
+		folio_zero_user(folio, vmf->real_address);
 		__folio_mark_uptodate(folio);
 		new_folio = true;
 
--- a/mm/memory.c~mm-memory-convert-clear_huge_page-to-folio_zero_user
+++ a/mm/memory.c
@@ -4477,7 +4477,7 @@ static struct folio *alloc_anon_folio(st
 				goto next;
 			}
 			folio_throttle_swaprate(folio, gfp);
-			clear_huge_page(&folio->page, vmf->address, 1 << order);
+			folio_zero_user(folio, vmf->address);
 			return folio;
 		}
 next:
@@ -6430,41 +6430,39 @@ static inline int process_huge_page(
 	return 0;
 }
 
-static void clear_gigantic_page(struct page *page,
-				unsigned long addr,
+static void clear_gigantic_page(struct folio *folio, unsigned long addr,
 				unsigned int pages_per_huge_page)
 {
 	int i;
-	struct page *p;
 
 	might_sleep();
 	for (i = 0; i < pages_per_huge_page; i++) {
-		p = nth_page(page, i);
 		cond_resched();
-		clear_user_highpage(p, addr + i * PAGE_SIZE);
+		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
 	}
 }
 
 static int clear_subpage(unsigned long addr, int idx, void *arg)
 {
-	struct page *page = arg;
+	struct folio *folio = arg;
 
-	clear_user_highpage(nth_page(page, idx), addr);
+	clear_user_highpage(folio_page(folio, idx), addr);
 	return 0;
 }
 
-void clear_huge_page(struct page *page,
-		     unsigned long addr_hint, unsigned int pages_per_huge_page)
+/**
+ * folio_zero_user - Zero a folio which will be mapped to userspace.
+ * @folio: The folio to zero.
+ * @addr_hint: The address will be accessed or the base address if uncelar.
+ */
+void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
-	unsigned long addr = addr_hint &
-		~(((unsigned long)pages_per_huge_page << PAGE_SHIFT) - 1);
+	unsigned int nr_pages = folio_nr_pages(folio);
 
-	if (unlikely(pages_per_huge_page > MAX_ORDER_NR_PAGES)) {
-		clear_gigantic_page(page, addr, pages_per_huge_page);
-		return;
-	}
-
-	process_huge_page(addr_hint, pages_per_huge_page, clear_subpage, page);
+	if (unlikely(nr_pages > MAX_ORDER_NR_PAGES))
+		clear_gigantic_page(folio, addr_hint, nr_pages);
+	else
+		process_huge_page(addr_hint, nr_pages, clear_subpage, folio);
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
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

