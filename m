From: akpm@linux-foundation.org
Subject: + mm-add-get_dump_page.patch added to -mm tree
Date: Wed, 09 Sep 2009 14:40:51 -0700
Message-ID: <200909092140.n89Lep1M001342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbZIIVmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 17:42:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     mm: add get_dump_page
has been added to the -mm tree.  Its filename is
     mm-add-get_dump_page.patch

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
Subject: mm: add get_dump_page
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

In preparation for the next patch, add a simple get_dump_page(addr)
interface for the CONFIG_ELF_CORE dumpers to use, instead of calling
get_user_pages() directly.  They're not interested in errors: they
just want to use holes as much as possible, to save space and make
sure that the data is aligned where the headers said it would be.

Oh, and don't use that horrid DUMP_SEEK(off) macro!

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c       |   42 +++++++++---------------------
 fs/binfmt_elf_fdpic.c |   56 +++++++++++++---------------------------
 include/linux/mm.h    |    1 
 mm/memory.c           |   33 ++++++++++++++++++++++-
 4 files changed, 65 insertions(+), 67 deletions(-)

diff -puN fs/binfmt_elf.c~mm-add-get_dump_page fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~mm-add-get_dump_page
+++ a/fs/binfmt_elf.c
@@ -1280,9 +1280,6 @@ static int writenote(struct memelfnote *
 #define DUMP_WRITE(addr, nr)	\
 	if ((size += (nr)) > limit || !dump_write(file, (addr), (nr))) \
 		goto end_coredump;
-#define DUMP_SEEK(off)	\
-	if (!dump_seek(file, (off))) \
-		goto end_coredump;
 
 static void fill_elf_header(struct elfhdr *elf, int segs,
 			    u16 machine, u32 flags, u8 osabi)
@@ -2016,7 +2013,8 @@ static int elf_core_dump(long signr, str
 		goto end_coredump;
 
 	/* Align to page */
-	DUMP_SEEK(dataoff - foffset);
+	if (!dump_seek(file, dataoff - foffset))
+		goto end_coredump;
 
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
@@ -2027,33 +2025,19 @@ static int elf_core_dump(long signr, str
 
 		for (addr = vma->vm_start; addr < end; addr += PAGE_SIZE) {
 			struct page *page;
-			struct vm_area_struct *tmp_vma;
+			int stop;
 
-			if (get_user_pages(current, current->mm, addr, 1, 0, 1,
-						&page, &tmp_vma) <= 0) {
-				DUMP_SEEK(PAGE_SIZE);
-			} else {
-				if (page == ZERO_PAGE(0)) {
-					if (!dump_seek(file, PAGE_SIZE)) {
-						page_cache_release(page);
-						goto end_coredump;
-					}
-				} else {
-					void *kaddr;
-					flush_cache_page(tmp_vma, addr,
-							 page_to_pfn(page));
-					kaddr = kmap(page);
-					if ((size += PAGE_SIZE) > limit ||
-					    !dump_write(file, kaddr,
-					    PAGE_SIZE)) {
-						kunmap(page);
-						page_cache_release(page);
-						goto end_coredump;
-					}
-					kunmap(page);
-				}
+			page = get_dump_page(addr);
+			if (page) {
+				void *kaddr = kmap(page);
+				stop = ((size += PAGE_SIZE) > limit) ||
+					!dump_write(file, kaddr, PAGE_SIZE);
+				kunmap(page);
 				page_cache_release(page);
-			}
+			} else
+				stop = !dump_seek(file, PAGE_SIZE);
+			if (stop)
+				goto end_coredump;
 		}
 	}
 
diff -puN fs/binfmt_elf_fdpic.c~mm-add-get_dump_page fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~mm-add-get_dump_page
+++ a/fs/binfmt_elf_fdpic.c
@@ -1325,9 +1325,6 @@ static int writenote(struct memelfnote *
 #define DUMP_WRITE(addr, nr)	\
 	if ((size += (nr)) > limit || !dump_write(file, (addr), (nr))) \
 		goto end_coredump;
-#define DUMP_SEEK(off)	\
-	if (!dump_seek(file, (off))) \
-		goto end_coredump;
 
 static inline void fill_elf_fdpic_header(struct elfhdr *elf, int segs)
 {
@@ -1518,6 +1515,7 @@ static int elf_fdpic_dump_segments(struc
 			   unsigned long *limit, unsigned long mm_flags)
 {
 	struct vm_area_struct *vma;
+	int err = 0;
 
 	for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
 		unsigned long addr;
@@ -1525,43 +1523,26 @@ static int elf_fdpic_dump_segments(struc
 		if (!maydump(vma, mm_flags))
 			continue;
 
-		for (addr = vma->vm_start;
-		     addr < vma->vm_end;
-		     addr += PAGE_SIZE
-		     ) {
-			struct vm_area_struct *vma;
-			struct page *page;
-
-			if (get_user_pages(current, current->mm, addr, 1, 0, 1,
-					   &page, &vma) <= 0) {
-				DUMP_SEEK(file->f_pos + PAGE_SIZE);
-			}
-			else if (page == ZERO_PAGE(0)) {
-				page_cache_release(page);
-				DUMP_SEEK(file->f_pos + PAGE_SIZE);
-			}
-			else {
-				void *kaddr;
-
-				flush_cache_page(vma, addr, page_to_pfn(page));
-				kaddr = kmap(page);
-				if ((*size += PAGE_SIZE) > *limit ||
-				    !dump_write(file, kaddr, PAGE_SIZE)
-				    ) {
-					kunmap(page);
-					page_cache_release(page);
-					return -EIO;
-				}
+		for (addr = vma->vm_start; addr < vma->vm_end;
+							addr += PAGE_SIZE) {
+			struct page *page = get_dump_page(addr);
+			if (page) {
+				void *kaddr = kmap(page);
+				*size += PAGE_SIZE;
+				if (*size > *limit)
+					err = -EFBIG;
+				else if (!dump_write(file, kaddr, PAGE_SIZE))
+					err = -EIO;
 				kunmap(page);
 				page_cache_release(page);
-			}
+			} else if (!dump_seek(file, file->f_pos + PAGE_SIZE))
+				err = -EFBIG;
+			if (err)
+				goto out;
 		}
 	}
-
-	return 0;
-
-end_coredump:
-	return -EFBIG;
+out:
+	return err;
 }
 #endif
 
@@ -1802,7 +1783,8 @@ static int elf_fdpic_core_dump(long sign
 				goto end_coredump;
 	}
 
-	DUMP_SEEK(dataoff);
+	if (!dump_seek(file, dataoff))
+		goto end_coredump;
 
 	if (elf_fdpic_dump_segments(file, &size, &limit, mm_flags) < 0)
 		goto end_coredump;
diff -puN include/linux/mm.h~mm-add-get_dump_page include/linux/mm.h
--- a/include/linux/mm.h~mm-add-get_dump_page
+++ a/include/linux/mm.h
@@ -824,6 +824,7 @@ int get_user_pages(struct task_struct *t
 			struct page **pages, struct vm_area_struct **vmas);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
+struct page *get_dump_page(unsigned long addr);
 
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned long offset);
diff -puN mm/memory.c~mm-add-get_dump_page mm/memory.c
--- a/mm/memory.c~mm-add-get_dump_page
+++ a/mm/memory.c
@@ -1424,9 +1424,40 @@ int get_user_pages(struct task_struct *t
 
 	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas);
 }
-
 EXPORT_SYMBOL(get_user_pages);
 
+/**
+ * get_dump_page() - pin user page in memory while writing it to core dump
+ * @addr: user address
+ *
+ * Returns struct page pointer of user page pinned for dump,
+ * to be freed afterwards by page_cache_release() or put_page().
+ *
+ * Returns NULL on any kind of failure - a hole must then be inserted into
+ * the corefile, to preserve alignment with its headers; and also returns
+ * NULL wherever the ZERO_PAGE, or an anonymous pte_none, has been found -
+ * allowing a hole to be left in the corefile to save diskspace.
+ *
+ * Called without mmap_sem, but after all other threads have been killed.
+ */
+#ifdef CONFIG_ELF_CORE
+struct page *get_dump_page(unsigned long addr)
+{
+	struct vm_area_struct *vma;
+	struct page *page;
+
+	if (__get_user_pages(current, current->mm, addr, 1,
+				GUP_FLAGS_FORCE, &page, &vma) < 1)
+		return NULL;
+	if (page == ZERO_PAGE(0)) {
+		page_cache_release(page);
+		return NULL;
+	}
+	flush_cache_page(vma, addr, page_to_pfn(page));
+	return page;
+}
+#endif /* CONFIG_ELF_CORE */
+
 pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
 			spinlock_t **ptl)
 {
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

