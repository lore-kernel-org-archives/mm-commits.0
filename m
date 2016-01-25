From: akpm@linux-foundation.org
Subject: [merged] dax-never-rely-on-bhb_dev-being-set-by-get_block.patch
 removed from -mm tree
Date: Mon, 25 Jan 2016 10:58:56 -0800
Message-ID: <56a67070.vS+aI/0CbYa9xX+y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983AbcAYS64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 13:58:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: never rely on bh.b_dev being set by get_block()
has been removed from the -mm tree.  Its filename was
     dax-never-rely-on-bhb_dev-being-set-by-get_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: never rely on bh.b_dev being set by get_block()

Previously in DAX we assumed that calls to get_block() would set bh.b_bdev,
and we would then use that value even in error cases for debugging.  This
caused a NULL pointer dereference in __dax_dbg() which was fixed by a
previous commit, but that commit only changed the one place where we were
hitting an error.

Instead, update dax.c so that we always initialize bh.b_bdev as best we can
based on the information that DAX has.  get_block() may or may not update
to a new value, but this at least lets us get something helpful from
bh.b_bdev for error messages and not have to worry about whether it was set
by get_block() or not.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/dax.c~dax-never-rely-on-bhb_dev-being-set-by-get_block fs/dax.c
--- a/fs/dax.c~dax-never-rely-on-bhb_dev-being-set-by-get_block
+++ a/fs/dax.c
@@ -246,6 +246,7 @@ ssize_t dax_do_io(struct kiocb *iocb, st
 	loff_t end = pos + iov_iter_count(iter);
 
 	memset(&bh, 0, sizeof(bh));
+	bh.b_bdev = inode->i_sb->s_bdev;
 
 	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ) {
 		struct address_space *mapping = inode->i_mapping;
@@ -607,6 +608,7 @@ int __dax_fault(struct vm_area_struct *v
 
 	memset(&bh, 0, sizeof(bh));
 	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
+	bh.b_bdev = inode->i_sb->s_bdev;
 	bh.b_size = PAGE_SIZE;
 
  repeat:
@@ -1078,6 +1080,7 @@ int dax_zero_page_range(struct inode *in
 	BUG_ON((offset + length) > PAGE_CACHE_SIZE);
 
 	memset(&bh, 0, sizeof(bh));
+	bh.b_bdev = inode->i_sb->s_bdev;
 	bh.b_size = PAGE_CACHE_SIZE;
 	err = get_block(inode, index, &bh, 0);
 	if (err < 0)
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are


