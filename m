Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFD6EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjHUUlu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjHUUko (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2ECFCD1
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E8BA6333C
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7209BC433C7;
        Mon, 21 Aug 2023 20:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650428;
        bh=uSAAKIfrjITwWavO/WytDMxcCz+Oicbq33XXo7fQOHs=;
        h=Date:To:From:Subject:From;
        b=DD62Y0mXhr/L8AbdI1SDdlKThCSkXJy9y4824GJU39pB5dg/6sA/1ktxZp9elbvk0
         d7UR5SgAxWGeq4zquTJEGzRW63k1z6Xtm1ml3QmZNDpCYfwz8WUsVz1fi6Xf7v+JEk
         Ycc4iGKG4vmKbIjJkwlqhcIiEmXO/XxcxtITJDrk=
Date:   Mon, 21 Aug 2023 13:40:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        david@redhat.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap_statec-use-helper-macro-k.patch removed from -mm tree
Message-Id: <20230821204028.7209BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap_state.c: use helper macro K()
has been removed from the -mm tree.  Its filename was
     mm-swap_statec-use-helper-macro-k.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/swap_state.c: use helper macro K()
Date: Fri, 4 Aug 2023 09:25:55 +0800

Use helper macro K() to improve code readability.  No functional
modification involved.

Link: https://lkml.kernel.org/r/20230804012559.2617515-4-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/swap_state.c~mm-swap_statec-use-helper-macro-k
+++ a/mm/swap_state.c
@@ -63,9 +63,8 @@ static atomic_t swapin_readahead_hits =
 void show_swap_cache_info(void)
 {
 	printk("%lu pages in swap cache\n", total_swapcache_pages());
-	printk("Free swap  = %ldkB\n",
-		get_nr_swap_pages() << (PAGE_SHIFT - 10));
-	printk("Total swap = %lukB\n", total_swap_pages << (PAGE_SHIFT - 10));
+	printk("Free swap  = %ldkB\n", K(get_nr_swap_pages()));
+	printk("Total swap = %lukB\n", K(total_swap_pages));
 }
 
 void *get_shadow_from_swap_cache(swp_entry_t entry)
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


