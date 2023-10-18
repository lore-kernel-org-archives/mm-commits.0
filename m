Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD18CDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 16:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjJRQG1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 12:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbjJRQGZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 12:06:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CB8125
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 09:06:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C32C433C7;
        Wed, 18 Oct 2023 16:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697645183;
        bh=7DWg2H7tcl0O1Q0F+LguGaTM/wx9eX9M9I9DlCpdXgY=;
        h=Date:To:From:Subject:From;
        b=rRxGlAiIPg48Gw8yT5WLfDcLd9PqX5jPrVr0VNcIci2VbugV7W4mVhYib2aiQagLN
         tP5kqDchziXG6vDzpKJO6DOkcBFHMi9B4u2juoGXjow5O1SzJDBJXi1+uDnoMtkcFU
         TewbYMoKwt6any+zLL1FrFcBGghPsiNVxTsLCXwc=
Date:   Wed, 18 Oct 2023 09:06:22 -0700
To:     mm-commits@vger.kernel.org, weixugc@google.com, tj@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        longman@redhat.com, ivan@cloudflare.com, hannes@cmpxchg.org,
        gthelen@google.com, cerasuolodomenico@gmail.com,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-make-stats-flushing-threshold-per-memcg-fix.patch added to mm-unstable branch
Message-Id: <20231018160623.26C32C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: clear percpu stats_pending during stats flush
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-make-stats-flushing-threshold-per-memcg-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-make-stats-flushing-threshold-per-memcg-fix.patch

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
Subject: mm: memcg: clear percpu stats_pending during stats flush
Date: Tue, 17 Oct 2023 23:07:59 +0000

When flushing memcg stats, we clear the per-memcg count of pending stat
updates, as they are captured by the flush. Also clear the percpu count
for the cpu being flushed.

Link: https://lkml.kernel.org/r/CAJD7tkZDarDn_38ntFg5bK2fAmFdSe+Rt6DKOZA7Sgs_kERoVA@mail.gmail.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Wei Xu <weixugc@google.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c~mm-memcg-make-stats-flushing-threshold-per-memcg-fix
+++ a/mm/memcontrol.c
@@ -5728,6 +5728,7 @@ static void mem_cgroup_css_rstat_flush(s
 			}
 		}
 	}
+	statc->stats_updates = 0;
 	/* We are in a per-cpu loop here, only do the atomic write once */
 	if (atomic64_read(&memcg->vmstats->stats_updates))
 		atomic64_set(&memcg->vmstats->stats_updates, 0);
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-refactor-page-state-unit-helpers.patch
mm-memcg-normalize-the-value-passed-into-memcg_rstat_updated.patch
mm-memcg-change-flush_next_time-to-flush_last_time.patch
mm-memcg-move-vmstats-structs-definition-above-flushing-code.patch
mm-memcg-make-stats-flushing-threshold-per-memcg.patch
mm-memcg-make-stats-flushing-threshold-per-memcg-fix.patch
mm-workingset-move-the-stats-flush-into-workingset_test_recent.patch
mm-memcg-restore-subtree-stats-flushing.patch

