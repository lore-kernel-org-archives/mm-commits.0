Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B523C77B6F
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjC1XWO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjC1XVx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906CC358C
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47570B81EEC
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E3AC4339B;
        Tue, 28 Mar 2023 23:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045704;
        bh=7efs8VRLvEpl73wpgxyPX7p9ajs5oiT55QbfQBsVRz8=;
        h=Date:To:From:Subject:From;
        b=FGLVLZ923v06zSBeNIzNnf03JnrbvJDXDyGgtzvJS83SY3u8aQQVwOirQgEUc5tuo
         m7UTwFIB5GpeTWM+qBR5jKNn3DFRifXipkHimO14FY4GaUONgirN05BERoMaLFuxDA
         MLWdKD927DWmTgZn0n0awtLLigTrr7s8NyWHhsNM=
Date:   Tue, 28 Mar 2023 16:21:43 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tangyeechou@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, findns94@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-prevent-memoryoomgroup-load-store-tearing.patch removed from -mm tree
Message-Id: <20230328232143.E0E3AC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, memcg: prevent memory.oom.group load/store tearing
has been removed from the -mm tree.  Its filename was
     mm-memcg-prevent-memoryoomgroup-load-store-tearing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yue Zhao <findns94@gmail.com>
Subject: mm, memcg: Prevent memory.oom.group load/store tearing
Date: Mon, 6 Mar 2023 23:41:35 +0800

Patch series "mm, memcg: cgroup v1 and v2 tunable load/store tearing
fixes", v2.

This patch series helps to prevent load/store tearing in
several cgroup knobs.

As kindly pointed out by Michal Hocko and Roman Gushchin
, the changelog has been rephrased.

Besides, more knobs were checked, according to kind suggestions
from Shakeel Butt and Muchun Song.


This patch (of 4):

The knob for cgroup v2 memory controller: memory.oom.group
is not protected by any locking so it can be modified while it is used.
This is not an actual problem because races are unlikely (the knob is
usually configured long before any workloads hits actual memcg oom)
but it is better to use READ_ONCE/WRITE_ONCE to prevent compiler from
doing anything funky.

The access of memcg->oom_group is lockless, so it can be
concurrently set at the same time as we are trying to read it.

Link: https://lkml.kernel.org/r/20230306154138.3775-1-findns94@gmail.com
Link: https://lkml.kernel.org/r/20230306154138.3775-2-findns94@gmail.com
Signed-off-by: Yue Zhao <findns94@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tang Yizhou <tangyeechou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-memoryoomgroup-load-store-tearing
+++ a/mm/memcontrol.c
@@ -2067,7 +2067,7 @@ struct mem_cgroup *mem_cgroup_get_oom_gr
 	 * highest-level memory cgroup with oom.group set.
 	 */
 	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
-		if (memcg->oom_group)
+		if (READ_ONCE(memcg->oom_group))
 			oom_group = memcg;
 
 		if (memcg == oom_domain)
@@ -6623,7 +6623,7 @@ static int memory_oom_group_show(struct
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	seq_printf(m, "%d\n", memcg->oom_group);
+	seq_printf(m, "%d\n", READ_ONCE(memcg->oom_group));
 
 	return 0;
 }
@@ -6645,7 +6645,7 @@ static ssize_t memory_oom_group_write(st
 	if (oom_group != 0 && oom_group != 1)
 		return -EINVAL;
 
-	memcg->oom_group = oom_group;
+	WRITE_ONCE(memcg->oom_group, oom_group);
 
 	return nbytes;
 }
_

Patches currently in -mm which might be from findns94@gmail.com are


