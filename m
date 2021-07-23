Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F014AC4338F
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 22:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAE7C60F38
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 22:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhGWWKH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jul 2021 18:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233064AbhGWWKG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Jul 2021 18:10:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 345D760EB5;
        Fri, 23 Jul 2021 22:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627080639;
        bh=MjVWOlwxEnyXFMcGd7wYkPesTcfyvbVCGVsHFNt63Mk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Jiyha2YZwX/tK0BEtEhXU6agivtiThuj83gOJbPPzkX7h+MSn61yxP3bQAJ1cHI9W
         f1NkjiIB7+7aFIN+1a4fARj9tG1eoX+5nWmo+jl5D497e6POo8puKBRuGBNe8mESze
         CSxkxo55I3Vv20/BCSW1mQbHsg0D1wYXcxn+vXr4=
Date:   Fri, 23 Jul 2021 15:50:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        pankaj.gupta@ionos.com, shy828301@gmail.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org
Subject:  [patch 13/15] mm: mmap_lock: fix disabling preemption
 directly
Message-ID: <20210723225038.7yIzuPTXo%akpm@linux-foundation.org>
In-Reply-To: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: mmap_lock: fix disabling preemption directly

The commit 832b50725373 ("mm: mmap_lock: use local locks instead of
disabling preemption") fix a bug by using local locks.  But commit
d01079f3d0c0 ("mm/mmap_lock: remove dead code for !CONFIG_TRACING
configurations") changes those lines to original version.  I guess it is
introduced by the conflicts fixing on merging.

Link: https://lkml.kernel.org/r/20210720074228.76342-1-songmuchun@bytedance.com
Fixes: d01079f3d0c0 ("mm/mmap_lock: remove dead code for !CONFIG_TRACING configurations")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap_lock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap_lock.c~mm-mmap_lock-fix-disabling-preemption-directly
+++ a/mm/mmap_lock.c
@@ -156,14 +156,14 @@ static inline void put_memcg_path_buf(vo
 #define TRACE_MMAP_LOCK_EVENT(type, mm, ...)                                   \
 	do {                                                                   \
 		const char *memcg_path;                                        \
-		preempt_disable();                                             \
+		local_lock(&memcg_paths.lock);                                 \
 		memcg_path = get_mm_memcg_path(mm);                            \
 		trace_mmap_lock_##type(mm,                                     \
 				       memcg_path != NULL ? memcg_path : "",   \
 				       ##__VA_ARGS__);                         \
 		if (likely(memcg_path != NULL))                                \
 			put_memcg_path_buf();                                  \
-		preempt_enable();                                              \
+		local_unlock(&memcg_paths.lock);                               \
 	} while (0)
 
 #else /* !CONFIG_MEMCG */
_
