From: akpm@linux-foundation.org
Subject: + fs-introduce-filemap_range_has_page.patch added to -mm tree
Date: Thu, 15 Jun 2017 11:54:39 -0700
Message-ID: <5942d7ef.eA+zV4Nlef2wPzBI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59298 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752541AbdFOSyp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 14:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgoldwyn@suse.com, adilger.kernel@dilger.ca, axboe@kernel.dk, clm@fb.com, darrick.wong@oracle.com, dsterba@suse.com, hch@lst.de, jack@suse.cz, jbacik@fb.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: introduce filemap_range_has_page()
has been added to the -mm tree.  Its filename is
     fs-introduce-filemap_range_has_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-introduce-filemap_range_has_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-introduce-filemap_range_has_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: fs: introduce filemap_range_has_page()

filemap_range_has_page() return true if the file's mapping has a page
within the range mentioned.  This function will be used to check if a
write() call will cause a writeback of previous writes.

Link: http://lkml.kernel.org/r/20170615160002.17233-3-rgoldwyn@suse.de
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Chris Mason <clm@fb.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 ++
 mm/filemap.c       |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff -puN include/linux/fs.h~fs-introduce-filemap_range_has_page include/linux/fs.h
--- a/include/linux/fs.h~fs-introduce-filemap_range_has_page
+++ a/include/linux/fs.h
@@ -2517,6 +2517,8 @@ extern int filemap_fdatawait(struct addr
 extern void filemap_fdatawait_keep_errors(struct address_space *);
 extern int filemap_fdatawait_range(struct address_space *, loff_t lstart,
 				   loff_t lend);
+extern int filemap_range_has_page(struct address_space *, loff_t lstart,
+				  loff_t lend);
 extern int filemap_write_and_wait(struct address_space *mapping);
 extern int filemap_write_and_wait_range(struct address_space *mapping,
 				        loff_t lstart, loff_t lend);
diff -puN mm/filemap.c~fs-introduce-filemap_range_has_page mm/filemap.c
--- a/mm/filemap.c~fs-introduce-filemap_range_has_page
+++ a/mm/filemap.c
@@ -376,6 +376,39 @@ int filemap_flush(struct address_space *
 }
 EXPORT_SYMBOL(filemap_flush);
 
+/**
+ * filemap_range_has_page - check if a page exists in range.
+ * @mapping:           address space structure to wait for
+ * @start_byte:        offset in bytes where the range starts
+ * @end_byte:          offset in bytes where the range ends (inclusive)
+ *
+ * Find at least one page in the range supplied, usually used to check if
+ * direct writing in this range will trigger a writeback.
+ */
+int filemap_range_has_page(struct address_space *mapping,
+			   loff_t start_byte, loff_t end_byte)
+{
+	pgoff_t index = start_byte >> PAGE_SHIFT;
+	pgoff_t end = end_byte >> PAGE_SHIFT;
+	struct pagevec pvec;
+	int ret;
+
+	if (end_byte < start_byte)
+		return 0;
+
+	if (mapping->nrpages == 0)
+		return 0;
+
+	pagevec_init(&pvec, 0);
+	ret = pagevec_lookup(&pvec, mapping, index, 1);
+	if (!ret)
+		return 0;
+	ret = (pvec.pages[0]->index <= end);
+	pagevec_release(&pvec);
+	return ret;
+}
+EXPORT_SYMBOL(filemap_range_has_page);
+
 static int __filemap_fdatawait_range(struct address_space *mapping,
 				     loff_t start_byte, loff_t end_byte)
 {
_

Patches currently in -mm which might be from rgoldwyn@suse.com are

fs-separate-out-kiocb-flags-setup-based-on-rwf_-flags.patch
fs-introduce-filemap_range_has_page.patch
fs-use-rwf_-flags-for-aio-operations.patch
fs-introduce-rwf_nowait-and-fmode_aio_nowait.patch
fs-return-if-direct-write-will-trigger-writeback.patch
fs-introduce-iomap_nowait.patch
block-return-on-congested-block-device.patch
ext4-nowait-aio-support.patch
xfs-nowait-aio-support.patch
btrfs-nowait-aio-support.patch

