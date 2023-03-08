Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C97C678D5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 20:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjCHUPI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Mar 2023 15:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjCHUOv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2023 15:14:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B252062867
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 12:14:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D315B81DFC
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 20:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCBDC433D2;
        Wed,  8 Mar 2023 20:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678306468;
        bh=Hv05QUCSj8jikCtoZwVnjOtM37dv9fPUH814EuMf5yg=;
        h=Date:To:From:Subject:From;
        b=cxk6rE+pEH2PT7/1yO8F05dEF5PGyQcb3BG4qTn3SKkpTZ0SZe24xXYIp6ymzfG0i
         I2RjGtVJ7Fq7DKK5y12zPlpt4Zzxjoy3wJRnZo/7VMCTd5MK8QS5JStZkKKgLCoHJB
         KMNd8nCdqF2GZUfW8Q/pVfF9y7O0Tk6I6JGHRv8g=
Date:   Wed, 08 Mar 2023 12:14:27 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tangyeechou@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, findns94@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-prevent-memoryswappiness-load-store-tearing-v3.patch added to mm-unstable branch
Message-Id: <20230308201428.0DCBDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-prevent-memoryswappiness-load-store-tearing-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-prevent-memoryswappiness-load-store-tearing-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-prevent-memoryswappiness-load-store-tearing-v3.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yue Zhao <findns94@gmail.com>
Subject: mm-memcg-prevent-memoryswappiness-load-store-tearing-v3
Date: Thu, 9 Mar 2023 00:25:53 +0800

Add [WRITE|READ]_ONCE for all occurrences of memcg->oom_kill_disable,
memcg->swappiness and memcg->soft_limit

Link: https://lkml.kernel.org/r/20230308162555.14195-3-findns94@gmail.com
Signed-off-by: Yue Zhao <findns94@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tang Yizhou <tangyeechou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
mm-memcg-prevent-memoryswappiness-load-store-tearing-v3.patch
mm-memcg-prevent-memoryoom_control-load-store-tearing.patch
mm-memcg-prevent-memoryoom_control-load-store-tearing-v3.patch
mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing.patch
mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing-v3.patch

