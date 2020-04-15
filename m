From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-readahead-prototypes-from-mmh.patch added to
 -mm tree
Date: Tue, 14 Apr 2020 18:17:22 -0700
Message-ID: <20200415011722.rXP73SJzB%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388394AbgDOBRY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Apr 2020 21:17:24 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, dchinner@redhat.com, ebiggers@google.com, gaoxiang25@huawei.com, hch@lst.de, jaegeuk@kernel.org, jhubbard@nvidia.com, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org, william.kucharski@oracle.com, willy@infradead.org, xiyou.wangcong@gmail.com, yuchao0@huawei.com, ziy@nvidia.com


The patch titled
     Subject: mm: move readahead prototypes from mm.h
has been added to the -mm tree.  Its filename is
     mm-move-readahead-prototypes-from-mmh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-readahead-prototypes-from-mmh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-readahead-prototypes-from-mmh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2601,25 +2601,6 @@ extern vm_fault_t filemap_page_mkwrite(s
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
@@ -615,6 +615,14 @@ int replace_page_cache_page(struct page
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

mm-move-readahead-prototypes-from-mmh.patch
mm-return-void-from-various-readahead-functions.patch
mm-ignore-return-value-of-readpages.patch
mm-move-readahead-nr_pages-check-into-read_pages.patch
mm-add-new-readahead_control-api.patch
mm-use-readahead_control-to-pass-arguments.patch
mm-rename-various-offset-parameters-to-index.patch
mm-rename-readahead-loop-variable-to-i.patch
mm-remove-page_offset-from-readahead-loop.patch
mm-put-readahead-pages-in-cache-earlier.patch
mm-add-readahead-address-space-operation.patch
mm-move-end_index-check-out-of-readahead-loop.patch
mm-add-page_cache_readahead_unbounded.patch
mm-document-why-we-dont-set-pagereadahead.patch
mm-use-memalloc_nofs_save-in-readahead-path.patch
fs-convert-mpage_readpages-to-mpage_readahead.patch
btrfs-convert-from-readpages-to-readahead.patch
erofs-convert-uncompressed-files-from-readpages-to-readahead.patch
erofs-convert-compressed-files-from-readpages-to-readahead.patch
ext4-convert-from-readpages-to-readahead.patch
ext4-pass-the-inode-to-ext4_mpage_readpages.patch
f2fs-convert-from-readpages-to-readahead.patch
f2fs-pass-the-inode-to-f2fs_mpage_readpages.patch
fuse-convert-from-readpages-to-readahead.patch
iomap-convert-from-readpages-to-readahead.patch
