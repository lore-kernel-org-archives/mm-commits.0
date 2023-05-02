Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752B7C77B78
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 21:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjEBV4W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 17:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjEBV4W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 17:56:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01E519BB
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 14:56:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E1BE621B6
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 21:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9954FC433D2;
        Tue,  2 May 2023 21:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683064579;
        bh=3oezjg4rsQs5huONMCAmhXHgeeOpmm3JvBrDk3K1nb4=;
        h=Date:To:From:Subject:From;
        b=zY6tp2/dLjEGkFUmeYKDBVewg8cuCnBJONnbhTQ2Q6Z2CUErUNB7merzVx2v6O0RL
         fpqrsk/cm9lBbwvLaptBFsz6fKM7Y2sK6w7rcYewZ+9YrYSO3QnYWeqUzxpNvm/q2D
         ahLxTy+4uSn854+looF9sllSl36Gn9eGIocdshg0=
Date:   Tue, 02 May 2023 14:56:18 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize.patch added to mm-unstable branch
Message-Id: <20230502215619.9954FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, oom: remove unnecessary check in mem_cgroup_oom_synchronize()
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize.patch

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
Subject: memcg, oom: remove unnecessary check in mem_cgroup_oom_synchronize()
Date: Wed, 19 Apr 2023 03:07:38 +0000

mem_cgroup_oom_synchronize() is only used when the memcg oom handling is
handed over to the edge of the #PF path.  Since commit 29ef680ae7c2
("memcg, oom: move out_of_memory back to the charge path") this is the
case only when the kernel memcg oom killer is disabled
(current->memcg_in_oom is only set if memcg->oom_kill_disable).  Therefore
a check for oom_kill_disable in mem_cgroup_oom_synchronize() is not
required.

Link: https://lkml.kernel.org/r/20230419030739.115845-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize
+++ a/mm/memcontrol.c
@@ -2024,16 +2024,9 @@ bool mem_cgroup_oom_synchronize(bool han
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
 
 	if (locked) {
 		mem_cgroup_oom_unlock(memcg);
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

cpuset-clean-up-cpuset_node_allowed.patch
memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize.patch
memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize.patch

