From: akpm@linux-foundation.org
Subject: [folded-merged] dax-add-dax_zero_page_range-fix.patch removed
 from -mm tree
Date: Mon, 16 Feb 2015 15:45:13 -0800
Message-ID: <54e28109.5axwRRe4sKnHOMuC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbBPXpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 18:45:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, matthew.r.wilcox@intel.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: dax-add-dax_zero_page_range-fix
has been removed from the -mm tree.  Its filename was
     dax-add-dax_zero_page_range-fix.patch

This patch was dropped because it was folded into dax-add-dax_zero_page_range.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dax-add-dax_zero_page_range-fix

fix typos in comments

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/dax.c~dax-add-dax_zero_page_range-fix fs/dax.c
--- a/fs/dax.c~dax-add-dax_zero_page_range-fix
+++ a/fs/dax.c
@@ -479,7 +479,7 @@ EXPORT_SYMBOL_GPL(dax_fault);
  * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
  * took care of disposing of the unnecessary blocks.  Even if the filesystem
  * block size is smaller than PAGE_SIZE, we have to zero the rest of the page
- * since the file might be mmaped.
+ * since the file might be mmapped.
  */
 int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 							get_block_t get_block)
@@ -518,13 +518,13 @@ EXPORT_SYMBOL_GPL(dax_zero_page_range);
  * @get_block: The filesystem method used to translate file offsets to blocks
  *
  * Similar to block_truncate_page(), this function can be called by a
- * filesystem when it is truncating an DAX file to handle the partial page.
+ * filesystem when it is truncating a DAX file to handle the partial page.
  *
  * We work in terms of PAGE_CACHE_SIZE here for commonality with
  * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
  * took care of disposing of the unnecessary blocks.  Even if the filesystem
  * block size is smaller than PAGE_SIZE, we have to zero the rest of the page
- * since the file might be mmaped.
+ * since the file might be mmapped.
  */
 int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-xip-fault-vs-truncate-race.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
dax-add-dax_zero_page_range.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch

