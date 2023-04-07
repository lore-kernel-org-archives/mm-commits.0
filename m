Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BAD1C6FD1D
	for <mm-commits@archiver.kernel.org>; Fri,  7 Apr 2023 22:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjDGWQf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Apr 2023 18:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDGWQf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2023 18:16:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0FF93C8
        for <mm-commits@vger.kernel.org>; Fri,  7 Apr 2023 15:16:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC912652A4
        for <mm-commits@vger.kernel.org>; Fri,  7 Apr 2023 22:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2DDC433D2;
        Fri,  7 Apr 2023 22:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680905793;
        bh=CqqA/Q8eDJHOrzbQYxXMc1uH8ZtDf8ODJoVG9gPalBY=;
        h=Date:To:From:Subject:From;
        b=kWPNyUImBQG7SMX3YAqjnMt9boOWoQRBCsZBcjUyq+SSsFtxMIe1nZ4AeenA7kt61
         /XssdtVQKkgErnN83Hm09gbKg3yBlVQ6MQ3gcWCnPKm2X9Vm8X4/okF8u/oEgxt+/V
         2LBN2oggTozu2zH7p8hwop0RVAoODLZ1ygcI2ftw=
Date:   Fri, 07 Apr 2023 15:16:32 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-oom-simplify-mem_cgroup_oom_synchronize.patch added to mm-unstable branch
Message-Id: <20230407221633.1B2DDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, oom: simplify mem_cgroup_oom_synchronize
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-oom-simplify-mem_cgroup_oom_synchronize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-oom-simplify-mem_cgroup_oom_synchronize.patch

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
Subject: memcg, oom: simplify mem_cgroup_oom_synchronize
Date: Fri, 7 Apr 2023 09:06:44 +0000

Since commit 29ef680ae7c2 ("memcg, oom: move out_of_memory back to the
charge path"), only oom_kill_disable is set, oom killer will be delayed to
page fault path.  So the oom_kill_disable check is unnecessary.

In the charge patch, even if the oom_lock in memcg can't be acquired, the
oom handing can also be invoked.  In order to keep the behavior consistent
with it, remove the lock check.

Also the explicit wakeup for the lock holder is unneeded because the lock
contender won't be scheduled out.

Link: https://lkml.kernel.org/r/20230407090644.399108-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

--- a/mm/memcontrol.c~memcg-oom-simplify-mem_cgroup_oom_synchronize
+++ a/mm/memcontrol.c
@@ -2027,26 +2027,12 @@ bool mem_cgroup_oom_synchronize(bool han
 	if (locked)
 		mem_cgroup_oom_notify(memcg);
 
-	if (locked && !READ_ONCE(memcg->oom_kill_disable)) {
-		mem_cgroup_unmark_under_oom(memcg);
-		finish_wait(&memcg_oom_waitq, &owait.wait);
-		mem_cgroup_out_of_memory(memcg, current->memcg_oom_gfp_mask,
-					 current->memcg_oom_order);
-	} else {
-		schedule();
-		mem_cgroup_unmark_under_oom(memcg);
-		finish_wait(&memcg_oom_waitq, &owait.wait);
-	}
+	schedule();
+	mem_cgroup_unmark_under_oom(memcg);
+	finish_wait(&memcg_oom_waitq, &owait.wait);
 
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
memcg-oom-simplify-mem_cgroup_oom_synchronize.patch

