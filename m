Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE51BEB64DD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 19:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjHNTao (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 15:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjHNTaR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 15:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35999C
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 12:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A9A96594F
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 19:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E2EC433C7;
        Mon, 14 Aug 2023 19:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692041415;
        bh=91Fx8N9COsiNWChNEKO3HgQ488qp6PuHAvBVlugwcqA=;
        h=Date:To:From:Subject:From;
        b=SpAOdmg8Y5MYS8lt+ug5TkXfJame3UFs4sDyD7F+3IKvBIwUDb+lfQLNJ8hJu3rPf
         ZStfJ/mf7Mo1OeAuTaSvENHDubz9wXWb+4h+3XkqaECX9GdOPl1kRy6wCx4cCBipix
         zNJBbD03q0NYPAtcrIp8GgkzG+oeFMK2rgQ6QsyU=
Date:   Mon, 14 Aug 2023 12:30:14 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, shakeelb@google.com, mhocko@suse.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom-terminate-the-oom_evaluate_task-loop-early.patch added to mm-unstable branch
Message-Id: <20230814193015.93E2EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: oom: terminate the oom_evaluate_task() loop early
has been added to the -mm mm-unstable branch.  Its filename is
     mm-oom-terminate-the-oom_evaluate_task-loop-early.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom-terminate-the-oom_evaluate_task-loop-early.patch

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
Subject: mm: oom: terminate the oom_evaluate_task() loop early
Date: Mon, 14 Aug 2023 14:34:28 +0800

If task is allocating a lot of memory and has been marked to be killed
first, then it gets the highest score (LONG_MAX).  Therefore, there is no
need to continue to calculate the points of other tasks.  Just terminate
the oom_evaluate_task() loop early, when the task with the highest score
is found.  By doing this, we can get some performance gains in
select_bad_process().

To implement it, the return value of oom_evaluate_task() is modified. 
When the task with the highest score is found (points == LONG_MAX),
oom_evaluate_task() will return 1 and the loop will terminate early.

Link: https://lkml.kernel.org/r/20230814063428.4111206-3-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/oom_kill.c~mm-oom-terminate-the-oom_evaluate_task-loop-early
+++ a/mm/oom_kill.c
@@ -346,6 +346,8 @@ static int oom_evaluate_task(struct task
 	get_task_struct(task);
 	oc->chosen = task;
 	oc->chosen_points = points;
+	if (points == LONG_MAX)
+		return 1;
 next:
 	return 0;
 abort:
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

