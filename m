From: akpm@linux-foundation.org
Subject: + mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:28:22 -0700
Message-ID: <20120712212823.07DF2200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:46345 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161575Ab2GLV2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:28:25 -0400
Received: by mail-lb0-f202.google.com with SMTP id gp10so165960lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:28:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc


The patch titled
     Subject: mm: account for the number of times direct reclaimers get throttled
has been added to the -mm tree.  Its filename is
     mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch

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
Subject: mm: account for the number of times direct reclaimers get throttled

Under significant pressure when writing back to network-backed storage,
direct reclaimers may get throttled.  This is expected to be a short-lived
event and the processes get woken up again but processes do get stalled. 
This patch counts how many times such stalling occurs.  It's up to the
administrator whether to reduce these stalls by increasing
min_free_kbytes.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    1 +
 mm/vmscan.c                   |    3 +++
 mm/vmstat.c                   |    1 +
 3 files changed, 5 insertions(+)

diff -puN include/linux/vm_event_item.h~mm-account-for-the-number-of-times-direct-reclaimers-get-throttled include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-account-for-the-number-of-times-direct-reclaimers-get-throttled
+++ a/include/linux/vm_event_item.h
@@ -30,6 +30,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGSTEAL_DIRECT),
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
+		PGSCAN_DIRECT_THROTTLE,
 #ifdef CONFIG_NUMA
 		PGSCAN_ZONE_RECLAIM_FAILED,
 #endif
diff -puN mm/vmscan.c~mm-account-for-the-number-of-times-direct-reclaimers-get-throttled mm/vmscan.c
--- a/mm/vmscan.c~mm-account-for-the-number-of-times-direct-reclaimers-get-throttled
+++ a/mm/vmscan.c
@@ -2184,6 +2184,9 @@ static void throttle_direct_reclaim(gfp_
 	if (pfmemalloc_watermark_ok(pgdat))
 		return;
 
+	/* Account for the throttling */
+	count_vm_event(PGSCAN_DIRECT_THROTTLE);
+
 	/*
 	 * If the caller cannot enter the filesystem, it's possible that it
 	 * is due to the caller holding an FS lock or performing a journal
diff -puN mm/vmstat.c~mm-account-for-the-number-of-times-direct-reclaimers-get-throttled mm/vmstat.c
--- a/mm/vmstat.c~mm-account-for-the-number-of-times-direct-reclaimers-get-throttled
+++ a/mm/vmstat.c
@@ -744,6 +744,7 @@ const char * const vmstat_text[] = {
 	TEXTS_FOR_ZONES("pgsteal_direct")
 	TEXTS_FOR_ZONES("pgscan_kswapd")
 	TEXTS_FOR_ZONES("pgscan_direct")
+	"pgscan_direct_throttle",
 
 #ifdef CONFIG_NUMA
 	"zone_reclaim_failed",
_
Subject: Subject: mm: account for the number of times direct reclaimers get throttled

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

