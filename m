From: akpm@linux-foundation.org
Subject: [merged]
 mm-return-void-from-various-readahead-functions.patch removed from -mm tree
Date: Tue, 02 Jun 2020 14:38:08 -0700
Message-ID: <20200602213808.18-vJBpgk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgFBViK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:38:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, dchinner@redhat.com, ebiggers@google.com, gaoxiang25@huawei.com, hch@lst.de, jaegeuk@kernel.org, jhubbard@nvidia.com, johannes.thumshirn@wdc.com, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org, mszeredi@redhat.com, william.kucharski@oracle.com, willy@infradead.org, xiyou.wangcong@gmail.com, yuchao0@huawei.com, ziy@nvidia.com


The patch titled
     Subject: mm: return void from various readahead functions
has been removed from the -mm tree.  Its filename was
     mm-return-void-from-various-readahead-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: return void from various readahead functions

ondemand_readahead has two callers, neither of which use the return value.
That means that both ra_submit and __do_page_cache_readahead() can return
void, and we don't need to worry that a present page in the readahead
window causes us to return a smaller nr_pages than we ought to have.

Similarly, no caller uses the return value from
force_page_cache_readahead().

Link: http://lkml.kernel.org/r/20200414150233.24495-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Gao Xiang <gaoxiang25@huawei.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c   |    4 ----
 mm/internal.h  |   12 ++++++------
 mm/readahead.c |   31 +++++++++++++------------------
 3 files changed, 19 insertions(+), 28 deletions(-)

--- a/mm/fadvise.c~mm-return-void-from-various-readahead-functions
+++ a/mm/fadvise.c
@@ -104,10 +104,6 @@ int generic_fadvise(struct file *file, l
 		if (!nrpages)
 			nrpages = ~0UL;
 
-		/*
-		 * Ignore return value because fadvise() shall return
-		 * success even if filesystem can't retrieve a hint,
-		 */
 		force_page_cache_readahead(mapping, file, start_index, nrpages);
 		break;
 	case POSIX_FADV_NOREUSE:
--- a/mm/internal.h~mm-return-void-from-various-readahead-functions
+++ a/mm/internal.h
@@ -49,20 +49,20 @@ void unmap_page_range(struct mmu_gather
 			     unsigned long addr, unsigned long end,
 			     struct zap_details *details);
 
-int force_page_cache_readahead(struct address_space *, struct file *,
+void force_page_cache_readahead(struct address_space *, struct file *,
 		pgoff_t index, unsigned long nr_to_read);
-extern unsigned int __do_page_cache_readahead(struct address_space *mapping,
-		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
+void __do_page_cache_readahead(struct address_space *, struct file *,
+		pgoff_t index, unsigned long nr_to_read,
 		unsigned long lookahead_size);
 
 /*
  * Submit IO for the read-ahead request in file_ra_state.
  */
-static inline unsigned long ra_submit(struct file_ra_state *ra,
+static inline void ra_submit(struct file_ra_state *ra,
 		struct address_space *mapping, struct file *filp)
 {
-	return __do_page_cache_readahead(mapping, filp,
-					ra->start, ra->size, ra->async_size);
+	__do_page_cache_readahead(mapping, filp,
+			ra->start, ra->size, ra->async_size);
 }
 
 /**
--- a/mm/readahead.c~mm-return-void-from-various-readahead-functions
+++ a/mm/readahead.c
@@ -149,10 +149,8 @@ out:
  * the pages first, then submits them for I/O. This avoids the very bad
  * behaviour which would occur if page allocations are causing VM writeback.
  * We really don't want to intermingle reads and writes like that.
- *
- * Returns the number of pages requested, or the maximum amount of I/O allowed.
  */
-unsigned int __do_page_cache_readahead(struct address_space *mapping,
+void __do_page_cache_readahead(struct address_space *mapping,
 		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
 		unsigned long lookahead_size)
 {
@@ -166,7 +164,7 @@ unsigned int __do_page_cache_readahead(s
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
 
 	if (isize == 0)
-		goto out;
+		return;
 
 	end_index = ((isize - 1) >> PAGE_SHIFT);
 
@@ -211,23 +209,21 @@ unsigned int __do_page_cache_readahead(s
 	if (nr_pages)
 		read_pages(mapping, filp, &page_pool, nr_pages, gfp_mask);
 	BUG_ON(!list_empty(&page_pool));
-out:
-	return nr_pages;
 }
 
 /*
  * Chunk the readahead into 2 megabyte units, so that we don't pin too much
  * memory at once.
  */
-int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			       pgoff_t offset, unsigned long nr_to_read)
+void force_page_cache_readahead(struct address_space *mapping,
+		struct file *filp, pgoff_t offset, unsigned long nr_to_read)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
 	struct file_ra_state *ra = &filp->f_ra;
 	unsigned long max_pages;
 
 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
-		return -EINVAL;
+		return;
 
 	/*
 	 * If the request exceeds the readahead window, allow the read to
@@ -245,7 +241,6 @@ int force_page_cache_readahead(struct ad
 		offset += this_chunk;
 		nr_to_read -= this_chunk;
 	}
-	return 0;
 }
 
 /*
@@ -378,11 +373,10 @@ static int try_context_readahead(struct
 /*
  * A minimal readahead algorithm for trivial sequential/random reads.
  */
-static unsigned long
-ondemand_readahead(struct address_space *mapping,
-		   struct file_ra_state *ra, struct file *filp,
-		   bool hit_readahead_marker, pgoff_t offset,
-		   unsigned long req_size)
+static void ondemand_readahead(struct address_space *mapping,
+		struct file_ra_state *ra, struct file *filp,
+		bool hit_readahead_marker, pgoff_t offset,
+		unsigned long req_size)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
 	unsigned long max_pages = ra->ra_pages;
@@ -428,7 +422,7 @@ ondemand_readahead(struct address_space
 		rcu_read_unlock();
 
 		if (!start || start - offset > max_pages)
-			return 0;
+			return;
 
 		ra->start = start;
 		ra->size = start - offset;	/* old async_size */
@@ -464,7 +458,8 @@ ondemand_readahead(struct address_space
 	 * standalone, small random read
 	 * Read as is, and do not pollute the readahead state.
 	 */
-	return __do_page_cache_readahead(mapping, filp, offset, req_size, 0);
+	__do_page_cache_readahead(mapping, filp, offset, req_size, 0);
+	return;
 
 initial_readahead:
 	ra->start = offset;
@@ -489,7 +484,7 @@ readit:
 		}
 	}
 
-	return ra_submit(ra, mapping, filp);
+	ra_submit(ra, mapping, filp);
 }
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are

mm-simplify-calling-a-compound-page-destructor.patch
ipc-convert-ipcs_idr-to-xarray.patch
ipc-convert-ipcs_idr-to-xarray-update.patch
