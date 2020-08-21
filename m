Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0E7C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 19:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A353520724
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 19:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598039853;
	bh=7GFEAR1N1FkSIbKu0ViQSjxCBamjPrnCjaFsgV/16/E=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=byRD4qs9uVfBPm48fi6nfhCktl2DpOErdtdT6J/CiQchQI2WEan+MIt3bwWmrehAE
	 LaLyuSfCUiHm+nkwRCNLGpKankuTBU0uDSXLOJJ9lXvdNnSEg8uWEl5gy+r6E9k1a1
	 LxSF/kZzaHIU2J1xX8eVWvrRdj3CP8YhPOjm/3Qg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgHUT50 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Aug 2020 15:57:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727793AbgHUT5Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 Aug 2020 15:57:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A445520724;
        Fri, 21 Aug 2020 19:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598039843;
        bh=7GFEAR1N1FkSIbKu0ViQSjxCBamjPrnCjaFsgV/16/E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wC+sD6UoXMRBuL0+2MRS5RfpmYwKbSbYO4Pdrm3D2m9RKL/seG/9AcR/mCdL8PvLF
         Oj751r2bsJnvK0J0KPOxJDDFUVjJHrcAbV5UTD8fNOgiejvT3m18GX1WLoV2sSA2Yl
         X3nW42SrXM9V5PmQ6q8Td11OhtxBkCDBxnjlMeDM=
Date:   Fri, 21 Aug 2020 12:57:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     catalin.marinas@arm.com, dave@stgolabs.net, dbueso@suse.de,
        mm-commits@vger.kernel.org, oleg@redhat.com
Subject:  + mm-kmemleak-rely-on-rcu-for-task-stack-scanning.patch
 added to -mm tree
Message-ID: <20200821195723.v40-N6Q-s%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: rely on rcu for task stack scanning
has been added to the -mm tree.  Its filename is
     mm-kmemleak-rely-on-rcu-for-task-stack-scanning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-rely-on-rcu-for-task-stack-scanning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-rely-on-rcu-for-task-stack-scanning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20200820203902.11308-1-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
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

mm-kmemleak-rely-on-rcu-for-task-stack-scanning.patch

