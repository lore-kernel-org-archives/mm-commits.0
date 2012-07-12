From: akpm@linux-foundation.org
Subject: + nfs-disable-data-cache-revalidation-for-swapfiles.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:48:08 -0700
Message-ID: <20120712214808.809E31E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:47822 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058Ab2GLVsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:48:10 -0400
Received: by qcqs25 with SMTP id s25so283579qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:48:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc


The patch titled
     Subject: nfs: disable data cache revalidation for swapfiles
has been added to the -mm tree.  Its filename is
     nfs-disable-data-cache-revalidation-for-swapfiles.patch

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
Subject: nfs: disable data cache revalidation for swapfiles

The VM does not like PG_private set on PG_swapcache pages.  As suggested
by Trond in http://lkml.org/lkml/2006/8/25/348, this patch disables NFS
data cache revalidation on swap files.  as it does not make sense to have
other clients change the file while it is being used as swap.  This avoids
setting PG_private on swap pages, since there ought to be no further races
with invalidate_inode_pages2() to deal with.

Since we cannot set PG_private we cannot use page->private which is
already used by PG_swapcache pages to store the nfs_page.  Thus augment
the new nfs_page_find_request logic.

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

 fs/nfs/inode.c |    4 +++
 fs/nfs/write.c |   49 +++++++++++++++++++++++++++++++++--------------
 2 files changed, 39 insertions(+), 14 deletions(-)

diff -puN fs/nfs/inode.c~nfs-disable-data-cache-revalidation-for-swapfiles fs/nfs/inode.c
--- a/fs/nfs/inode.c~nfs-disable-data-cache-revalidation-for-swapfiles
+++ a/fs/nfs/inode.c
@@ -883,6 +883,10 @@ int nfs_revalidate_mapping(struct inode 
 	struct nfs_inode *nfsi = NFS_I(inode);
 	int ret = 0;
 
+	/* swapfiles are not supposed to be shared. */
+	if (IS_SWAPFILE(inode))
+		goto out;
+
 	if (nfs_mapping_need_revalidate_inode(inode)) {
 		ret = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
 		if (ret < 0)
diff -puN fs/nfs/write.c~nfs-disable-data-cache-revalidation-for-swapfiles fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-disable-data-cache-revalidation-for-swapfiles
+++ a/fs/nfs/write.c
@@ -139,15 +139,28 @@ static void nfs_context_set_write_error(
 	set_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
 }
 
-static struct nfs_page *nfs_page_find_request_locked(struct page *page)
+static struct nfs_page *
+nfs_page_find_request_locked(struct nfs_inode *nfsi, struct page *page)
 {
 	struct nfs_page *req = NULL;
 
-	if (PagePrivate(page)) {
+	if (PagePrivate(page))
 		req = (struct nfs_page *)page_private(page);
-		if (req != NULL)
-			kref_get(&req->wb_kref);
+	else if (unlikely(PageSwapCache(page))) {
+		struct nfs_page *freq, *t;
+
+		/* Linearly search the commit list for the correct req */
+		list_for_each_entry_safe(freq, t, &nfsi->commit_info.list, wb_list) {
+			if (freq->wb_page == page) {
+				req = freq;
+				break;
+			}
+		}
 	}
+
+	if (req)
+		kref_get(&req->wb_kref);
+
 	return req;
 }
 
@@ -157,7 +170,7 @@ static struct nfs_page *nfs_page_find_re
 	struct nfs_page *req = NULL;
 
 	spin_lock(&inode->i_lock);
-	req = nfs_page_find_request_locked(page);
+	req = nfs_page_find_request_locked(NFS_I(inode), page);
 	spin_unlock(&inode->i_lock);
 	return req;
 }
@@ -258,7 +271,7 @@ static struct nfs_page *nfs_find_and_loc
 
 	spin_lock(&inode->i_lock);
 	for (;;) {
-		req = nfs_page_find_request_locked(page);
+		req = nfs_page_find_request_locked(NFS_I(inode), page);
 		if (req == NULL)
 			break;
 		if (nfs_lock_request(req))
@@ -413,9 +426,15 @@ static void nfs_inode_add_request(struct
 	spin_lock(&inode->i_lock);
 	if (!nfsi->npages && NFS_PROTO(inode)->have_delegation(inode, FMODE_WRITE))
 		inode->i_version++;
-	set_bit(PG_MAPPED, &req->wb_flags);
-	SetPagePrivate(req->wb_page);
-	set_page_private(req->wb_page, (unsigned long)req);
+	/*
+	 * Swap-space should not get truncated. Hence no need to plug the race
+	 * with invalidate/truncate.
+	 */
+	if (likely(!PageSwapCache(req->wb_page))) {
+		set_bit(PG_MAPPED, &req->wb_flags);
+		SetPagePrivate(req->wb_page);
+		set_page_private(req->wb_page, (unsigned long)req);
+	}
 	nfsi->npages++;
 	kref_get(&req->wb_kref);
 	spin_unlock(&inode->i_lock);
@@ -432,9 +451,11 @@ static void nfs_inode_remove_request(str
 	BUG_ON (!NFS_WBACK_BUSY(req));
 
 	spin_lock(&inode->i_lock);
-	set_page_private(req->wb_page, 0);
-	ClearPagePrivate(req->wb_page);
-	clear_bit(PG_MAPPED, &req->wb_flags);
+	if (likely(!PageSwapCache(req->wb_page))) {
+		set_page_private(req->wb_page, 0);
+		ClearPagePrivate(req->wb_page);
+		clear_bit(PG_MAPPED, &req->wb_flags);
+	}
 	nfsi->npages--;
 	spin_unlock(&inode->i_lock);
 	nfs_release_request(req);
@@ -730,7 +751,7 @@ static struct nfs_page *nfs_try_to_updat
 	spin_lock(&inode->i_lock);
 
 	for (;;) {
-		req = nfs_page_find_request_locked(page);
+		req = nfs_page_find_request_locked(NFS_I(inode), page);
 		if (req == NULL)
 			goto out_unlock;
 
@@ -1744,7 +1765,7 @@ int nfs_wb_page_cancel(struct inode *ino
  */
 int nfs_wb_page(struct inode *inode, struct page *page)
 {
-	loff_t range_start = page_offset(page);
+	loff_t range_start = page_file_offset(page);
 	loff_t range_end = range_start + (loff_t)(PAGE_CACHE_SIZE - 1);
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_ALL,
_
Subject: Subject: nfs: disable data cache revalidation for swapfiles

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

