From: akpm@linux-foundation.org
Subject: + mm-add-comment-in-alloc_pages_exact_node.patch added to -mm tree
Date: Thu, 15 Apr 2010 13:08:43 -0700
Message-ID: <201004152008.o3FK8hxw028266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756101Ab0DOUJK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 16:09:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lliubbo@gmail.com, mel@csn.ul.ie


The patch titled
     mm: add comment in alloc_pages_exact_node
has been added to the -mm tree.  Its filename is
     mm-add-comment-in-alloc_pages_exact_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add comment in alloc_pages_exact_node
From: Minchan Kim <minchan.kim@gmail.com>

alloc_pages_exact_node() misleads some people.  They considered it
following as.  "This function will allocate pages from node which I wanted
exactly".  But it can allocate pages from fallback list if page allocator
can't find free page from node user wanted.

So let's comment this NOTE.

Actually I wanted to change naming with something better, such as
alloc_pages_explict_node().  But I changed my mind since the comment will
be enough.

If anybody suggests better name, I will do with pleasure.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/gfp.h~mm-add-comment-in-alloc_pages_exact_node include/linux/gfp.h
--- a/include/linux/gfp.h~mm-add-comment-in-alloc_pages_exact_node
+++ a/include/linux/gfp.h
@@ -288,6 +288,12 @@ static inline struct page *alloc_pages_n
 	return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
 }
 
+/*
+ * Use this instead of alloc_pages_node when the caller knows
+ * exactly which node they need (as opposed to passing in -1
+ * for current). Fallback to other nodes will still occur
+ * unless __GFP_THISNODE is specified.
+ */
 static inline struct page *alloc_pages_exact_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

linux-next.patch
rmap-add-exclusively-owned-pages-to-the-newest-anon_vma.patch
ntfs-clean-up-ntfs_attr_extend_initialized.patch
ntfs-use-add_to_page_cache_lru.patch
shmem-remove-redundant-code.patch
mm-remove-return-value-of-putback_lru_pages.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-unusable-free-space-index-via-proc-unusable_index-fix.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index-fix.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-memory-compaction-core-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix-fix.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
mm-migration-allow-the-migration-of-pageswapcache-pages-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
mm-remove-nodes-validity-check-in-alloc_pages.patch
mm-alloc-function-in-pcpu_alloc_pages.patch
mm-change-alloc-function-in-vmemmap_alloc_block.patch
mm-change-alloc-function-in-__vmalloc_area_node.patch
mm-add-comment-in-alloc_pages_exact_node.patch

