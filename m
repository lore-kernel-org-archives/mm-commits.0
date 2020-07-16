Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3C5C433E1
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A1C820870
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594942082;
	bh=V8Ciaua4djghO6IyEj/rfPCZ1IB+C7Zw1XpJ0pMKSkw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=nwZn20DBcGE7LaDiKqGtCRUWTF77PsU3HG4Tu+HWCdpudE2pGAzEq5sPsbTXdFKgk
	 PAHQV6gE/UWwiwf+rTsNU9GqyC889PMIdwzV7LA7hnsJHBF0J5JlzpNuzQ9DTC666P
	 DbryI794ZlJCsHhiiNEoGVAwLejx+wqj4npRskHY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgGPX2C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 19:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726113AbgGPX2B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 19:28:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A692C20760;
        Thu, 16 Jul 2020 23:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594942081;
        bh=V8Ciaua4djghO6IyEj/rfPCZ1IB+C7Zw1XpJ0pMKSkw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HwWy8j0gOh4BsUMV519Q/OtypA1Mci1dkZduCAZCKtRzmqK0SyjT1bm8UorEeHvmv
         0mRKeOLLcTX6LEylIil8tVU5N23k6jVv4xsa3QviRRFGFS9l0pj4INhMdhCcimQ91s
         Y5vgWy2YCEHEzpsswuVBFzPxZak18q2SvYhWaPDE=
Date:   Thu, 16 Jul 2020 16:28:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     chris@chrisdown.name, hannes@cmpxchg.org, laoar.shao@gmail.com,
        mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com
Subject:  + memcg-oom-check-memcg-margin-for-parallel-oom.patch
 added to -mm tree
Message-ID: <20200716232800.VpamkVDvF%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, oom: check memcg margin for parallel oom
has been added to the -mm tree.  Its filename is
     memcg-oom-check-memcg-margin-for-parallel-oom.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-oom-check-memcg-margin-for-parallel-oom.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-oom-check-memcg-margin-for-parallel-oom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: memcg, oom: check memcg margin for parallel oom

Memcg oom killer invocation is synchronized by the global oom_lock and
tasks are sleeping on the lock while somebody is selecting the victim or
potentially race with the oom_reaper is releasing the victim's memory. 
This can result in a pointless oom killer invocation because a waiter
might be racing with the oom_reaper

        P1              oom_reaper              P2
                        oom_reap_task           mutex_lock(oom_lock)
                                                out_of_memory # no victim because we have one already
                        __oom_reap_task_mm      mute_unlock(oom_lock)
 mutex_lock(oom_lock)
                        set MMF_OOM_SKIP
 select_bad_process
 # finds a new victim

The page allocator prevents from this race by trying to allocate after the
lock can be acquired (in __alloc_pages_may_oom) which acts as a last
minute check.  Moreover page allocator simply doesn't block on the
oom_lock and simply retries the whole reclaim process.

Memcg oom killer should do the last minute check as well.  Call
mem_cgroup_margin to do that.  Trylock on the oom_lock could be done as
well but this doesn't seem to be necessary at this stage.

[mhocko@kernel.org: commit log]
Link: http://lkml.kernel.org/r/1594735034-19190-1-git-send-email-laoar.shao@gmail.com
Suggested-by: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-oom-check-memcg-margin-for-parallel-oom
+++ a/mm/memcontrol.c
@@ -1665,15 +1665,21 @@ static bool mem_cgroup_out_of_memory(str
 		.gfp_mask = gfp_mask,
 		.order = order,
 	};
-	bool ret;
+	bool ret = true;
 
 	if (mutex_lock_killable(&oom_lock))
 		return true;
+
+	if (mem_cgroup_margin(memcg) >= (1 << order))
+		goto unlock;
+
 	/*
 	 * A few threads which were not waiting at mutex_lock_killable() can
 	 * fail to bail out. Therefore, check again after holding oom_lock.
 	 */
 	ret = should_force_charge() || out_of_memory(&oc);
+
+unlock:
 	mutex_unlock(&oom_lock);
 	return ret;
 }
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-memcg-avoid-stale-protection-values-when-cgroup-is-above-protection.patch
memcg-oom-check-memcg-margin-for-parallel-oom.patch
mm-oom-make-the-calculation-of-oom-badness-more-accurate.patch
mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3.patch

