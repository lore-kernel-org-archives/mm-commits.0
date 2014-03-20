From: akpm@linux-foundation.org
Subject: + mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch
 added to -mm tree
Date: Thu, 20 Mar 2014 15:53:48 -0700
Message-ID: <532b717c.kIIrouvRlekgvmTS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759767AbaCTWxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Mar 2014 18:53:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, stable@vger.kernel.org, sasha.levin@oracle.com, rientjes@google.com, riel@redhat.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, hughd@google.com, bob.liu@oracle.com, vbabka@suse.cz

Subject: + mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch added to -mm tree
To: vbabka@suse.cz,bob.liu@oracle.com,hughd@google.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,riel@redhat.com,rientjes@google.com,sasha.levin@oracle.com,stable@vger.kernel.org,walken@google.com
From: akpm@linux-foundation.org
Date: Thu, 20 Mar 2014 15:53:48 -0700


The patch titled
     Subject: mm: try_to_unmap_cluster() should lock_page() before mlocking
has been added to the -mm tree.  Its filename is
     mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: try_to_unmap_cluster() should lock_page() before mlocking

A BUG_ON(!PageLocked) was triggered in mlock_vma_page() by Sasha Levin
fuzzing with trinity.  The call site try_to_unmap_cluster() does not lock
the pages other than its check_page parameter (which is already locked).

The BUG_ON in mlock_vma_page() is not documented and its purpose is
somewhat unclear, but apparently it serializes against page migration,
which could otherwise fail to transfer the PG_mlocked flag.  This would
not be fatal, as the page would be eventually encountered again, but
NR_MLOCK accounting would become distorted nevertheless.  This patch adds
a comment to the BUG_ON in mlock_vma_page() and munlock_vma_page() to that
effect.

The call site try_to_unmap_cluster() is fixed so that for page !=
check_page, trylock_page() is attempted (to avoid possible deadlocks as we
already have check_page locked) and mlock_vma_page() is performed only
upon success.  If the page lock cannot be obtained, the page is left
without PG_mlocked, which is again not a problem in the whole unevictable
memory design.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Bob Liu <bob.liu@oracle.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 ++
 mm/rmap.c  |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff -puN mm/mlock.c~mm-try_to_unmap_cluster-should-lock_page-before-mlocking mm/mlock.c
--- a/mm/mlock.c~mm-try_to_unmap_cluster-should-lock_page-before-mlocking
+++ a/mm/mlock.c
@@ -79,6 +79,7 @@ void clear_page_mlock(struct page *page)
  */
 void mlock_vma_page(struct page *page)
 {
+	/* Serialize with page migration */
 	BUG_ON(!PageLocked(page));
 
 	if (!TestSetPageMlocked(page)) {
@@ -174,6 +175,7 @@ unsigned int munlock_vma_page(struct pag
 	unsigned int nr_pages;
 	struct zone *zone = page_zone(page);
 
+	/* For try_to_munlock() and to serialize with page migration */
 	BUG_ON(!PageLocked(page));
 
 	/*
diff -puN mm/rmap.c~mm-try_to_unmap_cluster-should-lock_page-before-mlocking mm/rmap.c
--- a/mm/rmap.c~mm-try_to_unmap_cluster-should-lock_page-before-mlocking
+++ a/mm/rmap.c
@@ -1318,9 +1318,19 @@ static int try_to_unmap_cluster(unsigned
 		BUG_ON(!page || PageAnon(page));
 
 		if (locked_vma) {
-			mlock_vma_page(page);   /* no-op if already mlocked */
-			if (page == check_page)
+			if (page == check_page) {
+				/* we know we have check_page locked */
+				mlock_vma_page(page);
 				ret = SWAP_MLOCK;
+			} else if (trylock_page(page)) {
+				/*
+				 * If we can lock the page, perform mlock.
+				 * Otherwise leave the page alone, it will be
+				 * eventually encountered again later.
+				 */
+				mlock_vma_page(page);
+				unlock_page(page);
+			}
 			continue;	/* don't unmap */
 		}
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-compaction-disallow-high-order-page-for-migration-target.patch
mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch
mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch
mm-compaction-check-pageblock-suitability-once-per-pageblock.patch
mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-compaction-determine-isolation-mode-only-once.patch
mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch

