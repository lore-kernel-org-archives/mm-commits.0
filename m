Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC61C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357342AbiCYBcE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357352AbiCYBbu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24380387A5
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B53ED61929
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6AAC340EC;
        Fri, 25 Mar 2022 01:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171811;
        bh=Mxh4viB7Jq9pjBVWePLyVWvXy6QkML7RA02Qz9uIzOY=;
        h=Date:To:From:Subject:From;
        b=DJcBfGctNSdlyOKdkkcs139v9NSoGSHxuianzT1z6K2zfkRLi29PJCe8UgwgJOsLh
         qnY/WTzO5uQi6go4x+N8lQ2Liis8QEE7bvRn/hSSqiLaAWtnN9ghdfe4aL+0aE6v8l
         O7bUMYqedZta+3IDIPg+uCOT6swia2FJ5wnt8HNc=
Date:   Thu, 24 Mar 2022 18:30:10 -0700
To:     mm-commits@vger.kernel.org, vvs@virtuozzo.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        shakeelb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] memcg-replace-in_interrupt-with-in_task.patch removed from -mm tree
Message-Id: <20220325013011.1C6AAC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: replace in_interrupt() with !in_task()
has been removed from the -mm tree.  Its filename was
     memcg-replace-in_interrupt-with-in_task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: replace in_interrupt() with !in_task()

Replace the deprecated in_interrupt() with !in_task() because
in_interrupt() returns true for BH disabled even if the call happens in
the task context.  in_task() is the right interface to differentiate task
context from NMI, hard IRQ and softirq contexts.

Link: https://lkml.kernel.org/r/20220127162636.3461256-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-replace-in_interrupt-with-in_task
+++ a/mm/memcontrol.c
@@ -2688,7 +2688,7 @@ done_restock:
 			READ_ONCE(memcg->swap.high);
 
 		/* Don't bother a random interrupted task */
-		if (in_interrupt()) {
+		if (!in_task()) {
 			if (mem_high) {
 				schedule_work(&memcg->high_work);
 				break;
@@ -6968,7 +6968,7 @@ void mem_cgroup_sk_alloc(struct sock *sk
 		return;
 
 	/* Do not associate the sock with unrelated interrupted task's memcg. */
-	if (in_interrupt())
+	if (!in_task())
 		return;
 
 	rcu_read_lock();
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-sync-flush-only-if-periodic-flush-is-delayed.patch

