Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD63CCA485
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbiGRAVr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiGRAUc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC50A14D12
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 688B660F4B
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1026C341C0;
        Mon, 18 Jul 2022 00:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103517;
        bh=11/Rcpf6uRvvbXanqEtMqyyz9/+RzZTiRvkLjxPrGNc=;
        h=Date:To:From:Subject:From;
        b=kJncLRRHmlMAYkc6U1TCH3tv03QROoZota2mhan8jxjBZvmPDNBTuU05Th5zxU1LE
         PrW5m+K10jZe69xALxjjaugKfYKvkUiY+D9+P6MeJcjlPCrny0QxVA4MYt5C7SKVEq
         fHVTOXs4W1E42IxJuBwUo2mdI1wvvO9Si7xOLIOE=
Date:   Sun, 17 Jul 2022 17:18:37 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-fix-comment-of-page_deferred_list.patch removed from -mm tree
Message-Id: <20220718001837.C1026C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: fix comment of page_deferred_list
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-comment-of-page_deferred_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: fix comment of page_deferred_list
Date: Mon, 4 Jul 2022 21:21:58 +0800

The current comment is confusing because if global or memcg deferred list
in the second tail page is occupied by compound_head, why we still use
page[2].deferred_list here? I think it wants to say that Global or memcg
deferred list in the first tail page is occupied by compound_mapcount and
compound_pincount so we use the second tail page's deferred_list instead.

Link: https://lkml.kernel.org/r/20220704132201.14611-14-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-fix-comment-of-page_deferred_list
+++ a/include/linux/huge_mm.h
@@ -294,8 +294,8 @@ static inline bool thp_migration_support
 static inline struct list_head *page_deferred_list(struct page *page)
 {
 	/*
-	 * Global or memcg deferred list in the second tail pages is
-	 * occupied by compound_head.
+	 * See organization of tail pages of compound page in
+	 * "struct page" definition.
 	 */
 	return &page[2].deferred_list;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

