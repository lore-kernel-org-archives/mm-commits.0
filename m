From: akpm@linux-foundation.org
Subject: [merged] hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch removed from -mm tree
Date: Mon, 26 Apr 2010 10:26:31 -0400
Message-ID: <201004261728.o3QHS5uY009090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752875Ab0DZR2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 13:28:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, darren@dvhart.com, peterz@infradead.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     hugetlb: fix infinite loop in get_futex_key() when backed by huge pages
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: fix infinite loop in get_futex_key() when backed by huge pages
From: Mel Gorman <mel@csn.ul.ie>

If a futex key happens to be located within a huge page mapped
MAP_PRIVATE, get_futex_key() can go into an infinite loop waiting for a
page->mapping that will never exist.  This was reported and documented in
an external bugzilla at

This patch makes page->mapping a poisoned value that includes
PAGE_MAPPING_ANON mapped MAP_PRIVATE.  This is enough for futex to
continue but because of PAGE_MAPPING_ANON, the poisoned value is not
dereferenced or used by futex.  No other part of the VM should be
dereferencing the page->mapping of a hugetlbfs page as its page cache is
not on the LRU.

This patch fixes the problem with the test case described in the bugzilla.

Addresses https://bugzilla.redhat.com/show_bug.cgi?id=552257

[akpm@linux-foundation.org: mel cant spel]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Darren Hart <darren@dvhart.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    9 +++++++++
 mm/hugetlb.c           |    5 ++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -puN include/linux/poison.h~hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages include/linux/poison.h
--- a/include/linux/poison.h~hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages
+++ a/include/linux/poison.h
@@ -48,6 +48,15 @@
 #define POISON_FREE	0x6b	/* for use-after-free poisoning */
 #define	POISON_END	0xa5	/* end-byte of poisoning */
 
+/********** mm/hugetlb.c **********/
+/*
+ * Private mappings of hugetlb pages use this poisoned value for
+ * page->mapping. The core VM should not be doing anything with this mapping
+ * but futex requires the existence of some page->mapping value even though it
+ * is unused if PAGE_MAPPING_ANON is set.
+ */
+#define HUGETLB_POISON	((void *)(0x00300300 + POISON_POINTER_DELTA + PAGE_MAPPING_ANON))
+
 /********** arch/$ARCH/mm/init.c **********/
 #define POISON_FREE_INITMEM	0xcc
 
diff -puN mm/hugetlb.c~hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages
+++ a/mm/hugetlb.c
@@ -546,6 +546,7 @@ static void free_huge_page(struct page *
 
 	mapping = (struct address_space *) page_private(page);
 	set_page_private(page, 0);
+	page->mapping = NULL;
 	BUG_ON(page_count(page));
 	INIT_LIST_HEAD(&page->lru);
 
@@ -2447,8 +2448,10 @@ retry:
 			spin_lock(&inode->i_lock);
 			inode->i_blocks += blocks_per_huge_page(h);
 			spin_unlock(&inode->i_lock);
-		} else
+		} else {
 			lock_page(page);
+			page->mapping = HUGETLB_POISON;
+		}
 	}
 
 	/*
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mmmigration-take-a-reference-to-the-anon_vma-before-migrating.patch
mmmigration-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mmmigration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mmmigration-allow-the-migration-of-pageswapcache-pages.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mm-export-fragmentation-index-via-debugfs.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mmcompaction-memory-compaction-core.patch
mmcompaction-add-proc-trigger-for-memory-compaction.patch
mmcompaction-add-sys-trigger-for-per-node-memory-compaction.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mmcompaction-defer-compaction-using-an-exponential-backoff-when-compaction-fails.patch
mm-introduce-free_pages_prepare.patch
mm-introduce-free_pages_prepare-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
add-debugging-aid-for-memory-initialisation-problems.patch

