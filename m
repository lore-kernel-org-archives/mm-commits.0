Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4FEC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiJCVPe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiJCVN7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E574E61A
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9187E611FD
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E0EC433D6;
        Mon,  3 Oct 2022 21:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831368;
        bh=f2+imcP8eKK57IOTSOMMeRxn4PZKv35OAZdwN3cdchM=;
        h=Date:To:From:Subject:From;
        b=iZA2w2k9DvJGFtFEgC+7peFmGfVvHDMD39Ql04rqY9F6H8rbJLU10UktXiTD+zmN8
         85W/1AMnLKhiVTNwd+jNt6/2cOOrHGB7kqU7oW9aGfViuYWc4YObJpAIYIJil81Vs7
         /3b/8nHStlCO7G82cSgmMqYlCVsLT6aLX9u2XU0c=
Date:   Mon, 03 Oct 2022 14:09:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-make-zone_pcp_update-static.patch removed from -mm tree
Message-Id: <20221003210927.E0E0EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: make zone_pcp_update() static
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-zone_pcp_update-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: make zone_pcp_update() static
Date: Fri, 16 Sep 2022 15:22:43 +0800

Since commit b92ca18e8ca5 ("mm/page_alloc: disassociate the pcp->high from
pcp->batch"), zone_pcp_update() is only used in mm/page_alloc.c.  Move
zone_pcp_update() up to avoid forward declaration and then make it static.
No functional change intended.

Link: https://lkml.kernel.org/r/20220916072257.9639-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    1 -
 mm/page_alloc.c |   22 +++++++++++-----------
 2 files changed, 11 insertions(+), 12 deletions(-)

--- a/mm/internal.h~mm-page_alloc-make-zone_pcp_update-static
+++ a/mm/internal.h
@@ -367,7 +367,6 @@ extern int user_min_free_kbytes;
 extern void free_unref_page(struct page *page, unsigned int order);
 extern void free_unref_page_list(struct list_head *list);
 
-extern void zone_pcp_update(struct zone *zone, int cpu_online);
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
--- a/mm/page_alloc.c~mm-page_alloc-make-zone_pcp_update-static
+++ a/mm/page_alloc.c
@@ -7243,6 +7243,17 @@ void __meminit setup_zone_pageset(struct
 }
 
 /*
+ * The zone indicated has a new number of managed_pages; batch sizes and percpu
+ * page high values need to be recalculated.
+ */
+static void zone_pcp_update(struct zone *zone, int cpu_online)
+{
+	mutex_lock(&pcp_batch_high_lock);
+	zone_set_pageset_high_and_batch(zone, cpu_online);
+	mutex_unlock(&pcp_batch_high_lock);
+}
+
+/*
  * Allocate per cpu pagesets and initialize them.
  * Before this call only boot pagesets were available.
  */
@@ -9474,17 +9485,6 @@ void free_contig_range(unsigned long pfn
 EXPORT_SYMBOL(free_contig_range);
 
 /*
- * The zone indicated has a new number of managed_pages; batch sizes and percpu
- * page high values need to be recalculated.
- */
-void zone_pcp_update(struct zone *zone, int cpu_online)
-{
-	mutex_lock(&pcp_batch_high_lock);
-	zone_set_pageset_high_and_batch(zone, cpu_online);
-	mutex_unlock(&pcp_batch_high_lock);
-}
-
-/*
  * Effectively disable pcplists for the zone by setting the high limit to 0
  * and draining all cpus. A concurrent page freeing on another CPU that's about
  * to put the page on pcplist will either finish before the drain and the page
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


