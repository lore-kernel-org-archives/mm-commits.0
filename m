Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF474C77B75
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 21:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjEBVPA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 17:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjEBVO7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 17:14:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD77410EF
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 14:14:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3567A62296
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 21:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B07CC4339B;
        Tue,  2 May 2023 21:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683062096;
        bh=FGc7NfcoxyBIOSX1vc+pi5T65DVxvOYCQO2y6HJGN5o=;
        h=Date:To:From:Subject:From;
        b=f+NY2F0kWN10z1ITh2E34rC6LAdN6jBVD0B3NBzP+i5W2K1PYgSUMXIEtBHTnind0
         nN7IDfVPTEqyA3HPwgeJlCv+1+Mq5PuHVoFeQpH1wqI1QlO+eER1OJdQfj8vtG9cST
         HaP5xnCIrFKJET4Ewo+/S/J9F9unLXo4+j2YfkJQ=
Date:   Tue, 02 May 2023 14:14:55 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        jack@suse.cz, hannes@cmpxchg.org, brauner@kernel.org,
        axboe@kernel.dk, yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-flush-stats-non-atomically-in-mem_cgroup_wb_stats.patch added to mm-unstable branch
Message-Id: <20230502211456.8B07CC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: flush stats non-atomically in mem_cgroup_wb_stats()
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-flush-stats-non-atomically-in-mem_cgroup_wb_stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-flush-stats-non-atomically-in-mem_cgroup_wb_stats.patch

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
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
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

memcg-use-seq_buf_do_printk-with-mem_cgroup_print_oom_meminfo.patch
memcg-dump-memorystat-during-cgroup-oom-for-v1.patch
writeback-move-wb_over_bg_thresh-call-outside-lock-section.patch
memcg-flush-stats-non-atomically-in-mem_cgroup_wb_stats.patch
memcg-calculate-root-usage-from-global-state.patch
memcg-remove-mem_cgroup_flush_stats_atomic.patch
cgroup-remove-cgroup_rstat_flush_atomic.patch

