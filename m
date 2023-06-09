Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9410C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjFIX1G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbjFIX1B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926393583
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E65365CDB
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83377C433D2;
        Fri,  9 Jun 2023 23:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353217;
        bh=cLAsWvlEkCo94LuBoDIozKB7Cn0T5ahyoC0sLN05fMg=;
        h=Date:To:From:Subject:From;
        b=T2G38iTPOult0qXSxHc8UX+rsKk2vcW4A74rYBzTyOUgV7MNN6iNC9yTqpu4Y+jSK
         L8Ya7RRmCKIbJUL/BMeCd0kFqH81eoxG8ysmbTwxaHBo5C+nnYrvFijGcxtEBVo1Mp
         +0zttLvBhqIEqbcxeCJjG13qCpk0C8Z8IfTDlsPQ=
Date:   Fri, 09 Jun 2023 16:26:56 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        jack@suse.cz, hannes@cmpxchg.org, brauner@kernel.org,
        axboe@kernel.dk, yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-flush-stats-non-atomically-in-mem_cgroup_wb_stats.patch removed from -mm tree
Message-Id: <20230609232657.83377C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: flush stats non-atomically in mem_cgroup_wb_stats()
has been removed from the -mm tree.  Its filename was
     memcg-flush-stats-non-atomically-in-mem_cgroup_wb_stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: memcg: flush stats non-atomically in mem_cgroup_wb_stats()
Date: Fri, 21 Apr 2023 17:40:17 +0000

The previous patch moved the wb_over_bg_thresh()->mem_cgroup_wb_stats()
code path in wb_writeback() outside the lock section.  We no longer need
to flush the stats atomically.  Flush the stats non-atomically.

Link: https://lkml.kernel.org/r/20230421174020.2994750-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/memcontrol.c~memcg-flush-stats-non-atomically-in-mem_cgroup_wb_stats
+++ a/mm/memcontrol.c
@@ -4656,11 +4656,7 @@ void mem_cgroup_wb_stats(struct bdi_writ
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	/*
-	 * wb_writeback() takes a spinlock and calls
-	 * wb_over_bg_thresh()->mem_cgroup_wb_stats(). Do not sleep.
-	 */
-	mem_cgroup_flush_stats_atomic();
+	mem_cgroup_flush_stats();
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-support-exclusive-loads.patch

