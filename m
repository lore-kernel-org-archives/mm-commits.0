Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6EADC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CEA222CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781330;
	bh=8buI4U/A+YZMwTmUmzwOuFWCSMd7tVNO5fQy6sTm0yU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ZGmpvdRuqUxHPzBZQTUnN9jGr1H3rVqh3lPunYKdRe8ECOALOPDfFTDw/nRJhRCzq
	 08dCpBsFRA82wAgYai2unqEMNcEN3onsfE3I340P85cOfsNeQfQhQg/oYNKh3DwcFc
	 0Cbm4Gct/3lwAQ2NluOkAB8cYvuSqElle6bpm32c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgHGGWK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgHGGWK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:22:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5039F221E5;
        Fri,  7 Aug 2020 06:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781329;
        bh=8buI4U/A+YZMwTmUmzwOuFWCSMd7tVNO5fQy6sTm0yU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OD9SJB/p0NMRrUKp1k4SI+XY+ZSKnBu7FeMQfntAefLDV6E257gXhwXxcIMDBVfWI
         dpV1ALFh0J/1hSIw6k1yixYMyI0rb5j3EJ1I4EFwJgNQZ3YcBoffsIETg88i4l1UtV
         Ei/hoGbNuFh0u+z2Hb6WQqA670Fn6RVz1glNHhg8=
Date:   Thu, 06 Aug 2020 23:22:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name,
        hannes@cmpxchg.org, laoar.shao@gmail.com, linux-mm@kvack.org,
        mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 090/163] memcg, oom: check memcg margin for
 parallel oom
Message-ID: <20200807062208.OPynQN011%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1663,15 +1663,21 @@ static bool mem_cgroup_out_of_memory(str
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
