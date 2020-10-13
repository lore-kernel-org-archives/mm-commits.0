Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC5FC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E447D21D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632932;
	bh=9BuS3tGWmxiV+VoM6tl+rvsPXTd7Br6j53ufCjVaIGQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=y1Y0DAykD0huup4Vj+x7uIHe3nUOFsxX7/CjODCOY3lZrU5vrC2hdKOQFeF4rBnY7
	 eNY1Gx89OHm1VcpdgnvuF3Ar0g4/tER3Jc6rS0iWYeOCmgF1aJaKrgAR8dwCGyoF/U
	 0AKeDEPnyThPl0kr3KZboKyfYaU8NFXxisyXvjGs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgJMXsv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbgJMXsv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FBCB22200;
        Tue, 13 Oct 2020 23:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632931;
        bh=9BuS3tGWmxiV+VoM6tl+rvsPXTd7Br6j53ufCjVaIGQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KdnXX8f1o/i/TPRdeaxbPwJa6wOYiqT94QmJMKZ9Ng9//r1bw/HB0oqPGaTSqzBNw
         HTW3jBKtFPX17JP3aDjHty7I8aXtatD6knROO7X0BDrcA6pndheCCUJSHHiw57F2hh
         My+13dCdAaxb49fjfpoDnBvD7VpXIupBCDkPUVZE=
Date:   Tue, 13 Oct 2020 16:48:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, catalin.marinas@arm.com,
        dave@stgolabs.net, dbueso@suse.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 024/181] mm/kmemleak: rely on rcu for task stack
 scanning
Message-ID: <20201013234850.AsSd7RSbj%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/kmemleak: rely on rcu for task stack scanning

kmemleak_scan() currently relies on the big tasklist_lock hammer to
stabilize iterating through the tasklist.  Instead, this patch proposes
simply using rcu along with the rcu-safe for_each_process_thread flavor
(without changing scan semantics), which doesn't make use of
next_thread/p->thread_group and thus cannot race with exit.  Furthermore,
any races with fork() and not seeing the new child should be benign as
it's not running yet and can also be detected by the next scan.

Avoiding the tasklist_lock could prove beneficial for performance
considering the scan operation is done periodically.  I have seen
improvements of 30%-ish when doing similar replacements on very
pathological microbenchmarks (ie stressing get/setpriority(2)).

However my main motivation is that it's one less user of the global
lock, something that Linus has long time wanted to see gone eventually
(if ever) even if the traditional fairness issues has been dealt with
now with qrwlocks.  Of course this is a very long ways ahead.  This
patch also kills another user of the deprecated tsk->thread_group.

Link: https://lkml.kernel.org/r/20200820203902.11308-1-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-rely-on-rcu-for-task-stack-scanning
+++ a/mm/kmemleak.c
@@ -1471,15 +1471,15 @@ static void kmemleak_scan(void)
 	if (kmemleak_stack_scan) {
 		struct task_struct *p, *g;
 
-		read_lock(&tasklist_lock);
-		do_each_thread(g, p) {
+		rcu_read_lock();
+		for_each_process_thread(g, p) {
 			void *stack = try_get_task_stack(p);
 			if (stack) {
 				scan_block(stack, stack + THREAD_SIZE, NULL);
 				put_task_stack(p);
 			}
-		} while_each_thread(g, p);
-		read_unlock(&tasklist_lock);
+		}
+		rcu_read_unlock();
 	}
 
 	/*
_
