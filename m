Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D667CC4742C
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93A8E2224B
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:47:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="abKgTQRc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388589AbgKPUqq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 15:46:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731170AbgKPUqq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 15:46:46 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B68632223D;
        Mon, 16 Nov 2020 20:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605559604;
        bh=M1htz31itok+q1HpV9ypQTnxIHLliWImTAa2YQXT5Zk=;
        h=Date:From:To:Subject:From;
        b=abKgTQRcyNKFVy2ZcgsQN3vy7Q07BJhy+vPEr9RttOsCQ00D5g42i+L+28LxiHqEx
         gMOshNJ18zk0AfQSRbbVEN1OpMqzMyln0VGFMUKatCUQ7XOuYTSvvxki7Cks9ha1rp
         GujgBMubIefz7b1ufdzmIRx3aeTw8o9b3oG2CpyQ=
Date:   Mon, 16 Nov 2020 12:46:44 -0800
From:   akpm@linux-foundation.org
To:     edumazet@google.com, minchan@kernel.org, mm-commits@vger.kernel.org
Subject:  + mm-madvise-fix-memory-leak-from-process_madvise.patch
 added to -mm tree
Message-ID: <20201116204644.rBGfKQBmT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: fix memory leak from process_madvise
has been added to the -mm tree.  Its filename is
     mm-madvise-fix-memory-leak-from-process_madvise.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-fix-memory-leak-from-process_madvise.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-fix-memory-leak-from-process_madvise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: mm/madvise: fix memory leak from process_madvise

The eary return in process_madvise will produce memory leak.  Fix it.

Link: https://lkml.kernel.org/r/20201116155132.GA3805951@google.com
Fixes: ecb8ac8b1f14 ("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-fix-memory-leak-from-process_madvise
+++ a/mm/madvise.c
@@ -1231,8 +1231,6 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 		ret = total_len - iov_iter_count(&iter);
 
 	mmput(mm);
-	return ret;
-
 release_task:
 	put_task_struct(task);
 put_pid:
_

Patches currently in -mm which might be from edumazet@google.com are

mm-madvise-fix-memory-leak-from-process_madvise.patch

