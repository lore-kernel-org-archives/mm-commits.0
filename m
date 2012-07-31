From: akpm@linux-foundation.org
Subject: [folded] mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:33:25 -0700
Message-ID: <20120731233326.1FAE0A028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:64132 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab2GaXd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:33:28 -0400
Received: by fat25 with SMTP id 25so296766fat.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:33:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: buildfix: mm: sl[au]b: add knowledge of PFMEMALLOC reserve pages
has been removed from the -mm tree.  Its filename was
     mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix.patch

This patch was dropped because it was folded into mm-slb-add-knowledge-of-pfmemalloc-reserve-pages.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: buildfix: mm: sl[au]b: add knowledge of PFMEMALLOC reserve pages

Fix build error for bisection reasons.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    1 +
 mm/slub.c                  |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix
+++ a/include/linux/page-flags.h
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <linux/bug.h>
+#include <linux/mmdebug.h>
 #ifndef __GENERATING_BOUNDS_H
 #include <linux/mm_types.h>
 #include <generated/bounds.h>
diff -puN mm/slub.c~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix mm/slub.c
--- a/mm/slub.c~mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix
+++ a/mm/slub.c
@@ -2327,7 +2327,7 @@ redo:
 
 	object = c->freelist;
 	page = c->page;
-	if (unlikely(!object || !node_match(page, node)
+	if (unlikely(!object || !node_match(page, node) ||
 					!pfmemalloc_match(page, gfpflags)))
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
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
nfs-enable-swap-on-nfs-fix-fix.patch
nfs-prevent-page-allocator-recursions-with-swap-over-nfs.patch
swapfile-avoid-dereferencing-bd_disk-during-swap_entry_free-for-network-storage.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch

