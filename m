Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A7C1C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E32760FA0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347569AbhIBV5A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347915AbhIBV46 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A81C60F12;
        Thu,  2 Sep 2021 21:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619760;
        bh=CszRvsYS7YknnqC2xK71FmtEtvifu+2vd9GJd820pIM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aaCug2yh/ZXRHwX7/vaxpOgdjQyzixlZ6H/7+0ZHvedefPWBN2CfIXDQaQDSxILG3
         QF7cSZVVbE3B+JKubKan/wby9fnrTDBuLhIUJ7g+ajlfBSNZlG7WIJJeiu9V6dcfJn
         ykkb1xQTSVdKpLiXoik/HZTOhZyYcsudP0omBICc=
Date:   Thu, 02 Sep 2021 14:55:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org, guro@fb.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com,
        willy@infradead.org
Subject:  [patch 112/212] mm, memcg: save some atomic ops when
 flush is already true
Message-ID: <20210902215559.5d1VDc9Cn%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
