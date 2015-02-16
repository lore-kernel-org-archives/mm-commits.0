From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch removed from
 -mm tree
Date: Mon, 16 Feb 2015 15:43:57 -0800
Message-ID: <54e280bd.pOo8cm7vZ25GQjn9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbbBPXoe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 18:44:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, matthew.r.wilcox@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch

This patch was dropped because it was folded into mm-allow-page-fault-handlers-to-perform-the-cow.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/memory.c~mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix mm/memory.c
--- a/mm/memory.c~mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix
+++ a/mm/memory.c
@@ -2897,8 +2897,8 @@ static int do_cow_fault(struct mm_struct
 			page_cache_release(fault_page);
 		} else {
 			/*
-			 * DAX doesn't have a page to lock, so it uses
-			 * i_mmap_lock()
+			 * The fault handler has no page to lock, so it holds
+			 * i_mmap_lock for read to protect against truncate.
 			 */
 			i_mmap_unlock_read(vma->vm_file->f_mapping);
 		}
@@ -2912,11 +2912,11 @@ static int do_cow_fault(struct mm_struct
 		unlock_page(fault_page);
 		page_cache_release(fault_page);
 	} else {
-			/*
-			 * DAX doesn't have a page to lock, so it uses
-			 * i_mmap_lock()
-			 */
-			i_mmap_unlock_read(vma->vm_file->f_mapping);
+		/*
+		 * The fault handler has no page to lock, so it holds
+		 * i_mmap_lock for read to protect against truncate.
+		 */
+		i_mmap_unlock_read(vma->vm_file->f_mapping);
 	}
 	return ret;
 uncharge_out:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch

