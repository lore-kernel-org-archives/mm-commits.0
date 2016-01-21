From: akpm@linux-foundation.org
Subject: + dax-never-rely-on-bhb_dev-being-set-by-get_block.patch added to -mm tree
Date: Thu, 21 Jan 2016 12:46:09 -0800
Message-ID: <56a14391.dxwDYCHc/AUo/RNo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbcAUUqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 15:46:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: never rely on bh.b_dev being set by get_block()
has been added to the -mm tree.  Its filename is
     dax-never-rely-on-bhb_dev-being-set-by-get_block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-never-rely-on-bhb_dev-being-set-by-get_block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-never-rely-on-bhb_dev-being-set-by-get_block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -606,6 +607,7 @@ int __dax_fault(struct vm_area_struct *v
 
 	memset(&bh, 0, sizeof(bh));
 	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
+	bh.b_bdev = inode->i_sb->s_bdev;
 	bh.b_size = PAGE_SIZE;
 
  repeat:
@@ -1077,6 +1079,7 @@ int dax_zero_page_range(struct inode *in
 	BUG_ON((offset + length) > PAGE_CACHE_SIZE);
 
 	memset(&bh, 0, sizeof(bh));
+	bh.b_bdev = inode->i_sb->s_bdev;
 	bh.b_size = PAGE_CACHE_SIZE;
 	err = get_block(inode, index, &bh, 0);
 	if (err < 0)
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-null-pointer-dereference-in-__dax_dbg.patch
dax-fix-conversion-of-holes-to-pmds.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
pmem-add-wb_cache_pmem-to-the-pmem-api-v6.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
dax-support-dirty-dax-entries-in-radix-tree-v6.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
dax-add-support-for-fsync-sync-v6.patch
dax-add-support-for-fsync-msync-v7.patch
dax-add-support-for-fsync-msync-v8.patch
dax-add-support-for-fsync-msync-v8-fix.patch
dax-add-support-for-fsync-msync-v8-fix-2.patch
dax-add-support-for-fsync-msync-v8-fix-3.patch
dax-add-support-for-fsync-sync-v8-fix-4.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
dax-never-rely-on-bhb_dev-being-set-by-get_block.patch

