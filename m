From: akpm@linux-foundation.org
Subject: + mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:47:53 -0700
Message-ID: <20120712214754.076FC5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38613 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2GLVr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:47:57 -0400
Received: by eekd4 with SMTP id d4so92313eek.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:47:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc


The patch titled
     Subject: mm: add get_kernel_page[s] for pinning of kernel addresses for I/O
has been added to the -mm tree.  Its filename is
     mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o.patch

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
Subject: mm: add get_kernel_page[s] for pinning of kernel addresses for I/O

This patch adds two new APIs get_kernel_pages() and get_kernel_page() that
may be used to pin a vector of kernel addresses for IO.  The initial user
is expected to be NFS for allowing pages to be written to swap using
aops->direct_IO().  Strictly speaking, swap-over-NFS only needs to pin one
page for IO but it makes sense to express the API in terms of a vector and
add a helper for pinning single pages.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blk_types.h |    2 +
 include/linux/fs.h        |    2 +
 include/linux/mm.h        |    4 ++
 mm/memory.c               |   53 ++++++++++++++++++++++++++++++++++++
 4 files changed, 61 insertions(+)

diff -puN include/linux/blk_types.h~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o include/linux/blk_types.h
--- a/include/linux/blk_types.h~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o
+++ a/include/linux/blk_types.h
@@ -160,6 +160,7 @@ enum rq_flag_bits {
 	__REQ_FLUSH_SEQ,	/* request for flush sequence */
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
+	__REQ_KERNEL, 		/* direct IO to kernel pages */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -201,5 +202,6 @@ enum rq_flag_bits {
 #define REQ_IO_STAT		(1 << __REQ_IO_STAT)
 #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
 #define REQ_SECURE		(1 << __REQ_SECURE)
+#define REQ_KERNEL		(1 << __REQ_KERNEL)
 
 #endif /* __LINUX_BLK_TYPES_H */
diff -puN include/linux/fs.h~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o include/linux/fs.h
--- a/include/linux/fs.h~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o
+++ a/include/linux/fs.h
@@ -165,6 +165,8 @@ struct inodes_stat_t {
 #define READ			0
 #define WRITE			RW_MASK
 #define READA			RWA_MASK
+#define KERNEL_READ		(READ|REQ_KERNEL)
+#define KERNEL_WRITE		(WRITE|REQ_KERNEL)
 
 #define READ_SYNC		(READ | REQ_SYNC)
 #define WRITE_SYNC		(WRITE | REQ_SYNC | REQ_NOIDLE)
diff -puN include/linux/mm.h~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o include/linux/mm.h
--- a/include/linux/mm.h~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o
+++ a/include/linux/mm.h
@@ -1019,6 +1019,10 @@ int get_user_pages(struct task_struct *t
 			struct page **pages, struct vm_area_struct **vmas);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
+struct kvec;
+int get_kernel_pages(const struct kvec *iov, int nr_pages, int write,
+			struct page **pages);
+int get_kernel_page(unsigned long start, int write, struct page **pages);
 struct page *get_dump_page(unsigned long addr);
 
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
diff -puN mm/memory.c~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o mm/memory.c
--- a/mm/memory.c~mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o
+++ a/mm/memory.c
@@ -1843,6 +1843,59 @@ next_page:
 EXPORT_SYMBOL(__get_user_pages);
 
 /*
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
+/*
  * fixup_user_fault() - manually resolve a user page fault
  * @tsk:	the task_struct to use for page fault accounting, or
  *		NULL if faults are not to be recorded.
_
Subject: Subject: mm: add get_kernel_page[s] for pinning of kernel addresses for I/O

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-prevent-oom-with-too-many-dirty-pages-fix.patch
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
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages.patch
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
netvm-set-pf_memalloc-as-appropriate-during-skb-processing.patch
mm-micro-optimise-slab-to-avoid-a-function-call.patch
nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch
mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage.patch
mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch
netvm-prevent-a-stream-specific-deadlock.patch
selinux-tag-avc-cache-alloc-as-non-critical.patch
mm-methods-for-teaching-filesystems-about-pg_swapcache-pages.patch
mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages.patch
mm-swap-implement-generic-handler-for-swap_activate.patch
mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o.patch
mm-add-support-for-direct_io-to-highmem-pages.patch
nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages.patch
nfs-disable-data-cache-revalidation-for-swapfiles.patch
nfs-enable-swap-on-nfs.patch
nfs-prevent-page-allocator-recursions-with-swap-over-nfs.patch
swapfile-avoid-dereferencing-bd_disk-during-swap_entry_free-for-network-storage.patch

