Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D28C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A017622250
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708994;
	bh=jTouIx6/WeQaKaa9Vgr/2f8YO/m6ZtT/GmfokajDoFo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vxokA8jXXsWjL7A3MLt6Jhsvo3qnD3lFRRDHuR5kSCgwq5L6qWA6e629uBEb10GM2
	 vlvbljpvx3ZrUqSYkPMKg0zgx04FdoVw9mEY5zxFGoxLD9/owpQLDYdoJGZlcc/NQ3
	 F7xrqCVfkXuEyH86UfpBl1Hu/b17S5Wf+ZejED/4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389404AbgJNU4e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389386AbgJNU4c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:56:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A70B022257;
        Wed, 14 Oct 2020 20:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708992;
        bh=jTouIx6/WeQaKaa9Vgr/2f8YO/m6ZtT/GmfokajDoFo=;
        h=Date:From:To:Subject:From;
        b=BeNKVHcJZBtdLkkjAFSYWuzcpWdnvu87jDLecVMDIKrTS3ePGUXXc7DsWFzPYt5ds
         yAvpZf9B60x4uuhle7+tP8LbQLSg5mupbfiIPUIEi7HStP6hJPKjxHLXu87RZoG4s/
         hCkh5VivoxBr54VyAg1DgSPYozsMFifJJCSHNnrg=
Date:   Wed, 14 Oct 2020 13:56:31 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, catalin.marinas@arm.com, dave@stgolabs.net,
        dbueso@suse.de, mm-commits@vger.kernel.org, oleg@redhat.com
Subject:  [merged]
 mm-kmemleak-rely-on-rcu-for-task-stack-scanning.patch removed from -mm tree
Message-ID: <20201014205631.5ivBi_p7u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: rely on rcu for task stack scanning
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-rely-on-rcu-for-task-stack-scanning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from dave@stgolabs.net are


