Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCDCEC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A052E64E60
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbhBXUMo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:12:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235479AbhBXUKc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C2A964EC4;
        Wed, 24 Feb 2021 20:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197392;
        bh=eeixNsFXgZKGs1v3XLlSzeyRAoDd0cdPojtTzEEi/bY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=snZ7Y5mJ4fcFA5ZWB0FCTHJ/SAjVZXTILJW9SAfnVRGtGckkrsfgim1BYhiLLd/9J
         OaNPUq4WORm7hjyVwP4nlDtVMaPS7dpdAijRrP526LoxpXqcYGedtuOjaoUMk7VTx/
         vZ84gYLa/7b29yYXoE+BJR9ra8xeI4owsg8FeWeQ=
Date:   Wed, 24 Feb 2021 12:09:50 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        tangyizhou@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 162/173] mm, oom: fix a comment in dump_task()
Message-ID: <20210224200950.wUwH8Cuz5%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
