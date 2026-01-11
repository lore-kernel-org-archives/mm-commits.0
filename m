Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2611E515
	for <mm-commits@vger.kernel.org>; Sun, 11 Jan 2026 02:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768099452; cv=none; b=lYSj2T+BRvYQqjt18mx/LKhHmwq+iYUZlO/HYIApdeCcjUlrNrunJQd+u8/2NfoTdgMM8SSz2daQUq6Z90ofbXP9RKk5ZoGuqBdnuh/JFaZwmSb1bOw0rBwPRbfDwdnxWCKya+q4q53Z0oiswRghkzyZddTzaLs2l4qQ9z0C73g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768099452; c=relaxed/simple;
	bh=ksUOBz2PN6Hzs7yENjmg0n3SJrLg8jMjPihag3gNMU0=;
	h=Date:To:From:Subject:Message-Id; b=Quwz8PqISVTmqPI85JAI0AUoWPNa6kSg2IWsjubINXw8NnI43z0MuTK5dLx+Vhe1RTKHrsXk2Q05djCEmDuEvLj82bi+w/7KN0lMBGKXDM6gvJ2sI8Dl5K5OJCCh3njLFSQQC5zcGZPjurYPrJauY6dW5UAlas1li9YqGOuBeO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gVFW1u+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gVFW1u+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8E6C4CEF1;
	Sun, 11 Jan 2026 02:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768099451;
	bh=ksUOBz2PN6Hzs7yENjmg0n3SJrLg8jMjPihag3gNMU0=;
	h=Date:To:From:Subject:From;
	b=gVFW1u+2LsnccDdMroM24XOjOQCtjvQAXiw7xSXg/XND0mVe/UIuUJ3o/LaWxWorK
	 KPbTbDOBeCevK9G7uGoyKjvy9mSYj21CGfAvOSz3Jz22hdbV4ZW4Yqpr9lQZ7lB8Ni
	 H5i9cRbUhq8Jvzq9eL165uYN50edjSRIR7lymZTs=
Date: Sat, 10 Jan 2026 18:44:11 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@suse.cz,riel@surriel.com,rakie.kim@sk.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate-replace-rmp_-flags-with-ttu_-flags.patch added to mm-new branch
Message-Id: <20260111024411.BA8E6C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: migrate: replace RMP_ flags with TTU_ flags
has been added to the -mm mm-new branch.  Its filename is
     migrate-replace-rmp_-flags-with-ttu_-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate-replace-rmp_-flags-with-ttu_-flags.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: migrate: replace RMP_ flags with TTU_ flags
Date: Fri, 9 Jan 2026 04:13:43 +0000

Instead of translating between RMP_ and TTU_ flags, remove the RMP_ flags
and just use the TTU_ flag space; there's plenty available.

Possibly we should rename these to RMAP_ flags, and maybe even pass them
in through rmap_walk_arg, but that can be done later.

Link: https://lkml.kernel.org/r/20260109041345.3863089-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    9 +++------
 mm/huge_memory.c     |    8 ++++----
 mm/migrate.c         |   12 ++++++------
 3 files changed, 13 insertions(+), 16 deletions(-)

--- a/include/linux/rmap.h~migrate-replace-rmp_-flags-with-ttu_-flags
+++ a/include/linux/rmap.h
@@ -92,6 +92,7 @@ struct anon_vma_chain {
 };
 
 enum ttu_flags {
+	TTU_USE_SHARED_ZEROPAGE	= 0x2,	/* for unused pages of large folios */
 	TTU_SPLIT_HUGE_PMD	= 0x4,	/* split huge PMD if any */
 	TTU_IGNORE_MLOCK	= 0x8,	/* ignore mlock */
 	TTU_SYNC		= 0x10,	/* avoid racy checks with PVMW_SYNC */
@@ -933,12 +934,8 @@ int mapping_wrprotect_range(struct addre
 int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 		      struct vm_area_struct *vma);
 
-enum rmp_flags {
-	RMP_LOCKED		= 1 << 0,
-	RMP_USE_SHARED_ZEROPAGE	= 1 << 1,
-};
-
-void remove_migration_ptes(struct folio *src, struct folio *dst, int flags);
+void remove_migration_ptes(struct folio *src, struct folio *dst,
+		enum ttu_flags flags);
 
 /*
  * rmap_walk_control: To control rmap traversing for specific needs
--- a/mm/huge_memory.c~migrate-replace-rmp_-flags-with-ttu_-flags
+++ a/mm/huge_memory.c
@@ -3431,7 +3431,7 @@ static void remap_page(struct folio *fol
 	if (!folio_test_anon(folio))
 		return;
 	for (;;) {
-		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
+		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
 		if (i >= nr)
 			break;
@@ -3944,7 +3944,7 @@ static int __folio_split(struct folio *f
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
-	int remap_flags = 0;
+	enum ttu_flags ttu_flags = 0;
 	int ret;
 	pgoff_t end = 0;
 
@@ -4064,9 +4064,9 @@ fail:
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
 	if (!ret && is_anon && !folio_is_device_private(folio))
-		remap_flags = RMP_USE_SHARED_ZEROPAGE;
+		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 
-	remap_page(folio, 1 << old_order, remap_flags);
+	remap_page(folio, 1 << old_order, ttu_flags);
 
 	/*
 	 * Unlock all after-split folios except the one containing
--- a/mm/migrate.c~migrate-replace-rmp_-flags-with-ttu_-flags
+++ a/mm/migrate.c
@@ -452,11 +452,12 @@ static bool remove_migration_pte(struct
  * Get rid of all migration entries and replace them by
  * references to the indicated page.
  */
-void remove_migration_ptes(struct folio *src, struct folio *dst, int flags)
+void remove_migration_ptes(struct folio *src, struct folio *dst,
+		enum ttu_flags flags)
 {
 	struct rmap_walk_arg rmap_walk_arg = {
 		.folio = src,
-		.map_unused_to_zeropage = flags & RMP_USE_SHARED_ZEROPAGE,
+		.map_unused_to_zeropage = flags & TTU_USE_SHARED_ZEROPAGE,
 	};
 
 	struct rmap_walk_control rwc = {
@@ -464,9 +465,9 @@ void remove_migration_ptes(struct folio
 		.arg = &rmap_walk_arg,
 	};
 
-	VM_BUG_ON_FOLIO((flags & RMP_USE_SHARED_ZEROPAGE) && (src != dst), src);
+	VM_BUG_ON_FOLIO((flags & TTU_USE_SHARED_ZEROPAGE) && (src != dst), src);
 
-	if (flags & RMP_LOCKED)
+	if (flags & TTU_RMAP_LOCKED)
 		rmap_walk_locked(dst, &rwc);
 	else
 		rmap_walk(dst, &rwc);
@@ -1521,8 +1522,7 @@ static int unmap_and_move_huge_page(new_
 		rc = move_to_new_folio(dst, src, mode);
 
 	if (page_was_mapped)
-		remove_migration_ptes(src, !rc ? dst : src,
-				ttu ? RMP_LOCKED : 0);
+		remove_migration_ptes(src, !rc ? dst : src, ttu);
 
 	if (ttu & TTU_RMAP_LOCKED)
 		i_mmap_unlock_write(mapping);
_

Patches currently in -mm which might be from willy@infradead.org are

migrate-correct-lock-ordering-for-hugetlb-file-folios.patch
migrate-replace-rmp_-flags-with-ttu_-flags.patch

