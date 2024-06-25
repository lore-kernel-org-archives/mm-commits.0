Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CF814389F
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291652; cv=none; b=mOPELaUm08JQl8VT5lZBikswibA+Qj/iKyUD3tUC6DjYqyFAFzCDjnzA77ESHd+LquhtGgvF2E9MBDQehqeXaIhuM43dfZjrPTuNt2MqzR5Y2PGT9FMMFr0QDcguYTNs38AqlUXA34RmkmGAuUf8wz/R/6+s3D5gVSzS+XfXuns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291652; c=relaxed/simple;
	bh=1+U4dXTK8QfcxiwgsDdCEC0LiiuVnPQTCj1XPckJlk4=;
	h=Date:To:From:Subject:Message-Id; b=WlyKDsusvp6NaOgIuQJpAvmFtJLaNa82eN0fzhOp/9TbdYwV+Q9wabus3PAMF5Spu7PMZ92WkmW/UNodmZyb9c/g2BaNLDx9atV2REWOcHTBT6uBNkYNAw64AnnE9K5vp8fPWGPIfU0Rc/XcZTvnzhWH+glo7JMFqNGlz/STLmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NTEti46J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NTEti46J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BB8C32789;
	Tue, 25 Jun 2024 05:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291652;
	bh=1+U4dXTK8QfcxiwgsDdCEC0LiiuVnPQTCj1XPckJlk4=;
	h=Date:To:From:Subject:From;
	b=NTEti46JsWBUrH4zNuEKLTNeLiKhvOfyKZYUqB06vjTcrWtetmfN9MZddrLvHI0c8
	 j0p6mtq4OnsABDF5zHFEqUw676tnxVv9dCZQo2lBe6u4IYMn9qqVGgkrSQnUw8bscS
	 bdsZxdPBI9omBD/rzDSm/EivIXEITruHpICj44kQ=
Date: Mon, 24 Jun 2024 22:00:51 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,kirill.shutemov@linux.intel.com,ioworker0@gmail.com,corbet@lwn.net,adobriyan@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch removed from -mm tree
Message-Id: <20240625050052.58BB8C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: properly detect PM_MMAP_EXCLUSIVE per page of PMD-mapped THPs
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/task_mmu: properly detect PM_MMAP_EXCLUSIVE per page of PMD-mapped THPs
Date: Fri, 7 Jun 2024 14:23:54 +0200

We added PM_MMAP_EXCLUSIVE in 2015 via commit 77bb499bb60f ("pagemap: add
mmap-exclusive bit for marking pages mapped only here"), when THPs could
not be partially mapped and page_mapcount() returned something that was
true for all pages of the THP.

In 2016, we added support for partially mapping THPs via commit
53f9263baba6 ("mm: rework mapcount accounting to enable 4k mapping of
THPs") but missed to determine PM_MMAP_EXCLUSIVE as well per page.

Checking page_mapcount() on the head page does not tell the whole story.

We should check each individual page.  In a future without per-page
mapcounts it will be different, but we'll change that to be consistent
with PTE-mapped THPs once we deal with that.

Link: https://lkml.kernel.org/r/20240607122357.115423-4-david@redhat.com
Fixes: 53f9263baba6 ("mm: rework mapcount accounting to enable 4k mapping of THPs")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps
+++ a/fs/proc/task_mmu.c
@@ -1474,6 +1474,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 
 	ptl = pmd_trans_huge_lock(pmdp, vma);
 	if (ptl) {
+		unsigned int idx = (addr & ~PMD_MASK) >> PAGE_SHIFT;
 		u64 flags = 0, frame = 0;
 		pmd_t pmd = *pmdp;
 		struct page *page = NULL;
@@ -1490,8 +1491,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 			if (pmd_uffd_wp(pmd))
 				flags |= PM_UFFD_WP;
 			if (pm->show_pfn)
-				frame = pmd_pfn(pmd) +
-					((addr & ~PMD_MASK) >> PAGE_SHIFT);
+				frame = pmd_pfn(pmd) + idx;
 		}
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 		else if (is_swap_pmd(pmd)) {
@@ -1500,11 +1500,9 @@ static int pagemap_pmd_range(pmd_t *pmdp
 
 			if (pm->show_pfn) {
 				if (is_pfn_swap_entry(entry))
-					offset = swp_offset_pfn(entry);
+					offset = swp_offset_pfn(entry) + idx;
 				else
-					offset = swp_offset(entry);
-				offset = offset +
-					((addr & ~PMD_MASK) >> PAGE_SHIFT);
+					offset = swp_offset(entry) + idx;
 				frame = swp_type(entry) |
 					(offset << MAX_SWAPFILES_SHIFT);
 			}
@@ -1520,12 +1518,16 @@ static int pagemap_pmd_range(pmd_t *pmdp
 
 		if (page && !PageAnon(page))
 			flags |= PM_FILE;
-		if (page && (flags & PM_PRESENT) && page_mapcount(page) == 1)
-			flags |= PM_MMAP_EXCLUSIVE;
 
-		for (; addr != end; addr += PAGE_SIZE) {
-			pagemap_entry_t pme = make_pme(frame, flags);
+		for (; addr != end; addr += PAGE_SIZE, idx++) {
+			unsigned long cur_flags = flags;
+			pagemap_entry_t pme;
+
+			if (page && (flags & PM_PRESENT) &&
+			    page_mapcount(page + idx) == 1)
+				cur_flags |= PM_MMAP_EXCLUSIVE;
 
+			pme = make_pme(frame, cur_flags);
 			err = add_to_pagemap(&pme, pm);
 			if (err)
 				break;
_

Patches currently in -mm which might be from david@redhat.com are

mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch

