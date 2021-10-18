Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DDC3C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 19:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E5E4610C9
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 19:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhJRTqG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 15:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231787AbhJRTqG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 15:46:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C261460F57;
        Mon, 18 Oct 2021 19:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634586235;
        bh=KFHXNVSTeB3Sgxu/2aGuuhwLAxHcn0HG2NQHXsnxc8k=;
        h=Date:From:To:Subject:From;
        b=cdjSUx8RcRUQF8nNkXn2HP59gawt4aOv2krF70z2Z+scRoQn/uQmbr3tojQvcMLgo
         q7MHmmsLOEOBK1StndAgTfyfWcfHd9uxjdNXvu0IwwEY8pXvHy4iKbUuQF1t+XvPRU
         IS6+sWn3RX9i55iZqTvusMZp1pkbzxXEnN07Eydw=
Date:   Mon, 18 Oct 2021 12:43:54 -0700
From:   akpm@linux-foundation.org
To:     42.hyeyoo@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  + mm-slub-use-prefetchw-instead-of-prefetch.patch added
 to -mm tree
Message-ID: <20211018194354.ChLoUfuMp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: use prefetchw instead of prefetch
has been added to the -mm tree.  Its filename is
     mm-slub-use-prefetchw-instead-of-prefetch.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-use-prefetchw-instead-of-prefetch.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-use-prefetchw-instead-of-prefetch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm, slub: use prefetchw instead of prefetch

commit 0ad9500e16fe ("slub: prefetch next freelist pointer in
slab_alloc()") introduced prefetch_freepointer() because when other cpu(s)
freed objects into a page that current cpu owns, the freelist link is hot
on cpu(s) which freed objects and possibly very cold on current cpu.

But if freelist link chain is hot on cpu(s) which freed objects,
it's better to invalidate that chain because they're not going to access
again within a short time.

So use prefetchw instead of prefetch. On supported architectures like x86
and arm, it invalidates other copied instances of a cache line when
prefetching it.

Before:

Time: 91.677

 Performance counter stats for 'hackbench -g 100 -l 10000':
        1462938.07 msec cpu-clock                 #   15.908 CPUs utilized
          18072550      context-switches          #   12.354 K/sec
           1018814      cpu-migrations            #  696.416 /sec
            104558      page-faults               #   71.471 /sec
     1580035699271      cycles                    #    1.080 GHz                      (54.51%)
     2003670016013      instructions              #    1.27  insn per cycle           (54.31%)
        5702204863      branch-misses                                                 (54.28%)
      643368500985      cache-references          #  439.778 M/sec                    (54.26%)
       18475582235      cache-misses              #    2.872 % of all cache refs      (54.28%)
      642206796636      L1-dcache-loads           #  438.984 M/sec                    (46.87%)
       18215813147      L1-dcache-load-misses     #    2.84% of all L1-dcache accesses  (46.83%)
      653842996501      dTLB-loads                #  446.938 M/sec                    (46.63%)
        3227179675      dTLB-load-misses          #    0.49% of all dTLB cache accesses  (46.85%)
      537531951350      iTLB-loads                #  367.433 M/sec                    (54.33%)
         114750630      iTLB-load-misses          #    0.02% of all iTLB cache accesses  (54.37%)
      630135543177      L1-icache-loads           #  430.733 M/sec                    (46.80%)
       22923237620      L1-icache-load-misses     #    3.64% of all L1-icache accesses  (46.76%)

      91.964452802 seconds time elapsed

      43.416742000 seconds user
    1422.441123000 seconds sys

After:

Time: 90.220

 Performance counter stats for 'hackbench -g 100 -l 10000':
        1437418.48 msec cpu-clock                 #   15.880 CPUs utilized
          17694068      context-switches          #   12.310 K/sec
            958257      cpu-migrations            #  666.651 /sec
            100604      page-faults               #   69.989 /sec
     1583259429428      cycles                    #    1.101 GHz                      (54.57%)
     2004002484935      instructions              #    1.27  insn per cycle           (54.37%)
        5594202389      branch-misses                                                 (54.36%)
      643113574524      cache-references          #  447.409 M/sec                    (54.39%)
       18233791870      cache-misses              #    2.835 % of all cache refs      (54.37%)
      640205852062      L1-dcache-loads           #  445.386 M/sec                    (46.75%)
       17968160377      L1-dcache-load-misses     #    2.81% of all L1-dcache accesses  (46.79%)
      651747432274      dTLB-loads                #  453.415 M/sec                    (46.59%)
        3127124271      dTLB-load-misses          #    0.48% of all dTLB cache accesses  (46.75%)
      535395273064      iTLB-loads                #  372.470 M/sec                    (54.38%)
         113500056      iTLB-load-misses          #    0.02% of all iTLB cache accesses  (54.35%)
      628871845924      L1-icache-loads           #  437.501 M/sec                    (46.80%)
       22585641203      L1-icache-load-misses     #    3.59% of all L1-icache accesses  (46.79%)

      90.514819303 seconds time elapsed

      43.877656000 seconds user
    1397.176001000 seconds sys

Link: https://lkml.org/lkml/2021/10/8/598=20
Link: https://lkml.kernel.org/r/20211011144331.70084-1-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-use-prefetchw-instead-of-prefetch
+++ a/mm/slub.c
@@ -354,7 +354,7 @@ static inline void *get_freepointer(stru
 
 static void prefetch_freepointer(const struct kmem_cache *s, void *object)
 {
-	prefetch(object + s->offset);
+	prefetchw(object + s->offset);
 }
 
 static inline void *get_freepointer_safe(struct kmem_cache *s, void *object)
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-slub-use-prefetchw-instead-of-prefetch.patch

