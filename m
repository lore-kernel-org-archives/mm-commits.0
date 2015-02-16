From: akpm@linux-foundation.org
Subject: [folded-merged] mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 15:43:21 -0800
Message-ID: <54e28099.LuU8v/y9bV9a4P/u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbbBPXn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 18:43:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, matthew.r.wilcox@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-xip-fault-vs-truncate-race-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-xip-fault-vs-truncate-race-fix-fix.patch

This patch was dropped because it was folded into mm-fix-xip-fault-vs-truncate-race.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-xip-fault-vs-truncate-race-fix-fix

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN mm/memory.c~mm-fix-xip-fault-vs-truncate-race-fix-fix mm/memory.c
--- a/mm/memory.c~mm-fix-xip-fault-vs-truncate-race-fix-fix
+++ a/mm/memory.c
@@ -1303,11 +1303,6 @@ static void unmap_single_vma(struct mmu_
 			 * safe to do nothing in this case.
 			 */
 			if (vma->vm_file) {
-				/*
-				 * Note that DAX uses i_mmap_lock to serialise
-				 * against file truncate - truncate calls into
-				 * unmap_single_vma().
-				 */
 				i_mmap_lock_write(vma->vm_file->f_mapping);
 				__unmap_hugepage_range_final(tlb, vma, start, end, NULL);
 				i_mmap_unlock_write(vma->vm_file->f_mapping);
@@ -2334,6 +2329,7 @@ void unmap_mapping_range(struct address_
 		details.last_index = ULONG_MAX;
 
 
+	/* DAX uses i_mmap_lock to serialise file truncate vs page fault */
 	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch

