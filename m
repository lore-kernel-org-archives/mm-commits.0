Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3792DECA5
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 23:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762386897; cv=none; b=lwfrlG8v6/zESTfySrucppqi1NXWCfEwpHgYFgmIMHQPGjmY9uvYrILkpEtoXycvmgIBQJweTC/yfzXTJ5qT4jE9SQHj1zweJjzO8GSdv6gej/6j+OW3YWxajI0xiHTC1SAhVfq0QXFHBQd5tvZmMUQkBQU7xux06jeoyzzLv2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762386897; c=relaxed/simple;
	bh=oD6BW+nnlOR3JRAEq0Hr1aNBS6UMTUfwxPoc0jeIWUA=;
	h=Date:To:From:Subject:Message-Id; b=LcAatrJ5eWPE98mQGAAhfwP8F7K+UiH7hqHzLJTFHNArV7CO+kw5x/Xa4YtGkIetz+50VQbf5avuAkCZVkYcP9w12HQ8K1A5lbjcU2rCtHtNkhfK/3lXhRQmpAHG+VZIo+Y9tp1ewwD/+FwWvAuR5fRBBTURK9DzAzBJXOVdk7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cr3ecymn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cr3ecymn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94264C4CEF5;
	Wed,  5 Nov 2025 23:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762386896;
	bh=oD6BW+nnlOR3JRAEq0Hr1aNBS6UMTUfwxPoc0jeIWUA=;
	h=Date:To:From:Subject:From;
	b=Cr3ecymn1sF7CCGuaLyfLLE0CDE5TcngkgmlTdK/Cr33PdC4kWjyGQdWHeNiyIMxu
	 xnAqK7L7MzXkjcJwjg5LTosGtcvf+1UcX9a5aLDE6v+LGAo1PqjBid8wkLaH5fQJUK
	 uRkCGpvghNBDo38dM/qLRpdoRA8mVaIjWulPnBG0=
Date: Wed, 05 Nov 2025 15:54:56 -0800
To: mm-commits@vger.kernel.org,david@kernel.org,pedrodemargomes@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch added to mm-unstable branch
Message-Id: <20251105235456.94264C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk"
has been added to the -mm mm-unstable branch.  Its filename is
     revert-mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

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

ksm-use-range-walk-function-to-jump-over-holes-in-scan_get_next_rmap_item.patch
revert-mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch
ksm-perform-a-range-walk-in-break_ksm.patch
ksm-replace-function-unmerge_ksm_pages-with-break_ksm.patch

