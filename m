From: akpm@linux-foundation.org
Subject: + mm-rmap-calculate-page-offset-when-needed.patch added to -mm
 tree
Date: Wed, 12 Nov 2014 14:53:21 -0800
Message-ID: <5463e4e1.FgT9XJ6sKJE8EFAD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaKLWxW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 17:53:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: calculate page offset when needed
has been added to the -mm tree.  Its filename is
     mm-rmap-calculate-page-offset-when-needed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-calculate-page-offset-when-needed.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-calculate-page-offset-when-needed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1633,7 +1633,7 @@ static struct anon_vma *rmap_walk_anon_l
 static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma;
-	pgoff_t pgoff = page_to_pgoff(page);
+	pgoff_t pgoff;
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
@@ -1641,6 +1641,7 @@ static int rmap_walk_anon(struct page *p
 	if (!anon_vma)
 		return ret;
 
+	pgoff = page_to_pgoff(page);
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
@@ -1674,7 +1675,7 @@ static int rmap_walk_anon(struct page *p
 static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page_to_pgoff(page);
+	pgoff_t pgoff;
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
 
@@ -1689,6 +1690,7 @@ static int rmap_walk_file(struct page *p
 	if (!mapping)
 		return ret;
 
+	pgoff = page_to_pgoff(page);
 	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
_

Patches currently in -mm which might be from dave@stgolabs.net are

mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-convert-i_mmap_mutex-to-rwsem-fix.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
mm-rmap-calculate-page-offset-when-needed.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-semc-increase-semmsl-semmni-semopm.patch
ipc-msg-increase-msgmni-remove-scaling.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch

