From: akpm@linux-foundation.org
Subject: [merged]
 mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 14:33:51 -0800
Message-ID: <569973cf.mnxBMpF+cHmsPWmU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, david@fromorbit.com, jack@suse.com, mfasheh@suse.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow GFP_{FS,IO} for page_cache_read page cache allocation
has been removed from the -mm tree.  Its filename was
     mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: allow GFP_{FS,IO} for page_cache_read page cache allocation

page_cache_read has been historically using page_cache_alloc_cold to
allocate a new page.  This means that mapping_gfp_mask is used as the base
for the gfp_mask.  Many filesystems are setting this mask to GFP_NOFS to
prevent from fs recursion issues.  page_cache_read is called from the
vm_operations_struct::fault() context during the page fault.  This context
doesn't need the reclaim protection normally.

ceph and ocfs2 which call filemap_fault from their fault handlers seem to
be OK because they are not taking any fs lock before invoking generic
implementation.  xfs which takes XFS_MMAPLOCK_SHARED is safe from the
reclaim recursion POV because this lock serializes truncate and punch hole
with the page faults and it doesn't get involved in the reclaim.

There is simply no reason to deliberately use a weaker allocation context
when a __GFP_FS | __GFP_IO can be used.  The GFP_NOFS protection might be
even harmful.  There is a push to fail GFP_NOFS allocations rather than
loop within allocator indefinitely with a very limited reclaim ability. 
Once we start failing those requests the OOM killer might be triggered
prematurely because the page cache allocation failure is propagated up the
page fault path and end up in pagefault_out_of_memory.

We cannot play with mapping_gfp_mask directly because that would be racy
wrt.  parallel page faults and it might interfere with other users who
really rely on NOFS semantic from the stored gfp_mask.  The mask is also
inode proper so it would even be a layering violation.  What we can do
instead is to push the gfp_mask into struct vm_fault and allow fs layer to
overwrite it should the callback need to be called with a different
allocation context.

Initialize the default to (mapping_gfp_mask | __GFP_FS | __GFP_IO) because
this should be safe from the page fault path normally.  Why do we care
about mapping_gfp_mask at all then?  Because this doesn't hold only
reclaim protection flags but it also might contain zone and movability
restrictions (GFP_DMA32, __GFP_MOVABLE and others) so we have to respect
those.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Jan Kara <jack@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++++
 mm/filemap.c       |    9 ++++-----
 mm/memory.c        |   17 +++++++++++++++++
 3 files changed, 25 insertions(+), 5 deletions(-)

diff -puN include/linux/mm.h~mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation include/linux/mm.h
--- a/include/linux/mm.h~mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation
+++ a/include/linux/mm.h
@@ -236,10 +236,14 @@ extern pgprot_t protection_map[16];
  * ->fault function. The vma's ->fault is responsible for returning a bitmask
  * of VM_FAULT_xxx flags that give details about how the fault was handled.
  *
+ * MM layer fills up gfp_mask for page allocations but fault handler might
+ * alter it if its implementation requires a different allocation context.
+ *
  * pgoff should be used in favour of virtual_address, if possible.
  */
 struct vm_fault {
 	unsigned int flags;		/* FAULT_FLAG_xxx flags */
+	gfp_t gfp_mask;			/* gfp mask to be used for allocations */
 	pgoff_t pgoff;			/* Logical page offset based on vma */
 	void __user *virtual_address;	/* Faulting virtual address */
 
diff -puN mm/filemap.c~mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation mm/filemap.c
--- a/mm/filemap.c~mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation
+++ a/mm/filemap.c
@@ -1812,19 +1812,18 @@ EXPORT_SYMBOL(generic_file_read_iter);
  * This adds the requested page to the page cache if it isn't already there,
  * and schedules an I/O to read in its contents from disk.
  */
-static int page_cache_read(struct file *file, pgoff_t offset)
+static int page_cache_read(struct file *file, pgoff_t offset, gfp_t gfp_mask)
 {
 	struct address_space *mapping = file->f_mapping;
 	struct page *page;
 	int ret;
 
 	do {
-		page = page_cache_alloc_cold(mapping);
+		page = __page_cache_alloc(gfp_mask|__GFP_COLD);
 		if (!page)
 			return -ENOMEM;
 
-		ret = add_to_page_cache_lru(page, mapping, offset,
-				mapping_gfp_constraint(mapping, GFP_KERNEL));
+		ret = add_to_page_cache_lru(page, mapping, offset, gfp_mask & GFP_KERNEL);
 		if (ret == 0)
 			ret = mapping->a_ops->readpage(file, page);
 		else if (ret == -EEXIST)
@@ -2005,7 +2004,7 @@ no_cached_page:
 	 * We're only likely to ever get here if MADV_RANDOM is in
 	 * effect.
 	 */
-	error = page_cache_read(file, offset);
+	error = page_cache_read(file, offset, vmf->gfp_mask);
 
 	/*
 	 * The page we want has now been added to the page cache.
diff -puN mm/memory.c~mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation mm/memory.c
--- a/mm/memory.c~mm-allow-gfp_iofs-for-page_cache_read-page-cache-allocation
+++ a/mm/memory.c
@@ -1938,6 +1938,20 @@ static inline void cow_user_page(struct
 		copy_user_highpage(dst, src, va, vma);
 }
 
+static gfp_t __get_fault_gfp_mask(struct vm_area_struct *vma)
+{
+	struct file *vm_file = vma->vm_file;
+
+	if (vm_file)
+		return mapping_gfp_mask(vm_file->f_mapping) | __GFP_FS | __GFP_IO;
+
+	/*
+	 * Special mappings (e.g. VDSO) do not have any file so fake
+	 * a default GFP_KERNEL for them.
+	 */
+	return GFP_KERNEL;
+}
+
 /*
  * Notify the address space that the page is about to become writable so that
  * it can prohibit this or wait for the page to get into an appropriate state.
@@ -1953,6 +1967,7 @@ static int do_page_mkwrite(struct vm_are
 	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
 	vmf.pgoff = page->index;
 	vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
+	vmf.gfp_mask = __get_fault_gfp_mask(vma);
 	vmf.page = page;
 	vmf.cow_page = NULL;
 
@@ -2757,6 +2772,7 @@ static int __do_fault(struct vm_area_str
 	vmf.pgoff = pgoff;
 	vmf.flags = flags;
 	vmf.page = NULL;
+	vmf.gfp_mask = __get_fault_gfp_mask(vma);
 	vmf.cow_page = cow_page;
 
 	ret = vma->vm_ops->fault(vma, &vmf);
@@ -2923,6 +2939,7 @@ static void do_fault_around(struct vm_ar
 	vmf.pgoff = pgoff;
 	vmf.max_pgoff = max_pgoff;
 	vmf.flags = flags;
+	vmf.gfp_mask = __get_fault_gfp_mask(vma);
 	vma->vm_ops->map_pages(vma, &vmf);
 }
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch
mm-oom-introduce-oom-reaper.patch
mm-oom-introduce-oom-reaper-v4.patch
oom-reaper-handle-anonymous-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch

