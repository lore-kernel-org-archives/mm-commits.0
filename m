From: akpm@linux-foundation.org
Subject: [merged] dax-fix-radix-tree-insertion-race.patch removed from -mm tree
Date: Mon, 10 Apr 2017 11:51:01 -0700
Message-ID: <58ebd415.ORdLZRoosNZb2ZEL%akpm__32128.5953432836$1491850270$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46954 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752114AbdDJSvC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 14:51:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, darrick.wong@oracle.com, hch@lst.de, jack@suse.cz, mawilcox@microsoft.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix radix tree insertion race
has been removed from the -mm tree.  Its filename was
     dax-fix-radix-tree-insertion-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: fix radix tree insertion race

While running generic/340 in my test setup I hit the following race.  It
can happen with kernels that support FS DAX PMDs, so v4.10 thru v4.11-rc5.

Thread 1				Thread 2
--------				--------
dax_iomap_pmd_fault()
  grab_mapping_entry()
    spin_lock_irq()
    get_unlocked_mapping_entry()
    'entry' is NULL, can't call lock_slot()
    spin_unlock_irq()
    radix_tree_preload()
					dax_iomap_pmd_fault()
					  grab_mapping_entry()
					    spin_lock_irq()
					    get_unlocked_mapping_entry()
					    ...
					    lock_slot()
					    spin_unlock_irq()
					  dax_pmd_insert_mapping()
					    <inserts a PMD mapping>
    spin_lock_irq()
    __radix_tree_insert() fails with -EEXIST
    <fall back to 4k fault, and die horribly
     when inserting a 4k entry where a PMD exists>

The issue is that we have to drop mapping->tree_lock while calling
radix_tree_preload(), but since we didn't have a radix tree entry to lock
(unlike in the pmd_downgrade case) we have no protection against Thread 2
coming along and inserting a PMD at the same index.  For 4k entries we
handled this with a special-case response to -EEXIST coming from the
__radix_tree_insert(), but this doesn't save us for PMDs because the
-EEXIST case can also mean that we collided with a 4k entry in the radix
tree at a different index, but one that is covered by our PMD range.

So, correctly handle both the 4k and 2M collision cases by explicitly
re-checking the radix tree for an entry at our index once we reacquire
mapping->tree_lock.

This patch has made it through a clean xfstests run with the current
v4.11-rc5 based linux/master, and it also ran generic/340 500 times in a
loop.  It used to fail within the first 10 iterations.

Link: http://lkml.kernel.org/r/20170406212944.2866-1-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: <stable@vger.kernel.org>    [4.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff -puN fs/dax.c~dax-fix-radix-tree-insertion-race fs/dax.c
--- a/fs/dax.c~dax-fix-radix-tree-insertion-race
+++ a/fs/dax.c
@@ -373,6 +373,22 @@ restart:
 		}
 		spin_lock_irq(&mapping->tree_lock);
 
+		if (!entry) {
+			/*
+			 * We needed to drop the page_tree lock while calling
+			 * radix_tree_preload() and we didn't have an entry to
+			 * lock.  See if another thread inserted an entry at
+			 * our index during this time.
+			 */
+			entry = __radix_tree_lookup(&mapping->page_tree, index,
+					NULL, &slot);
+			if (entry) {
+				radix_tree_preload_end();
+				spin_unlock_irq(&mapping->tree_lock);
+				goto restart;
+			}
+		}
+
 		if (pmd_downgrade) {
 			radix_tree_delete(&mapping->page_tree, index);
 			mapping->nrexceptional--;
@@ -388,19 +404,12 @@ restart:
 		if (err) {
 			spin_unlock_irq(&mapping->tree_lock);
 			/*
-			 * Someone already created the entry?  This is a
-			 * normal failure when inserting PMDs in a range
-			 * that already contains PTEs.  In that case we want
-			 * to return -EEXIST immediately.
-			 */
-			if (err == -EEXIST && !(size_flag & RADIX_DAX_PMD))
-				goto restart;
-			/*
-			 * Our insertion of a DAX PMD entry failed, most
-			 * likely because it collided with a PTE sized entry
-			 * at a different index in the PMD range.  We haven't
-			 * inserted anything into the radix tree and have no
-			 * waiters to wake.
+			 * Our insertion of a DAX entry failed, most likely
+			 * because we were inserting a PMD entry and it
+			 * collided with a PTE sized entry at a different
+			 * index in the PMD range.  We haven't inserted
+			 * anything into the radix tree and have no waiters to
+			 * wake.
 			 */
 			return ERR_PTR(err);
 		}
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-add-tracepoints-to-dax_iomap_pte_fault.patch
dax-add-tracepoints-to-dax_pfn_mkwrite.patch
dax-add-tracepoints-to-dax_load_hole.patch
dax-add-tracepoints-to-dax_writeback_mapping_range.patch
dax-add-tracepoints-to-dax_writeback_mapping_range-fix.patch
dax-add-tracepoint-to-dax_writeback_one.patch
dax-add-tracepoint-to-dax_insert_mapping.patch

