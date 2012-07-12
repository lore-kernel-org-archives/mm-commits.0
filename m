From: akpm@linux-foundation.org
Subject: + nfs-prevent-page-allocator-recursions-with-swap-over-nfs.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:48:18 -0700
Message-ID: <20120712214818.F1AD320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:46822 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071Ab2GLVsX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:48:23 -0400
Received: by weyr1 with SMTP id r1so149138wey.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:48:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc


The patch titled
     Subject: nfs: prevent page allocator recursions with swap over NFS.
has been added to the -mm tree.  Its filename is
     nfs-prevent-page-allocator-recursions-with-swap-over-nfs.patch

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
Subject: nfs: prevent page allocator recursions with swap over NFS.

GFP_NOFS is _more_ permissive than GFP_NOIO in that it will initiate IO,
just not of any filesystem data.

The problem is that previously NOFS was correct because that avoids
recursion into the NFS code.  With swap-over-NFS, it is no longer correct
as swap IO can lead to this recursion.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/pagelist.c |    2 +-
 fs/nfs/write.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/nfs/pagelist.c~nfs-prevent-page-allocator-recursions-with-swap-over-nfs fs/nfs/pagelist.c
--- a/fs/nfs/pagelist.c~nfs-prevent-page-allocator-recursions-with-swap-over-nfs
+++ a/fs/nfs/pagelist.c
@@ -70,7 +70,7 @@ void nfs_set_pgio_error(struct nfs_pgio_
 static inline struct nfs_page *
 nfs_page_alloc(void)
 {
-	struct nfs_page	*p = kmem_cache_zalloc(nfs_page_cachep, GFP_KERNEL);
+	struct nfs_page	*p = kmem_cache_zalloc(nfs_page_cachep, GFP_NOIO);
 	if (p)
 		INIT_LIST_HEAD(&p->wb_list);
 	return p;
diff -puN fs/nfs/write.c~nfs-prevent-page-allocator-recursions-with-swap-over-nfs fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-prevent-page-allocator-recursions-with-swap-over-nfs
+++ a/fs/nfs/write.c
@@ -52,7 +52,7 @@ static mempool_t *nfs_commit_mempool;
 
 struct nfs_commit_data *nfs_commitdata_alloc(void)
 {
-	struct nfs_commit_data *p = mempool_alloc(nfs_commit_mempool, GFP_NOFS);
+	struct nfs_commit_data *p = mempool_alloc(nfs_commit_mempool, GFP_NOIO);
 
 	if (p) {
 		memset(p, 0, sizeof(*p));
@@ -70,7 +70,7 @@ EXPORT_SYMBOL_GPL(nfs_commit_free);
 
 struct nfs_write_header *nfs_writehdr_alloc(void)
 {
-	struct nfs_write_header *p = mempool_alloc(nfs_wdata_mempool, GFP_NOFS);
+	struct nfs_write_header *p = mempool_alloc(nfs_wdata_mempool, GFP_NOIO);
 
 	if (p) {
 		struct nfs_pgio_header *hdr = &p->header;
_
Subject: Subject: nfs: prevent page allocator recursions with swap over NFS.

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

