Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D20C43462
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0999B6141E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEHWml (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhEHWmk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:42:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 772316140E;
        Sat,  8 May 2021 22:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513697;
        bh=ocEV07XGOoSTqCe74fmhERaMP8j+KVPMIEo3xCAm028=;
        h=Date:From:To:Subject:From;
        b=NugWhKpovWGAHZmW3HerRv5jp502rLEENqoNwQuqSqQMbK/BbrWgVSGKQKQzqn6aW
         ILVulY3f0Bm1YPsPk9AR8vpbUq7AvPEXxUQ4buxayN3Mw9/531J3+4NgmjGtyZfsTW
         ivhQMCufQw7jkGs8+RZ+iscOgyJ891zlT7dOt+w8=
Date:   Sat, 08 May 2021 15:41:37 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-move-pagememcgkmem-to-the-scope-of-config_memcg_kmem.patch
 removed from -mm tree
Message-ID: <20210508224137.MKmRny-Bz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: move PageMemcgKmem to the scope of CONFIG_MEMCG_KMEM
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-move-pagememcgkmem-to-the-scope-of-config_memcg_kmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from songmuchun@bytedance.com are


