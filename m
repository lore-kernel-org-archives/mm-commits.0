Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E283C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20A5761480
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhD3F5q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhD3F5q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:57:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA84361476;
        Fri, 30 Apr 2021 05:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762219;
        bh=yptM377cC6Zn+Cynf8aTo/jadDDWoR7jobGaLzu/m3Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wUgZDvvvXe6IiyKKJSixR2dISUDc6Am28vzgAaLah5uVzzYAis46QA0rv0EkyFch6
         MsgMxrn2KHdCGaHikd5FNr0cbVidyPYgnQe3O0vEJeQtnS+kht9Yjuz9rWjQgayLNh
         XJMZRodHYrNR3wQrkAxjUuFFl0SyytDjLG3b5cVA=
Date:   Thu, 29 Apr 2021 22:56:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, duanxiongchun@bytedance.com,
        guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 074/178] mm: memcontrol: move PageMemcgKmem to the
 scope of CONFIG_MEMCG_KMEM
Message-ID: <20210430055658.fMENa5cAc%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: move PageMemcgKmem to the scope of CONFIG_MEMCG_KMEM

The page only can be marked as kmem when CONFIG_MEMCG_KMEM is enabled.  So
move PageMemcgKmem() to the scope of the CONFIG_MEMCG_KMEM.

As a bonus, on !CONFIG_MEMCG_KMEM build some code can be compiled out.

Link: https://lkml.kernel.org/r/20210319163821.20704-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-move-pagememcgkmem-to-the-scope-of-config_memcg_kmem
+++ a/include/linux/memcontrol.h
@@ -523,6 +523,7 @@ static inline struct mem_cgroup *page_me
 	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
+#ifdef CONFIG_MEMCG_KMEM
 /*
  * PageMemcgKmem - check if the page has MemcgKmem flag set
  * @page: a pointer to the page struct
@@ -537,7 +538,6 @@ static inline bool PageMemcgKmem(struct
 	return page->memcg_data & MEMCG_DATA_KMEM;
 }
 
-#ifdef CONFIG_MEMCG_KMEM
 /*
  * page_objcgs - get the object cgroups vector associated with a page
  * @page: a pointer to the page struct
@@ -579,6 +579,11 @@ static inline struct obj_cgroup **page_o
 }
 
 #else
+static inline bool PageMemcgKmem(struct page *page)
+{
+	return false;
+}
+
 static inline struct obj_cgroup **page_objcgs(struct page *page)
 {
 	return NULL;
_
