From: akpm@linux-foundation.org
Subject: [merged] mm-rmap-share-the-i_mmap_rwsem.patch removed from -mm
 tree
Date: Sat, 13 Dec 2014 20:06:29 -0800
Message-ID: <548d0cc5.MZuufZdEmpiEIJ9b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaLNEGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:06:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, hughd@google.com, kirill@shutemov.name, mgorman@suse.de, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: share the i_mmap_rwsem
has been removed from the -mm tree.  Its filename was
     mm-rmap-share-the-i_mmap_rwsem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/rmap: share the i_mmap_rwsem

Similarly to the anon memory counterpart, we can share the mapping's lock
ownership as the interval tree is not modified when doing doing the walk,
only the file page.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |   10 ++++++++++
 mm/rmap.c          |    6 +++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff -puN include/linux/fs.h~mm-rmap-share-the-i_mmap_rwsem include/linux/fs.h
--- a/include/linux/fs.h~mm-rmap-share-the-i_mmap_rwsem
+++ a/include/linux/fs.h
@@ -478,6 +478,16 @@ static inline void i_mmap_unlock_write(s
 	up_write(&mapping->i_mmap_rwsem);
 }
 
+static inline void i_mmap_lock_read(struct address_space *mapping)
+{
+	down_read(&mapping->i_mmap_rwsem);
+}
+
+static inline void i_mmap_unlock_read(struct address_space *mapping)
+{
+	up_read(&mapping->i_mmap_rwsem);
+}
+
 /*
  * Might pages of this file be mapped into userspace?
  */
diff -puN mm/rmap.c~mm-rmap-share-the-i_mmap_rwsem mm/rmap.c
--- a/mm/rmap.c~mm-rmap-share-the-i_mmap_rwsem
+++ a/mm/rmap.c
@@ -1690,7 +1690,8 @@ static int rmap_walk_file(struct page *p
 
 	if (!mapping)
 		return ret;
-	i_mmap_lock_write(mapping);
+
+	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 
@@ -1711,9 +1712,8 @@ static int rmap_walk_file(struct page *p
 		goto done;
 
 	ret = rwc->file_nonlinear(page, mapping, rwc->arg);
