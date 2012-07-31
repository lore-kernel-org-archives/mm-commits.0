From: akpm@linux-foundation.org
Subject: [folded] nfs-enable-swap-on-nfs-fix-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:34:52 -0700
Message-ID: <20120731233452.B0F90A028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52639 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab2GaXey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:34:54 -0400
Received: by obbwc20 with SMTP id wc20so4820094obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:34:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Trond.Myklebust@netapp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: buildfix: nfs: enable swap on NFS
has been removed from the -mm tree.  Its filename was
     nfs-enable-swap-on-nfs-fix-fix.patch

This patch was dropped because it was folded into nfs-enable-swap-on-nfs.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: buildfix: nfs: enable swap on NFS

Stephen Rothwell reported a merge conflict between a MM patch "nfs: enable
swap on NFS" and an NFS patch "nfs: skip commit in releasepage if we're
freeing memory for fs-related reasons".

Trond pointed out that at the points of the conflict the running context
is rpciod and not a softirq context.  This patch stops PF_MEMALLOC being
set but rpc_malloc still uses __GFP_MEMALLOC where necessary to allocate
from the reserves.  When merged with the "nfs: enable swap on NFS", the
conflict with the NFS tree should disappear.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprtsock.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN net/sunrpc/xprtsock.c~nfs-enable-swap-on-nfs-fix-fix net/sunrpc/xprtsock.c
--- a/net/sunrpc/xprtsock.c~nfs-enable-swap-on-nfs-fix-fix
+++ a/net/sunrpc/xprtsock.c
@@ -2003,15 +2003,11 @@ static void xs_udp_setup_socket(struct w
 		container_of(work, struct sock_xprt, connect_worker.work);
 	struct rpc_xprt *xprt = &transport->xprt;
 	struct socket *sock = transport->sock;
-	unsigned long pflags = current->flags;
 	int status = -EIO;
 
 	if (xprt->shutdown)
 		goto out;
 
-	if (xprt->swapper)
-		current->flags |= PF_MEMALLOC;
-
 	/* Start by resetting any existing state */
 	xs_reset_transport(transport);
 	sock = xs_create_sock(xprt, transport,
@@ -2030,7 +2026,6 @@ static void xs_udp_setup_socket(struct w
 out:
 	xprt_clear_connecting(xprt);
 	xprt_wake_pending_tasks(xprt, status);
-	tsk_restore_flags(current, pflags, PF_MEMALLOC);
 }
 
 /*
@@ -2153,15 +2148,11 @@ static void xs_tcp_setup_socket(struct w
 		container_of(work, struct sock_xprt, connect_worker.work);
 	struct socket *sock = transport->sock;
 	struct rpc_xprt *xprt = &transport->xprt;
-	unsigned long pflags = current->flags;
 	int status = -EIO;
 
 	if (xprt->shutdown)
 		goto out;
 
-	if (xprt->swapper)
-		current->flags |= PF_MEMALLOC;
-
 	if (!sock) {
 		clear_bit(XPRT_CONNECTION_ABORT, &xprt->state);
 		sock = xs_create_sock(xprt, transport,
@@ -2211,7 +2202,6 @@ static void xs_tcp_setup_socket(struct w
 	case -EINPROGRESS:
 	case -EALREADY:
 		xprt_clear_connecting(xprt);
-		tsk_restore_flags(current, pflags, PF_MEMALLOC);
 		return;
 	case -EINVAL:
 		/* Happens, for instance, if the user specified a link
@@ -2224,7 +2214,6 @@ out_eagain:
 out:
 	xprt_clear_connecting(xprt);
 	xprt_wake_pending_tasks(xprt, status);
-	tsk_restore_flags(current, pflags, PF_MEMALLOC);
 }
 
 /**
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
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
mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o.patch
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
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch

