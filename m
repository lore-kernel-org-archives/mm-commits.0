Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 078A3C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7DDF64F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234498AbhBYThD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:37:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234947AbhBYTfO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A259D64FC3;
        Thu, 25 Feb 2021 19:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280739;
        bh=e42+6JLSBEQHOqcCmYwcSrwo+V65dtTHI+zvFVhzOnE=;
        h=Date:From:To:Subject:From;
        b=fCcEA8CWH3HPhgyGE1vZ6086AFAQUH0gG2IplNYIT1w4bDbdIgXjDQMOq7IQcC2ml
         F55DpyTxONoR0UjfnGPtoX6m9xHqiz9VLfxznJWLdMycOF/x1r8sGbOb5heGCXaY0F
         yuSTDCWW7ZbNRtHATDvICkedy346HfGRaQkusbM8=
Date:   Thu, 25 Feb 2021 11:18:59 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com,
        tangyizhou@huawei.com
Subject:  [merged] mm-oom-fix-a-comment-in-dump_task.patch removed
 from -mm tree
Message-ID: <20210225191859.7Y380tL8O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: fix a comment in dump_task()
has been removed from the -mm tree.  Its filename was
     mm-oom-fix-a-comment-in-dump_task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Yizhou <tangyizhou@huawei.com>
Subject: mm, oom: fix a comment in dump_task()

If p is a kthread, it will be checked in oom_unkillable_task() so
we can delete the corresponding comment.

Link: https://lkml.kernel.org/r/20210125133006.7242-1-tangyizhou@huawei.com
Signed-off-by: Tang Yizhou <tangyizhou@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/oom_kill.c~mm-oom-fix-a-comment-in-dump_task
+++ a/mm/oom_kill.c
@@ -395,9 +395,8 @@ static int dump_task(struct task_struct
 	task = find_lock_task_mm(p);
 	if (!task) {
 		/*
-		 * This is a kthread or all of p's threads have already
-		 * detached their mm's.  There's no need to report
-		 * them; they can't be oom killed anyway.
+		 * All of p's threads have already detached their mm's. There's
+		 * no need to report them; they can't be oom killed anyway.
 		 */
 		return 0;
 	}
_

Patches currently in -mm which might be from tangyizhou@huawei.com are


