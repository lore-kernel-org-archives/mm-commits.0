From: akpm@linux-foundation.org
Subject: + alloc_percpu-fails-to-allocate-percpu-data.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:31:53 -0800
Message-ID: <200802230732.m1N7WgdK018091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755173AbYBWHzR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:55:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, a.p.zijlstra@chello.nl


The patch titled
     alloc_percpu() fails to allocate percpu data
has been added to the -mm tree.  Its filename is
     alloc_percpu-fails-to-allocate-percpu-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alloc_percpu() fails to allocate percpu data
From: Eric Dumazet <dada1@cosmosbay.com>

Some oprofile results obtained while using tbench on a 2x2 cpu machine were
very surprising.

For example, loopback_xmit() function was using high number of cpu cycles
to perform the statistic updates, supposed to be real cheap since they use
percpu data

        pcpu_lstats = netdev_priv(dev);
        lb_stats = per_cpu_ptr(pcpu_lstats, smp_processor_id());
        lb_stats->packets++;  /* HERE : serious contention */
        lb_stats->bytes += skb->len;

struct pcpu_lstats is a small structure containing two longs.  It appears
that on my 32bits platform, alloc_percpu(8) allocates a single cache line,
instead of giving to each cpu a separate cache line.

Using the following patch gave me impressive boost in various benchmarks
( 6 % in tbench)
(all percpu_counters hit this bug too)

Long term fix (ie >= 2.6.26) would be to let each CPU allocate their own
block of memory, so that we dont need to roudup sizes to L1_CACHE_BYTES, or
merging the SGI stuff of course...

Note : SLUB vs SLAB is important here to *show* the improvement, since they
dont have the same minimum allocation sizes (8 bytes vs 32 bytes).  This
could very well explain regressions some guys reported when they switched
to SLUB.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/allocpercpu.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN mm/allocpercpu.c~alloc_percpu-fails-to-allocate-percpu-data mm/allocpercpu.c
--- a/mm/allocpercpu.c~alloc_percpu-fails-to-allocate-percpu-data
+++ a/mm/allocpercpu.c
@@ -6,6 +6,10 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 
+#ifndef cache_line_size
+#define cache_line_size()	L1_CACHE_BYTES
+#endif
+
 /**
  * percpu_depopulate - depopulate per-cpu data for given cpu
  * @__pdata: per-cpu data to depopulate
@@ -52,6 +56,11 @@ void *percpu_populate(void *__pdata, siz
 	struct percpu_data *pdata = __percpu_disguise(__pdata);
 	int node = cpu_to_node(cpu);
 
+	/*
+	 * We should make sure each CPU gets private memory.
+	 */
+	size = roundup(size, cache_line_size());
+
 	BUG_ON(pdata->ptrs[cpu]);
 	if (node_online(node))
 		pdata->ptrs[cpu] = kmalloc_node(size, gfp|__GFP_ZERO, node);
@@ -98,7 +107,11 @@ EXPORT_SYMBOL_GPL(__percpu_populate_mask
  */
 void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
 {
-	void *pdata = kzalloc(nr_cpu_ids * sizeof(void *), gfp);
+	/*
+	 * We allocate whole cache lines to avoid false sharing
+	 */
+	size_t sz = roundup(nr_cpu_ids * sizeof(void *), cache_line_size());
+	void *pdata = kzalloc(sz, gfp);
 	void *__pdata = __percpu_disguise(pdata);
 
 	if (unlikely(!pdata))
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

alloc_percpu-fails-to-allocate-percpu-data.patch
avoid-divides-in-bits_to_longs.patch
