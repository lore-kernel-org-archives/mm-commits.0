Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFF3C19F20
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 21:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjEBV40 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 17:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjEBV4X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 17:56:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB2B1704
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 14:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A02761E7D
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 21:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B5AC433D2;
        Tue,  2 May 2023 21:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683064581;
        bh=EfFmWR0aF+ebRVwzivj0NT1KtblR0UT1BbGrQlQu9+U=;
        h=Date:To:From:Subject:From;
        b=RKt0nNbuacO6SethvthfmUdZPTQ2ZKOTCxBDuL7BLkg5G1/znYXLthOoef54sikif
         gPuQ2ZAItxYPRNDAq1gU4nw/X7A5GizMXBGhLsqYQZqQtV/urwoy6pXr0LunhlmL/b
         4rWnarwhd/E3H3V3R2+v9Kklr0sSPRx+MvhQXQSU=
Date:   Tue, 02 May 2023 14:56:20 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize.patch added to mm-unstable branch
Message-Id: <20230502215621.84B5AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, oom: remove explicit wakeup in mem_cgroup_oom_synchronize()
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize.patch

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
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: memcg, oom: remove explicit wakeup in mem_cgroup_oom_synchronize()
Date: Wed, 19 Apr 2023 03:07:39 +0000

Before commit 29ef680ae7c2 ("memcg, oom: move out_of_memory back to the
charge path"), all memcg oom killers were delayed to page fault path.  And
the explicit wakeup is used in this case:

thread A:
        ...
        if (locked) {           // complete oom-kill, hold the lock
                mem_cgroup_oom_unlock(memcg);
                ...
        }
        ...

thread B:
        ...

        if (locked && !memcg->oom_kill_disable) {
                ...
        } else {
                schedule();     // can't acquire the lock
                ...
        }
        ...

The reason is that thread A kicks off the OOM-killer, which leads to
wakeups from the uncharges of the exiting task.  But thread B is not
guaranteed to see them if it enters the OOM path after the OOM kills but
before thread A releases the lock.

Now only oom_kill_disable case is handled from the #PF path.  In that case
it is userspace to trigger the wake up not the #PF path itself.  All
potential paths to free some charges are responsible to call
memcg_oom_recover() , so the explicit wakeup is not needed in the
mem_cgroup_oom_synchronize() path which doesn't release any memory itself.

Link: https://lkml.kernel.org/r/20230419030739.115845-2-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/memcontrol.c~memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize
+++ a/mm/memcontrol.c
@@ -2028,15 +2028,8 @@ bool mem_cgroup_oom_synchronize(bool han
 	mem_cgroup_unmark_under_oom(memcg);
 	finish_wait(&memcg_oom_waitq, &owait.wait);
 
-	if (locked) {
+	if (locked)
 		mem_cgroup_oom_unlock(memcg);
-		/*
-		 * There is no guarantee that an OOM-lock contender
-		 * sees the wakeups triggered by the OOM kill
-		 * uncharges.  Wake any sleepers explicitly.
-		 */
-		memcg_oom_recover(memcg);
-	}
 cleanup:
 	current->memcg_in_oom = NULL;
 	css_put(&memcg->css);
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

cpuset-clean-up-cpuset_node_allowed.patch
memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize.patch
memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize.patch

