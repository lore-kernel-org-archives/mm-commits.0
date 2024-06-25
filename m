Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6E0143739
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291651; cv=none; b=H+z50x1dApTpyeYSLpXLp64qdbEI2N20hM8ON4RU/0oERQint8k6mqbSMF+q+JQxTZUVr5k6DzxC/0aer+VBEL6iHmbU9+wq0PxsJ+LU9k60R4FSH7IS2jyg29Lq+wXsWTLRbIi8qXW5gN/hHcOTpZ5lyvrhv+rz8ENOaL61NNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291651; c=relaxed/simple;
	bh=Mdy0uZeqFN6fnDGn2vbK6QZPqaj0I8QHRoN9weGA0eg=;
	h=Date:To:From:Subject:Message-Id; b=ou578QPSebc0NPunWZnA/hecGICb18kwvwcCxql59EEAiifWtn3CbQ2teffH1HnSP7bl0J+j3SxnyP3O7yKNKvtCA5U1C32Ldva8rJEenlLv7W+o8WXbyW3vEHzWNuIRJBU09lxsdcWyLKvcBJRlLTG6s7E3cEpXfDZZOCIOEcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vzw3Jg57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vzw3Jg57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C111CC32789;
	Tue, 25 Jun 2024 05:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291650;
	bh=Mdy0uZeqFN6fnDGn2vbK6QZPqaj0I8QHRoN9weGA0eg=;
	h=Date:To:From:Subject:From;
	b=Vzw3Jg57e9pV0yzRKXeClPbtzD2WpLzAWbAQpTZ+Bs+g1+Vk76PyURnVvuoxaI8dh
	 BWLyK+09EhJis5kn+ULUMjFc5seL6zxVDOP8HmF8wuzWfCfCQgFulkKyMqkPsZzxi8
	 nbcm+UG/S2Rm3cnC4TvPmK2C8x9ZBVZZeqPtjUuo=
Date: Mon, 24 Jun 2024 22:00:50 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,kirill.shutemov@linux.intel.com,ioworker0@gmail.com,corbet@lwn.net,adobriyan@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch removed from -mm tree
Message-Id: <20240625050050.C111CC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: don't indicate PM_MMAP_EXCLUSIVE without PM_PRESENT
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/task_mmu: don't indicate PM_MMAP_EXCLUSIVE without PM_PRESENT
Date: Fri, 7 Jun 2024 14:23:53 +0200

Relying on the mapcount for non-present PTEs that reference pages doesn't
make any sense: they are not accounted in the mapcount, so page_mapcount()
== 1 won't return the result we actually want to know.

While we don't check the mapcount for migration entries already, we could
end up checking it for swap, hwpoison, device exclusive, ...  entries,
which we really shouldn't.

There is one exception: device private entries, which we consider
fake-present (e.g., incremented the mapcount).  But we won't care about
that for now for PM_MMAP_EXCLUSIVE, because indicating PM_SWAP for them
although they are fake-present already sounds suspiciously wrong.

Let's never indicate PM_MMAP_EXCLUSIVE without PM_PRESENT.

Link: https://lkml.kernel.org/r/20240607122357.115423-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present
+++ a/fs/proc/task_mmu.c
@@ -1415,7 +1415,6 @@ static pagemap_entry_t pte_to_pagemap_en
 {
 	u64 frame = 0, flags = 0;
 	struct page *page = NULL;
-	bool migration = false;
 
 	if (pte_present(pte)) {
 		if (pm->show_pfn)
@@ -1447,7 +1446,6 @@ static pagemap_entry_t pte_to_pagemap_en
 			    (offset << MAX_SWAPFILES_SHIFT);
 		}
 		flags |= PM_SWAP;
-		migration = is_migration_entry(entry);
 		if (is_pfn_swap_entry(entry))
 			page = pfn_swap_entry_to_page(entry);
 		if (pte_marker_entry_uffd_wp(entry))
@@ -1456,7 +1454,7 @@ static pagemap_entry_t pte_to_pagemap_en
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
-	if (page && !migration && page_mapcount(page) == 1)
+	if (page && (flags & PM_PRESENT) && page_mapcount(page) == 1)
 		flags |= PM_MMAP_EXCLUSIVE;
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
@@ -1473,7 +1471,6 @@ static int pagemap_pmd_range(pmd_t *pmdp
 	pte_t *pte, *orig_pte;
 	int err = 0;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool migration = false;
 
 	ptl = pmd_trans_huge_lock(pmdp, vma);
 	if (ptl) {
@@ -1517,14 +1514,13 @@ static int pagemap_pmd_range(pmd_t *pmdp
 			if (pmd_swp_uffd_wp(pmd))
 				flags |= PM_UFFD_WP;
 			VM_BUG_ON(!is_pmd_migration_entry(pmd));
-			migration = is_migration_entry(entry);
 			page = pfn_swap_entry_to_page(entry);
 		}
 #endif
 
 		if (page && !PageAnon(page))
 			flags |= PM_FILE;
-		if (page && !migration && page_mapcount(page) == 1)
+		if (page && (flags & PM_PRESENT) && page_mapcount(page) == 1)
 			flags |= PM_MMAP_EXCLUSIVE;
 
 		for (; addr != end; addr += PAGE_SIZE) {
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

