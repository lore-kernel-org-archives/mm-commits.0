Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B835C04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbjHKXAF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237029AbjHKW7h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737383A87
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 089B4676A6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD4DC433C7;
        Fri, 11 Aug 2023 22:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794760;
        bh=a/XK+nb4ivUdBA7jSa/UbtW5v2ODvnp04oeaIky/rk8=;
        h=Date:To:From:Subject:From;
        b=pnQLQx5btTiqldrW4ba9PVMQ+kBJ6nL/aeswR52QnJDzV8kKBE9UKc21BG1OHLYZQ
         n5h/O4jTYQueY2ygbKgi17Hmh39XlvPkffM6TUCjTkcqcj1Ps9Yv4UaTt/Cm/azORX
         ropf88VfIgJ/Rno5uFrvBNstmxhmrZfc9h8I2Gz8=
Date:   Fri, 11 Aug 2023 15:59:19 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-avoid-false-page-outside-zone-error-info.patch removed from -mm tree
Message-Id: <20230811225920.5FD4DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: avoid false page outside zone error info
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-false-page-outside-zone-error-info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: page_alloc: avoid false page outside zone error info
Date: Tue, 4 Jul 2023 19:18:23 +0800

If pfn is outside zone boundaries in the first round, ret will be set to
1.  But if pfn is changed to inside the zone boundaries in zone span
seqretry path, ret is still set to 1 leading to false page outside zone
error info.

This is from code inspection.  The race window should be really small thus
hard to trigger in real world.

[akpm@linux-foundation.org: code simplification, per Matthew]
Link: https://lkml.kernel.org/r/20230704111823.940331-1-linmiaohe@huawei.com
Fixes: bdc8cb984576 ("[PATCH] memory hotplug locking: zone span seqlock")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-false-page-outside-zone-error-info
+++ a/mm/page_alloc.c
@@ -459,7 +459,7 @@ void set_pageblock_migratetype(struct pa
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
-	int ret = 0;
+	int ret;
 	unsigned seq;
 	unsigned long pfn = page_to_pfn(page);
 	unsigned long sp, start_pfn;
@@ -468,8 +468,7 @@ static int page_outside_zone_boundaries(
 		seq = zone_span_seqbegin(zone);
 		start_pfn = zone->zone_start_pfn;
 		sp = zone->spanned_pages;
-		if (!zone_spans_pfn(zone, pfn))
-			ret = 1;
+		ret = !zone_spans_pfn(zone, pfn);
 	} while (zone_span_seqretry(zone, seq));
 
 	if (ret)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch
mm-memory-failure-add-pageoffline-check.patch
mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch
mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch
mm-page_alloc-remove-unneeded-variable-base.patch
mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch
mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch
mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

