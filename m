Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9128C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjC1XWP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjC1XWD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CD63593
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01E23619A3
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C77FC4339B;
        Tue, 28 Mar 2023 23:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045709;
        bh=QnJvQk3IBWQP8ulhxneL7i3bBqOpDFN1lUqRRoSz7IM=;
        h=Date:To:From:Subject:From;
        b=t9RrD0/VoaPz+Yu1Yq3GMg62x6WFZ4l1qVzqVXLd0yvb899fJPDYq+niJIfg91sOH
         YtI6W3xO2uwEEIcRU5dWR9LstwkWV/7NuNsjhQLoMCkwjEXppO+bWHoqps0ACMh7k7
         YPc4olvzwazJ1uP4D8CdbeEnF83kuU3+606xfBOs=
Date:   Tue, 28 Mar 2023 16:21:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tangyeechou@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, findns94@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing.patch removed from -mm tree
Message-Id: <20230328232149.5C77FC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, memcg: prevent memory.soft_limit_in_bytes load/store tearing
has been removed from the -mm tree.  Its filename was
     mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yue Zhao <findns94@gmail.com>
Subject: mm, memcg: Prevent memory.soft_limit_in_bytes load/store tearing
Date: Mon, 6 Mar 2023 23:41:38 +0800

The knob for cgroup v1 memory controller: memory.soft_limit_in_bytes is
not protected by any locking so it can be modified while it is used.  This
is not an actual problem because races are unlikely.  But it is better to
use [READ|WRITE]_ONCE to prevent compiler from doing anything funky.

The access of memcg->soft_limit is lockless, so it can be concurrently set
at the same time as we are trying to read it.  All occurrences of
memcg->soft_limit are updated with [READ|WRITE]_ONCE.

[findns94@gmail.com: v3]
  Link: https://lkml.kernel.org/r/20230308162555.14195-5-findns94@gmail.com
Link: https://lkml.kernel.org/r/20230306154138.3775-5-findns94@gmail.com
Signed-off-by: Yue Zhao <findns94@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tang Yizhou <tangyeechou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing
+++ a/mm/memcontrol.c
@@ -3728,7 +3728,7 @@ static u64 mem_cgroup_read_u64(struct cg
 	case RES_FAILCNT:
 		return counter->failcnt;
 	case RES_SOFT_LIMIT:
-		return (u64)memcg->soft_limit * PAGE_SIZE;
+		return (u64)READ_ONCE(memcg->soft_limit) * PAGE_SIZE;
 	default:
 		BUG();
 	}
@@ -3870,7 +3870,7 @@ static ssize_t mem_cgroup_write(struct k
 		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
 			ret = -EOPNOTSUPP;
 		} else {
-			memcg->soft_limit = nr_pages;
+			WRITE_ONCE(memcg->soft_limit, nr_pages);
 			ret = 0;
 		}
 		break;
@@ -5347,7 +5347,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		return ERR_CAST(memcg);
 
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
-	memcg->soft_limit = PAGE_COUNTER_MAX;
+	WRITE_ONCE(memcg->soft_limit, PAGE_COUNTER_MAX);
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	memcg->zswap_max = PAGE_COUNTER_MAX;
 #endif
@@ -5502,7 +5502,7 @@ static void mem_cgroup_css_reset(struct
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
-	memcg->soft_limit = PAGE_COUNTER_MAX;
+	WRITE_ONCE(memcg->soft_limit, PAGE_COUNTER_MAX);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
 }
_

Patches currently in -mm which might be from findns94@gmail.com are


