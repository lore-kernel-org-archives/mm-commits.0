Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC25230D35
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343280; cv=none; b=o9GxDlOPaNEz+ZnLcnakq++DS3e6ysYDTk0mV7noC8ARS9Bq0e4e5ND58NxhldxjFqANiH1LrlqUsVKO/3kC+oDkpl8N0B8A8WXEVKPb05QeggWciolbwdPa9K9NotvMgmOB9Gxw3oqZBFsTiZ6COrAcudJxGyW8kR/gx+86JlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343280; c=relaxed/simple;
	bh=2fcYaBksPCXpM4CDhNRkRxasrj7brfmgpdVZAQsiYAs=;
	h=Date:To:From:Subject:Message-Id; b=egg1NtCaqICpe/RVAuBsJIZ4kxzH+CPNVzlutZOe696s5MVK1ma/7xKhOhW5NSdhSlKGFn4gpJ1uKt6aScCtuRHI3nCsPhiz3aka3LSM/ZJyiREhknDAQWKG0y+AsGMKQw1h/5O3sN9rag4p9Go4vAzzOifn6vG1bD9GGMTHUbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JbaMqhFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JbaMqhFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662EDC16AAE;
	Mon, 17 Nov 2025 01:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343279;
	bh=2fcYaBksPCXpM4CDhNRkRxasrj7brfmgpdVZAQsiYAs=;
	h=Date:To:From:Subject:From;
	b=JbaMqhFUf9+leirZjsIP41+YP/RrR9D7SSYQjQW7zr/FD3nob7RKNQVtuKvcnxGgX
	 SGqSvo132bvjDyth4Ucgu6x5UGmEIjELUM5XtBpB8B1ZFidj9s9vtDCRaseZNVkQCd
	 mTplqWnFQsepz+xhOGLxHjgU1OlyvtnyDRVGnOig=
Date: Sun, 16 Nov 2025 17:34:38 -0800
To: mm-commits@vger.kernel.org,david@kernel.org,pedrodemargomes@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch removed from -mm tree
Message-Id: <20251117013439.662EDC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk"
has been removed from the -mm tree.  Its filename was
     revert-mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: Revert "mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk"
Date: Wed, 5 Nov 2025 15:49:10 -0300

Patch series "ksm: perform a range-walk to jump over holes in break_ksm",
v4.

When unmerging an address range, unmerge_ksm_pages function walks every
page address in the specified range to locate ksm pages.  This becomes
highly inefficient when scanning large virtual memory areas that contain
mostly unmapped regions, causing the process to get blocked for several
minutes.

This patch makes break_ksm, function called by unmerge_ksm_pages for every
page in an address range, perform a range walk, allowing it to skip over
entire unmapped holes in a VMA, avoiding unnecessary lookups.

As pointed out by David Hildenbrand in [1], unmerge_ksm_pages() is called
from:

* ksm_madvise() through madvise(MADV_UNMERGEABLE).  There are not a lot
  of users of that function.

* __ksm_del_vma() through ksm_del_vmas().  Effectively called when
  disabling KSM for a process either through the sysctl or from s390x gmap
  code when enabling storage keys for a VM.

Consider the following test program which creates a 32 TiB mapping in the
virtual address space but only populates a single page:

#include <unistd.h>
#include <stdio.h>
#include <sys/mman.h>

/* 32 TiB */
const size_t size = 32ul * 1024 * 1024 * 1024 * 1024;

int main() {
        char *area = mmap(NULL, size, PROT_READ | PROT_WRITE,
                          MAP_NORESERVE | MAP_PRIVATE | MAP_ANON, -1, 0);

        if (area == MAP_FAILED) {
                perror("mmap() failed\n");
                return -1;
        }

        /* Populate a single page such that we get an anon_vma. */
        *area = 0;

        /* Enable KSM. */
        madvise(area, size, MADV_MERGEABLE);
        madvise(area, size, MADV_UNMERGEABLE);
        return 0;
}


Without this patch, this program takes 9 minutes to finish, while with
this patch it finishes in less then 5 seconds.


This patch (of 3):

This reverts commit e317a8d8b4f600fc7ec9725e26417030ee594f52 and changes
function break_ksm_pmd_entry() to use folios.

This reverts break_ksm() to use walk_page_range_vma() instead of
folio_walk_start().

Change break_ksm_pmd_entry() to call is_ksm_zero_pte() only if we know the
folio is present, and also rename variable ret to found.  This will make
it easier to later modify break_ksm() to perform a proper range walk.

Link: https://lkml.kernel.org/r/20251105184912.186329-1-pedrodemargomes@gmail.com
Link: https://lkml.kernel.org/r/20251105184912.186329-2-pedrodemargomes@gmail.com
Link: https://lore.kernel.org/linux-mm/e0886fdf-d198-4130-bd9a-be276c59da37@redhat.com/ [1]
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   64 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 16 deletions(-)

--- a/mm/ksm.c~revert-mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk
+++ a/mm/ksm.c
@@ -607,6 +607,48 @@ static inline bool ksm_test_exit(struct
 	return atomic_read(&mm->mm_users) == 0;
 }
 
+static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
+			struct mm_walk *walk)
+{
+	struct folio *folio = NULL;
+	spinlock_t *ptl;
+	pte_t *pte;
+	pte_t ptent;
+	int found;
+
+	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte)
+		return 0;
+	ptent = ptep_get(pte);
+	if (pte_present(ptent)) {
+		folio = vm_normal_folio(walk->vma, addr, ptent);
+	} else if (!pte_none(ptent)) {
+		swp_entry_t entry = pte_to_swp_entry(ptent);
+
+		/*
+		 * As KSM pages remain KSM pages until freed, no need to wait
+		 * here for migration to end.
+		 */
+		if (is_migration_entry(entry))
+			folio = pfn_swap_entry_folio(entry);
+	}
+	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
+	found = (folio && folio_test_ksm(folio)) ||
+		(pte_present(ptent) && is_ksm_zero_pte(ptent));
+	pte_unmap_unlock(pte, ptl);
+	return found;
+}
+
+static const struct mm_walk_ops break_ksm_ops = {
+	.pmd_entry = break_ksm_pmd_entry,
+	.walk_lock = PGWALK_RDLOCK,
+};
+
+static const struct mm_walk_ops break_ksm_lock_vma_ops = {
+	.pmd_entry = break_ksm_pmd_entry,
+	.walk_lock = PGWALK_WRLOCK,
+};
+
 /*
  * We use break_ksm to break COW on a ksm page by triggering unsharing,
  * such that the ksm page will get replaced by an exclusive anonymous page.
@@ -623,26 +665,16 @@ static inline bool ksm_test_exit(struct
 static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_vma)
 {
 	vm_fault_t ret = 0;
-
-	if (lock_vma)
-		vma_start_write(vma);
+	const struct mm_walk_ops *ops = lock_vma ?
+				&break_ksm_lock_vma_ops : &break_ksm_ops;
 
 	do {
-		bool ksm_page = false;
-		struct folio_walk fw;
-		struct folio *folio;
+		int ksm_page;
 
 		cond_resched();
-		folio = folio_walk_start(&fw, vma, addr,
-					 FW_MIGRATION | FW_ZEROPAGE);
-		if (folio) {
-			/* Small folio implies FW_LEVEL_PTE. */
-			if (!folio_test_large(folio) &&
-			    (folio_test_ksm(folio) || is_ksm_zero_pte(fw.pte)))
-				ksm_page = true;
-			folio_walk_end(&fw, vma);
-		}
-
+		ksm_page = walk_page_range_vma(vma, addr, addr + 1, ops, NULL);
+		if (WARN_ON_ONCE(ksm_page < 0))
+			return ksm_page;
 		if (!ksm_page)
 			return 0;
 		ret = handle_mm_fault(vma, addr,
_

Patches currently in -mm which might be from pedrodemargomes@gmail.com are


