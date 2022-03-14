Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFF7C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 14 Mar 2022 20:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245175AbiCNU5t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Mar 2022 16:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234775AbiCNU5s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Mar 2022 16:57:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625E33D1ED
        for <mm-commits@vger.kernel.org>; Mon, 14 Mar 2022 13:56:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5B64B80EBD
        for <mm-commits@vger.kernel.org>; Mon, 14 Mar 2022 20:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A332EC340E9;
        Mon, 14 Mar 2022 20:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647291395;
        bh=U8GBlAYkfGXkon00EYypVAf9FBUPe7Fp4WeZhEtTDbo=;
        h=Date:To:From:Subject:From;
        b=AmOpjqnSBQxsnNY+ihsmVcNp4uXgV171soxKt3H090ASWy+86/gUWvW9O3Q+JzH8x
         l4noXjBTUijjWM4umSiUSwQxu0F0ElOSJogD8kO/Hrjz5Bvjnob59qC17o+nKhC1Yo
         Knxk31hSmPvKWfL8NV68kHR7UzV+5yXDvVikhs7I=
Date:   Mon, 14 Mar 2022 13:56:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-early_ioremap-declare-early_memremap_pgprot_adjust.patch added to -mm tree
Message-Id: <20220314205635.A332EC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/early_ioremap: declare early_memremap_pgprot_adjust()
has been added to the -mm tree.  Its filename is
     mm-early_ioremap-declare-early_memremap_pgprot_adjust.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-early_ioremap-declare-early_memremap_pgprot_adjust.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-early_ioremap-declare-early_memremap_pgprot_adjust.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/early_ioremap: declare early_memremap_pgprot_adjust()

The mm/ directory can almost fully be built with W=1, which would help in
local development.  One remaining issue is missing prototype for
early_memremap_pgprot_adjust().

Thus add a declaration for this function.  Use mm/internal.h instead of
asm/early_ioremap.h to avoid missing type definitions and unnecessary
exposure.

Link: https://lkml.kernel.org/r/20220314165724.16071-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/early_ioremap.c |    1 +
 mm/internal.h      |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/mm/early_ioremap.c~mm-early_ioremap-declare-early_memremap_pgprot_adjust
+++ a/mm/early_ioremap.c
@@ -17,6 +17,7 @@
 #include <linux/vmalloc.h>
 #include <asm/fixmap.h>
 #include <asm/early_ioremap.h>
+#include "internal.h"
 
 #ifdef CONFIG_MMU
 static int early_ioremap_debug __initdata;
--- a/mm/internal.h~mm-early_ioremap-declare-early_memremap_pgprot_adjust
+++ a/mm/internal.h
@@ -155,6 +155,12 @@ extern unsigned long highest_memmap_pfn;
 #define MAX_RECLAIM_RETRIES 16
 
 /*
+ * in mm/early_ioremap.c
+ */
+pgprot_t __init early_memremap_pgprot_adjust(resource_size_t phys_addr,
+					unsigned long size, pgprot_t prot);
+
+/*
  * in mm/vmscan.c:
  */
 extern int isolate_lru_page(struct page *page);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-fault-injection-declare-should_fail_alloc_page.patch
mm-early_ioremap-declare-early_memremap_pgprot_adjust.patch

