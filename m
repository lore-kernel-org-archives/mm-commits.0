Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729A716D9A7
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718740619; cv=none; b=sxtJlxYpbO/mNCiSaq8Rdc0XkHe56DBXoZBUEaPj9qeqK+HIAN81DKaHdZ+PMuyIsFUES1dn84fSgEwY4fVJqVnIQeanSgRJgRCSnKN6O0cSsPLRkE0P/V9aOjmkXiEYFZxo+bb02xk35rl1Nb9qY9ltpHQSSb1h9Aadt9POmsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718740619; c=relaxed/simple;
	bh=3Wik28Rf3kEtiWoEM8CRir9o3hv+oR5G4u0MnswzBV0=;
	h=Date:To:From:Subject:Message-Id; b=FC4ga4cRhpmv57H+Ln5Z1+NERgVR6+nfk+sT+AlUQsMs5WM1v+cgAsW0Sz7mWozsrkotHcE+ZN9U63WxrcqpLBQprvsWIE0yLuwCUe5PgkNglEUyWGIYTCgpoADg3elYGH2K5+Loatj31+7dY+L4OPC9Ci9OgX51lrwFpyn4y5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x6+BIzJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x6+BIzJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6EAC3277B;
	Tue, 18 Jun 2024 19:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718740619;
	bh=3Wik28Rf3kEtiWoEM8CRir9o3hv+oR5G4u0MnswzBV0=;
	h=Date:To:From:Subject:From;
	b=x6+BIzJeahDJnQvIyhltjsVJAynWpfrZuZvC9faBlE55geanhkFN+xqEIbsKOIrLL
	 CfWtv6M7YLQJr4oajjGQqYxZOGuku3OFX6XyIoo4jWd6dV8aa4VJNfxHubEwG/Z4Io
	 Fji5AiWCIa6xaW23LpMf5/oMQlT6OlxZNkGBNpTE=
Date: Tue, 18 Jun 2024 12:56:58 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-use-folio-in-struct-copy_subpage_arg.patch added to mm-unstable branch
Message-Id: <20240618195658.EF6EAC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory: use folio in struct copy_subpage_arg
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-use-folio-in-struct-copy_subpage_arg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-use-folio-in-struct-copy_subpage_arg.patch

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
Subject: mm: memory: use folio in struct copy_subpage_arg
Date: Tue, 18 Jun 2024 17:12:40 +0800

Directly use folio in struct copy_subpage_arg.

Link: https://lkml.kernel.org/r/20240618091242.2140164-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-memory-use-folio-in-struct-copy_subpage_arg
+++ a/mm/memory.c
@@ -6487,16 +6487,16 @@ static int copy_user_gigantic_page(struc
 }
 
 struct copy_subpage_arg {
-	struct page *dst;
-	struct page *src;
+	struct folio *dst;
+	struct folio *src;
 	struct vm_area_struct *vma;
 };
 
 static int copy_subpage(unsigned long addr, int idx, void *arg)
 {
 	struct copy_subpage_arg *copy_arg = arg;
-	struct page *dst = nth_page(copy_arg->dst, idx);
-	struct page *src = nth_page(copy_arg->src, idx);
+	struct page *dst = folio_page(copy_arg->dst, idx);
+	struct page *src = folio_page(copy_arg->src, idx);
 
 	if (copy_mc_user_highpage(dst, src, addr, copy_arg->vma))
 		return -EHWPOISON;
@@ -6510,8 +6510,8 @@ int copy_user_large_folio(struct folio *
 	unsigned long addr = addr_hint &
 		~(((unsigned long)pages_per_huge_page << PAGE_SHIFT) - 1);
 	struct copy_subpage_arg arg = {
-		.dst = &dst->page,
-		.src = &src->page,
+		.dst = dst,
+		.src = src,
 		.vma = vma,
 	};
 
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

