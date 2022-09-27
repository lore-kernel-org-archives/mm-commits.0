Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B6DC07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiI0Cra (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiI0Cr0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2162C61D46
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7533461557
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0874C433C1;
        Tue, 27 Sep 2022 02:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246841;
        bh=xKNleTsc7EdErbzPWmuAoi0ISTYKEIsWMlMHqqdAiGY=;
        h=Date:To:From:Subject:From;
        b=QZGG5CEMYicLCrJqt3h+HUO0aC9FniuU7Z1PCU4//6LEn4stJNSva2DUCYECbIo53
         Q5c/VSt+kRWmR1TNQHLVzkJ5XPa+87xLZa/gXLPD1PwAkyMXfF2RbQJqcQew3EK7W6
         2VP2Xbri2opO9H2iC5j4XNnz6QfqANKjXSVNJuVM=
Date:   Mon, 26 Sep 2022 19:47:21 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch removed from -mm tree
Message-Id: <20220927024721.D0874C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: use num_poisoned_pages_sub() to decrease num_poisoned_pages
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, hwpoison: use num_poisoned_pages_sub() to decrease num_poisoned_pages
Date: Tue, 30 Aug 2022 20:36:01 +0800

Use num_poisoned_pages_sub() to combine multiple atomic ops into one. Also
num_poisoned_pages_dec() can be killed as there's no caller now.

Link: https://lkml.kernel.org/r/20220830123604.25763-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    5 -----
 mm/memory-failure.c     |    6 ++++--
 2 files changed, 4 insertions(+), 7 deletions(-)

--- a/include/linux/swapops.h~mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages
+++ a/include/linux/swapops.h
@@ -485,11 +485,6 @@ static inline void num_poisoned_pages_in
 	atomic_long_inc(&num_poisoned_pages);
 }
 
-static inline void num_poisoned_pages_dec(void)
-{
-	atomic_long_dec(&num_poisoned_pages);
-}
-
 static inline void num_poisoned_pages_sub(long i)
 {
 	atomic_long_sub(i, &num_poisoned_pages);
--- a/mm/memory-failure.c~mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages
+++ a/mm/memory-failure.c
@@ -2602,7 +2602,7 @@ retry:
 
 void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
 {
-	int i;
+	int i, total = 0;
 
 	/*
 	 * A further optimization is to have per section refcounted
@@ -2615,8 +2615,10 @@ void clear_hwpoisoned_pages(struct page
 
 	for (i = 0; i < nr_pages; i++) {
 		if (PageHWPoison(&memmap[i])) {
-			num_poisoned_pages_dec();
+			total++;
 			ClearPageHWPoison(&memmap[i]);
 		}
 	}
+	if (total)
+		num_poisoned_pages_sub(total);
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

writeback-remove-unused-macro-dirty_full_scope.patch
mm-page_alloc-ensure-kswapd-doesnt-accidentally-go-to-sleep.patch
mm-page_alloc-make-zone_pcp_update-static.patch
mm-remove-obsolete-macro-nr_pcp_order_mask-and-nr_pcp_order_width.patch
mm-page_alloc-remove-obsolete-comment-in-zone_statistics.patch
mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening.patch
mm-page_alloc-fix-freeing-static-percpu-memory.patch
mm-remove-obsolete-pgdat_is_empty.patch
mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard.patch
mm-page_alloc-use-local-variable-zone_idx-directly.patch
mm-memory_hotplug-remove-obsolete-generic_free_nodedata.patch
mm-page_alloc-make-boot_nodestats-static.patch
mm-page_alloc-use-helper-macro-sz_1km.patch
mm-page_alloc-init-local-variable-buddy_pfn.patch
mm-page_alloc-use-costly_order-in-warn_on_once_gfp.patch
mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch
mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix.patch
mm-page_alloc-fix-obsolete-comment-in-deferred_pfn_valid.patch

