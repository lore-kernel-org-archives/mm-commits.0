Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C2AC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244976AbiCYBgm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357420AbiCYBfR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A550BF509
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D351F60A1C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E26C340ED;
        Fri, 25 Mar 2022 01:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171976;
        bh=qrJqMFWMfy20kbqfZ2TgvMbbOk/ksFkeIRyyJ0vv7xM=;
        h=Date:To:From:Subject:From;
        b=wmLH+Ca+9T8KLfik1VP5OCXphoVbzk9w+GMHYDtD8I+gR1eHOHfnvK3QBPNjm6ruL
         CGBbsbwRbYMlKowmxqcbXfoLN37vWWOP3vbCPpUII1LiyUwjpTqKU8w/eRHJ7M8klc
         2LTV6DIXgWT2M+Yd6/XBY0cKRLCMcP53ZV5BrQt8=
Date:   Thu, 24 Mar 2022 18:32:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-early_ioremap-declare-early_memremap_pgprot_adjust.patch removed from -mm tree
Message-Id: <20220325013256.30E26C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/early_ioremap: declare early_memremap_pgprot_adjust()
has been removed from the -mm tree.  Its filename was
     mm-early_ioremap-declare-early_memremap_pgprot_adjust.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


