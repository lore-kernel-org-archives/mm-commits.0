Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 976F5C48BDF
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 23:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 774DF613E1
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 23:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFJXKX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 19:10:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230001AbhFJXKW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 19:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 963BD613D9;
        Thu, 10 Jun 2021 23:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623366493;
        bh=8JEKeAI7FMiF7LHvQgw8coqLh5SW1X0OXcXvzGtnLXw=;
        h=Date:From:To:Subject:From;
        b=KGcb77iPqrQQUAlnnqbnUEQFpJbbaZyL0WgS+LXwBMPwCOqXKyWvMOXy+XzbZpHKc
         Cox5U1cr5u4sIVPYRKLl+5ZY/m7ei3Mm0XCmjcNXX60AI4RWyQU5aNVKF58rV//dYT
         lmeG+q2e035GTb0GoLpN5+TQ9jvYI5bqPpBJVwMI=
Date:   Thu, 10 Jun 2021 16:08:13 -0700
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, mm-commits@vger.kernel.org,
        yanfei.xu@windriver.com
Subject:  +
 mm-kmemleak-use-read_once-for-accessing-jiffies_scan_wait.patch added to
 -mm tree
Message-ID: <20210610230813.V6S0m6K6c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: use READ_ONCE() for accessing jiffies_scan_wait
has been added to the -mm tree.  Its filename is
     mm-kmemleak-use-read_once-for-accessing-jiffies_scan_wait.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-use-read_once-for-accessing-jiffies_scan_wait.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-use-read_once-for-accessing-jiffies_scan_wait.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/kmemleak: use READ_ONCE() for accessing jiffies_scan_wait

The stop_scan_thread() and start_scan_thread() cannot really solve the
problem of concurrent accessing the global jiffies_scan_wait.

kmemleak_write              kmemleak_scan_thread
                              while (!kthread_should_stop())
  stop_scan_thread
  jiffies_scan_wait = xxx       timeout = jiffies_scan_wait
  start_scan_thread

We could replace these with a READ_ONCE() when reading jiffies_scan_wait. 
It also can prevent compiler from reordering the jiffies_scan_wait which
is in while loop.

Link: https://lkml.kernel.org/r/20210609155657.26972-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-use-read_once-for-accessing-jiffies_scan_wait
+++ a/mm/kmemleak.c
@@ -1567,7 +1567,7 @@ static int kmemleak_scan_thread(void *ar
 	}
 
 	while (!kthread_should_stop()) {
-		signed long timeout = jiffies_scan_wait;
+		signed long timeout = READ_ONCE(jiffies_scan_wait);
 
 		mutex_lock(&scan_mutex);
 		kmemleak_scan();
@@ -1812,11 +1812,8 @@ static ssize_t kmemleak_write(struct fil
 		ret = kstrtoul(buf + 5, 0, &secs);
 		if (ret < 0)
 			goto out;
-		stop_scan_thread();
-		if (secs) {
+		if (secs)
 			jiffies_scan_wait = msecs_to_jiffies(secs * 1000);
-			start_scan_thread();
-		}
 	} else if (strncmp(buf, "scan", 4) == 0)
 		kmemleak_scan();
 	else if (strncmp(buf, "dump=", 5) == 0)
_

Patches currently in -mm which might be from yanfei.xu@windriver.com are

mm-kmemleak-use-read_once-for-accessing-jiffies_scan_wait.patch

