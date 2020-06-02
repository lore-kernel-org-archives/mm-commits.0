From: akpm@linux-foundation.org
Subject: [merged] mm-move-readahead-prototypes-from-mmh.patch
 removed from -mm tree
Date: Tue, 02 Jun 2020 14:38:05 -0700
Message-ID: <20200602213805.dBTGypGzY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgFBViG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:38:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, dchinner@redhat.com, ebiggers@google.com, gaoxiang25@huawei.com, hch@lst.de, jaegeuk@kernel.org, jhubbard@nvidia.com, johannes.thumshirn@wdc.com, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org, mszeredi@redhat.com, william.kucharski@oracle.com, willy@infradead.org, xiyou.wangcong@gmail.com, yuchao0@huawei.com, ziy@nvidia.com


The patch titled
     Subject: mm: move readahead prototypes from mm.h
has been removed from the -mm tree.  Its filename was
     mm-move-readahead-prototypes-from-mmh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move readahead prototypes from mm.h

Patch series "Change readahead API", v11.

This series adds a readahead address_space operation to replace the
readpages operation.  The key difference is that pages are added to the
page cache as they are allocated (and then looked up by the filesystem)
instead of passing them on a list to the readpages operation and having
the filesystem add them to the page cache.  It's a net reduction in code
for each implementation, more efficient than walking a list, and solves
the direct-write vs buffered-read problem reported by yu kuai at
http://lkml.kernel.org/r/20200116063601.39201-1-yukuai3@huawei.com

The only unconverted filesystems are those which use fscache.  Their
conversion is pending Dave Howells' rewrite which will make the conversion
substantially easier.  This should be completed by the end of the year.

I want to thank the reviewers/testers; Dave Chinner, John Hubbard, Eric
Biggers, Johannes Thumshirn, Dave Sterba, Zi Yan, Christoph Hellwig and
Miklos Szeredi have done a marvellous job of providing constructive
criticism.

These patches pass an xfstests run on ext4, xfs & btrfs with no
regressions that I can tell (some of the tests seem a little flaky before
and remain flaky afterwards).


This patch (of 25):

The readahead code is part of the page cache so should be found in the
pagemap.h file.  force_page_cache_readahead is only used within mm, so
move it to mm/internal.h instead.  Remove the parameter names where they
add no value, and rename the ones which were actively misleading.

Link: http://lkml.kernel.org/r/20200414150233.24495-1-willy@infradead.org
Link: http://lkml.kernel.org/r/20200414150233.24495-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Gao Xiang <gaoxiang25@huawei.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c        |    1 +
 include/linux/mm.h      |   19 -------------------
 include/linux/pagemap.h |    8 ++++++++
 mm/fadvise.c            |    2 ++
 mm/internal.h           |    2 ++
 5 files changed, 13 insertions(+), 19 deletions(-)

--- a/block/blk-core.c~mm-move-readahead-prototypes-from-mmh
+++ a/block/blk-core.c
@@ -20,6 +20,7 @@
 #include <linux/blk-mq.h>
 #include <linux/highmem.h>
 #include <linux/mm.h>
+#include <linux/pagemap.h>
 #include <linux/kernel_stat.h>
 #include <linux/string.h>
 #include <linux/init.h>
--- a/include/linux/mm.h~mm-move-readahead-prototypes-from-mmh
+++ a/include/linux/mm.h
@@ -2608,25 +2608,6 @@ extern vm_fault_t filemap_page_mkwrite(s
 int __must_check write_one_page(struct page *page);
 void task_dirty_inc(struct task_struct *tsk);
 
-/* readahead.c */
-#define VM_READAHEAD_PAGES	(SZ_128K / PAGE_SIZE)
-
-int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			pgoff_t offset, unsigned long nr_to_read);
-
-void page_cache_sync_readahead(struct address_space *mapping,
-			       struct file_ra_state *ra,
-			       struct file *filp,
-			       pgoff_t offset,
-			       unsigned long size);
-
-void page_cache_async_readahead(struct address_space *mapping,
-				struct file_ra_state *ra,
-				struct file *filp,
-				struct page *pg,
-				pgoff_t offset,
-				unsigned long size);
-
 extern unsigned long stack_guard_gap;
 /* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
--- a/include/linux/pagemap.h~mm-move-readahead-prototypes-from-mmh
+++ a/include/linux/pagemap.h
@@ -618,6 +618,14 @@ int replace_page_cache_page(struct page
 void delete_from_page_cache_batch(struct address_space *mapping,
 				  struct pagevec *pvec);
 
+#define VM_READAHEAD_PAGES	(SZ_128K / PAGE_SIZE)
+
+void page_cache_sync_readahead(struct address_space *, struct file_ra_state *,
+		struct file *, pgoff_t index, unsigned long req_count);
+void page_cache_async_readahead(struct address_space *, struct file_ra_state *,
+		struct file *, struct page *, pgoff_t index,
+		unsigned long req_count);
+
 /*
  * Like add_to_page_cache_locked, but used to add newly allocated pages:
  * the page is new, so we can just run __SetPageLocked() against it.
--- a/mm/fadvise.c~mm-move-readahead-prototypes-from-mmh
+++ a/mm/fadvise.c
@@ -22,6 +22,8 @@
 
 #include <asm/unistd.h>
 
+#include "internal.h"
+
 /*
  * POSIX_FADV_WILLNEED could set PG_Referenced, and POSIX_FADV_NOREUSE could
  * deactivate the pages and clear PG_Referenced.
--- a/mm/internal.h~mm-move-readahead-prototypes-from-mmh
+++ a/mm/internal.h
@@ -49,6 +49,8 @@ void unmap_page_range(struct mmu_gather
 			     unsigned long addr, unsigned long end,
 			     struct zap_details *details);
 
+int force_page_cache_readahead(struct address_space *, struct file *,
+		pgoff_t index, unsigned long nr_to_read);
 extern unsigned int __do_page_cache_readahead(struct address_space *mapping,
 		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
 		unsigned long lookahead_size);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-simplify-calling-a-compound-page-destructor.patch
ipc-convert-ipcs_idr-to-xarray.patch
ipc-convert-ipcs_idr-to-xarray-update.patch
