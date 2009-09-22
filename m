From: akpm@linux-foundation.org
Subject: [merged] mm-add-get_dump_page.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:42:46 -0700
Message-ID: <200909222042.n8MKgkpP010271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978AbZIVUnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: add get_dump_page
has been removed from the -mm tree.  Its filename was
     mm-add-get_dump_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -817,6 +817,7 @@ int get_user_pages(struct task_struct *t
 			struct page **pages, struct vm_area_struct **vmas);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
+struct page *get_dump_page(unsigned long addr);
 
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned long offset);
diff -puN mm/memory.c~mm-add-get_dump_page mm/memory.c
--- a/mm/memory.c~mm-add-get_dump_page
+++ a/mm/memory.c
@@ -1423,9 +1423,40 @@ int get_user_pages(struct task_struct *t
 
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

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
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
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

