From: akpm@linux-foundation.org
Subject: [merged] mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:13:22 -0800
Message-ID: <52e02662.eORVIZlkedY8kgCu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbaAVUNX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mingo@kernel.org, mgorman@suse.de, hughd@google.com, dhillf@gmail.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,dhillf@gmail.com,hughd@google.com,mgorman@suse.de,mingo@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:22 -0800


The patch titled
     Subject: mm/rmap: factor lock function out of rmap_walk_anon()
has been removed from the -mm tree.  Its filename was
     mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/rmap: factor lock function out of rmap_walk_anon()

When we traverse anon_vma, we need to take a read-side anon_lock.  But
there is subtle difference in the situation so that we can't use same
method to take a lock in each cases.  Therefore, we need to make
rmap_walk_anon() taking difference lock function.

This patch is the first step, factoring lock function for anon_lock out of
rmap_walk_anon().  It will be used in case of removing migration entry and
in default of rmap_walk_anon().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff -puN mm/rmap.c~mm-rmap-factor-lock-function-out-of-rmap_walk_anon mm/rmap.c
--- a/mm/rmap.c~mm-rmap-factor-lock-function-out-of-rmap_walk_anon
+++ a/mm/rmap.c
@@ -1684,6 +1684,24 @@ void __put_anon_vma(struct anon_vma *ano
 }
 
 #ifdef CONFIG_MIGRATION
+static struct anon_vma *rmap_walk_anon_lock(struct page *page)
+{
+	struct anon_vma *anon_vma;
+
+	/*
+	 * Note: remove_migration_ptes() cannot use page_lock_anon_vma_read()
+	 * because that depends on page_mapped(); but not all its usages
+	 * are holding mmap_sem. Users without mmap_sem are required to
+	 * take a reference count to prevent the anon_vma disappearing
+	 */
+	anon_vma = page_anon_vma(page);
+	if (!anon_vma)
+		return NULL;
+
+	anon_vma_lock_read(anon_vma);
+	return anon_vma;
+}
+
 /*
  * rmap_walk() and its helpers rmap_walk_anon() and rmap_walk_file():
  * Called by migrate.c to remove migration ptes, but might be used more later.
@@ -1696,16 +1714,10 @@ static int rmap_walk_anon(struct page *p
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
-	/*
-	 * Note: remove_migration_ptes() cannot use page_lock_anon_vma_read()
-	 * because that depends on page_mapped(); but not all its usages
-	 * are holding mmap_sem. Users without mmap_sem are required to
-	 * take a reference count to prevent the anon_vma disappearing
-	 */
-	anon_vma = page_anon_vma(page);
+	anon_vma = rmap_walk_anon_lock(page);
 	if (!anon_vma)
 		return ret;
-	anon_vma_lock_read(anon_vma);
+
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch
mm-free-memblockmemory-in-free_all_bootmem.patch
mm-free-memblockmemory-in-free_all_bootmem-fix.patch

