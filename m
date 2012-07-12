From: akpm@linux-foundation.org
Subject: + mm-add-support-for-direct_io-to-highmem-pages.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:47:58 -0700
Message-ID: <20120712214759.5A5D5100056@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:53893 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab2GLVsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:48:01 -0400
Received: by qabg24 with SMTP id g24so302811qab.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:48:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc


The patch titled
     Subject: mm: add support for direct_IO to highmem pages
has been added to the -mm tree.  Its filename is
     mm-add-support-for-direct_io-to-highmem-pages.patch

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
Subject: mm: add support for direct_IO to highmem pages

The patch "mm: add support for a filesystem to activate swap files and use
direct_IO for writing swap pages" added support for using direct_IO to
write swap pages but it is insufficient for highmem pages.

To support highmem pages, this patch kmaps() the page before calling the
direct_IO() handler.  As direct_IO deals with virtual addresses an
additional helper is necessary for get_kernel_pages() to lookup the struct
page for a kmap virtual address.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
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

 include/linux/highmem.h |    7 +++++++
 mm/highmem.c            |   12 ++++++++++++
 mm/memory.c             |    3 +--
 mm/page_io.c            |    3 ++-
 4 files changed, 22 insertions(+), 3 deletions(-)

diff -puN include/linux/highmem.h~mm-add-support-for-direct_io-to-highmem-pages include/linux/highmem.h
--- a/include/linux/highmem.h~mm-add-support-for-direct_io-to-highmem-pages
+++ a/include/linux/highmem.h
@@ -39,10 +39,17 @@ extern unsigned long totalhigh_pages;
 
 void kmap_flush_unused(void);
 
+struct page *kmap_to_page(void *addr);
+
 #else /* CONFIG_HIGHMEM */
 
 static inline unsigned int nr_free_highpages(void) { return 0; }
 
+static inline struct page *kmap_to_page(void *addr)
+{
+	return virt_to_page(addr);
+}
+
 #define totalhigh_pages 0UL
 
 #ifndef ARCH_HAS_KMAP
diff -puN mm/highmem.c~mm-add-support-for-direct_io-to-highmem-pages mm/highmem.c
--- a/mm/highmem.c~mm-add-support-for-direct_io-to-highmem-pages
+++ a/mm/highmem.c
@@ -94,6 +94,18 @@ static DECLARE_WAIT_QUEUE_HEAD(pkmap_map
 		do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
 #endif
 
+struct page *kmap_to_page(void *vaddr)
+{
+	unsigned long addr = (unsigned long)vaddr;
+
+	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
+		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
+		return pte_page(pkmap_page_table[i]);
+	}
+
+	return virt_to_page(addr);
+}
+
 static void flush_all_zero_pkmaps(void)
 {
 	int i;
diff -puN mm/memory.c~mm-add-support-for-direct_io-to-highmem-pages mm/memory.c
--- a/mm/memory.c~mm-add-support-for-direct_io-to-highmem-pages
+++ a/mm/memory.c
@@ -1864,8 +1864,7 @@ int get_kernel_pages(const struct kvec *
 		if (WARN_ON(kiov[seg].iov_len != PAGE_SIZE))
 			return seg;
 
-		/* virt_to_page sanity checks the PFN */
-		pages[seg] = virt_to_page(kiov[seg].iov_base);
+		pages[seg] = kmap_to_page(kiov[seg].iov_base);
 		page_cache_get(pages[seg]);
 	}
 
diff -puN mm/page_io.c~mm-add-support-for-direct_io-to-highmem-pages mm/page_io.c
--- a/mm/page_io.c~mm-add-support-for-direct_io-to-highmem-pages
+++ a/mm/page_io.c
@@ -205,7 +205,7 @@ int swap_writepage(struct page *page, st
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 		struct iovec iov = {
-			.iov_base = page_address(page),
+			.iov_base = kmap(page),
 			.iov_len  = PAGE_SIZE,
 		};
 
@@ -218,6 +218,7 @@ int swap_writepage(struct page *page, st
 		ret = mapping->a_ops->direct_IO(KERNEL_WRITE,
 						&kiocb, &iov,
 						kiocb.ki_pos, 1);
+		kunmap(page);
 		if (ret == PAGE_SIZE) {
 			count_vm_event(PSWPOUT);
 			ret = 0;
_
Subject: Subject: mm: add support for direct_IO to highmem pages

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

