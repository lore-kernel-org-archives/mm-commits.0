Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E553A59
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188187; cv=none; b=HXeZErGJ/wFHUvkcE8IBgXZ++BRk6X2Zek7ZsG5VUJMrDRhNImMW6pivMFpwl3Mv+b6v1WJOp4U6A9STyLefxhHAd/T5+fSM21yn9QGWSlkHXi6HntQAiPP+hGwHs7atS7O/e3zW1MFiNnSQ00bnoQ88rQVH9Kjsku2wun8/SN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188187; c=relaxed/simple;
	bh=cU2eTBMXDIoWp1ClbWB90CraiyByjsYlI0VntRHXc20=;
	h=Date:To:From:Subject:Message-Id; b=onebZonypYQPOVbVpymgHattmPVfPZlWsYMje+HsAXf/LMVJCIAIXza1524LPh9U2mqvISuv/ZcBxFXBUs8efW8xCh7RiTnZlmdX22N94Y4U+FlZBP3Gtoj4bqS5aGhGDtwLS/Z5JVCd2cLarkNnIprNBVkaqA9RuBUPg4IdRYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TFRr1gKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TFRr1gKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FA7C4CEEC;
	Mon, 17 Mar 2025 05:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188187;
	bh=cU2eTBMXDIoWp1ClbWB90CraiyByjsYlI0VntRHXc20=;
	h=Date:To:From:Subject:From;
	b=TFRr1gKv7p1XPGDySpboodM00wrSo7zF8jWAxldaGN1SVjZDeLgMi/SfcLQv1oRj3
	 CpxSLxs43SH1i+2HVR2/Vh8Po/jkh5PuDly97SJAJgnkzHEITu60Dtyix2JNZAk6bu
	 EDHFcwymh7yaZx6bHmJ8XDBDlJOv3NhfjM79mH1o=
Date: Sun, 16 Mar 2025 22:09:46 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,sj@kernel.org,si.yanteng@linux.dev,simona.vetter@ffwll.ch,peterz@infradead.org,peterx@redhat.com,pasha.tatashin@soleen.com,oleg@redhat.com,mhiramat@kernel.org,lyude@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kherbst@redhat.com,jhubbard@nvidia.com,jglisse@redhat.com,jgg@nvidia.com,jannh@google.com,dakr@kernel.org,corbet@lwn.net,apopple@nvidia.com,alexs@kernel.org,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive.patch removed from -mm tree
Message-Id: <20250317050947.68FA7C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: convert make_device_exclusive_range() to make_device_exclusive()
has been removed from the -mm tree.  Its filename was
     mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: convert make_device_exclusive_range() to make_device_exclusive()
Date: Mon, 10 Feb 2025 20:37:45 +0100

The single "real" user in the tree of make_device_exclusive_range() always
requests making only a single address exclusive.  The current
implementation is hard to fix for properly supporting anonymous THP /
large folios and for avoiding messing with rmap walks in weird ways.

So let's always process a single address/page and return folio + page to
minimize page -> folio lookups.  This is a preparation for further
changes.

Reject any non-anonymous or hugetlb folios early, directly after GUP.

While at it, extend the documentation of make_device_exclusive() to
clarify some things.

Link: https://lkml.kernel.org/r/20250210193801.781278-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Simona Vetter <simona.vetter@ffwll.ch>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Alistair Popple <apopple@nvidia.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lyude <lyude@redhat.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/hmm.rst                    |    2 
 Documentation/translations/zh_CN/mm/hmm.rst |    2 
 drivers/gpu/drm/nouveau/nouveau_svm.c       |    5 
 include/linux/mmu_notifier.h                |    2 
 include/linux/rmap.h                        |    5 
 lib/test_hmm.c                              |   43 ++-----
 mm/rmap.c                                   |  105 ++++++++++--------
 7 files changed, 85 insertions(+), 79 deletions(-)

--- a/Documentation/mm/hmm.rst~mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive
+++ a/Documentation/mm/hmm.rst
@@ -400,7 +400,7 @@ Exclusive access memory
 Some devices have features such as atomic PTE bits that can be used to implement
 atomic access to system memory. To support atomic operations to a shared virtual
 memory page such a device needs access to that page which is exclusive of any
-userspace access from the CPU. The ``make_device_exclusive_range()`` function
+userspace access from the CPU. The ``make_device_exclusive()`` function
 can be used to make a memory range inaccessible from userspace.
 
 This replaces all mappings for pages in the given range with special swap
--- a/Documentation/translations/zh_CN/mm/hmm.rst~mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive
+++ a/Documentation/translations/zh_CN/mm/hmm.rst
@@ -326,7 +326,7 @@ 独占访问存储器
 
 一些设备具有诸如原子PTE位的功能，可以用来实现对系统内存的原子访问。为了支持对一
 个共享的虚拟内存页的原子操作，这样的设备需要对该页的访问是排他的，而不是来自CPU
-的任何用户空间访问。  ``make_device_exclusive_range()`` 函数可以用来使一
+的任何用户空间访问。  ``make_device_exclusive()`` 函数可以用来使一
 个内存范围不能从用户空间访问。
 
 这将用特殊的交换条目替换给定范围内的所有页的映射。任何试图访问交换条目的行为都会
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c~mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive
+++ a/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -610,10 +610,9 @@ static int nouveau_atomic_range_fault(st
 
 		notifier_seq = mmu_interval_read_begin(&notifier->notifier);
 		mmap_read_lock(mm);
-		ret = make_device_exclusive_range(mm, start, start + PAGE_SIZE,
-					    &page, drm->dev);
+		page = make_device_exclusive(mm, start, drm->dev, &folio);
 		mmap_read_unlock(mm);
-		if (ret <= 0 || !page) {
+		if (IS_ERR(page)) {
 			ret = -EINVAL;
 			goto out;
 		}
--- a/include/linux/mmu_notifier.h~mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive
+++ a/include/linux/mmu_notifier.h
@@ -46,7 +46,7 @@ struct mmu_interval_notifier;
  * @MMU_NOTIFY_EXCLUSIVE: to signal a device driver that the device will no
  * longer have exclusive access to the page. When sent during creation of an
  * exclusive range the owner will be initialised to the value provided by the
- * caller of make_device_exclusive_range(), otherwise the owner will be NULL.
+ * caller of make_device_exclusive(), otherwise the owner will be NULL.
  */
 enum mmu_notifier_event {
 	MMU_NOTIFY_UNMAP = 0,
--- a/include/linux/rmap.h~mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive
+++ a/include/linux/rmap.h
@@ -663,9 +663,8 @@ int folio_referenced(struct folio *, int
 void try_to_migrate(struct folio *folio, enum ttu_flags flags);
 void try_to_unmap(struct folio *, enum ttu_flags flags);
 
-int make_device_exclusive_range(struct mm_struct *mm, unsigned long start,
-				unsigned long end, struct page **pages,
-				void *arg);
+struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
+		void *owner, struct folio **foliop);
 
 /* Avoid racy checks */
 #define PVMW_SYNC		(1 << 0)
--- a/lib/test_hmm.c~mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive
+++ a/lib/test_hmm.c
@@ -780,10 +780,8 @@ static int dmirror_exclusive(struct dmir
 	unsigned long start, end, addr;
 	unsigned long size = cmd->npages << PAGE_SHIFT;
 	struct mm_struct *mm = dmirror->notifier.mm;
-	struct page *pages[64];
 	struct dmirror_bounce bounce;
-	unsigned long next;
-	int ret;
+	int ret = 0;
 
 	start = cmd->addr;
 	end = start + size;
@@ -795,36 +793,27 @@ static int dmirror_exclusive(struct dmir
 		return -EINVAL;
 
 	mmap_read_lock(mm);
-	for (addr = start; addr < end; addr = next) {
-		unsigned long mapped = 0;
-		int i;
-
-		next = min(end, addr + (ARRAY_SIZE(pages) << PAGE_SHIFT));
-
-		ret = make_device_exclusive_range(mm, addr, next, pages, NULL);
-		/*
-		 * Do dmirror_atomic_map() iff all pages are marked for
-		 * exclusive access to avoid accessing uninitialized
-		 * fields of pages.
-		 */
-		if (ret == (next - addr) >> PAGE_SHIFT)
-			mapped = dmirror_atomic_map(addr, next, pages, dmirror);
-		for (i = 0; i < ret; i++) {
-			if (pages[i]) {
-				unlock_page(pages[i]);
-				put_page(pages[i]);
-			}
+	for (addr = start; !ret && addr < end; addr += PAGE_SIZE) {
+		struct folio *folio;
+		struct page *page;
+
+		page = make_device_exclusive(mm, addr, NULL, &folio);
+		if (IS_ERR(page)) {
+			ret = PTR_ERR(page);
+			break;
 		}
 
-		if (addr + (mapped << PAGE_SHIFT) < next) {
-			mmap_read_unlock(mm);
-			mmput(mm);
-			return -EBUSY;
-		}
+		ret = dmirror_atomic_map(addr, addr + PAGE_SIZE, &page, dmirror);
+		ret = ret == 1 ? 0 : -EBUSY;
+		folio_unlock(folio);
+		folio_put(folio);
 	}
 	mmap_read_unlock(mm);
 	mmput(mm);
 
+	if (ret)
+		return ret;
+
 	/* Return the migrated data for verification. */
 	ret = dmirror_bounce_init(&bounce, start, size);
 	if (ret)
--- a/mm/rmap.c~mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive
+++ a/mm/rmap.c
@@ -2495,70 +2495,89 @@ static bool folio_make_device_exclusive(
 		.arg = &args,
 	};
 
-	/*
-	 * Restrict to anonymous folios for now to avoid potential writeback
-	 * issues.
-	 */
-	if (!folio_test_anon(folio) || folio_test_hugetlb(folio))
-		return false;
-
 	rmap_walk(folio, &rwc);
 
 	return args.valid && !folio_mapcount(folio);
 }
 
 /**
- * make_device_exclusive_range() - Mark a range for exclusive use by a device
+ * make_device_exclusive() - Mark a page for exclusive use by a device
  * @mm: mm_struct of associated target process
- * @start: start of the region to mark for exclusive device access
- * @end: end address of region
- * @pages: returns the pages which were successfully marked for exclusive access
+ * @addr: the virtual address to mark for exclusive device access
  * @owner: passed to MMU_NOTIFY_EXCLUSIVE range notifier to allow filtering
+ * @foliop: folio pointer will be stored here on success.
  *
- * Returns: number of pages found in the range by GUP. A page is marked for
- * exclusive access only if the page pointer is non-NULL.
+ * This function looks up the page mapped at the given address, grabs a
+ * folio reference, locks the folio and replaces the PTE with special
+ * device-exclusive PFN swap entry, preventing access through the process
+ * page tables. The function will return with the folio locked and referenced.
  *
- * This function finds ptes mapping page(s) to the given address range, locks
- * them and replaces mappings with special swap entries preventing userspace CPU
- * access. On fault these entries are replaced with the original mapping after
- * calling MMU notifiers.
+ * On fault, the device-exclusive entries are replaced with the original PTE
+ * under folio lock, after calling MMU notifiers.
+ *
+ * Only anonymous non-hugetlb folios are supported and the VMA must have
+ * write permissions such that we can fault in the anonymous page writable
+ * in order to mark it exclusive. The caller must hold the mmap_lock in read
+ * mode.
  *
  * A driver using this to program access from a device must use a mmu notifier
  * critical section to hold a device specific lock during programming. Once
- * programming is complete it should drop the page lock and reference after
+ * programming is complete it should drop the folio lock and reference after
  * which point CPU access to the page will revoke the exclusive access.
+ *
+ * Notes:
+ *   #. This function always operates on individual PTEs mapping individual
+ *      pages. PMD-sized THPs are first remapped to be mapped by PTEs before
+ *      the conversion happens on a single PTE corresponding to @addr.
+ *   #. While concurrent access through the process page tables is prevented,
+ *      concurrent access through other page references (e.g., earlier GUP
+ *      invocation) is not handled and not supported.
+ *   #. device-exclusive entries are considered "clean" and "old" by core-mm.
+ *      Device drivers must update the folio state when informed by MMU
+ *      notifiers.
+ *
+ * Returns: pointer to mapped page on success, otherwise a negative error.
  */
-int make_device_exclusive_range(struct mm_struct *mm, unsigned long start,
-				unsigned long end, struct page **pages,
-				void *owner)
+struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
+		void *owner, struct folio **foliop)
 {
-	long npages = (end - start) >> PAGE_SHIFT;
-	long i;
+	struct folio *folio;
+	struct page *page;
+	long npages;
 
-	npages = get_user_pages_remote(mm, start, npages,
+	mmap_assert_locked(mm);
+
+	/*
+	 * Fault in the page writable and try to lock it; note that if the
+	 * address would already be marked for exclusive use by a device,
+	 * the GUP call would undo that first by triggering a fault.
+	 */
+	npages = get_user_pages_remote(mm, addr, 1,
 				       FOLL_GET | FOLL_WRITE | FOLL_SPLIT_PMD,
-				       pages, NULL);
-	if (npages < 0)
-		return npages;
-
-	for (i = 0; i < npages; i++, start += PAGE_SIZE) {
-		struct folio *folio = page_folio(pages[i]);
-		if (PageTail(pages[i]) || !folio_trylock(folio)) {
-			folio_put(folio);
-			pages[i] = NULL;
-			continue;
-		}
-
-		if (!folio_make_device_exclusive(folio, mm, start, owner)) {
-			folio_unlock(folio);
-			folio_put(folio);
-			pages[i] = NULL;
-		}
+				       &page, NULL);
+	if (npages != 1)
+		return ERR_PTR(npages);
+	folio = page_folio(page);
+
+	if (!folio_test_anon(folio) || folio_test_hugetlb(folio)) {
+		folio_put(folio);
+		return ERR_PTR(-EOPNOTSUPP);
 	}
 
-	return npages;
+	if (!folio_trylock(folio)) {
+		folio_put(folio);
+		return ERR_PTR(-EBUSY);
+	}
+
+	if (!folio_make_device_exclusive(folio, mm, addr, owner)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return ERR_PTR(-EBUSY);
+	}
+	*foliop = folio;
+	return page;
 }
-EXPORT_SYMBOL_GPL(make_device_exclusive_range);
+EXPORT_SYMBOL_GPL(make_device_exclusive);
 #endif
 
 void __put_anon_vma(struct anon_vma *anon_vma)
_

Patches currently in -mm which might be from david@redhat.com are

mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order.patch
mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix.patch
mm-move-hugetlb-specific-things-in-folio-to-page.patch
mm-move-_pincount-in-folio-to-page-on-32bit.patch
mm-move-_entire_mapcount-in-folio-to-page-on-32bit.patch
mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends.patch
mm-rmap-pass-vma-to-__folio_add_rmap.patch
mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb.patch
bit_spinlock-__always_inline-unlock-functions.patch
mm-rmap-use-folio_large_nr_pages-in-add-remove-functions.patch
mm-rmap-basic-mm-owner-tracking-for-large-folios-hugetlb.patch
mm-copy-on-write-cow-reuse-support-for-pte-mapped-thp.patch
mm-convert-folio_likely_mapped_shared-to-folio_maybe_mapped_shared.patch
mm-config_no_page_mapcount-to-prepare-for-not-maintain-per-page-mapcounts-in-large-folios.patch
fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-pm_mmap_exclusive-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch
mm-stop-maintaining-the-per-page-mapcount-of-large-folios-config_no_page_mapcount.patch

