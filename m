From: akpm@linux-foundation.org
Subject: + mm-make-page-pfmemalloc-check-more-robust.patch added to -mm
 tree
Date: Thu, 13 Aug 2015 14:18:05 -0700
Message-ID: <55cd098d.ncYW/cO4iQ4w09a5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbbHMVSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Aug 2015 17:18:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, davem@davemloft.net, eric.dumazet@gmail.com, jbohac@suse.com, mgorman@suse.de, stable@vger.kernel.org, vbabka@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make page pfmemalloc check more robust
has been added to the -mm tree.  Its filename is
     mm-make-page-pfmemalloc-check-more-robust.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-page-pfmemalloc-check-more-robust.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-page-pfmemalloc-check-more-robust.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: make page pfmemalloc check more robust

The patch c48a11c7ad26 ("netvm: propagate page->pfmemalloc to skb") added
the checks for page->pfmemalloc to __skb_fill_page_desc():

        if (page->pfmemalloc && !page->mapping)
                skb->pfmemalloc = true;

It assumes page->mapping == NULL implies that page->pfmemalloc can be
trusted.  However, __delete_from_page_cache() can set set page->mapping to
NULL and leave page->index value alone.  Due to being in union, a non-zero
page->index will be interpreted as true page->pfmemalloc.

So the assumption is invalid if the networking code can see such a page. 
And it seems it can.  We have encountered this with a NFS over loopback
setup when such a page is attached to a new skbuf.  There is no copying
going on in this case so the page confuses __skb_fill_page_desc which
interprets the index as pfmemalloc flag and the network stack drops
packets that have been allocated using the reserves unless they are to be
queued on sockets handling the swapping which is the case here and that
leads to hangs when the nfs client waits for a response from the server
which has been dropped and thus never arrive.

The struct page is already heavily packed so rather than finding another
hole to put it in, let's do a trick instead.  We can reuse the index again
but define it to an impossible value (-1UL).  This is the page index so it
should never see the value that large.  Replace all direct users of
page->pfmemalloc by page_is_pfmemalloc which will hide this nastiness from
unspoiled eyes.

The information will get lost if somebody wants to use page->index
obviously but that was the case before and the original code expected that
the information should be persisted somewhere else if that is really
needed (e.g.  what SLAB and SLUB do).

Fixes: c48a11c7ad26 ("netvm: propagate page->pfmemalloc to skb")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Debugged-by: Vlastimil Babka <vbabka@suse.com>
Debugged-by: Jiri Bohac <jbohac@suse.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>	[3.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/intel/fm10k/fm10k_main.c     |    2 
 drivers/net/ethernet/intel/igb/igb_main.c         |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |    2 
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    2 
 include/linux/mm.h                                |   28 ++++++++++++
 include/linux/mm_types.h                          |    9 ---
 include/linux/skbuff.h                            |   14 ++----
 mm/page_alloc.c                                   |    9 ++-
 mm/slab.c                                         |    4 -
 mm/slub.c                                         |    2 
 net/core/skbuff.c                                 |    2 
 11 files changed, 47 insertions(+), 29 deletions(-)

diff -puN drivers/net/ethernet/intel/fm10k/fm10k_main.c~mm-make-page-pfmemalloc-check-more-robust drivers/net/ethernet/intel/fm10k/fm10k_main.c
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c~mm-make-page-pfmemalloc-check-more-robust
+++ a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -216,7 +216,7 @@ static void fm10k_reuse_rx_page(struct f
 
 static inline bool fm10k_page_is_reserved(struct page *page)
 {
-	return (page_to_nid(page) != numa_mem_id()) || page->pfmemalloc;
+	return (page_to_nid(page) != numa_mem_id()) || page_is_pfmemalloc(page);
 }
 
 static bool fm10k_can_reuse_rx_page(struct fm10k_rx_buffer *rx_buffer,
diff -puN drivers/net/ethernet/intel/igb/igb_main.c~mm-make-page-pfmemalloc-check-more-robust drivers/net/ethernet/intel/igb/igb_main.c
--- a/drivers/net/ethernet/intel/igb/igb_main.c~mm-make-page-pfmemalloc-check-more-robust
+++ a/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6566,7 +6566,7 @@ static void igb_reuse_rx_page(struct igb
 
 static inline bool igb_page_is_reserved(struct page *page)
 {
-	return (page_to_nid(page) != numa_mem_id()) || page->pfmemalloc;
+	return (page_to_nid(page) != numa_mem_id()) || page_is_pfmemalloc(page);
 }
 
 static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer,
diff -puN drivers/net/ethernet/intel/ixgbe/ixgbe_main.c~mm-make-page-pfmemalloc-check-more-robust drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c~mm-make-page-pfmemalloc-check-more-robust
+++ a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1832,7 +1832,7 @@ static void ixgbe_reuse_rx_page(struct i
 
 static inline bool ixgbe_page_is_reserved(struct page *page)
 {
-	return (page_to_nid(page) != numa_mem_id()) || page->pfmemalloc;
+	return (page_to_nid(page) != numa_mem_id()) || page_is_pfmemalloc(page);
 }
 
 /**
diff -puN drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c~mm-make-page-pfmemalloc-check-more-robust drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c~mm-make-page-pfmemalloc-check-more-robust
+++ a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -765,7 +765,7 @@ static void ixgbevf_reuse_rx_page(struct
 
 static inline bool ixgbevf_page_is_reserved(struct page *page)
 {
-	return (page_to_nid(page) != numa_mem_id()) || page->pfmemalloc;
+	return (page_to_nid(page) != numa_mem_id()) || page_is_pfmemalloc(page);
 }
 
 /**
diff -puN include/linux/mm.h~mm-make-page-pfmemalloc-check-more-robust include/linux/mm.h
--- a/include/linux/mm.h~mm-make-page-pfmemalloc-check-more-robust
+++ a/include/linux/mm.h
@@ -1003,6 +1003,34 @@ static inline int page_mapped(struct pag
 }
 
 /*
+ * Return true only if the page has been allocated with
+ * ALLOC_NO_WATERMARKS and the low watermark was not
+ * met implying that the system is under some pressure.
+ */
+static inline bool page_is_pfmemalloc(struct page *page)
+{
+	/*
+	 * Page index cannot be this large so this must be
+	 * a pfmemalloc page.
+	 */
+	return page->index == -1UL;
+}
+
+/*
+ * Only to be called by the page allocator on a freshly allocated
+ * page.
+ */
+static inline void set_page_pfmemalloc(struct page *page)
+{
+	page->index = -1UL;
+}
+
+static inline void clear_page_pfmemalloc(struct page *page)
+{
+	page->index = 0;
+}
+
+/*
  * Different kinds of faults, as returned by handle_mm_fault().
  * Used to decide whether a process gets delivered SIGBUS or
  * just gets major/minor fault counters bumped up.
diff -puN include/linux/mm_types.h~mm-make-page-pfmemalloc-check-more-robust include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-make-page-pfmemalloc-check-more-robust
+++ a/include/linux/mm_types.h
@@ -63,15 +63,6 @@ struct page {
 		union {
 			pgoff_t index;		/* Our offset within mapping. */
 			void *freelist;		/* sl[aou]b first free object */
-			bool pfmemalloc;	/* If set by the page allocator,
-						 * ALLOC_NO_WATERMARKS was set
-						 * and the low watermark was not
-						 * met implying that the system
-						 * is under some pressure. The
-						 * caller should try ensure
-						 * this page is only used to
-						 * free other pages.
-						 */
 		};
 
 		union {
diff -puN include/linux/skbuff.h~mm-make-page-pfmemalloc-check-more-robust include/linux/skbuff.h
--- a/include/linux/skbuff.h~mm-make-page-pfmemalloc-check-more-robust
+++ a/include/linux/skbuff.h
@@ -1602,20 +1602,16 @@ static inline void __skb_fill_page_desc(
 	skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 	/*
-	 * Propagate page->pfmemalloc to the skb if we can. The problem is
-	 * that not all callers have unique ownership of the page. If
-	 * pfmemalloc is set, we check the mapping as a mapping implies
-	 * page->index is set (index and pfmemalloc share space).
-	 * If it's a valid mapping, we cannot use page->pfmemalloc but we
-	 * do not lose pfmemalloc information as the pages would not be
-	 * allocated using __GFP_MEMALLOC.
+	 * Propagate page pfmemalloc to the skb if we can. The problem is
+	 * that not all callers have unique ownership of the page but rely
+	 * on page_is_pfmemalloc doing the right thing(tm).
 	 */
 	frag->page.p		  = page;
 	frag->page_offset	  = off;
 	skb_frag_size_set(frag, size);
 
 	page = compound_head(page);
-	if (page->pfmemalloc && !page->mapping)
+	if (page_is_pfmemalloc(page))
 		skb->pfmemalloc	= true;
 }
 
@@ -2263,7 +2259,7 @@ static inline struct page *dev_alloc_pag
 static inline void skb_propagate_pfmemalloc(struct page *page,
 					     struct sk_buff *skb)
 {
-	if (page && page->pfmemalloc)
+	if (page_is_pfmemalloc(page))
 		skb->pfmemalloc = true;
 }
 
diff -puN mm/page_alloc.c~mm-make-page-pfmemalloc-check-more-robust mm/page_alloc.c
--- a/mm/page_alloc.c~mm-make-page-pfmemalloc-check-more-robust
+++ a/mm/page_alloc.c
@@ -1343,12 +1343,15 @@ static int prep_new_page(struct page *pa
 	set_page_owner(page, order, gfp_flags);
 
 	/*
-	 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was necessary to
+	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
 	 * allocate the page. The expectation is that the caller is taking
 	 * steps that will free more memory. The caller should avoid the page
 	 * being used for !PFMEMALLOC purposes.
 	 */
-	page->pfmemalloc = !!(alloc_flags & ALLOC_NO_WATERMARKS);
+	if (alloc_flags & ALLOC_NO_WATERMARKS)
+		set_page_pfmemalloc(page);
+	else
+		clear_page_pfmemalloc(page);
 
 	return 0;
 }
@@ -3345,7 +3348,7 @@ refill:
 		atomic_add(size - 1, &page->_count);
 
 		/* reset page count bias and offset to start of new frag */
-		nc->pfmemalloc = page->pfmemalloc;
+		nc->pfmemalloc = page_is_pfmemalloc(page);
 		nc->pagecnt_bias = size;
 		nc->offset = size;
 	}
diff -puN mm/slab.c~mm-make-page-pfmemalloc-check-more-robust mm/slab.c
--- a/mm/slab.c~mm-make-page-pfmemalloc-check-more-robust
+++ a/mm/slab.c
@@ -1603,7 +1603,7 @@ static struct page *kmem_getpages(struct
 	}
 
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
-	if (unlikely(page->pfmemalloc))
+	if (page_is_pfmemalloc(page))
 		pfmemalloc_active = true;
 
 	nr_pages = (1 << cachep->gfporder);
@@ -1614,7 +1614,7 @@ static struct page *kmem_getpages(struct
 		add_zone_page_state(page_zone(page),
 			NR_SLAB_UNRECLAIMABLE, nr_pages);
 	__SetPageSlab(page);
-	if (page->pfmemalloc)
+	if (page_is_pfmemalloc(page))
 		SetPageSlabPfmemalloc(page);
 
 	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK)) {
diff -puN mm/slub.c~mm-make-page-pfmemalloc-check-more-robust mm/slub.c
--- a/mm/slub.c~mm-make-page-pfmemalloc-check-more-robust
+++ a/mm/slub.c
@@ -1427,7 +1427,7 @@ static struct page *new_slab(struct kmem
 	inc_slabs_node(s, page_to_nid(page), page->objects);
 	page->slab_cache = s;
 	__SetPageSlab(page);
-	if (page->pfmemalloc)
+	if (page_is_pfmemalloc)
 		SetPageSlabPfmemalloc(page);
 
 	start = page_address(page);
diff -puN net/core/skbuff.c~mm-make-page-pfmemalloc-check-more-robust net/core/skbuff.c
--- a/net/core/skbuff.c~mm-make-page-pfmemalloc-check-more-robust
+++ a/net/core/skbuff.c
@@ -340,7 +340,7 @@ struct sk_buff *build_skb(void *data, un
 
 	if (skb && frag_size) {
 		skb->head_frag = 1;
-		if (virt_to_head_page(data)->pfmemalloc)
+		if (page_is_pfmemalloc(virt_to_head_page(data)))
 			skb->pfmemalloc = 1;
 	}
 	return skb;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-make-page-pfmemalloc-check-more-robust.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages-fix.patch
mm-oom-remove-unnecessary-variable.patch
sparc32-do-not-include-swaph-from-pgtable_32h-export-struct-mem_cgroup.patch
memcg-move-memcg_proto_active-from-sockh.patch
mm-srcu-ify-shrinkers.patch

