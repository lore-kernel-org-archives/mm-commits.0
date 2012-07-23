From: akpm@linux-foundation.org
Subject: + mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix.patch added to -mm tree
Date: Mon, 23 Jul 2012 15:46:36 -0700
Message-ID: <20120723224637.1FE951E0078@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:49882 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab2GWWqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 18:46:39 -0400
Received: by qabg24 with SMTP id g24so391938qab.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 15:46:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, fengguang.wu@intel.com


The patch titled
     Subject: buildfix: mm: sl[au]b: add knowledge of PFMEMALLOC reserve pages
has been added to the -mm tree.  Its filename is
     mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix.patch

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
Subject: Subject: buildfix: mm: sl[au]b: add knowledge of PFMEMALLOC reserve pages

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

