Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6535415380A
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 20:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717793960; cv=none; b=Yw8pdubdcp6ToYzfMq0CVcXi/hoZ6IW3DaFQUFoBdO7XkWuvp9XS/odfGrpAjSadIxHP+JI9TrF/WffXntvpuMHB6akz4i5NvkmSQcvqDVII0Uv408fZhTATE1qeJt5PGkveOuka+yk/0+2b8ylrbP0wi+yYuUxMucrvmx2HCKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717793960; c=relaxed/simple;
	bh=elTXmQnFvQEqOfM5sFlZSQo94cIEsnBSEYhHEmshPbk=;
	h=Date:To:From:Subject:Message-Id; b=qjNF2NB4efA7ZY+0vo3UV3OkgfjMSWyHAtXK2EV8a3wLQ6QbqgTWFU20Ta7jVDLUrpW0GLlM7YjkoFVfByp91vi40f/6aO09WFeT3SrEvXTW1vlmX9a3cTGwu1VreBTLwYEExondEtEaF8BI6pwnRaO5EKh13bImKHncJDSp3Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cWJh3Z7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cWJh3Z7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6075C2BBFC;
	Fri,  7 Jun 2024 20:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717793960;
	bh=elTXmQnFvQEqOfM5sFlZSQo94cIEsnBSEYhHEmshPbk=;
	h=Date:To:From:Subject:From;
	b=cWJh3Z7PAE2naaUk5p3stOn29ZW17C5xYpOn3lHyW/aTQ1zmxubDmB7SK5CJld0jd
	 WwPMZE9Nj7fn6+T1SzraxZCYYtTBiuKZYtxCrQuQChTwvYA4Z2araC8qZQlcot0S45
	 aK/HJsG/8asLe0lfRtqVKEWJNckhO+sdUYEiMM+w=
Date: Fri, 07 Jun 2024 13:59:19 -0700
To: mm-commits@vger.kernel.org,kirill.shutemov@linux.intel.com,ioworker0@gmail.com,corbet@lwn.net,adobriyan@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch added to mm-unstable branch
Message-Id: <20240607205919.E6075C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: properly detect PM_MMAP_EXCLUSIVE per page of PMD-mapped THPs
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch

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

revert-mm-init_mlocked_on_free_v3.patch
mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch
fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch
fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch
fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch
fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch

