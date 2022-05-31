Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92232C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 21:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243351AbiEaVGo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 17:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbiEaVGn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 17:06:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4C3D51
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 14:06:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24108B816BC
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 21:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7C7C3411C;
        Tue, 31 May 2022 21:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654031199;
        bh=t4g4Q7XBlbnJ23Zh7y2+/cuYCg9r9aEQ0XWIGI5i+r0=;
        h=Date:To:From:Subject:From;
        b=pU5UnmuOsmPeaOZHa0gzwQupxkohoKAXGxL1r7UH4KR707Mh718YFsE0P5gSeZzGJ
         TWUc1y0/ZIokzZBBTLJvgvr0OLZqjlTiBpXh8Ji+lZn8rqq5IdffKN0rp1Qc25L0OM
         i8bSFIWgggU/J2TeRDQZoNJeHIRJKSM0IeWuZ2JM=
Date:   Tue, 31 May 2022 14:06:38 -0700
To:     mm-commits@vger.kernel.org, rientjes@google.com, mhocko@kernel.org,
        zackary.liu.pro@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_kill-break-evaluation-when-a-task-has-been-selected.patch added to mm-unstable branch
Message-Id: <20220531210639.9B7C7C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: break evaluation when a task has been selected
has been added to the -mm mm-unstable branch.  Its filename is
     mm-oom_kill-break-evaluation-when-a-task-has-been-selected.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom_kill-break-evaluation-when-a-task-has-been-selected.patch

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
From: Zhaoyu Liu <zackary.liu.pro@gmail.com>
Subject: mm/oom_kill: break evaluation when a task has been selected
Date: Sat, 14 May 2022 15:52:28 +0800

oom points no longer need to be calculated if a task is oom_task_origin(),
so return 1 to stop the oom_evaluate_task().

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
@@ -337,7 +337,7 @@ static enum oom_constraint constrained_a
 static int oom_evaluate_task(struct task_struct *task, void *arg)
 {
 	struct oom_control *oc = arg;
-	long points;
+	long points = 0;
 
 	if (oom_unkillable_task(task))
 		goto next;
@@ -378,7 +378,7 @@ select:
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

mm-oom_kill-break-evaluation-when-a-task-has-been-selected.patch

