Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63DFFC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BF1A610FC
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhD3F5e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhD3F5d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:57:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6607613A9;
        Fri, 30 Apr 2021 05:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762206;
        bh=GL8IqcMIuZ04rlW5GMBIGdlmIQ/Tp6tOVH9RSpNQ42A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NGElmZRr4hqfKsSCH3urO1sagSWr+EVILt7lESufcPd6rAxCrEnQwYOWnzQvCGl3l
         +UXPMuXFN04UL3TqcpLrPEylpNbSThqd5CbyM6+uO+3xyp1c2LpJKlV6pVdmjoHDxm
         /Oe1U22F1s4bhjJ4/AYnfV2OgAg6bybyFbcOoSpo=
Date:   Thu, 29 Apr 2021 22:56:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, duanxiongchun@bytedance.com,
        guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 070/178] mm: memcontrol: directly access
 page->memcg_data in mm/page_alloc.c
Message-ID: <20210430055645.miuXq4j_V%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: directly access page->memcg_data in mm/page_alloc.c

page_memcg() is not suitable for use by page_expected_state() and
page_bad_reason().  Because it can BUG_ON() for the slab pages when
CONFIG_DEBUG_VM is enabled.  As neither lru, nor kmem, nor slab page
should have anything left in there by the time the page is freed, what we
care about is whether the value of page->memcg_data is 0.  So just
directly access page->memcg_data here.

Link: https://lkml.kernel.org/r/20210319163821.20704-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-memcontrol-directly-access-page-memcg_data-in-mm-page_allocc
+++ a/mm/page_alloc.c
@@ -1103,7 +1103,7 @@ static inline bool page_expected_state(s
 	if (unlikely((unsigned long)page->mapping |
 			page_ref_count(page) |
 #ifdef CONFIG_MEMCG
-			(unsigned long)page_memcg(page) |
+			page->memcg_data |
 #endif
 			(page->flags & check_flags)))
 		return false;
@@ -1128,7 +1128,7 @@ static const char *page_bad_reason(struc
 			bad_reason = "PAGE_FLAGS_CHECK_AT_FREE flag(s) set";
 	}
 #ifdef CONFIG_MEMCG
-	if (unlikely(page_memcg(page)))
+	if (unlikely(page->memcg_data))
 		bad_reason = "page still charged to cgroup";
 #endif
 	return bad_reason;
_
