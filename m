From: akpm@osdl.org
Subject: - pass-io-size-to-batch_write-address-space-operation.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:05:09 -0800
Message-ID: <200612081105.kB8B59Fp018621@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50260 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938044AbWLHLUl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:20:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, hch@lst.de, mark.fasheh@oracle.com, miklos@szeredi.hu, nathans@sgi.com, reiser@namesys.com, swhiteho@redhat.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     Pass IO size to batch_write() address space operation
has been removed from the -mm tree.  Its filename was
     pass-io-size-to-batch_write-address-space-operation.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Pass IO size to batch_write() address space operation
From: Badari Pulavarty <pbadari@us.ibm.com>

Pass remaining size of this IO to batch_write().  This way filesystems
could choose to allocate for the entire IO, instead of current buffer size.

I would like to use this for setting ext3 reservation window or allocating
entire extent (ext4).

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Vladimir Saveliev <vs@namesys.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hans Reiser <reiser@namesys.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nathan Scott <nathans@sgi.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/fs.h |    2 ++
 mm/filemap.c       |    1 +
 2 files changed, 3 insertions(+)

diff -puN include/linux/fs.h~pass-io-size-to-batch_write-address-space-operation include/linux/fs.h
--- a/include/linux/fs.h~pass-io-size-to-batch_write-address-space-operation
+++ a/include/linux/fs.h
@@ -398,6 +398,7 @@ struct writeback_control;
  * struct write_descriptor - set of write arguments
  * @pos: offset from the start of the file to write to
  * @count: number of bytes to write
+ * @iosize: remaining number of bytes in the IO
  * @buf: pointer to data to be written
  * @lru_pvec: multipage container to batch adding pages to LRU list
  * @cached_page: allocated but not used on previous call
@@ -408,6 +409,7 @@ struct writeback_control;
 struct write_descriptor {
 	loff_t pos;
 	size_t count;
+	size_t iosize;
 	char __user *buf;
 	struct page *cached_page;
 	struct pagevec *lru_pvec;
diff -puN mm/filemap.c~pass-io-size-to-batch_write-address-space-operation mm/filemap.c
--- a/mm/filemap.c~pass-io-size-to-batch_write-address-space-operation
+++ a/mm/filemap.c
@@ -2201,6 +2201,7 @@ generic_file_buffered_write(struct kiocb
 	do {
 		/* do not walk over current segment */
 		desc.buf = cur_iov->iov_base + iov_base;
+		desc.iosize = count;
 		desc.count = min(count, cur_iov->iov_len - iov_base);
 		if (desc.count > 0)
 			status = (*batch_write)(file, &desc, &copied);
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

origin.patch
mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix.patch
dio-centralize-completion-in-dio_complete.patch
dio-call-blk_run_address_space-once-per-op.patch
dio-formalize-bio-counters-as-a-dio-reference-count.patch
dio-remove-duplicate-bio-wait-code.patch
dio-only-call-aio_complete-after-returning-eiocbqueued.patch
dio-lock-refcount-operations.patch

