Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBC5C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  7 Nov 2022 22:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiKGWH6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Nov 2022 17:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiKGWH5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2022 17:07:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4956D558C
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 14:07:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8426EB810B3
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 22:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28ED9C433D7;
        Mon,  7 Nov 2022 22:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667858874;
        bh=7LqohY2Zjt5ADDnDi0V8dwkIZnVihOg1oRg/FmtrYQE=;
        h=Date:To:From:Subject:From;
        b=k+Hqmm4Prho/+QsuxtNTTJuWEPi6xgd92d7rScTXn27wrFrCOLOxj6B8L+YYlH+q/
         Ur9bQ7Z1zUpzRnnQK2nDjKZIzJEYnp2AILL97MHIvUuWDOfwAkAZO26zZdVDla1ocB
         DgsBL9jZ3ZzglfzjV9e61Qb1ET72KoMIIG4NhkOA=
Date:   Mon, 07 Nov 2022 14:07:53 -0800
To:     mm-commits@vger.kernel.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-fair-use-try_cmpxchg-in-task_numa_work.patch added to mm-nonmm-unstable branch
Message-Id: <20221107220754.28ED9C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sched/fair: use try_cmpxchg in task_numa_work
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     sched-fair-use-try_cmpxchg-in-task_numa_work.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-fair-use-try_cmpxchg-in-task_numa_work.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

zram-use-try_cmpxchg-in-update_used_max.patch
llist-avoid-extra-memory-read-in-llist_add_batch.patch
sched-fair-use-try_cmpxchg-in-task_numa_work.patch

