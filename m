From: akpm@linux-foundation.org
Subject: + mm-fix-xip-fault-vs-truncate-race.patch added to -mm tree
Date: Mon, 12 Jan 2015 15:10:34 -0800
Message-ID: <54b4546a.ky1xCUFTOgl9+3kd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbbALXKf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:10:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix XIP fault vs truncate race
has been added to the -mm tree.  Its filename is
     mm-fix-xip-fault-vs-truncate-race.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-xip-fault-vs-truncate-race.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-xip-fault-vs-truncate-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: mm: fix XIP fault vs truncate race

DAX is a replacement for the variation of XIP currently supported by the
ext2 filesystem.  We have three different things in the tree called 'XIP',
and the new focus is on access to data rather than executables, so a name
change was in order.  DAX stands for Direct Access.  The X is for
eXciting.

The new focus on data access has resulted in more careful attention to
races that exist in the current XIP code, but are not hit by the use-case
that it was designed for.  XIP's architecture worked fine for ext2, but
DAX is architected to work with modern filsystems such as ext4 and XFS. 
DAX is not intended for use with btrfs; the value that btrfs adds relies
on manipulating data and writing data to different locations, while DAX's
value is for write-in-place and keeping the kernel from touching the data.

DAX was developed in order to support NV-DIMMs, but it's become clear that
its usefuless extends beyond NV-DIMMs and there are several potential
customers including the tracing machinery.  Other people want to place the
kernel log in an area of memory, as long as they have a BIOS that does not
clear DRAM on reboot.

Patch 1 is a bug fix, probably worth including in 3.18.

Patches 2 & 3 are infrastructure for DAX.

Patches 4-8 replace the XIP code with its DAX equivalents, transforming
ext2 to use the DAX code as we go.  Note that patch 10 is the
Documentation patch.

Patches 9-15 clean up after the XIP code, removing the infrastructure
that is no longer needed and renaming various XIP things to DAX.
Most of these patches were added after Jan found things he didn't
like in an earlier version of the ext4 patch ... that had been copied
from ext2.  So ext2 i being transformed to do things the same way that
ext4 will later.  The ability to mount ext2 filesystems with the 'xip'
option is retained, although the 'dax' option is now preferred.

Patch 16 adds some DAX infrastructure to support ext4.

Patch 17 adds DAX support to ext4.  It is broadly similar to ext2's DAX
support, but it is more efficient than ext4's due to its support for
unwritten extents.

Patch 18 is another cleanup patch renaming XIP to DAX.


My thanks to Mathieu Desnoyers for his reviews of the v11 patchset.  Most
of the changes below were based on his feedback.



This patch (of 18):

Pagecache faults recheck i_size after taking the page lock to ensure that
the fault didn't race against a truncate.  We don't have a page to lock in
the XIP case, so use i_mmap_lock_read() instead.  It is locked in the
truncate path in unmap_mapping_range() after updating i_size.  So while we
hold it in the fault path, we are guaranteed that either i_size has
already been updated in the truncate path, or that the truncate will
subsequently call zap_page_range_single() and so remove the mapping we
have just inserted.

There is a window of time in which i_size has been reduced and the thread
has a mapping to a page which will be removed from the file, but this is
harmless as the page will not be allocated to a different purpose before
the thread's access to it is revoked.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap_xip.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff -puN mm/filemap_xip.c~mm-fix-xip-fault-vs-truncate-race mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-fix-xip-fault-vs-truncate-race
+++ a/mm/filemap_xip.c
@@ -255,8 +255,17 @@ again:
 		__xip_unmap(mapping, vmf->pgoff);
 
 found:
+		/* We must recheck i_size under i_mmap_mutex */
+		mutex_lock(&mapping->i_mmap_mutex);
+		size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
+							PAGE_CACHE_SHIFT;
+		if (unlikely(vmf->pgoff >= size)) {
+			mutex_unlock(&mapping->i_mmap_mutex);
+			return VM_FAULT_SIGBUS;
+		}
 		err = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
 							xip_pfn);
+		mutex_unlock(&mapping->i_mmap_mutex);
 		if (err == -ENOMEM)
 			return VM_FAULT_OOM;
 		/*
@@ -280,16 +289,27 @@ found:
 		}
 		if (error != -ENODATA)
 			goto out;
+
+		/* We must recheck i_size under i_mmap_mutex */
+		mutex_lock(&mapping->i_mmap_mutex);
+		size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
+							PAGE_CACHE_SHIFT;
+		if (unlikely(vmf->pgoff >= size)) {
+			ret = VM_FAULT_SIGBUS;
+			goto unlock;
+		}
 		/* not shared and writable, use xip_sparse_page() */
 		page = xip_sparse_page();
 		if (!page)
-			goto out;
+			goto unlock;
 		err = vm_insert_page(vma, (unsigned long)vmf->virtual_address,
 							page);
 		if (err == -ENOMEM)
-			goto out;
+			goto unlock;
 
 		ret = VM_FAULT_NOPAGE;
+unlock:
+		mutex_unlock(&mapping->i_mmap_mutex);
 out:
 		write_seqcount_end(&xip_sparse_seq);
 		mutex_unlock(&xip_sparse_mutex);
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

axonram-fix-bug-in-direct_access.patch
block-change-direct_access-calling-convention.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

