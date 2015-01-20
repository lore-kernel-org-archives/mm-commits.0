From: akpm@linux-foundation.org
Subject: + mm-dont-use-compound_head-in-virt_to_head_page-v3.patch added
 to -mm tree
Date: Tue, 20 Jan 2015 14:18:42 -0800
Message-ID: <54bed442.v4E835PRBmv4Yxz2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbbATWSo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jan 2015 17:18:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't use compound_head() in virt_to_head_page()
has been added to the -mm tree.  Its filename is
     mm-dont-use-compound_head-in-virt_to_head_page-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-use-compound_head-in-virt_to_head_page-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-use-compound_head-in-virt_to_head_page-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm: don't use compound_head() in virt_to_head_page()

Change from v2: Add some code comments

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN include/linux/mm.h~mm-dont-use-compound_head-in-virt_to_head_page-v3 include/linux/mm.h
--- a/include/linux/mm.h~mm-dont-use-compound_head-in-virt_to_head_page-v3
+++ a/include/linux/mm.h
@@ -446,6 +446,12 @@ static inline struct page *compound_head
 	return tail;
 }
 
+/*
+ * Since either compound page could be dismantled asynchronously in THP
+ * or we access asynchronously arbitrary positioned struct page, there
+ * would be tail flag race. To handle this race, we should call
+ * smp_rmb() before checking tail flag. compound_head_by_tail() did it.
+ */
 static inline struct page *compound_head(struct page *page)
 {
 	if (unlikely(PageTail(page)))
@@ -453,6 +459,11 @@ static inline struct page *compound_head
 	return page;
 }
 
+/*
+ * If we access compound page synchronously such as access to
+ * allocated page, there is no need to handle tail flag race, so we can
+ * check tail flag directly without any synchronization primitive.
+ */
 static inline struct page *compound_head_fast(struct page *page)
 {
 	if (unlikely(PageTail(page)))
@@ -539,6 +550,12 @@ static inline struct page *virt_to_head_
 {
 	struct page *page = virt_to_page(x);
 
+	/*
+	 * We don't need to worry about synchronization of tail flag
+	 * when we call virt_to_head_page() since it is only called for
+	 * already allocated page and this page won't be freed until
+	 * this virt_to_head_page() is finished. So use _fast variant.
+	 */
 	return compound_head_fast(page);
 }
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch
mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch
mm-dont-use-compound_head-in-virt_to_head_page.patch
mm-dont-use-compound_head-in-virt_to_head_page-v3.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-vmstatc-fix-cleanup-ifdefs-fix.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
mm-cma-fix-totalcma_pages-to-include-dt-defined-cma-regions.patch
mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
mm-compaction-print-current-range-where-compaction-work.patch
mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch

