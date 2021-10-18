Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31D3C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 19:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF2DA6108E
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 19:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhJRT7H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 15:59:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233096AbhJRT7G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 15:59:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D71161002;
        Mon, 18 Oct 2021 19:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634587015;
        bh=nCRmbEVdguTgxi/pcJWSBqtCSiKOonc7VUO+wZ5Bd6M=;
        h=Date:From:To:Subject:From;
        b=M7xTBQi7eHj1nc5ouT/aMz9DI82xpGhQrvlESCeMqowZ+DdvdBr6AdxZ2FvUp7Cuf
         pbwZp0DjQVKSD2f9WSYFZGO21OYwIzk26Jjj2s7dNbmh37WI9MsCJL1OA8dW1ITCEV
         irO4lElSNEmAUzt9AZ6OXTwC4KMnHYNiunzKGkp0=
Date:   Mon, 18 Oct 2021 12:56:54 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, cl@linux.com, iamjoonsoo.kim@lge.com,
        mingo@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, tglx@linutronix.de, vbabka@suse.cz
Subject:  + mm-allow-only-slub-on-preempt_rt.patch added to -mm
 tree
Message-ID: <20211018195654.goC_YyFTU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow only SLUB on PREEMPT_RT
has been added to the -mm tree.  Its filename is
     mm-allow-only-slub-on-preempt_rt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-allow-only-slub-on-preempt_rt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-allow-only-slub-on-preempt_rt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ingo Molnar <mingo@kernel.org>
Subject: mm: allow only SLUB on PREEMPT_RT

Memory allocators may disable interrupts or preemption as part of the
allocation and freeing process.  For PREEMPT_RT it is important that these
sections remain deterministic and short and therefore don't depend on the
size of the memory to allocate/ free or the inner state of the algorithm.

Until v3.12-RT the SLAB allocator was an option but involved several
changes to meet all the requirements.  The SLUB design fits better with
PREEMPT_RT model and so the SLAB patches were dropped in the 3.12-RT
patchset.  Comparing the two allocator, SLUB outperformed SLAB in both
throughput (time needed to allocate and free memory) and the maximal
latency of the system measured with cyclictest during hackbench.

SLOB was never evaluated since it was unlikely that it preforms better
than SLAB.  During a quick test, the kernel crashed with SLOB enabled
during boot.

Disable SLAB and SLOB on PREEMPT_RT.

[bigeasy@linutronix.de: commit description]
Link: https://lkml.kernel.org/r/20211015210336.gen3tib33ig5q2md@linutronix.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/init/Kconfig~mm-allow-only-slub-on-preempt_rt
+++ a/init/Kconfig
@@ -1905,6 +1905,7 @@ choice
 
 config SLAB
 	bool "SLAB"
+	depends on !PREEMPT_RT
 	select HAVE_HARDENED_USERCOPY_ALLOCATOR
 	help
 	  The regular slab allocator that is established and known to work
@@ -1925,6 +1926,7 @@ config SLUB
 config SLOB
 	depends on EXPERT
 	bool "SLOB (Simple Allocator)"
+	depends on !PREEMPT_RT
 	help
 	   SLOB replaces the stock allocator with a drastically simpler
 	   allocator. SLOB is generally more space efficient but
_

Patches currently in -mm which might be from mingo@kernel.org are

mm-allow-only-slub-on-preempt_rt.patch

