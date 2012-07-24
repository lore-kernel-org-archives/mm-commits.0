From: akpm@linux-foundation.org
Subject: + mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o-fix.patch added to -mm tree
Date: Tue, 24 Jul 2012 14:33:31 -0700
Message-ID: <20120724213337.CBB391E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:58121 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab2GXVdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 17:33:45 -0400
Received: by qcqs25 with SMTP id s25so6779qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 14:33:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, msalter@redhat.com


The patch titled
     Subject: mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o-fix
has been added to the -mm tree.  Its filename is
     mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o-fix

get_kernel_pages was put in memory.c beside get_user_pages but this only
works for CONFIG_MMU.  As there is nothing special to be done for
!CONFIG_MMU, this build fix moves the functions to mm/swap.c which is the
next best fit.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Mark Salter <msalter@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   53 --------------------------------------------------
 mm/swap.c   |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 53 deletions(-)

diff -puN mm/memory.c~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o-fix mm/memory.c
--- a/mm/memory.c~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o-fix
+++ a/mm/memory.c
@@ -1852,59 +1852,6 @@ next_page:
 EXPORT_SYMBOL(__get_user_pages);
 
 /*
- * get_kernel_pages() - pin kernel pages in memory
- * @kiov:	An array of struct kvec structures
- * @nr_segs:	number of segments to pin
- * @write:	pinning for read/write, currently ignored
- * @pages:	array that receives pointers to the pages pinned.
- *		Should be at least nr_segs long.
- *
- * Returns number of pages pinned. This may be fewer than the number
- * requested. If nr_pages is 0 or negative, returns 0. If no pages
- * were pinned, returns -errno. Each page returned must be released
- * with a put_page() call when it is finished with.
- */
-int get_kernel_pages(const struct kvec *kiov, int nr_segs, int write,
-		struct page **pages)
-{
-	int seg;
-
-	for (seg = 0; seg < nr_segs; seg++) {
-		if (WARN_ON(kiov[seg].iov_len != PAGE_SIZE))
-			return seg;
-
-		/* virt_to_page sanity checks the PFN */
-		pages[seg] = virt_to_page(kiov[seg].iov_base);
-		page_cache_get(pages[seg]);
-	}
-
-	return seg;
-}
-EXPORT_SYMBOL_GPL(get_kernel_pages);
-
-/*
- * get_kernel_page() - pin a kernel page in memory
- * @start:	starting kernel address
- * @write:	pinning for read/write, currently ignored
- * @pages:	array that receives pointer to the page pinned.
- *		Must be at least nr_segs long.
- *
- * Returns 1 if page is pinned. If the page was not pinned, returns
- * -errno. The page returned must be released with a put_page() call
- * when it is finished with.
- */
-int get_kernel_page(unsigned long start, int write, struct page **pages)
-{
-	const struct kvec kiov = {
-		.iov_base = (void *)start,
-		.iov_len = PAGE_SIZE
-	};
-
-	return get_kernel_pages(&kiov, 1, write, pages);
-}
-EXPORT_SYMBOL_GPL(get_kernel_page);
-
-/*
  * fixup_user_fault() - manually resolve a user page fault
  * @tsk:	the task_struct to use for page fault accounting, or
  *		NULL if faults are not to be recorded.
diff -puN mm/swap.c~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o-fix mm/swap.c
--- a/mm/swap.c~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o-fix
+++ a/mm/swap.c
@@ -236,6 +236,59 @@ void put_pages_list(struct list_head *pa
 }
 EXPORT_SYMBOL(put_pages_list);
 
+/*
+ * get_kernel_pages() - pin kernel pages in memory
+ * @kiov:	An array of struct kvec structures
+ * @nr_segs:	number of segments to pin
+ * @write:	pinning for read/write, currently ignored
+ * @pages:	array that receives pointers to the pages pinned.
+ *		Should be at least nr_segs long.
+ *
+ * Returns number of pages pinned. This may be fewer than the number
+ * requested. If nr_pages is 0 or negative, returns 0. If no pages
+ * were pinned, returns -errno. Each page returned must be released
+ * with a put_page() call when it is finished with.
+ */
+int get_kernel_pages(const struct kvec *kiov, int nr_segs, int write,
+		struct page **pages)
+{
+	int seg;
+
+	for (seg = 0; seg < nr_segs; seg++) {
+		if (WARN_ON(kiov[seg].iov_len != PAGE_SIZE))
+			return seg;
+
+		/* virt_to_page sanity checks the PFN */
+		pages[seg] = virt_to_page(kiov[seg].iov_base);
+		page_cache_get(pages[seg]);
+	}
+
+	return seg;
+}
+EXPORT_SYMBOL_GPL(get_kernel_pages);
+
+/*
+ * get_kernel_page() - pin a kernel page in memory
+ * @start:	starting kernel address
+ * @write:	pinning for read/write, currently ignored
+ * @pages:	array that receives pointer to the page pinned.
+ *		Must be at least nr_segs long.
+ *
+ * Returns 1 if page is pinned. If the page was not pinned, returns
+ * -errno. The page returned must be released with a put_page() call
+ * when it is finished with.
+ */
+int get_kernel_page(unsigned long start, int write, struct page **pages)
+{
+	const struct kvec kiov = {
+		.iov_base = (void *)start,
+		.iov_len = PAGE_SIZE
+	};
+
+	return get_kernel_pages(&kiov, 1, write, pages);
+}
+EXPORT_SYMBOL_GPL(get_kernel_page);
+
 static void pagevec_lru_move_fn(struct pagevec *pvec,
 	void (*move_fn)(struct page *page, struct lruvec *lruvec, void *arg),
 	void *arg)
_
Subject: Subject: mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o-fix

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-fix-wrong-argument-of-migrate_huge_pages-in-soft_offline_huge_page.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
parisc-redefine-atomic_init-and-atomic64_init-like-other-architectures.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix.patch
mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks.patch
mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves.patch
mm-allow-pf_memalloc-from-softirq-context.patch
mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used.patch
mm-ignore-mempolicies-when-using-alloc_no_watermark.patch
net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket.patch
netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets.patch
netvm-allow-skb-allocation-to-use-pfmemalloc-reserves.patch
netvm-propagate-page-pfmemalloc-to-skb.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
netvm-set-pf_memalloc-as-appropriate-during-skb-processing.patch
mm-micro-optimise-slab-to-avoid-a-function-call.patch
nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch
mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage.patch
mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch
netvm-prevent-a-stream-specific-deadlock.patch
selinux-tag-avc-cache-alloc-as-non-critical.patch
mm-methods-for-teaching-filesystems-about-pg_swapcache-pages.patch
mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o.patch
mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o-fix.patch
mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages.patch
mm-swap-implement-generic-handler-for-swap_activate.patch
mm-add-support-for-direct_io-to-highmem-pages.patch
nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages.patch
nfs-disable-data-cache-revalidation-for-swapfiles.patch
nfs-enable-swap-on-nfs.patch
nfs-prevent-page-allocator-recursions-with-swap-over-nfs.patch
swapfile-avoid-dereferencing-bd_disk-during-swap_entry_free-for-network-storage.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch

