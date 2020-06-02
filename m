From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 024/128] mm: add readahead address space operation
Date: Mon, 01 Jun 2020 21:46:44 -0700
Message-ID: <20200602044644.40W6VoU2d%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBEqq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:46:46 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, darrick.wong@oracle.com, dchinner@redhat.com, ebiggers@google.com, gaoxiang25@huawei.com, hch@lst.de, jaegeuk@kernel.org, jhubbard@nvidia.com, johannes.thumshirn@wdc.com, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, mszeredi@redhat.com, torvalds@linux-foundation.org, william.kucharski@oracle.com, willy@infradead.org, xiyou.wangcong@gmail.com, yuchao0@huawei.com, ziy@nvidia.com

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add readahead address space operation

This replaces ->readpages with a saner interface:
 - Return void instead of an ignored error code.
 - Page cache is already populated with locked pages when ->readahead
   is called.
 - New arguments can be passed to the implementation without changing
   all the filesystems that use a common helper function like
   mpage_readahead().

Link: http://lkml.kernel.org/r/20200414150233.24495-12-willy@infradead.org
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
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/locking.rst |    6 +++++-
 Documentation/filesystems/vfs.rst     |   15 +++++++++++++++
 include/linux/fs.h                    |    2 ++
 mm/readahead.c                        |   12 ++++++++++--
 4 files changed, 32 insertions(+), 3 deletions(-)

--- a/Documentation/filesystems/locking.rst~mm-add-readahead-address-space-operation
+++ a/Documentation/filesystems/locking.rst
@@ -239,6 +239,7 @@ prototypes::
 	int (*readpage)(struct file *, struct page *);
 	int (*writepages)(struct address_space *, struct writeback_control *);
 	int (*set_page_dirty)(struct page *page);
+	void (*readahead)(struct readahead_control *);
 	int (*readpages)(struct file *filp, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages);
 	int (*write_begin)(struct file *, struct address_space *mapping,
@@ -271,7 +272,8 @@ writepage:		yes, unlocks (see below)
 readpage:		yes, unlocks
 writepages:
 set_page_dirty		no
-readpages:
+readahead:		yes, unlocks
+readpages:		no
 write_begin:		locks the page		 exclusive
 write_end:		yes, unlocks		 exclusive
 bmap:
@@ -295,6 +297,8 @@ the request handler (/dev/loop).
 ->readpage() unlocks the page, either synchronously or via I/O
 completion.
 
+->readahead() unlocks the pages that I/O is attempted on like ->readpage().
+
 ->readpages() populates the pagecache with the passed pages and starts
 I/O against them.  They come unlocked upon I/O completion.
 
--- a/Documentation/filesystems/vfs.rst~mm-add-readahead-address-space-operation
+++ a/Documentation/filesystems/vfs.rst
@@ -706,6 +706,7 @@ cache in your filesystem.  The following
 		int (*readpage)(struct file *, struct page *);
 		int (*writepages)(struct address_space *, struct writeback_control *);
 		int (*set_page_dirty)(struct page *page);
+		void (*readahead)(struct readahead_control *);
 		int (*readpages)(struct file *filp, struct address_space *mapping,
 				 struct list_head *pages, unsigned nr_pages);
 		int (*write_begin)(struct file *, struct address_space *mapping,
@@ -781,12 +782,26 @@ cache in your filesystem.  The following
 	If defined, it should set the PageDirty flag, and the
 	PAGECACHE_TAG_DIRTY tag in the radix tree.
 
+``readahead``
+	Called by the VM to read pages associated with the address_space
+	object.  The pages are consecutive in the page cache and are
+	locked.  The implementation should decrement the page refcount
+	after starting I/O on each page.  Usually the page will be
+	unlocked by the I/O completion handler.  If the filesystem decides
+	to stop attempting I/O before reaching the end of the readahead
+	window, it can simply return.  The caller will decrement the page
+	refcount and unlock the remaining pages for you.  Set PageUptodate
+	if the I/O completes successfully.  Setting PageError on any page
+	will be ignored; simply unlock the page if an I/O error occurs.
+
 ``readpages``
 	called by the VM to read pages associated with the address_space
 	object.  This is essentially just a vector version of readpage.
 	Instead of just one page, several pages are requested.
 	readpages is only used for read-ahead, so read errors are
 	ignored.  If anything goes wrong, feel free to give up.
+	This interface is deprecated and will be removed by the end of
+	2020; implement readahead instead.
 
 ``write_begin``
 	Called by the generic buffered write code to ask the filesystem
--- a/include/linux/fs.h~mm-add-readahead-address-space-operation
+++ a/include/linux/fs.h
@@ -292,6 +292,7 @@ enum positive_aop_returns {
 struct page;
 struct address_space;
 struct writeback_control;
+struct readahead_control;
 
 /*
  * Write life time hint values.
@@ -375,6 +376,7 @@ struct address_space_operations {
 	 */
 	int (*readpages)(struct file *filp, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages);
+	void (*readahead)(struct readahead_control *);
 
 	int (*write_begin)(struct file *, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
--- a/mm/readahead.c~mm-add-readahead-address-space-operation
+++ a/mm/readahead.c
@@ -125,7 +125,14 @@ static void read_pages(struct readahead_
 
 	blk_start_plug(&plug);
 
-	if (aops->readpages) {
+	if (aops->readahead) {
+		aops->readahead(rac);
+		/* Clean up the remaining pages */
+		while ((page = readahead_page(rac))) {
+			unlock_page(page);
+			put_page(page);
+		}
+	} else if (aops->readpages) {
 		aops->readpages(rac->file, rac->mapping, pages,
 				readahead_count(rac));
 		/* Clean up the remaining pages */
@@ -233,7 +240,8 @@ void force_page_cache_readahead(struct a
 	struct file_ra_state *ra = &filp->f_ra;
 	unsigned long max_pages;
 
-	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
+	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages &&
+			!mapping->a_ops->readahead))
 		return;
 
 	/*
_
