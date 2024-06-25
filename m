Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45C2142E93
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291655; cv=none; b=JbH3+Ilv+hEd94ZdjRCwYiuY40VwbuuMlDgUB9W6EynJjiTrmbYc562nubl3DBo6JnH0DCIJ+Rp08HeV77UGrgZKr1uHqcpMyDDUHGAjbLpWCof2lolP92eTxe5q/E98P4AsoRFppB5Ow5bFBVSWdv5z1ApFo+Fnidy26mwcy7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291655; c=relaxed/simple;
	bh=+g3LjCQ9voVrOkdDPB/hn6ChlBUtb2gyo09LJz8r2r4=;
	h=Date:To:From:Subject:Message-Id; b=laa5+v2nomGvF8ZlE+JSJ6lOktB0GB+C739gTbKrnK6FsIHd56pLin2+8psn0DCj9zXBT+HBHa+CinfjEkG/cN+MOQOs5oUlpC3vZ99kREqt9ZNAI44u+ceToQe51R6hx2NEdnRLNw0p+sdMtXL3MmBgRbHx0H1fzmzAXTy5GY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qDQrWdcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qDQrWdcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C99C32782;
	Tue, 25 Jun 2024 05:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291655;
	bh=+g3LjCQ9voVrOkdDPB/hn6ChlBUtb2gyo09LJz8r2r4=;
	h=Date:To:From:Subject:From;
	b=qDQrWdcV2qki+ey68/V7wNlXA8Ljoyh4PywJLnz08W4dsqxiXdyRxf9IouSUPKArA
	 7+iH0rXHePZf9ZhIwsjBm6fCrgwJbTaARSkDhD/5AxRd0Zlc7/PTmOY5qBDsXXw6Ww
	 AruyYHycXb++QLlS7A+lP6H2ccOqJlzsy+FggjmY=
Date: Mon, 24 Jun 2024 22:00:55 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.com,kirill.shutemov@linux.intel.com,ioworker0@gmail.com,dan.carpenter@linaro.org,corbet@lwn.net,adobriyan@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-move-page_mapcount-to-fs-proc-internalh.patch removed from -mm tree
Message-Id: <20240625050055.86C99C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc: move page_mapcount() to fs/proc/internal.h
has been removed from the -mm tree.  Its filename was
     fs-proc-move-page_mapcount-to-fs-proc-internalh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc: move page_mapcount() to fs/proc/internal.h
Date: Fri, 7 Jun 2024 14:23:56 +0200

...  and rename it to folio_precise_page_mapcount().  fs/proc is the last
remaining user, and that should stay that way.

While at it, cleanup kpagecount_read() a bit: there are still some legacy
leftovers -- when the interface was introduced it returned the page
refcount, but was changed briefly afterwards to return the page mapcount. 
Further, some simple folio conversion.

Once we stop using the per-page mapcounts of large folios, all
folio_precise_page_mapcount() users will have to implement an alternative
way to achieve what they are trying to achieve, possibly in a less precise
way.

[dan.carpenter@linaro.org: fix uninitialized variable in pagemap_pmd_range()]
  Link: https://lkml.kernel.org/r/9d6eaba7-92f8-4a70-8765-38a519680a87@moroto.mountain
Link: https://lkml.kernel.org/r/20240607122357.115423-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Oscar Salvador <osalvador@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h |   33 +++++++++++++++++++++++++++++++++
 fs/proc/page.c     |   21 ++++++++++-----------
 fs/proc/task_mmu.c |   35 ++++++++++++++++++++++-------------
 include/linux/mm.h |   27 +--------------------------
 4 files changed, 66 insertions(+), 50 deletions(-)

--- a/fs/proc/internal.h~fs-proc-move-page_mapcount-to-fs-proc-internalh
+++ a/fs/proc/internal.h
@@ -13,6 +13,7 @@
 #include <linux/binfmts.h>
 #include <linux/sched/coredump.h>
 #include <linux/sched/task.h>
+#include <linux/mm.h>
 
 struct ctl_table_header;
 struct mempolicy;
@@ -142,6 +143,38 @@ unsigned name_to_int(const struct qstr *
 /* Worst case buffer size needed for holding an integer. */
 #define PROC_NUMBUF 13
 
+/**
+ * folio_precise_page_mapcount() - Number of mappings of this folio page.
+ * @folio: The folio.
+ * @page: The page.
+ *
+ * The number of present user page table entries that reference this page
+ * as tracked via the RMAP: either referenced directly (PTE) or as part of
+ * a larger area that covers this page (e.g., PMD).
+ *
+ * Use this function only for the calculation of existing statistics
+ * (USS, PSS, mapcount_max) and for debugging purposes (/proc/kpagecount).
+ *
+ * Do not add new users.
+ *
+ * Returns: The number of mappings of this folio page. 0 for
+ * folios that are not mapped to user space or are not tracked via the RMAP
+ * (e.g., shared zeropage).
+ */
+static inline int folio_precise_page_mapcount(struct folio *folio,
+		struct page *page)
+{
+	int mapcount = atomic_read(&page->_mapcount) + 1;
+
+	/* Handle page_has_type() pages */
+	if (mapcount < PAGE_MAPCOUNT_RESERVE + 1)
+		mapcount = 0;
+	if (folio_test_large(folio))
+		mapcount += folio_entire_mapcount(folio);
+
+	return mapcount;
+}
+
 /*
  * array.c
  */
--- a/fs/proc/page.c~fs-proc-move-page_mapcount-to-fs-proc-internalh
+++ a/fs/proc/page.c
@@ -37,21 +37,19 @@ static inline unsigned long get_max_dump
 #endif
 }
 
-/* /proc/kpagecount - an array exposing page counts
+/* /proc/kpagecount - an array exposing page mapcounts
  *
  * Each entry is a u64 representing the corresponding
- * physical page count.
+ * physical page mapcount.
  */
 static ssize_t kpagecount_read(struct file *file, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	const unsigned long max_dump_pfn = get_max_dump_pfn();
 	u64 __user *out = (u64 __user *)buf;
-	struct page *ppage;
 	unsigned long src = *ppos;
 	unsigned long pfn;
 	ssize_t ret = 0;
-	u64 pcount;
 
 	pfn = src / KPMSIZE;
 	if (src & KPMMASK || count & KPMMASK)
@@ -61,18 +59,19 @@ static ssize_t kpagecount_read(struct fi
 	count = min_t(unsigned long, count, (max_dump_pfn * KPMSIZE) - src);
 
 	while (count > 0) {
+		struct page *page;
+		u64 mapcount = 0;
+
 		/*
 		 * TODO: ZONE_DEVICE support requires to identify
 		 * memmaps that were actually initialized.
 		 */
-		ppage = pfn_to_online_page(pfn);
-
-		if (!ppage)
-			pcount = 0;
-		else
-			pcount = page_mapcount(ppage);
+		page = pfn_to_online_page(pfn);
+		if (page)
+			mapcount = folio_precise_page_mapcount(page_folio(page),
+							       page);
 
-		if (put_user(pcount, out)) {
+		if (put_user(mapcount, out)) {
 			ret = -EFAULT;
 			break;
 		}
--- a/fs/proc/task_mmu.c~fs-proc-move-page_mapcount-to-fs-proc-internalh
+++ a/fs/proc/task_mmu.c
@@ -488,12 +488,12 @@ static void smaps_account(struct mem_siz
 		return;
 	}
 	/*
-	 * The page_mapcount() is called to get a snapshot of the mapcount.
-	 * Without holding the folio lock this snapshot can be slightly wrong as
-	 * we cannot always read the mapcount atomically.
+	 * We obtain a snapshot of the mapcount. Without holding the folio lock
+	 * this snapshot can be slightly wrong as we cannot always read the
+	 * mapcount atomically.
 	 */
 	for (i = 0; i < nr; i++, page++) {
-		int mapcount = page_mapcount(page);
+		int mapcount = folio_precise_page_mapcount(folio, page);
 		unsigned long pss = PAGE_SIZE << PSS_SHIFT;
 		if (mapcount >= 2)
 			pss /= mapcount;
@@ -1424,6 +1424,7 @@ static pagemap_entry_t pte_to_pagemap_en
 {
 	u64 frame = 0, flags = 0;
 	struct page *page = NULL;
+	struct folio *folio;
 
 	if (pte_present(pte)) {
 		if (pm->show_pfn)
@@ -1461,10 +1462,14 @@ static pagemap_entry_t pte_to_pagemap_en
 			flags |= PM_UFFD_WP;
 	}
 
-	if (page && !PageAnon(page))
-		flags |= PM_FILE;
-	if (page && (flags & PM_PRESENT) && page_mapcount(page) == 1)
-		flags |= PM_MMAP_EXCLUSIVE;
+	if (page) {
+		folio = page_folio(page);
+		if (!folio_test_anon(folio))
+			flags |= PM_FILE;
+		if ((flags & PM_PRESENT) &&
+		    folio_precise_page_mapcount(folio, page) == 1)
+			flags |= PM_MMAP_EXCLUSIVE;
+	}
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
 
@@ -1487,6 +1492,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		u64 flags = 0, frame = 0;
 		pmd_t pmd = *pmdp;
 		struct page *page = NULL;
+		struct folio *folio = NULL;
 
 		if (vma->vm_flags & VM_SOFTDIRTY)
 			flags |= PM_SOFT_DIRTY;
@@ -1525,15 +1531,18 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		}
 #endif
 
-		if (page && !PageAnon(page))
-			flags |= PM_FILE;
+		if (page) {
+			folio = page_folio(page);
+			if (!folio_test_anon(folio))
+				flags |= PM_FILE;
+		}
 
 		for (; addr != end; addr += PAGE_SIZE, idx++) {
 			unsigned long cur_flags = flags;
 			pagemap_entry_t pme;
 
-			if (page && (flags & PM_PRESENT) &&
-			    page_mapcount(page + idx) == 1)
+			if (folio && (flags & PM_PRESENT) &&
+			    folio_precise_page_mapcount(folio, page + idx) == 1)
 				cur_flags |= PM_MMAP_EXCLUSIVE;
 
 			pme = make_pme(frame, cur_flags);
@@ -2572,7 +2581,7 @@ static void gather_stats(struct page *pa
 			unsigned long nr_pages)
 {
 	struct folio *folio = page_folio(page);
-	int count = page_mapcount(page);
+	int count = folio_precise_page_mapcount(folio, page);
 
 	md->pages += nr_pages;
 	if (pte_dirty || folio_test_dirty(folio))
--- a/include/linux/mm.h~fs-proc-move-page_mapcount-to-fs-proc-internalh
+++ a/include/linux/mm.h
@@ -1197,8 +1197,7 @@ static inline int is_vmalloc_or_module_a
 /*
  * How many times the entire folio is mapped as a single unit (eg by a
  * PMD or PUD entry).  This is probably not what you want, except for
- * debugging purposes - it does not include PTE-mapped sub-pages; look
- * at folio_mapcount() or page_mapcount() instead.
+ * debugging purposes or implementation of other core folio_*() primitives.
  */
 static inline int folio_entire_mapcount(const struct folio *folio)
 {
@@ -1216,30 +1215,6 @@ static inline void page_mapcount_reset(s
 	atomic_set(&(page)->_mapcount, -1);
 }
 
-/**
- * page_mapcount() - Number of times this precise page is mapped.
- * @page: The page.
- *
- * The number of times this page is mapped.  If this page is part of
- * a large folio, it includes the number of times this page is mapped
- * as part of that folio.
- *
- * Will report 0 for pages which cannot be mapped into userspace, eg
- * slab, page tables and similar.
- */
-static inline int page_mapcount(struct page *page)
-{
-	int mapcount = atomic_read(&page->_mapcount) + 1;
-
-	/* Handle page_has_type() pages */
-	if (mapcount < PAGE_MAPCOUNT_RESERVE + 1)
-		mapcount = 0;
-	if (unlikely(PageCompound(page)))
-		mapcount += folio_entire_mapcount(page_folio(page));
-
-	return mapcount;
-}
-
 static inline int folio_large_mapcount(const struct folio *folio)
 {
 	VM_WARN_ON_FOLIO(!folio_test_large(folio), folio);
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

