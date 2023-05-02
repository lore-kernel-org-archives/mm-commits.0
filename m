Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3856FC77B78
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 21:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjEBVO7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 17:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjEBVO6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 17:14:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E79171B
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 14:14:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C74C628D2
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 21:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A338BC433EF;
        Tue,  2 May 2023 21:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683062094;
        bh=/19qTSOFctvVLdDd1wAEBoTV7aXkqgWCc5I2XcHPVFs=;
        h=Date:To:From:Subject:From;
        b=mpJOqA4onjJX+2IeCP1UsbeDqaH7zpaVpoDAQvC7AVnb5s4tQDFjgbfiP+dKbcylN
         exxiMWlgZB1BUD5GQSCagJfYAj3O5l44BOSfZDaxssukdjMkGcFfFwk7M6/SxOkQyH
         1SoGFNtbHnZRa/6VEb9BACW8DeFe27SoUH6CSoa8=
Date:   Tue, 02 May 2023 14:14:53 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        jack@suse.cz, hannes@cmpxchg.org, brauner@kernel.org,
        axboe@kernel.dk, yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-move-wb_over_bg_thresh-call-outside-lock-section.patch added to mm-unstable branch
Message-Id: <20230502211454.A338BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: move wb_over_bg_thresh() call outside lock section
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-move-wb_over_bg_thresh-call-outside-lock-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-move-wb_over_bg_thresh-call-outside-lock-section.patch

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
Subject: writeback: move wb_over_bg_thresh() call outside lock section
Date: Fri, 21 Apr 2023 17:40:16 +0000

Patch series "cgroup: eliminate atomic rstat flushing", v5.

A previous patch series [1] changed most atomic rstat flushing contexts to
become non-atomic.  This was done to avoid an expensive operation that
scales with # cgroups and # cpus to happen with irqs disabled and
scheduling not permitted.  There were two remaining atomic flushing
contexts after that series.  This series tries to eliminate them as well,
eliminating atomic rstat flushing completely.

The two remaining atomic flushing contexts are:
(a) wb_over_bg_thresh()->mem_cgroup_wb_stats()
(b) mem_cgroup_threshold()->mem_cgroup_usage()

For (a), flushing needs to be atomic as wb_writeback() calls
wb_over_bg_thresh() with a spinlock held.  However, it seems like the call
to wb_over_bg_thresh() doesn't need to be protected by that spinlock, so
this series proposes a refactoring that moves the call outside the lock
criticial section and makes the stats flushing in mem_cgroup_wb_stats()
non-atomic.

For (b), flushing needs to be atomic as mem_cgroup_threshold() is called
with irqs disabled.  We only flush the stats when calculating the root
usage, as it is approximated as the sum of some memcg stats (file, anon,
and optionally swap) instead of the conventional page counter.  This
series proposes changing this calculation to use the global stats instead,
eliminating the need for a memcg stat flush.

After these 2 contexts are eliminated, we no longer need
mem_cgroup_flush_stats_atomic() or cgroup_rstat_flush_atomic().  We can
remove them and simplify the code.

[1] https://lore.kernel.org/linux-mm/20230330191801.1967435-1-yosryahmed@google.com/


This patch (of 5):

wb_over_bg_thresh() calls mem_cgroup_wb_stats() which invokes an rstat
flush, which can be expensive on large systems. Currently,
wb_writeback() calls wb_over_bg_thresh() within a lock section, so we
have to do the rstat flush atomically. On systems with a lot of
cpus and/or cgroups, this can cause us to disable irqs for a long time,
potentially causing problems.

Move the call to wb_over_bg_thresh() outside the lock section in
preparation to make the rstat flush in mem_cgroup_wb_stats() non-atomic.
The list_empty(&wb->work_list) check should be okay outside the lock
section of wb->list_lock as it is protected by a separate lock
(wb->work_lock), and wb_over_bg_thresh() doesn't seem like it is
modifying any of wb->b_* lists the wb->list_lock is protecting.
Also, the loop seems to be already releasing and reacquring the
lock, so this refactoring looks safe.

Link: https://lkml.kernel.org/r/20230421174020.2994750-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20230421174020.2994750-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/fs-writeback.c~writeback-move-wb_over_bg_thresh-call-outside-lock-section
+++ a/fs/fs-writeback.c
@@ -2024,7 +2024,6 @@ static long wb_writeback(struct bdi_writ
 	struct blk_plug plug;
 
 	blk_start_plug(&plug);
-	spin_lock(&wb->list_lock);
 	for (;;) {
 		/*
 		 * Stop writeback when nr_pages has been consumed
@@ -2049,6 +2048,9 @@ static long wb_writeback(struct bdi_writ
 		if (work->for_background && !wb_over_bg_thresh(wb))
 			break;
 
+
+		spin_lock(&wb->list_lock);
+
 		/*
 		 * Kupdate and background works are special and we want to
 		 * include all inodes that need writing. Livelock avoidance is
@@ -2078,13 +2080,19 @@ static long wb_writeback(struct bdi_writ
 		 * mean the overall work is done. So we keep looping as long
 		 * as made some progress on cleaning pages or inodes.
 		 */
-		if (progress)
+		if (progress) {
+			spin_unlock(&wb->list_lock);
 			continue;
+		}
+
 		/*
 		 * No more inodes for IO, bail
 		 */
-		if (list_empty(&wb->b_more_io))
+		if (list_empty(&wb->b_more_io)) {
+			spin_unlock(&wb->list_lock);
 			break;
+		}
+
 		/*
 		 * Nothing written. Wait for some inode to
 		 * become available for writeback. Otherwise
@@ -2096,9 +2104,7 @@ static long wb_writeback(struct bdi_writ
 		spin_unlock(&wb->list_lock);
 		/* This function drops i_lock... */
 		inode_sleep_on_writeback(inode);
-		spin_lock(&wb->list_lock);
 	}
-	spin_unlock(&wb->list_lock);
 	blk_finish_plug(&plug);
 
 	return nr_pages - work->nr_pages;
_

Patches currently in -mm which might be from yosryahmed@google.com are

memcg-use-seq_buf_do_printk-with-mem_cgroup_print_oom_meminfo.patch
memcg-dump-memorystat-during-cgroup-oom-for-v1.patch
writeback-move-wb_over_bg_thresh-call-outside-lock-section.patch
memcg-flush-stats-non-atomically-in-mem_cgroup_wb_stats.patch
memcg-calculate-root-usage-from-global-state.patch
memcg-remove-mem_cgroup_flush_stats_atomic.patch
cgroup-remove-cgroup_rstat_flush_atomic.patch

