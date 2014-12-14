From: akpm@linux-foundation.org
Subject: [merged] mm-rmap-calculate-page-offset-when-needed.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:07:04 -0800
Message-ID: <548d0ce8.Yy7EJ88NC7MQVA7N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaLNEG4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:06:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: calculate page offset when needed
has been removed from the -mm tree.  Its filename was
     mm-rmap-calculate-page-offset-when-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/rmap: calculate page offset when needed

Call page_to_pgoff() to get the page offset once we are sure we actually
need it, and any very obvious initial function checks have passed. 
Trivial micro-optimization, and potentially save some cycles.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/rmap.c~mm-rmap-calculate-page-offset-when-needed mm/rmap.c
--- a/mm/rmap.c~mm-rmap-calculate-page-offset-when-needed
+++ a/mm/rmap.c
@@ -1635,7 +1635,7 @@ static struct anon_vma *rmap_walk_anon_l
 static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma;
-	pgoff_t pgoff = page_to_pgoff(page);
+	pgoff_t pgoff;
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
@@ -1643,6 +1643,7 @@ static int rmap_walk_anon(struct page *p
 	if (!anon_vma)
 		return ret;
 
+	pgoff = page_to_pgoff(page);
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
@@ -1676,7 +1677,7 @@ static int rmap_walk_anon(struct page *p
 static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page_to_pgoff(page);
+	pgoff_t pgoff;
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
 
@@ -1691,6 +1692,7 @@ static int rmap_walk_file(struct page *p
 	if (!mapping)
 		return ret;
 
+	pgoff = page_to_pgoff(page);
 	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch

