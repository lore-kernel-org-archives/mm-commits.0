Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A66CC25B08
	for <mm-commits@archiver.kernel.org>; Sun, 21 Aug 2022 03:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiHUDUd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 23:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiHUDUc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 23:20:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0F4201BD
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 20:20:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80375B80AE9
        for <mm-commits@vger.kernel.org>; Sun, 21 Aug 2022 03:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0228C433D6;
        Sun, 21 Aug 2022 03:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661052028;
        bh=EihPQUD0EL0SPq7p6jNGkSOoCCtgcHr5G5XYQPGIWSg=;
        h=Date:To:From:Subject:From;
        b=Exdqr2Cq+qafcCuocPB/RszUvMaSs1CbLKnuFodsa1QE24nvI+NqdK647434QQ4J2
         X74veo6mxInhlBGvkF+Hm9Iw/phX/on5ZAhkCeSRPM+y4Cu6IIGPtBI7TLlink94Bo
         SG6/xfG6wDjweBfegQj84/EbH0xsxWpZR7KAubRM=
Date:   Sat, 20 Aug 2022 20:20:27 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-export-workingset-refault-stats-for-cgroup-v1.patch added to mm-unstable branch
Message-Id: <20220821032027.F0228C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: export workingset refault stats for cgroup v1
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-export-workingset-refault-stats-for-cgroup-v1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-export-workingset-refault-stats-for-cgroup-v1.patch

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
From: Yang Shi <shy828301@gmail.com>
Subject: mm: memcg: export workingset refault stats for cgroup v1
Date: Tue, 16 Aug 2022 11:58:01 -0700

Workingset refault stats are important and useful metrics to measure how
well reclaimer and swapping work and how healthy the services are, but
they are just available for cgroup v2.  There are still plenty users with
cgroup v1, export the stats for cgroup v1.

Link: https://lkml.kernel.org/r/20220816185801.651091-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-export-workingset-refault-stats-for-cgroup-v1
+++ a/mm/memcontrol.c
@@ -3976,6 +3976,8 @@ static const unsigned int memcg1_stats[]
 	NR_FILE_MAPPED,
 	NR_FILE_DIRTY,
 	NR_WRITEBACK,
+	WORKINGSET_REFAULT_ANON,
+	WORKINGSET_REFAULT_FILE,
 	MEMCG_SWAP,
 };
 
@@ -3989,6 +3991,8 @@ static const char *const memcg1_stat_nam
 	"mapped_file",
 	"dirty",
 	"writeback",
+	"workingset_refault_anon",
+	"workingset_refault_file",
 	"swap",
 };
 
@@ -4017,7 +4021,8 @@ static int memcg_stat_show(struct seq_fi
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		nr = memcg_page_state_local(memcg, memcg1_stats[i]);
-		seq_printf(m, "%s %lu\n", memcg1_stat_names[i], nr * PAGE_SIZE);
+		seq_printf(m, "%s %lu\n", memcg1_stat_names[i],
+			   nr * memcg_page_state_unit(memcg1_stats[i]));
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
@@ -4048,7 +4053,7 @@ static int memcg_stat_show(struct seq_fi
 			continue;
 		nr = memcg_page_state(memcg, memcg1_stats[i]);
 		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
-						(u64)nr * PAGE_SIZE);
+			   (u64)nr * memcg_page_state_unit(memcg1_stats[i]));
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-khugepaged-dont-carry-huge-page-to-the-next-loop-for-config_numa.patch
mm-memcg-export-workingset-refault-stats-for-cgroup-v1.patch

