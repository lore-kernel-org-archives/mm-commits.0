Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE95C27C7A
	for <mm-commits@archiver.kernel.org>; Wed, 16 Aug 2023 22:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347031AbjHPWuw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Aug 2023 18:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347040AbjHPWun (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Aug 2023 18:50:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5730FD
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 15:50:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43E316124A
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 22:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99262C433C8;
        Wed, 16 Aug 2023 22:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692226241;
        bh=23H92tGqZXbc2mHjn6j5iDtn+DyJe8USaTAxL2HBw6s=;
        h=Date:To:From:Subject:From;
        b=PVgL61Xi1jEmWbohGSfM7sPCbEpRh/3OVl9mPfm0YsSdXJ7IBEAlhBPfCFyHf/nm8
         L1CN6A7oKtkf9tdVLdldGkgXKgXufRfrjc+B1rHleJphYzQp02fsLheA3kcquyg8cI
         mxEVwC4DN90DeBvFhUcT3QY5vLhL/MqaQqxRDFg0=
Date:   Wed, 16 Aug 2023 15:50:41 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, shakeelb@google.com, mhocko@suse.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-oom-terminate-the-oom_evaluate_task-loop-early.patch removed from -mm tree
Message-Id: <20230816225041.99262C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: oom: terminate the oom_evaluate_task() loop early
has been removed from the -mm tree.  Its filename was
     mm-oom-terminate-the-oom_evaluate_task-loop-early.patch

This patch was dropped because it was nacked

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
mm-secretmem-use-a-folio-in-secretmem_fault.patch

