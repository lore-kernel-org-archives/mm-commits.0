Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 396F8C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiI0CrW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiI0CrV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A511E4DB4C
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A2A661557
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886D6C433D6;
        Tue, 27 Sep 2022 02:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246839;
        bh=adSVwWpJPIu9MlMr9cuTUtW/92N8cQ9RLh7Rqo6O0dM=;
        h=Date:To:From:Subject:From;
        b=fWfTwaOJyaVBNS+9uNT6bEPrVzVmW3UkPxPjBLN1CuvtdrCi3H2IohmuPrqJy2Dt5
         UQqZUUB8h8iT/PpFe+htZw6zrujjhpRozGCHMFu/SQ8s8asrq+3TigJFGp84BQPWHF
         PQtg/i9NkfLanUcwFM7E3ayb/gd8VPtJ55SYBk+Q=
Date:   Mon, 26 Sep 2022 19:47:18 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch removed from -mm tree
Message-Id: <20220927024719.886D6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: use ClearPageHWPoison() in memory_failure()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, hwpoison: use ClearPageHWPoison() in memory_failure()
Date: Tue, 30 Aug 2022 20:35:59 +0800

Patch series "A few cleanup patches for memory-failure".

his series contains a few cleanup patches to use __PageMovable() to detect
non-lru movable pages, use num_poisoned_pages_sub() to reduce multiple
atomic ops overheads and so on.  More details can be found in the
respective changelogs.


This patch (of 6):

Use ClearPageHWPoison() instead of TestClearPageHWPoison() to clear page
hwpoison flags to avoid unneeded full memory barrier overhead.

Link: https://lkml.kernel.org/r/20220830123604.25763-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220830123604.25763-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-hwpoison-use-clearpagehwpoison-in-memory_failure
+++ a/mm/memory-failure.c
@@ -2131,7 +2131,7 @@ try_again:
 	page_flags = p->flags;
 
 	if (hwpoison_filter(p)) {
-		TestClearPageHWPoison(p);
+		ClearPageHWPoison(p);
 		unlock_page(p);
 		put_page(p);
 		res = -EOPNOTSUPP;
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

