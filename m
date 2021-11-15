Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE01EC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 02:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D702561B66
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 02:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244107AbhKPCRI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 21:17:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238704AbhKORpr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 12:45:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1B3163315;
        Mon, 15 Nov 2021 17:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636997371;
        bh=Q0f8il/c/FLJeu3lYaVf3gSiOpPrFL0RKxv/hu0szn8=;
        h=Date:From:To:Subject:From;
        b=eIJdOEQljgieervsKMkQXsQl9RWMSm6dg6GP9AurTWotX8nI1Y88QmISedoyTB5Y1
         ebGvQpk2F97E80dwSfe5ZrziYtXKairi1ZFSSCqQ1TfA+i/BbS8W7YZ349j3tZ60qc
         YicjFpScMwKiWjpUE3/NMqN6s+2eUx9Fitf3/k9c=
Date:   Mon, 15 Nov 2021 09:29:30 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, cl@linux.com, iamjoonsoo.kim@lge.com,
        mingo@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged] mm-allow-only-slub-on-preempt_rt.patch removed
 from -mm tree
Message-ID: <20211115172930.54O4rMiRZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow only SLUB on PREEMPT_RT
has been removed from the -mm tree.  Its filename was
     mm-allow-only-slub-on-preempt_rt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1896,6 +1896,7 @@ choice
 
 config SLAB
 	bool "SLAB"
+	depends on !PREEMPT_RT
 	select HAVE_HARDENED_USERCOPY_ALLOCATOR
 	help
 	  The regular slab allocator that is established and known to work
@@ -1916,6 +1917,7 @@ config SLUB
 config SLOB
 	depends on EXPERT
 	bool "SLOB (Simple Allocator)"
+	depends on !PREEMPT_RT
 	help
 	   SLOB replaces the stock allocator with a drastically simpler
 	   allocator. SLOB is generally more space efficient but
_

Patches currently in -mm which might be from mingo@kernel.org are


