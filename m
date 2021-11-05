Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054A3C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5A326126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhKEUiB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:32828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232002AbhKEUiB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:38:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4002B611C0;
        Fri,  5 Nov 2021 20:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144521;
        bh=BFrRHDItB033KGMI0DsbXXAPXn9nInuCSxGMm1myxbE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EXlsT492wsfhEbZ0AHTE9uYvWR6tXaHE8ux+ob+fhZCBXdmSz+evmGHDv8V+XWhEp
         e65KzXtme/bJUxW96oF3Idoh/Xi4HKVdP4aSTjkfXBZcL5r2mJFA3JzG3pggxzlMry
         k8gV3EpLwGVqZTcu+sF8f3ibmn91kjVkLargTAe0=
Date:   Fri, 05 Nov 2021 13:35:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 015/262] mm/slub: increase default cpu partial
 list sizes
Message-ID: <20211105203520.Q1wOR3Iwr%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/slub: increase default cpu partial list sizes

The defaults are determined based on object size and can go up to 30 for
objects smaller than 256 bytes.  Before the previous patch changed the
accounting, this could have made cpu partial list contain up to 30 pages. 
After that patch, only up to 2 pages with default allocation order.

Very short lists limit the usefulness of the whole concept of cpu partial
lists, so this patch aims at a more reasonable default under the new
accounting.  The defaults are quadrupled, except for object size >=
PAGE_SIZE where it's doubled.  This makes the lists grow up to 10 pages in
practice.

A quick test of booting a kernel under virtme with 4GB RAM and 8 vcpus
shows the following slab memory usage after boot:

Before previous patch (using page->pobjects):
Slab:              36732 kB
SReclaimable:      14836 kB
SUnreclaim:        21896 kB

After previous patch (using page->pages):
Slab:              34720 kB
SReclaimable:      13716 kB
SUnreclaim:        21004 kB

After this patch (using page->pages, higher defaults):
Slab:              35252 kB
SReclaimable:      13944 kB
SUnreclaim:        21308 kB

In the same setup, I also ran 5 times:
hackbench -l 16000 -g 16

Differences in time were in the noise, we can compare slub stats as given
by slabinfo -r skbuff_head_cache (the other cache heavily used by
hackbench, kmalloc-cg-512 looks similar).  Negligible stats left out for
brevity.

Before previous patch (using page->pobjects):

Objects: 1408, Memory Total:  401408 Used :  304128

Slab Perf Counter       Alloc     Free %Al %Fr
--------------------------------------------------
Fastpath             469952498  5946606  91   1
Slowpath             42053573 506059465   8  98
Page Alloc              41093    41044   0   0
Add partial                18 21229327   0   4
Remove partial       20039522    36051   3   0
Cpu partial list      4686640 24767229   0   4
RemoteObj/SlabFrozen       16 124027841   0  24
Total                512006071 512006071
Flushes       18

Slab Deactivation             Occurrences %
-------------------------------------------------
Slab empty                       4993    0%
Deactivation bypass           24767229   99%
Refilled from foreign frees   21972674   88%

After previous patch (using page->pages):

Objects: 480, Memory Total:  131072 Used :  103680

Slab Perf Counter       Alloc     Free %Al %Fr
--------------------------------------------------
Fastpath             473016294  5405653  92   1
Slowpath             38989777 506600418   7  98
Page Alloc              32717    32701   0   0
Add partial                 3 22749164   0   4
Remove partial       11371127    32474   2   0
Cpu partial list     11686226 23090059   2   4
RemoteObj/SlabFrozen        2 67541803   0  13
Total                512006071 512006071
Flushes        3

Slab Deactivation             Occurrences %
-------------------------------------------------
Slab empty                        227    0%
Deactivation bypass           23090059   99%
Refilled from foreign frees   27585695  119%

After this patch (using page->pages, higher defaults):

Objects: 896, Memory Total:  229376 Used :  193536

Slab Perf Counter       Alloc     Free %Al %Fr
--------------------------------------------------
Fastpath             473799295  4980278  92   0
Slowpath             38206776 507025793   7  99
Page Alloc              32295    32267   0   0
Add partial                11 23291143   0   4
Remove partial        5815764    31278   1   0
Cpu partial list     18119280 23967320   3   4
RemoteObj/SlabFrozen       10 76974794   0  15
Total                512006071 512006071
Flushes       11

Slab Deactivation             Occurrences %
-------------------------------------------------
Slab empty                        989    0%
Deactivation bypass           23967320   99%
Refilled from foreign frees   32358473  135%

As expected, memory usage dropped significantly with change of accounting,
increasing the defaults increased it, but not as much.  The number of page
allocation/frees dropped significantly with the new accounting, but didn't
increase with the higher defaults.  Interestingly, the number of fasthpath
allocations increased, as well as allocations from the cpu partial list,
even though it's shorter.

Link: https://lkml.kernel.org/r/20211012134651.11258-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/slub.c~mm-slub-increase-default-cpu-partial-list-sizes
+++ a/mm/slub.c
@@ -4030,13 +4030,13 @@ static void set_cpu_partial(struct kmem_
 	if (!kmem_cache_has_cpu_partial(s))
 		nr_objects = 0;
 	else if (s->size >= PAGE_SIZE)
-		nr_objects = 2;
-	else if (s->size >= 1024)
 		nr_objects = 6;
+	else if (s->size >= 1024)
+		nr_objects = 24;
 	else if (s->size >= 256)
-		nr_objects = 13;
+		nr_objects = 52;
 	else
-		nr_objects = 30;
+		nr_objects = 120;
 
 	slub_set_cpu_partial(s, nr_objects);
 #endif
_
