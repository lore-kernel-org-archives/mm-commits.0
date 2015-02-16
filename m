From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch removed from -mm
 tree
Date: Mon, 16 Feb 2015 15:43:52 -0800
Message-ID: <54e280b8.qR8FPgh4lv/GjIgx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbbBPXo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 18:44:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, matthew.r.wilcox@intel.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-allow-page-fault-handlers-to-perform-the-cow-fix
has been removed from the -mm tree.  Its filename was
     mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch

This patch was dropped because it was folded into mm-allow-page-fault-handlers-to-perform-the-cow.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-allow-page-fault-handlers-to-perform-the-cow-fix

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-allow-page-fault-handlers-to-perform-the-cow-fix mm/memory.c
--- a/mm/memory.c~mm-allow-page-fault-handlers-to-perform-the-cow-fix
+++ a/mm/memory.c
@@ -2896,7 +2896,11 @@ static int do_cow_fault(struct mm_struct
 			unlock_page(fault_page);
 			page_cache_release(fault_page);
 		} else {
-			mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+			/*
+			 * DAX doesn't have a page to lock, so it uses
+			 * i_mmap_lock()
+			 */
+			i_mmap_unlock_read(&vma->vm_file->f_mapping);
 		}
 		goto uncharge_out;
 	}
@@ -2908,7 +2912,11 @@ static int do_cow_fault(struct mm_struct
 		unlock_page(fault_page);
 		page_cache_release(fault_page);
 	} else {
-		mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+			/*
+			 * DAX doesn't have a page to lock, so it uses
+			 * i_mmap_lock()
+			 */
+			i_mmap_unlock_read(&vma->vm_file->f_mapping);
 	}
 	return ret;
 uncharge_out:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch

