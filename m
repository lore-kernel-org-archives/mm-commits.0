Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9DAC07E95
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 21:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38B89610F7
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 21:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbhGTU35 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 16:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235073AbhGTUYK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 16:24:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BD5760233;
        Tue, 20 Jul 2021 21:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626815087;
        bh=Mls41ulVX+glVvDyUaYMCxdrFgROY/oK0ar1p56ujEc=;
        h=Date:From:To:Subject:From;
        b=naePmU6rQ6c+e4AHCsmTxn4369+PRN6w7ElhgIB9SHY3pd1DL/bxC200FUKPcugPt
         CkIjPbytKOvvO7jcb84cEwRwvrZeUgdGrTHkA/TLDgtV9FnG/mvegQfDc+ZHRDGEbJ
         ACIsqhkSJuiEjXM7JP7ExkkqMr6zQBH05QTAyt5s=
Date:   Tue, 20 Jul 2021 14:04:46 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        mgorman@techsingularity.net, songmuchun@bytedance.com
Subject:  + mm-mmap_lock-fix-disabling-preemption-directly.patch
 added to -mm tree
Message-ID: <20210720210446.GfPmN%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap_lock: fix disabling preemption directly
has been added to the -mm tree.  Its filename is
     mm-mmap_lock-fix-disabling-preemption-directly.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap_lock-fix-disabling-preemption-directly.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap_lock-fix-disabling-preemption-directly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-mmap_lock-fix-disabling-preemption-directly.patch

