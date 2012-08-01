From: akpm@linux-foundation.org
Subject: [merged] mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:16:59 -0700
Message-ID: <20120801201700.63CF25C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:47138 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2HAURE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:17:04 -0400
Received: by eaao12 with SMTP id o12so293291eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:17:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, msalter@redhat.com, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add get_kernel_page[s] for pinning of kernel addresses for I/O
has been removed from the -mm tree.  Its filename was
     mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: add get_kernel_page[s] for pinning of kernel addresses for I/O

This patch adds two new APIs get_kernel_pages() and get_kernel_page() that
may be used to pin a vector of kernel addresses for IO.  The initial user
is expected to be NFS for allowing pages to be written to swap using
aops->direct_IO().  Strictly speaking, swap-over-NFS only needs to pin one
page for IO but it makes sense to express the API in terms of a vector and
add a helper for pinning single pages.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Xiaotian Feng <dfeng@redhat.com>
Cc: Mark Salter <msalter@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blk_types.h |    2 +
 include/linux/fs.h        |    2 +
 include/linux/mm.h        |    4 ++
 mm/swap.c                 |   53 ++++++++++++++++++++++++++++++++++++
 4 files changed, 61 insertions(+)

diff -puN include/linux/blk_types.h~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o include/linux/blk_types.h
--- a/include/linux/blk_types.h~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o
+++ a/include/linux/blk_types.h
@@ -160,6 +160,7 @@ enum rq_flag_bits {
 	__REQ_FLUSH_SEQ,	/* request for flush sequence */
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
+	__REQ_KERNEL, 		/* direct IO to kernel pages */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -201,5 +202,6 @@ enum rq_flag_bits {
 #define REQ_IO_STAT		(1 << __REQ_IO_STAT)
 #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
 #define REQ_SECURE		(1 << __REQ_SECURE)
+#define REQ_KERNEL		(1 << __REQ_KERNEL)
 
 #endif /* __LINUX_BLK_TYPES_H */
diff -puN include/linux/fs.h~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o include/linux/fs.h
--- a/include/linux/fs.h~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o
+++ a/include/linux/fs.h
@@ -165,6 +165,8 @@ struct inodes_stat_t {
 #define READ			0
 #define WRITE			RW_MASK
 #define READA			RWA_MASK
+#define KERNEL_READ		(READ|REQ_KERNEL)
+#define KERNEL_WRITE		(WRITE|REQ_KERNEL)
 
 #define READ_SYNC		(READ | REQ_SYNC)
 #define WRITE_SYNC		(WRITE | REQ_SYNC | REQ_NOIDLE)
diff -puN include/linux/mm.h~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o include/linux/mm.h
--- a/include/linux/mm.h~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o
+++ a/include/linux/mm.h
@@ -1019,6 +1019,10 @@ int get_user_pages(struct task_struct *t
 			struct page **pages, struct vm_area_struct **vmas);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
+struct kvec;
+int get_kernel_pages(const struct kvec *iov, int nr_pages, int write,
+			struct page **pages);
+int get_kernel_page(unsigned long start, int write, struct page **pages);
 struct page *get_dump_page(unsigned long addr);
 
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
diff -puN mm/swap.c~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o mm/swap.c
--- a/mm/swap.c~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o
+++ a/mm/swap.c
@@ -236,6 +236,59 @@ void put_pages_list(struct list_head *pa
 }
 EXPORT_SYMBOL(put_pages_list);
 
+/*
+ * get_kernel_pages() - pin kernel pages in memory
+ * @kiov:	An array of struct kvec structures
+ * @nr_segs:	number of segments to pin
+ * @write:	pinning for read/write, currently ignored
+ * @pages:	array that receives pointers to the pages pinned.
+ *		Should be at least nr_segs long.
+ *
+ * Returns number of pages pinned. This may be fewer than the number
+ * requested. If nr_pages is 0 or negative, returns 0. If no pages
+ * were pinned, returns -errno. Each page returned must be released
+ * with a put_page() call when it is finished with.
+ */
+int get_kernel_pages(const struct kvec *kiov, int nr_segs, int write,
+		struct page **pages)
+{
+	int seg;
+
+	for (seg = 0; seg < nr_segs; seg++) {
+		if (WARN_ON(kiov[seg].iov_len != PAGE_SIZE))
+			return seg;
+
+		/* virt_to_page sanity checks the PFN */
+		pages[seg] = virt_to_page(kiov[seg].iov_base);
+		page_cache_get(pages[seg]);
+	}
+
+	return seg;
+}
+EXPORT_SYMBOL_GPL(get_kernel_pages);
+
+/*
+ * get_kernel_page() - pin a kernel page in memory
+ * @start:	starting kernel address
+ * @write:	pinning for read/write, currently ignored
+ * @pages:	array that receives pointer to the page pinned.
+ *		Must be at least nr_segs long.
+ *
+ * Returns 1 if page is pinned. If the page was not pinned, returns
+ * -errno. The page returned must be released with a put_page() call
+ * when it is finished with.
+ */
+int get_kernel_page(unsigned long start, int write, struct page **pages)
+{
+	const struct kvec kiov = {
+		.iov_base = (void *)start,
+		.iov_len = PAGE_SIZE
+	};
+
+	return get_kernel_pages(&kiov, 1, write, pages);
+}
+EXPORT_SYMBOL_GPL(get_kernel_page);
+
 static void pagevec_lru_move_fn(struct pagevec *pvec,
 	void (*move_fn)(struct page *page, struct lruvec *lruvec, void *arg),
 	void *arg)
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

