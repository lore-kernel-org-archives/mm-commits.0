Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF6DC76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjC1XPw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjC1XPv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:15:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215551BF0
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:15:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0B7D619E8
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E971BC433EF;
        Tue, 28 Mar 2023 23:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045349;
        bh=4/ZEfM3yDsDyq1PF+M3Nc/f6aMzs5r5OCJUsDpJL+z0=;
        h=Date:To:From:Subject:From;
        b=IokUCk/e0uA5J08D/5m9Vm8wCnWTrRYzQ6MrjT3gT6fKPCuGyXoqquTHE11V9ZOld
         GxPjRYIjq7o2YrLieThxg9tV0oZf2km94gx628jg1iH5vZOCfJjW/6MgKAK3DyvP+i
         oxz1zIUWasa6x7cKPyOH7GorN1u362SbRpzpMmYk=
Date:   Tue, 28 Mar 2023 16:15:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tangyeechou@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, findns94@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-prevent-memoryswappiness-load-store-tearing-v3.patch removed from -mm tree
Message-Id: <20230328231548.E971BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memcg-prevent-memoryswappiness-load-store-tearing-v3
has been removed from the -mm tree.  Its filename was
     mm-memcg-prevent-memoryswappiness-load-store-tearing-v3.patch

This patch was dropped because it was folded into mm-memcg-prevent-memoryswappiness-load-store-tearing.patch

------------------------------------------------------
From: Yue Zhao <findns94@gmail.com>
Subject: mm-memcg-prevent-memoryswappiness-load-store-tearing-v3
Date: Thu, 9 Mar 2023 00:25:53 +0800

Add [WRITE|READ]_ONCE for all occurrences of memcg->oom_kill_disable,
memcg->swappiness and memcg->soft_limit

Link: https://lkml.kernel.org/r/20230308162555.14195-3-findns94@gmail.com
Signed-off-by: Yue Zhao <findns94@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tang Yizhou <tangyeechou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-memoryswappiness-load-store-tearing-v3
+++ a/mm/memcontrol.c
@@ -5353,7 +5353,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 #endif
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
-		memcg->swappiness = mem_cgroup_swappiness(parent);
+		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->oom_kill_disable = parent->oom_kill_disable;
 
 		page_counter_init(&memcg->memory, &parent->memory);
_

Patches currently in -mm which might be from findns94@gmail.com are

mm-memcg-prevent-memoryoomgroup-load-store-tearing.patch
mm-memcg-prevent-memoryswappiness-load-store-tearing.patch
mm-memcg-prevent-memoryoom_control-load-store-tearing.patch
mm-memcg-prevent-memoryoom_control-load-store-tearing-v3.patch
mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing.patch
mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing-v3.patch

