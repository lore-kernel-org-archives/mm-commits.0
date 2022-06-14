Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C676C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jun 2022 17:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbiFNRdD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Jun 2022 13:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiFNRdC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2022 13:33:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3ED11C10F
        for <mm-commits@vger.kernel.org>; Tue, 14 Jun 2022 10:33:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67834B81A3F
        for <mm-commits@vger.kernel.org>; Tue, 14 Jun 2022 17:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC02C3411C;
        Tue, 14 Jun 2022 17:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655227979;
        bh=lqC9fBQT6R/+0jIiWDai8mfFmlKmj4KZd8+daRHrC64=;
        h=Date:To:From:Subject:From;
        b=YTomk+MVrNqKTS51g2GsNZn8q1lzJICT1ZMmQM+fDKpTCAnY5xrPHNPGQdu6CJ2w6
         mzKiJ2Q1j4nVKXY9NKny3eGwrrAKeAO/JrEz0tRWU591ZOMqlimt5HSoDV1QQRnh7P
         icaRWUm2Lxwday9hom80eT6ok0BuFQp5m2Ni/2e8=
Date:   Tue, 14 Jun 2022 10:32:58 -0700
To:     mm-commits@vger.kernel.org, rientjes@google.com, mhocko@kernel.org,
        zackary.liu.pro@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-oom_kill-break-evaluation-when-a-task-has-been-selected.patch removed from -mm tree
Message-Id: <20220614173259.0BC02C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/oom_kill: break evaluation when a task has been selected
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-break-evaluation-when-a-task-has-been-selected.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Zhaoyu Liu <zackary.liu.pro@gmail.com>
Subject: mm/oom_kill: break evaluation when a task has been selected
Date: Sat, 14 May 2022 15:52:28 +0800

oom points no longer need to be calculated if a task is oom_task_origin(),
so return 1 to stop the oom_evaluate_task().

The victim was marked in the last oom, and now it has entered the oom
again, which means that the system still has no deprecated memory
available.  In order to ensure that the system can return to normal as
soon as possible, killing the original task immediately should be a
good choice, and the role of this patch is to end oom_evaluate_task and
return true as soon as the original task is found.  Maybe this patch is
not the optimal solution, it has a trade-off.

Link: https://lkml.kernel.org/r/20220514075223.GA11384@pc
Signed-off-by: Zhaoyu Liu <zackary.liu.pro@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-break-evaluation-when-a-task-has-been-selected
+++ a/mm/oom_kill.c
@@ -308,7 +308,7 @@ static enum oom_constraint constrained_a
 static int oom_evaluate_task(struct task_struct *task, void *arg)
 {
 	struct oom_control *oc = arg;
-	long points;
+	long points = 0;
 
 	if (oom_unkillable_task(task))
 		goto next;
@@ -349,7 +349,7 @@ select:
 	oc->chosen = task;
 	oc->chosen_points = points;
 next:
-	return 0;
+	return points == LONG_MAX;
 abort:
 	if (oc->chosen)
 		put_task_struct(oc->chosen);
_

Patches currently in -mm which might be from zackary.liu.pro@gmail.com are


