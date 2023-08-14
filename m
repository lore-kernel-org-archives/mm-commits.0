Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1249EC41513
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 19:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbjHNTao (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 15:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjHNTaP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 15:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB029C
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 12:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AF666594F
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 19:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E98C433C8;
        Mon, 14 Aug 2023 19:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692041413;
        bh=ogKVgiXnpX4mBkYsw7OiiP7LaAECir5VDoSV1VzOuQw=;
        h=Date:To:From:Subject:From;
        b=BFwTSbBwuUQfszHTgr3fmB7uOUnIItu4BDmlSUhQaOdjw3VgV1GRNZ4EJ0n4lehMz
         Q6J4/VP9Xp7ywDzcI0ZA5zb4dQeZvvVfqVTpds1PF7yDmHzFLccNtcpRf6QKS3Xe0c
         tj0RGQzQORL0yn6OC5HVai5mB/kOXhRew9B7vn+E=
Date:   Mon, 14 Aug 2023 12:30:13 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, shakeelb@google.com, mhocko@suse.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom-remove-unnecessary-goto-in-oom_evaluate_task.patch added to mm-unstable branch
Message-Id: <20230814193013.C8E98C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: oom: remove unnecessary goto in oom_evaluate_task()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-oom-remove-unnecessary-goto-in-oom_evaluate_task.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom-remove-unnecessary-goto-in-oom_evaluate_task.patch

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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm: oom: remove unnecessary goto in oom_evaluate_task()
Date: Mon, 14 Aug 2023 14:34:27 +0800

Patch series "mm: oom: terminate the oom_evaluate_task() loop early".

This patch series improves the performance of select_bad_process() by
terminating the oom_evaluate_task() loop early (if points == LONG_MAX).


This patch (of 2):

Remove redundant goto statement in oom_evaluate_task() to simplify the
code a bit. No functional modification involved.

Link: https://lkml.kernel.org/r/20230814063428.4111206-2-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/oom_kill.c~mm-oom-remove-unnecessary-goto-in-oom_evaluate_task
+++ a/mm/oom_kill.c
@@ -335,14 +335,12 @@ static int oom_evaluate_task(struct task
 	 */
 	if (oom_task_origin(task)) {
 		points = LONG_MAX;
-		goto select;
+	} else {
+		points = oom_badness(task, oc->totalpages);
+		if (points == LONG_MIN || points < oc->chosen_points)
+			goto next;
 	}
 
-	points = oom_badness(task, oc->totalpages);
-	if (points == LONG_MIN || points < oc->chosen_points)
-		goto next;
-
-select:
 	if (oc->chosen)
 		put_task_struct(oc->chosen);
 	get_task_struct(task);
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-kmsan-use-helper-function-page_size.patch
mm-kmsan-use-helper-macro-offset_in_page.patch
mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch
mm-remove-redundant-k-macro-definition.patch
mm-swapfilec-use-helper-macro-k.patch
mm-swap_statec-use-helper-macro-k.patch
mm-shmemc-use-helper-macro-k.patch
mm-nommuc-use-helper-macro-k.patch
mm-mmapc-use-helper-macro-k.patch
mm-hugetlbc-use-helper-macro-k.patch
mm-page_alloc-remove-unused-parameter-from-reserve_highatomic_pageblock.patch
mm-oom-remove-unnecessary-goto-in-oom_evaluate_task.patch
mm-oom-terminate-the-oom_evaluate_task-loop-early.patch

