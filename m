Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7655C76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjC1XRM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjC1XRL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:17:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747551BFB
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:17:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18579B81F4E
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97059C433D2;
        Tue, 28 Mar 2023 23:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045422;
        bh=bqCm110rs01a8stQVAWpcPhB03izfIlLyY1SsR+/kpg=;
        h=Date:To:From:Subject:From;
        b=kv9AEv0dfUtA1PDa70umOje5L8s0b7MCpmiWo9FLQYzTRKqcOM171D8V4UQxIsqgl
         YIESu0xPUnp1PpQ6hEJXh7Hur9Ys0C+orMjiZ9jb7/ALC2jtap7xr7lq0NrYBIvQ7N
         pD6ViHMTfCpWs8ItYAh/8RHPw7TdIRrXF5GHCldU=
Date:   Tue, 28 Mar 2023 16:17:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tangyeechou@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, findns94@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing-v3.patch removed from -mm tree
Message-Id: <20230328231702.97059C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing-v3
has been removed from the -mm tree.  Its filename was
     mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing-v3.patch

This patch was dropped because it was folded into mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing.patch

------------------------------------------------------
From: Yue Zhao <findns94@gmail.com>
Subject: mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing-v3
Date: Thu, 9 Mar 2023 00:25:55 +0800

Add [WRITE|READ]_ONCE for all occurrences of memcg->oom_kill_disable,
memcg->swappiness and memcg->soft_limit.

Link: https://lkml.kernel.org/r/20230308162555.14195-5-findns94@gmail.com
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

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing-v3
+++ a/mm/memcontrol.c
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

mm-memcg-prevent-memoryoomgroup-load-store-tearing.patch
mm-memcg-prevent-memoryswappiness-load-store-tearing.patch
mm-memcg-prevent-memoryoom_control-load-store-tearing.patch
mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing.patch

