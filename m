From: akpm@linux-foundation.org
Subject: + nfs-enable-swap-on-nfs-fix.patch added to -mm tree
Date: Mon, 30 Jul 2012 15:24:57 -0700
Message-ID: <20120730222457.A73F3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:43987 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab2G3WY6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 18:24:58 -0400
Received: by obbwc20 with SMTP id wc20so4044737obb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 15:24:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, fengguang.wu@intel.com


The patch titled
     Subject: nfs-enable-swap-on-nfs-fix
has been added to the -mm tree.  Its filename is
     nfs-enable-swap-on-nfs-fix.patch

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
Subject: nfs-enable-swap-on-nfs-fix

Fengguang Wu reports the following sparse problem

	net/sunrpc/clnt.c:720:36: sparse: dereference of noderef expression

task->tk_client->cl_xprt is RCU protected and must be dereferenced using
rcu_dereference(). This patch checks if a socket is being used for swap
and if so it takes the RCU read lock and dereferences properly. This is
a fix for "nfs: enable swap on NFS"

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/clnt.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN net/sunrpc/clnt.c~nfs-enable-swap-on-nfs-fix net/sunrpc/clnt.c
--- a/net/sunrpc/clnt.c~nfs-enable-swap-on-nfs-fix
+++ a/net/sunrpc/clnt.c
@@ -717,8 +717,15 @@ void rpc_task_set_client(struct rpc_task
 		atomic_inc(&clnt->cl_count);
 		if (clnt->cl_softrtry)
 			task->tk_flags |= RPC_TASK_SOFT;
-		if (task->tk_client->cl_xprt->swapper)
-			task->tk_flags |= RPC_TASK_SWAPPER;
+		if (sk_memalloc_socks()) {
+			struct rpc_xprt *xprt;
+
+			rcu_read_lock();
+			xprt = rcu_dereference(clnt->cl_xprt);
+			if (xprt->swapper)
+				task->tk_flags |= RPC_TASK_SWAPPER;
+			rcu_read_unlock();
+		}
 		/* Add to the client's list of all tasks */
 		spin_lock(&clnt->cl_lock);
 		list_add_tail(&task->tk_task, &clnt->cl_tasks);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-fix-wrong-argument-of-migrate_huge_pages-in-soft_offline_huge_page.patch
linux-next.patch
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
nfs-enable-swap-on-nfs-fix.patch
nfs-prevent-page-allocator-recursions-with-swap-over-nfs.patch
swapfile-avoid-dereferencing-bd_disk-during-swap_entry_free-for-network-storage.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch

