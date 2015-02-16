From: akpm@linux-foundation.org
Subject: [folded-merged]
 daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch removed from -mm tree
Date: Mon, 16 Feb 2015 15:44:26 -0800
Message-ID: <54e280da.ZtMCt5OH+s3l+1wP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbbBPXpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 18:45:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, matthew.r.wilcox@intel.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix
has been removed from the -mm tree.  Its filename was
     daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch

This patch was dropped because it was folded into daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix

Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/dax.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix fs/dax.c
--- a/fs/dax.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix
+++ a/fs/dax.c
@@ -279,7 +279,7 @@ static int dax_insert_mapping(struct ino
 	pgoff_t size;
 	int error;
 
-	mutex_lock(&mapping->i_mmap_mutex);
+	i_mmap_lock_read(mapping);
 
 	/*
 	 * Check truncate didn't happen while we were allocating a block.
@@ -308,7 +308,7 @@ static int dax_insert_mapping(struct ino
 	error = vm_insert_mixed(vma, vaddr, pfn);
 
  out:
-	mutex_unlock(&mapping->i_mmap_mutex);
+	i_mmap_unlock_read(mapping);
 
 	if (bh->b_end_io)
 		bh->b_end_io(bh, 1);
@@ -389,12 +389,12 @@ static int do_dax_fault(struct vm_area_s
 			goto unlock_page;
 		vmf->page = page;
 		if (!page) {
-			mutex_lock(&mapping->i_mmap_mutex);
+			i_mmap_lock_read(mapping);
 			/* Check we didn't race with truncate */
 			size = (i_size_read(inode) + PAGE_SIZE - 1) >>
 								PAGE_SHIFT;
 			if (vmf->pgoff >= size) {
-				mutex_unlock(&mapping->i_mmap_mutex);
+				i_mmap_unlock_read(mapping);
 				error = -EIO;
 				goto out;
 			}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-xip-fault-vs-truncate-race.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch

