Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9E12D7814
	for <mm-commits@vger.kernel.org>; Tue, 28 Oct 2025 22:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761691674; cv=none; b=icxn2Duuub733r6PFBj0k036jqkpSlbvH3bNWYBbhsXJxr4vezUxaf65OFL6YYsfPIfLaG3qmjh0Yo5HIet4m6mj1hIJmCXlsbD4Tts2rQ5jSXqesCuQ4Gk22xxqu68obXR8FIq4rRN4WuNFgAwOXQOfrf6zX9tsiF68V+NHe6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761691674; c=relaxed/simple;
	bh=w5TjEkWf7m8QSVKO4wRx6A8Jf5sXKqvkYxPSUm7GYgA=;
	h=Date:To:From:Subject:Message-Id; b=t1E6pxeYV1FOFrEH39bP9nNcKJnfS1NBO191gypSl3mYDuelSjsHQyXIZ0+Xbg/5+uuEDAnUlZ6KtSVnc6JZI5EYe3xmzsjtdOhBG5GPKJijtsP0Iooa7KP9+FqyIKIoN+mBigOAOjWdo6ZZvq2UxhoEvUoEqBW/Cy1DOa94Yok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wnV3TF4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wnV3TF4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF79C4CEE7;
	Tue, 28 Oct 2025 22:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761691674;
	bh=w5TjEkWf7m8QSVKO4wRx6A8Jf5sXKqvkYxPSUm7GYgA=;
	h=Date:To:From:Subject:From;
	b=wnV3TF4QqLln6BncnCTN/Lxf1kcurWcGDkmpZCVVbS3t8SHJKvjHKSvVgwT5dUrP7
	 0cDQxSxyQsgoTItc2git4VIO6Rx5RMmdJ9nDya1zl7/H8Pl79M9vxAypsgyFfELFeR
	 jL8CRPNKFMPZiENThQ4ZutpuVdENVIKx6PdK/0MQ=
Date: Tue, 28 Oct 2025 15:47:53 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,david@redhat.com,chengming.zhou@linux.dev,pedrodemargomes@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch added to mm-new branch
Message-Id: <20251028224754.2AF79C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk"
has been added to the -mm mm-new branch.  Its filename is
     revert-mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Date: Tue, 28 Oct 2025 10:19:43 -0300

Patch series "ksm: perform a range-walk to jump over holes in break_ksm".

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

Consider the following test program which creates a 32 TiB mapping in
the virtual address space but only populates a single page:

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
PageKsm(page) to folio_test_ksm(page_folio(page)).

This reverts break_ksm() to use walk_page_range_vma() instead of
folio_walk_start().
This will make it easier to later modify break_ksm() to perform a proper
range walk.

Link: https://lkml.kernel.org/r/20251028131945.26445-1-pedrodemargomes@gmail.com
Link: https://lkml.kernel.org/r/20251028131945.26445-2-pedrodemargomes@gmail.com
Link: https://lore.kernel.org/linux-mm/e0886fdf-d198-4130-bd9a-be276c59da37@redhat.com/ [1]
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   63 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 16 deletions(-)

--- a/mm/ksm.c~revert-mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk
+++ a/mm/ksm.c
@@ -607,6 +607,47 @@ static inline bool ksm_test_exit(struct
 	return atomic_read(&mm->mm_users) == 0;
 }
 
+static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
+			struct mm_walk *walk)
+{
+	struct page *page = NULL;
+	spinlock_t *ptl;
+	pte_t *pte;
+	pte_t ptent;
+	int ret;
+
+	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte)
+		return 0;
+	ptent = ptep_get(pte);
+	if (pte_present(ptent)) {
+		page = vm_normal_page(walk->vma, addr, ptent);
+	} else if (!pte_none(ptent)) {
+		swp_entry_t entry = pte_to_swp_entry(ptent);
+
+		/*
+		 * As KSM pages remain KSM pages until freed, no need to wait
+		 * here for migration to end.
+		 */
+		if (is_migration_entry(entry))
+			page = pfn_swap_entry_to_page(entry);
+	}
+	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
+	ret = (page && folio_test_ksm(page_folio(page))) || is_ksm_zero_pte(ptent);
+	pte_unmap_unlock(pte, ptl);
+	return ret;
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
@@ -623,26 +664,16 @@ static inline bool ksm_test_exit(struct
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

