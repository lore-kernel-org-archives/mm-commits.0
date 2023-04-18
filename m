Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B2DC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 22:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbjDRWSK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 18:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjDRWSJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 18:18:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D1E8A58
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 15:18:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8CA660B41
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 22:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D5BC4339B;
        Tue, 18 Apr 2023 22:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681856287;
        bh=C9zZwQrpdIoQn+gAcKSIhcV0rPdX37PistZDUBQcbgs=;
        h=Date:To:From:Subject:From;
        b=muCSpjGopdHLi9nDy43Hz7hx3JfvSR9qvivUlth77vIElUx5BxubvKzYlDw9eqohu
         jMIxnC9QyfTzhZl88sG7SPonsnymmrXjavferg8c+KSXbUg9CPVzRNpkcGxrF5xVos
         fwm79ecwVAABW2WJ4M+s+glQ+nBZRKbsH6Nt7Qf4=
Date:   Tue, 18 Apr 2023 15:18:06 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] memcg-oom-simplify-mem_cgroup_oom_synchronize.patch removed from -mm tree
Message-Id: <20230418221807.46D5BC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg, oom: simplify mem_cgroup_oom_synchronize
has been removed from the -mm tree.  Its filename was
     memcg-oom-simplify-mem_cgroup_oom_synchronize.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: memcg, oom: simplify mem_cgroup_oom_synchronize
Date: Fri, 7 Apr 2023 09:06:44 +0000

Since commit 29ef680ae7c2 ("memcg, oom: move out_of_memory back to the
charge path"), only if oom_kill_disable is set, oom killer will be
delayed to page fault path.  So the oom_kill_disable check is
unnecessary.

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
mm-vmscan-simplify-shrink_node.patch

