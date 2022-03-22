Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 117E5C4321E
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbiCVVtu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236754AbiCVVt2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:49:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD461DF39
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:47:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AE9CB81DB7
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F77BC340F5;
        Tue, 22 Mar 2022 21:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985676;
        bh=DXWMWCtNqcjsmwVePQKE6A5+0n6p7w3U86+C8RQt9xA=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=q0IGxVA6vcDdJWR2L0f3dFsHSfX7Hvo8bjNjdTPNDQau3QGOJm9W5K5I8fHAYpfie
         diQaShq61vT023NC2P8bbU2hAXOl19HKxqufL9rsIFDltnt1cQK6Cx7G3hswh70xN4
         YUVTQyTmbZwB/S4qazYx/Pw8b1Z9u//NPdQPfiLQ=
Date:   Tue, 22 Mar 2022 14:47:55 -0700
To:     willy@infradead.org, mgorman@techsingularity.net, david@redhat.com,
        vbabka@suse.cz, akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 185/227] mm/early_ioremap: declare early_memremap_pgprot_adjust()
Message-Id: <20220322214756.0F77BC340F5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
