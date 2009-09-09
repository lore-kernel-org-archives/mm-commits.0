From: akpm@linux-foundation.org
Subject: + mm-foll_dump-replace-foll_anon.patch added to -mm tree
Date: Wed, 09 Sep 2009 14:40:53 -0700
Message-ID: <200909092140.n89LesUP001353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937AbZIIVvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 17:51:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     mm: FOLL_DUMP replace FOLL_ANON
has been added to the -mm tree.  Its filename is
     mm-foll_dump-replace-foll_anon.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: FOLL_DUMP replace FOLL_ANON
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

The "FOLL_ANON optimization" and its use_zero_page() test have caused
confusion and bugs: why does it test VM_SHARED? for the very good but
unsatisfying reason that VMware crashed without.  As we look to maybe
reinstating anonymous use of the ZERO_PAGE, we need to sort this out.

Easily done: it's silly for __get_user_pages() and follow_page() to
be guessing whether it's safe to assume that they're being used for
a coredump (which can take a shortcut snapshot where other uses must
handle a fault) - just tell them with GUP_FLAGS_DUMP and FOLL_DUMP.

get_dump_page() doesn't even want a ZERO_PAGE: an error suits fine.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 -
 mm/internal.h      |    1 
 mm/memory.c        |   45 ++++++++++++-------------------------------
 3 files changed, 15 insertions(+), 33 deletions(-)

diff -puN include/linux/mm.h~mm-foll_dump-replace-foll_anon include/linux/mm.h
--- a/include/linux/mm.h~mm-foll_dump-replace-foll_anon
+++ a/include/linux/mm.h
@@ -1238,7 +1238,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_WRITE	0x01	/* check pte is writable */
 #define FOLL_TOUCH	0x02	/* mark page accessed */
 #define FOLL_GET	0x04	/* do get_page on page */
-#define FOLL_ANON	0x08	/* give ZERO_PAGE if no pgtable */
+#define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff -puN mm/internal.h~mm-foll_dump-replace-foll_anon mm/internal.h
--- a/mm/internal.h~mm-foll_dump-replace-foll_anon
+++ a/mm/internal.h
@@ -252,6 +252,7 @@ static inline void mminit_validate_memmo
 
 #define GUP_FLAGS_WRITE		0x01
 #define GUP_FLAGS_FORCE		0x02
+#define GUP_FLAGS_DUMP		0x04
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long start, int len, int flags,
diff -puN mm/memory.c~mm-foll_dump-replace-foll_anon mm/memory.c
--- a/mm/memory.c~mm-foll_dump-replace-foll_anon
+++ a/mm/memory.c
@@ -1174,41 +1174,22 @@ no_page:
 	pte_unmap_unlock(ptep, ptl);
 	if (!pte_none(pte))
 		return page;
-	/* Fall through to ZERO_PAGE handling */
+
 no_page_table:
 	/*
 	 * When core dumping an enormous anonymous area that nobody
-	 * has touched so far, we don't want to allocate page tables.
-	 */
-	if (flags & FOLL_ANON) {
-		page = ZERO_PAGE(0);
-		if (flags & FOLL_GET)
-			get_page(page);
-		BUG_ON(flags & FOLL_WRITE);
-	}
+	 * has touched so far, we don't want to allocate unnecessary pages or
+	 * page tables.  Return error instead of NULL to skip handle_mm_fault,
+	 * then get_dump_page() will return NULL to leave a hole in the dump.
+	 * But we can only make this optimization where a hole would surely
+	 * be zero-filled if handle_mm_fault() actually did handle it.
+	 */
+	if ((flags & FOLL_DUMP) &&
+	    (!vma->vm_ops || !vma->vm_ops->fault))
+		return ERR_PTR(-EFAULT);
 	return page;
 }
 
-/* Can we do the FOLL_ANON optimization? */
-static inline int use_zero_page(struct vm_area_struct *vma)
-{
-	/*
-	 * We don't want to optimize FOLL_ANON for make_pages_present()
-	 * when it tries to page in a VM_LOCKED region. As to VM_SHARED,
-	 * we want to get the page from the page tables to make sure
-	 * that we serialize and update with any other user of that
-	 * mapping.
-	 */
-	if (vma->vm_flags & (VM_LOCKED | VM_SHARED))
-		return 0;
-	/*
-	 * And if we have a fault routine, it's not an anonymous region.
-	 */
-	return !vma->vm_ops || !vma->vm_ops->fault;
-}
-
-
-
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long start, int nr_pages, int flags,
 		     struct page **pages, struct vm_area_struct **vmas)
@@ -1288,8 +1269,8 @@ int __get_user_pages(struct task_struct 
 		foll_flags = FOLL_TOUCH;
 		if (pages)
 			foll_flags |= FOLL_GET;
-		if (!write && use_zero_page(vma))
-			foll_flags |= FOLL_ANON;
+		if (flags & GUP_FLAGS_DUMP)
+			foll_flags |= FOLL_DUMP;
 
 		do {
 			struct page *page;
@@ -1447,7 +1428,7 @@ struct page *get_dump_page(unsigned long
 	struct page *page;
 
 	if (__get_user_pages(current, current->mm, addr, 1,
-				GUP_FLAGS_FORCE, &page, &vma) < 1)
+			GUP_FLAGS_FORCE | GUP_FLAGS_DUMP, &page, &vma) < 1)
 		return NULL;
 	if (page == ZERO_PAGE(0)) {
 		page_cache_release(page);
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

linux-next.patch
acpi-fix-null-bug-for-hid-uid-string-2.patch
vfs-optimize-touch_time-too-fix.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
vfs-seq_file-add-helpers-for-data-filling.patch
vfs-revert-proc-mounts-to-old-behavior-for-unreachable-mountpoints.patch
vfs-no-unreachable-prefix-for-sysvipc-maps-in-proc-pid-maps.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
ksm-rename-kernel_pages_allocated.patch
ksm-move-pages_sharing-updates.patch
ksm-pages_unshared-and-pages_volatile.patch
ksm-break-cow-once-unshared.patch
ksm-keep-quiet-while-list-empty.patch
ksm-five-little-cleanups.patch
ksm-fix-endless-loop-on-oom.patch
ksm-distribute-remove_mm_from_lists.patch
ksm-fix-oom-deadlock.patch
ksm-fix-deadlock-with-munlock-in-exit_mmap.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
ksm-clean-up-obsolete-references.patch
ksm-unmerge-is-an-origin-of-ooms.patch
ksm-mremap-use-err-from-ksm_madvise.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-introduce-page_lru_base_type-fix.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch
mm-munlock-use-follow_page.patch
mm-remove-unused-gup-flags.patch
mm-add-get_dump_page.patch
mm-foll_dump-replace-foll_anon.patch
mm-follow_hugetlb_page-flags.patch
mm-fix-anonymous-dirtying.patch
mm-reinstate-zero_page.patch
mm-foll-flags-for-gup-flags.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

