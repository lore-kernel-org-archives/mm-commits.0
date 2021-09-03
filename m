Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F296EC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD29F6112F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbhICU7K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242776AbhICU7J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72E52610FD;
        Fri,  3 Sep 2021 20:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702688;
        bh=BzBRSXUH/jSkzZApA4ns3yMprnR7gYgNKs6GrnIIHkc=;
        h=Date:From:To:Subject:From;
        b=ZobAdOEBw1Abi6XofJ9qGxSrYup/tYIUquCB/izSEvWTLHTKspklxIbVWCDEkQuRH
         LrZf0BCre4LK0ZxxEkPE129/n7BQ+YNbZAU50EbJCWufQ3W3h44o98IJzu2FpsGS4F
         RuM6ZecBWcEVDy2G6OvLn0tYJDlv9PNbfxp0YjLg=
Date:   Fri, 03 Sep 2021 13:58:08 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, guro@fb.com, linmiaohe@huawei.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com,
        willy@infradead.org
Subject:  [merged]
 mm-memcg-save-some-atomic-ops-when-flush-is-already-true.patch removed from
 -mm tree
Message-ID: <20210903205808.uluceO8Jn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: save some atomic ops when flush is already true
has been removed from the -mm tree.  Its filename was
     mm-memcg-save-some-atomic-ops-when-flush-is-already-true.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, memcg: save some atomic ops when flush is already true

Add 'else' to save some atomic ops in obj_stock_flush_required() when
flush is already true.  No functional change intended here.

Link: https://lkml.kernel.org/r/20210807082835.61281-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-save-some-atomic-ops-when-flush-is-already-true
+++ a/mm/memcontrol.c
@@ -2246,7 +2246,7 @@ static void drain_all_stock(struct mem_c
 		if (memcg && stock->nr_pages &&
 		    mem_cgroup_is_descendant(memcg, root_memcg))
 			flush = true;
-		if (obj_stock_flush_required(stock, root_memcg))
+		else if (obj_stock_flush_required(stock, root_memcg))
 			flush = true;
 		rcu_read_unlock();
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

