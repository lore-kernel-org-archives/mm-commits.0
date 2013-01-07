From: akpm@linux-foundation.org
Subject: + mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch added to -mm tree
Date: Mon, 07 Jan 2013 12:06:36 -0800
Message-ID: <20130107200637.266C5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:40819 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab3AGUGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 15:06:38 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so2123001qcq.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 12:06:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shli@kernel.org, hughd@google.com, riel@redhat.com, shli@fusionio.com


The patch titled
     Subject: mm: make madvise(MADV_WILLNEED) support swap file prefetch
has been added to the -mm tree.  Its filename is
     mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: mm: make madvise(MADV_WILLNEED) support swap file prefetch

Make madvise(MADV_WILLNEED) support swap file prefetch.  If memory is
swapout, this syscall can do swapin prefetch.  It has no impact if the
memory isn't swapout.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   94 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff -puN mm/madvise.c~mm-make-madvisemadv_willneed-support-swap-file-prefetch mm/madvise.c
--- a/mm/madvise.c~mm-make-madvisemadv_willneed-support-swap-file-prefetch
+++ a/mm/madvise.c
@@ -16,6 +16,9 @@
 #include <linux/ksm.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/blkdev.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
 
 /*
  * Any behaviour which results in changes to the vma->vm_flags needs to
@@ -131,6 +134,82 @@ out:
 	return error;
 }
 
+static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
+	unsigned long end, struct mm_walk *walk)
+{
+	pte_t *orig_pte;
+	struct vm_area_struct *vma = walk->private;
+	unsigned long index;
+
+	if (pmd_none_or_trans_huge_or_clear_bad(pmd))
+		return 0;
+
+	for (index = start; index != end; index += PAGE_SIZE) {
+		pte_t pte;
+		swp_entry_t entry;
+		struct page *page;
+		spinlock_t *ptl;
+
+		orig_pte = pte_offset_map_lock(vma->vm_mm, pmd, start, &ptl);
+		pte = *(orig_pte + ((index - start) / PAGE_SIZE));
+		pte_unmap_unlock(orig_pte, ptl);
+
+		if (pte_present(pte) || pte_none(pte) || pte_file(pte))
+			continue;
+		entry = pte_to_swp_entry(pte);
+		if (unlikely(non_swap_entry(entry)))
+			continue;
+
+		page = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
+								vma, index);
+		if (page)
+			page_cache_release(page);
+	}
+
+	return 0;
+}
+
+static void force_swapin_readahead(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end)
+{
+	struct mm_walk walk = {
+		.mm = vma->vm_mm,
+		.pmd_entry = swapin_walk_pmd_entry,
+		.private = vma,
+	};
+
+	walk_page_range(start, end, &walk);
+
+	lru_add_drain();	/* Push any new pages onto the LRU now */
+}
+
+static void force_shm_swapin_readahead(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		struct address_space *mapping)
+{
+	pgoff_t index;
+	struct page *page;
+	swp_entry_t swap;
+
+	for (; start < end; start += PAGE_SIZE) {
+		index = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+
+		page = find_get_page(mapping, index);
+		if (!radix_tree_exceptional_entry(page)) {
+			if (page)
+				page_cache_release(page);
+			continue;
+		}
+		swap = radix_to_swp_entry(page);
+		page = read_swap_cache_async(swap, GFP_HIGHUSER_MOVABLE,
+								NULL, 0);
+		if (page)
+			page_cache_release(page);
+	}
+
+	lru_add_drain();	/* Push any new pages onto the LRU now */
+}
+
 /*
  * Schedule all required I/O operations.  Do not wait for completion.
  */
@@ -140,6 +219,18 @@ static long madvise_willneed(struct vm_a
 {
 	struct file *file = vma->vm_file;
 
+#ifdef CONFIG_SWAP
+	if (!file || mapping_cap_swap_backed(file->f_mapping)) {
+		*prev = vma;
+		if (!file)
+			force_swapin_readahead(vma, start, end);
+		else
+			force_shm_swapin_readahead(vma, start, end,
+						file->f_mapping);
+		return 0;
+	}
+#endif
+
 	if (!file)
 		return -EBADF;
 
@@ -371,6 +462,7 @@ SYSCALL_DEFINE3(madvise, unsigned long, 
 	int error = -EINVAL;
 	int write;
 	size_t len;
+	struct blk_plug plug;
 
 #ifdef CONFIG_MEMORY_FAILURE
 	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
@@ -410,6 +502,7 @@ SYSCALL_DEFINE3(madvise, unsigned long, 
 	if (vma && start > vma->vm_start)
 		prev = vma;
 
+	blk_start_plug(&plug);
 	for (;;) {
 		/* Still start < end. */
 		error = -ENOMEM;
@@ -445,6 +538,7 @@ SYSCALL_DEFINE3(madvise, unsigned long, 
 			vma = find_vma(current->mm, start);
 	}
 out:
+	blk_finish_plug(&plug);
 	if (write)
 		up_write(&current->mm->mmap_sem);
 	else
_

Patches currently in -mm which might be from shli@kernel.org are

linux-next.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch

