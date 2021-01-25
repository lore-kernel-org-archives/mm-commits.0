Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21067C433DB
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C731120756
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731500AbhAYWWa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:22:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732418AbhAYWWU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 17:22:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0AB02072C;
        Mon, 25 Jan 2021 22:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611613300;
        bh=0XHMx1iY/TIWeuIHxwzjjWMEaHQOa5eGG1mqAundiSo=;
        h=Date:From:To:Subject:From;
        b=FHGssR/bMegix6ZVVULZKlcvepHTrlQNNTimxIAAPUDi4bH+d5OG4u19zyBzP7UKk
         MwaxoMTMY4q9YCcXMkTekOwuTiwdLtJc6wq8q79c5UuoX0sZjGwQV1gFNrmPjjUK/7
         sBjN/LW63B8uJldU9poGKDpkO3TohkJ3azNA7mgI=
Date:   Mon, 25 Jan 2021 14:21:39 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com,
        tangyizhou@huawei.com
Subject:  + mm-oom-fix-a-comment-in-dump_task.patch added to -mm
 tree
Message-ID: <20210125222139.vfuwFZt1f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: fix a comment in dump_task()
has been added to the -mm tree.  Its filename is
     mm-oom-fix-a-comment-in-dump_task.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-oom-fix-a-comment-in-dump_task.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-fix-a-comment-in-dump_task.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Yizhou <tangyizhou@huawei.com>
Subject: mm, oom: fix a comment in dump_task()

If p is a kthread, it will be checked in oom_unkillable_task() so
we can delete the corresponding comment.

Link: https://lkml.kernel.org/r/20210125133006.7242-1-tangyizhou@huawei.com
Signed-off-by: Tang Yizhou <tangyizhou@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>x
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

mm-oom-fix-a-comment-in-dump_task.patch

