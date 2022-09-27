Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A7FC32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiI0Cri (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiI0Cr3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7CC6173F
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CA06B80DA7
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C54EC433D7;
        Tue, 27 Sep 2022 02:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246844;
        bh=q6GdD9YViQFeYq6+Xz6fa+ZkXNAMW6i7fzad/hqb47w=;
        h=Date:To:From:Subject:From;
        b=vn40sLr9OTMZTvQFu8W3JFxIk5OeihS4fSjF10GOXJoCXt4K/DfDDmcuDiqjWZJEH
         N/a2o+XOvf/H3t3pS0Di8pNnUCwjjAyTj4CsZFqcYK39tYGgFOHMOUQ7laubooismr
         kqnF7cmAaC1rtCE+GHsGBGfQXJHWoM66RZNTPAqY=
Date:   Mon, 26 Sep 2022 19:47:23 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch removed from -mm tree
Message-Id: <20220927024724.1C54EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: check PageTable() explicitly in hwpoison_user_mappings()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, hwpoison: check PageTable() explicitly in hwpoison_user_mappings()
Date: Tue, 30 Aug 2022 20:36:03 +0800

PageTable can't be handled by memory_failure(). Filter it out explicitly in
hwpoison_user_mappings(). This will also make code more consistent with the
relevant check in unpoison_memory().

Link: https://lkml.kernel.org/r/20220830123604.25763-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings
+++ a/mm/memory-failure.c
@@ -1409,7 +1409,7 @@ static bool hwpoison_user_mappings(struc
 	 * Here we are interested only in user-mapped pages, so skip any
 	 * other types of pages.
 	 */
-	if (PageReserved(p) || PageSlab(p))
+	if (PageReserved(p) || PageSlab(p) || PageTable(p))
 		return true;
 	if (!(PageLRU(hpage) || PageHuge(p)))
 		return true;
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

