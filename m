From: akpm@linux-foundation.org
Subject: + fs-jfs-remove-slab-object-constructor.patch added to -mm tree
Date: Wed, 25 Mar 2015 14:55:35 -0700
Message-ID: <55132ed7.P8HqAZohEJTWAijd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbbCYVzg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 17:55:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, catalin.marinas@arm.com, dave.kleikamp@oracle.com, hch@lst.de, mpatocka@redhat.com, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, jfs: remove slab object constructor
has been added to the -mm tree.  Its filename is
     fs-jfs-remove-slab-object-constructor.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-jfs-remove-slab-object-constructor.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-jfs-remove-slab-object-constructor.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: fs, jfs: remove slab object constructor

Mempools based on slab caches with object constructors are risky because
element allocation can happen either from the slab cache itself, meaning
the constructor is properly called before returning, or from the mempool
reserve pool, meaning the constructor is not called before returning,
depending on the allocation context.

For this reason, we should disallow creating mempools based on slab caches
that have object constructors.  Callers of mempool_alloc() will be
responsible for properly initializing the returned element.

Then, it doesn't matter if the element came from the slab cache or the
mempool reserved pool.

The only occurrence of a mempool being based on a slab cache with an
object constructor in the tree is in fs/jfs/jfs_metapage.c.  Remove it and
properly initialize the element in alloc_metapage().

At the same time, META_free is never used, so remove it as well.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_metapage.c |   31 ++++++++++++-------------------
 fs/jfs/jfs_metapage.h |    1 -
 2 files changed, 12 insertions(+), 20 deletions(-)

diff -puN fs/jfs/jfs_metapage.c~fs-jfs-remove-slab-object-constructor fs/jfs/jfs_metapage.c
--- a/fs/jfs/jfs_metapage.c~fs-jfs-remove-slab-object-constructor
+++ a/fs/jfs/jfs_metapage.c
@@ -183,30 +183,23 @@ static inline void remove_metapage(struc
 
 #endif
 
-static void init_once(void *foo)
-{
-	struct metapage *mp = (struct metapage *)foo;
-
-	mp->lid = 0;
-	mp->lsn = 0;
-	mp->flag = 0;
-	mp->data = NULL;
-	mp->clsn = 0;
-	mp->log = NULL;
-	set_bit(META_free, &mp->flag);
-	init_waitqueue_head(&mp->wait);
-}
-
 static inline struct metapage *alloc_metapage(gfp_t gfp_mask)
 {
-	return mempool_alloc(metapage_mempool, gfp_mask);
+	struct metapage *mp = mempool_alloc(metapage_mempool, gfp_mask);
+
+	if (mp) {
+		mp->lid = 0;
+		mp->lsn = 0;
+		mp->data = NULL;
+		mp->clsn = 0;
+		mp->log = NULL;
+		init_waitqueue_head(&mp->wait);
+	}
+	return mp;
 }
 
 static inline void free_metapage(struct metapage *mp)
 {
-	mp->flag = 0;
-	set_bit(META_free, &mp->flag);
-
 	mempool_free(mp, metapage_mempool);
 }
 
@@ -216,7 +209,7 @@ int __init metapage_init(void)
 	 * Allocate the metapage structures
 	 */
 	metapage_cache = kmem_cache_create("jfs_mp", sizeof(struct metapage),
-					   0, 0, init_once);
+					   0, 0, NULL);
 	if (metapage_cache == NULL)
 		return -ENOMEM;
 
diff -puN fs/jfs/jfs_metapage.h~fs-jfs-remove-slab-object-constructor fs/jfs/jfs_metapage.h
--- a/fs/jfs/jfs_metapage.h~fs-jfs-remove-slab-object-constructor
+++ a/fs/jfs/jfs_metapage.h
@@ -48,7 +48,6 @@ struct metapage {
 
 /* metapage flag */
 #define META_locked	0
-#define META_free	1
 #define META_dirty	2
 #define META_sync	3
 #define META_discard	4
_

Patches currently in -mm which might be from rientjes@google.com are

mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch
mm-pagewalk-prevent-positive-return-value-of-walk_page_test-from-being-passed-to-callers.patch
mm-memory-hotplog-postpone-the-reset-of-obsolete-pgdat.patch
mm-slub-fix-lockups-on-preempt-smp-kernels.patch
cxgb4-drop-__gfp_nofail-allocation.patch
sh-dwarf-destroy-mempools-on-cleanup.patch
sh-dwarf-use-mempool_create_slab_pool.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-slab-correct-config-option-in-comment.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-mempool-do-not-allow-atomic-resizing.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
mm-refactor-zone_movable_is_highmem.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix-2.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
allow-compaction-of-unevictable-pages.patch
mm-compaction-reset-compaction-scanner-positions.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch
hugetlbfs-add-minimum-size-accounting-to-subpools.patch
hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly.patch
hugetlbfs-document-min_size-mount-option-and-cleanup.patch
mm-vmalloc-fix-possible-exhaustion-of-vmalloc-space-caused-by-vm_map_ram-allocator.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
mremap-should-return-enomem-when-__vm_enough_memory-fail.patch
clean-up-goto-just-return-err_ptr.patch
fs-jfs-remove-slab-object-constructor.patch
mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors.patch
mm-mempool-poison-elements-backed-by-slab-allocator.patch
mm-mempool-poison-elements-backed-by-page-allocator.patch
hung_task-change-hung_taskc-to-use-for_each_process_thread.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

