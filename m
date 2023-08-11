Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1339C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236547AbjHKW7M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236458AbjHKW65 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1113588
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF696676A6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F0FC433C7;
        Fri, 11 Aug 2023 22:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794736;
        bh=wlwZGzzqxNWGqgNFM/byNT7PI9GDYc1Wnxdd4UV4/AE=;
        h=Date:To:From:Subject:From;
        b=IgX5FvyGr8I9+rcUgjydAA8zS1s9GL0fU2opb3mplL8syvcDBfSQ5x0UU3kDp0QNr
         R1IwgTANO8K/wVs6UVNjSoifKQQyBzk4Su3NdD72IqWyLBTeuvvBbIw2FJ96MlbaMx
         +7QFYxAIu7y+f1IHc6JS2YKTaq3bD4diIVS2rFzo=
Date:   Fri, 11 Aug 2023 15:58:55 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch removed from -mm tree
Message-Id: <20230811225856.41F0FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: remove unneeded page state check in shake_page()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: remove unneeded page state check in shake_page()
Date: Wed, 28 Jun 2023 09:49:29 +0800

Remove unneeded PageLRU(p) and is_free_buddy_page(p) check as slab caches
are not shrunk now.  This check can be added back when a lightweight range
based shrinker is available.

Link: https://lkml.kernel.org/r/20230628014929.3441386-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-unneeded-page-state-check-in-shake_page
+++ a/mm/memory-failure.c
@@ -363,17 +363,14 @@ void shake_page(struct page *p)
 {
 	if (PageHuge(p))
 		return;
-
-	if (!PageSlab(p)) {
-		lru_add_drain_all();
-		if (PageLRU(p) || is_free_buddy_page(p))
-			return;
-	}
-
 	/*
 	 * TODO: Could shrink slab caches here if a lightweight range-based
 	 * shrinker will be available.
 	 */
+	if (PageSlab(p))
+		return;
+
+	lru_add_drain_all();
 }
 EXPORT_SYMBOL_GPL(shake_page);
 
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

