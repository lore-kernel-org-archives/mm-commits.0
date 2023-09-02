Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4479BC001DB
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 23:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbjIBX25 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 19:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjIBX25 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 19:28:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A984E11A
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 16:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D628DB80906
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 23:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C80C433C9;
        Sat,  2 Sep 2023 23:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693697330;
        bh=DXpVt8Z4HMJUXXYYfrm/iO1fT9erJftAlohFAM5pr80=;
        h=Date:To:From:Subject:From;
        b=Con8l0I+zu8wG/xHdQbfozTfCcQxLow1UfIJui+NRsL0oyWU+H6Nn+Vizho7F/0r8
         OCHLiQRw1VuOzWzX1cne8lURykwAQLYMg9nvR2k45vPvSQAYin1fyc+n1CcxHKHrEg
         Yh1eNdTOKoS5zPoFdh26A3FNiJsntHZAAJCMoyuo=
Date:   Sat, 02 Sep 2023 16:28:49 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
        mhocko@kernel.org, longman@redhat.com, ivan@cloudflare.com,
        hannes@cmpxchg.org, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-let-non-unified-root-stats-flushes-help-unified-flushes.patch added to mm-unstable branch
Message-Id: <20230902232850.62C80C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: let non-unified root stats flushes help unified flushes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-let-non-unified-root-stats-flushes-help-unified-flushes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-let-non-unified-root-stats-flushes-help-unified-flushes.patch

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
Subject: mm: memcg: let non-unified root stats flushes help unified flushes
Date: Thu, 31 Aug 2023 16:56:10 +0000

Unified flushing of memcg stats keeps track of the magnitude of pending
updates, and only allows a flush if that magnitude exceeds a threshold. 
It also keeps track of the time at which ratelimited flushing should be
allowed as flush_next_time.

A non-unified flush on the root memcg has the same effect as a unified
flush, so let it help unified flushing by resetting pending updates and
kicking flush_next_time forward.  Move the logic into the common
do_stats_flush() helper, and do it for all root flushes, unified or not.

There is a subtle change here, we reset stats_flush_threshold before a
flush rather than after a flush.  This probably okay because:

(a) For flushers: only unified flushers check stats_flush_threshold,
    and those flushers skip anyway if there is another unified flush
    ongoing.  Having them also skip if there is an ongoing non-unified
    root flush is actually more consistent.

(b) For updaters: Resetting stats_flush_threshold early may lead to
    more atomic updates of stats_flush_threshold, as we start updating it
    earlier.  This should not be significant in practice because we stop
    updating stats_flush_threshold when it reaches the threshold anyway. 
    If we start early and stop early, the number of atomic updates remain
    the same.  The only difference is the scenario where we reset
    stats_flush_threshold early, start doing atomic updates early, and
    then the periodic flusher kicks in before we reach the threshold.  In
    this case, we will have done more atomic updates.  However, since the
    threshold wasn't reached, then we did not do a lot of updates anyway.

Link: https://lkml.kernel.org/r/20230831165611.2610118-4-yosryahmed@google.com
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-let-non-unified-root-stats-flushes-help-unified-flushes
+++ a/mm/memcontrol.c
@@ -647,6 +647,11 @@ static inline void memcg_rstat_updated(s
  */
 static void do_stats_flush(struct mem_cgroup *memcg)
 {
+	/* for unified flushing, root non-unified flushing can help as well */
+	if (mem_cgroup_is_root(memcg)) {
+		WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
+		atomic_set(&stats_flush_threshold, 0);
+	}
 	cgroup_rstat_flush(memcg->css.cgroup);
 }
 
@@ -665,11 +670,8 @@ static void do_unified_stats_flush(void)
 	    atomic_xchg(&stats_unified_flush_ongoing, 1))
 		return;
 
-	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
-
 	do_stats_flush(root_mem_cgroup);
 
-	atomic_set(&stats_flush_threshold, 0);
 	atomic_set(&stats_unified_flush_ongoing, 0);
 }
 
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-properly-name-and-document-unified-stats-flushing.patch
mm-memcg-add-a-helper-for-non-unified-stats-flushing.patch
mm-memcg-let-non-unified-root-stats-flushes-help-unified-flushes.patch
mm-memcg-use-non-unified-stats-flushing-for-userspace-reads.patch

