Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137A1C433E9
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3CAC20756
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731606AbhAYWZ5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:25:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732973AbhAYVhZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 16:37:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84F3C2083E;
        Mon, 25 Jan 2021 21:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611610524;
        bh=N74F6HkEkWDJiW2KTXZ5nJTNnhx+xk5J+9wzPTl3QKY=;
        h=Date:From:To:Subject:From;
        b=ArKpcUb3ZFrAuAK6PNdoOIZOkdTBDKmiTR2PD1Ja3SVD6Bsm7nSb3h7g4iltUwMVR
         PXBFB3w0ITWGKIR0MVZSiKYU0ch8KgHgS2lXorgO/rIn3urptqxfTuuVFAe5tV0E0L
         EYUYfOGvFKoqTtwVHTvOyKREbdzbVdpqTua7a36Q=
Date:   Mon, 25 Jan 2021 13:35:24 -0800
From:   akpm@linux-foundation.org
To:     andreas@gaisler.com, davem@davemloft.net,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paul@crapouillou.net, peterz@infradead.org, tglx@linutronix.de,
        tsbogend@alpha.franken.de
Subject:  [merged]
 mm-highmem-prepare-for-overriding-set_pte_at.patch removed from -mm tree
Message-ID: <20210125213524.-sqT3VrSG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: prepare for overriding set_pte_at()
has been removed from the -mm tree.  Its filename was
     mm-highmem-prepare-for-overriding-set_pte_at.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: mm/highmem: prepare for overriding set_pte_at()

The generic kmap_local() map function uses set_pte_at(), but MIPS requires
set_pte() and PowerPC wants __set_pte_at().

Provide arch_kmap_local_set_pte() and default it to set_pte_at().

Link: https://lkml.kernel.org/r/20210112170411.056306194@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/highmem.c~mm-highmem-prepare-for-overriding-set_pte_at
+++ a/mm/highmem.c
@@ -473,6 +473,11 @@ static inline void *arch_kmap_local_high
 }
 #endif
 
+#ifndef arch_kmap_local_set_pte
+#define arch_kmap_local_set_pte(mm, vaddr, ptep, ptev)	\
+	set_pte_at(mm, vaddr, ptep, ptev)
+#endif
+
 /* Unmap a local mapping which was obtained by kmap_high_get() */
 static inline bool kmap_high_unmap_local(unsigned long vaddr)
 {
@@ -515,7 +520,7 @@ void *__kmap_local_pfn_prot(unsigned lon
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte - idx)));
 	pteval = pfn_pte(pfn, prot);
-	set_pte_at(&init_mm, vaddr, kmap_pte - idx, pteval);
+	arch_kmap_local_set_pte(&init_mm, vaddr, kmap_pte - idx, pteval);
 	arch_kmap_local_post_map(vaddr, pteval);
 	current->kmap_ctrl.pteval[kmap_local_idx()] = pteval;
 	preempt_enable();
_

Patches currently in -mm which might be from tglx@linutronix.de are


