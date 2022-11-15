Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2293C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiKOWdo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238541AbiKOWdC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:33:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C393135C
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D6ED61A91
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927F7C433D6;
        Tue, 15 Nov 2022 22:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551557;
        bh=8rj2TvtvqrnRdeBXf/gTmmBkBmFmeM0pdnpfqxGHdDs=;
        h=Date:To:From:Subject:From;
        b=IZoey4ZoKyOYSwU09Fz0fzggd+riUaFIvg3obn30tNfKK8EyBvbLddzE0mr0BtmYl
         s60Gvre+blvWDURB0ukEzO/1ED4wz8/61iCie9SyquUZypzhbdqjbW7sOOWN4ZBRAI
         n0WP/60arBr6keE3TWyrxU4VtXtYyNnz908NggEM=
Date:   Tue, 15 Nov 2022 14:32:37 -0800
To:     mm-commits@vger.kernel.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] sched-fair-use-try_cmpxchg-in-task_numa_work.patch removed from -mm tree
Message-Id: <20221115223237.927F7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sched/fair: use try_cmpxchg in task_numa_work
has been removed from the -mm tree.  Its filename was
     sched-fair-use-try_cmpxchg-in-task_numa_work.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: sched/fair: use try_cmpxchg in task_numa_work
Date: Mon, 22 Aug 2022 19:39:56 +0200

Use try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
task_numa_work.  x86 CMPXCHG instruction returns success in ZF flag, so
this change saves a compare after cmpxchg (and related move instruction in
front of cmpxchg).

No functional change intended.

Link: https://lkml.kernel.org/r/20220822173956.82525-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/fair.c~sched-fair-use-try_cmpxchg-in-task_numa_work
+++ a/kernel/sched/fair.c
@@ -2964,7 +2964,7 @@ static void task_numa_work(struct callba
 	}
 
 	next_scan = now + msecs_to_jiffies(p->numa_scan_period);
-	if (cmpxchg(&mm->numa_next_scan, migrate, next_scan) != migrate)
+	if (!try_cmpxchg(&mm->numa_next_scan, &migrate, next_scan))
 		return;
 
 	/*
_

Patches currently in -mm which might be from ubizjak@gmail.com are


