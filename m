Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AAFAC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C69C6140E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhEHWmc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229690AbhEHWmb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95CA36140E;
        Sat,  8 May 2021 22:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513687;
        bh=DQfq8PAZsD/Ag2jyppasM3yj9uCJgc80ou2eYXjOCpM=;
        h=Date:From:To:Subject:From;
        b=TRRTsw89KOrAIoJGIxeONjiViLZWUYvD7Guv5xVdPC1omzONEi92FpJmJP9JnEHl9
         lKm6SdwTjVyFhTDTgXPz6xDood3R1v/msQK2JafmYgo6R8A016xeFW9IAEG6hujZsa
         uLlqI+1OidPrpXL55up03QlDnWmqrq80xmOr6w7Q=
Date:   Sat, 08 May 2021 15:41:27 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-directly-access-page-memcg_data-in-mm-page_allocc.patch
 removed from -mm tree
Message-ID: <20210508224127.feDfkeoYV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: directly access page->memcg_data in mm/page_alloc.c
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-directly-access-page-memcg_data-in-mm-page_allocc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from songmuchun@bytedance.com are


