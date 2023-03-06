Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D2EC64EC4
	for <mm-commits@archiver.kernel.org>; Mon,  6 Mar 2023 20:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCFUyH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Mar 2023 15:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjCFUyE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2023 15:54:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F40739CEF
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 12:54:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDCF4B81126
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 20:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9934FC433EF;
        Mon,  6 Mar 2023 20:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678136038;
        bh=Jq2Cvb2QKEc6mlie9mspPfpqAkF2PbJvGFd20jbInGg=;
        h=Date:To:From:Subject:From;
        b=q4SMowgFg5SvSS/Ct7pAQxeYeRrwQk675b8pn/CBOCICkURNPdb3EWUM8BFHBFvg6
         Pr8kE2Gmhbn4WxuC4BVZSdv8I0OlBJs1I2B5hMSUlrxDXQjgayKEp4crSvKqBqvK/U
         eYLMpF698d13gdKzGu7Cide0ZIZkJmHdreZliRY4=
Date:   Mon, 06 Mar 2023 12:53:57 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tangyeechou@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, findns94@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-prevent-memoryoom_control-load-store-tearing.patch added to mm-unstable branch
Message-Id: <20230306205358.9934FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: Prevent memory.oom_control load/store tearing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-prevent-memoryoom_control-load-store-tearing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-prevent-memoryoom_control-load-store-tearing.patch

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
Subject: mm, memcg: Prevent memory.oom_control load/store tearing
Date: Mon, 6 Mar 2023 23:41:37 +0800

The knob for cgroup v1 memory controller: memory.oom_control
is not protected by any locking so it can be modified while it is used.
This is not an actual problem because races are unlikely.
But it is better to use READ_ONCE/WRITE_ONCE to prevent compiler from
doing anything funky.

The access of memcg->oom_kill_disable is lockless,
so it can be concurrently set at the same time as we are
trying to read it.

Link: https://lkml.kernel.org/r/20230306154138.3775-4-findns94@gmail.com
Signed-off-by: Yue Zhao <findns94@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tang Yizhou <tangyeechou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memcontrol.c~mm-memcg-prevent-memoryoom_control-load-store-tearing
+++ a/mm/memcontrol.c
@@ -4515,7 +4515,7 @@ static int mem_cgroup_oom_control_read(s
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(sf);
 
-	seq_printf(sf, "oom_kill_disable %d\n", memcg->oom_kill_disable);
+	seq_printf(sf, "oom_kill_disable %d\n", READ_ONCE(memcg->oom_kill_disable));
 	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
 	seq_printf(sf, "oom_kill %lu\n",
 		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
@@ -4531,7 +4531,7 @@ static int mem_cgroup_oom_control_write(
 	if (mem_cgroup_is_root(memcg) || !((val == 0) || (val == 1)))
 		return -EINVAL;
 
-	memcg->oom_kill_disable = val;
+	WRITE_ONCE(memcg->oom_kill_disable, val);
 	if (!val)
 		memcg_oom_recover(memcg);
 
_

Patches currently in -mm which might be from findns94@gmail.com are

mm-memcg-prevent-memoryoomgroup-load-store-tearing.patch
mm-memcg-prevent-memoryswappiness-load-store-tearing.patch
mm-memcg-prevent-memoryoom_control-load-store-tearing.patch
mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing.patch

