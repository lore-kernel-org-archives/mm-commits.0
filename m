Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482DAC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D08E61463
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhD3F5h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhD3F5g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:57:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01B6A610FC;
        Fri, 30 Apr 2021 05:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762209;
        bh=Q8iz24SQ94LfbpU1yuLz06i5ZuI42EXgtfivq5NSTgo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kDhZZfmcFjikvqYVRsWE8K7/4lkJCfXdnN+VQO4flv6Ew1Nyf7DlBTC0C+tDfJr3m
         tT8gfLMNpaQlcqSyNfnAOj0IfnXq21QbF7nz9Z5e+O6mUeDhPR8f07eQWAf4StJL/J
         AKKd0huEhWgB1cbIzIkvS1NCiGVWOswcDj7Slogw=
Date:   Thu, 29 Apr 2021 22:56:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, duanxiongchun@bytedance.com,
        guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 071/178] mm: memcontrol: change ug->dummy_page
 only if memcg changed
Message-ID: <20210430055648.dvlfgXvVh%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: change ug->dummy_page only if memcg changed

Just like assignment to ug->memcg, we only need to update ug->dummy_page
if memcg changed.  So move it to there.  This is a very small
optimization.

Link: https://lkml.kernel.org/r/20210319163821.20704-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-change-ug-dummy_page-only-if-memcg-changed
+++ a/mm/memcontrol.c
@@ -6843,6 +6843,7 @@ static void uncharge_page(struct page *p
 			uncharge_gather_clear(ug);
 		}
 		ug->memcg = page_memcg(page);
+		ug->dummy_page = page;
 
 		/* pairs with css_put in uncharge_batch */
 		css_get(&ug->memcg->css);
@@ -6856,7 +6857,6 @@ static void uncharge_page(struct page *p
 	else
 		ug->pgpgout++;
 
-	ug->dummy_page = page;
 	page->memcg_data = 0;
 	css_put(&ug->memcg->css);
 }
_
