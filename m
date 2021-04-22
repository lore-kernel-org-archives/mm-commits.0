Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555BDC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 283F16144A
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbhDVESL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Apr 2021 00:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhDVESL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Apr 2021 00:18:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4A0160698;
        Thu, 22 Apr 2021 04:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619065057;
        bh=8Tl/yckrVCM5TeNpoG30CVlKW1UVR17H4nSleJtj/0o=;
        h=Date:From:To:Subject:From;
        b=NloYv9eYk6g7/fpxLjS1sYQUMZd2ws4cBfUuNqxdIjoCxa15FlNDyd/5ChEP6kwva
         qjsCUZeP8F9CbpYohfDuBRzGcsvQgR9ZZqDGFtPDsaYI0v68vWJ+lSs7quN7ePtg69
         jqw5Od8KuYhGwFGCe3qXI+7lKcJm9GfSVDFbVLQ4=
Date:   Wed, 21 Apr 2021 21:17:36 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        hdanton@sina.com, jannh@google.com, mark.rutland@arm.com,
        mm-commits@vger.kernel.org
Subject:  + kfence-maximize-allocation-wait-timeout-duration.patch
 added to -mm tree
Message-ID: <20210422041736.q78R-bbU6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: maximize allocation wait timeout duration
has been added to the -mm tree.  Its filename is
     kfence-maximize-allocation-wait-timeout-duration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-maximize-allocation-wait-timeout-duration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-maximize-allocation-wait-timeout-duration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: maximize allocation wait timeout duration

The allocation wait timeout was initially added because of warnings due to
CONFIG_DETECT_HUNG_TASK=y [1].  While the 1 sec timeout is sufficient to
resolve the warnings (given the hung task timeout must be 1 sec or larger)
it may cause unnecessary wake-ups if the system is idle.  [1]
https://lkml.kernel.org/r/CADYN=9J0DQhizAGB0-jz4HOBBh+05kMBXb4c0cXMS7Qi5NAJiw@mail.gmail.com

Fix it by computing the timeout duration in terms of the current
sysctl_hung_task_timeout_secs value.

Link: https://lkml.kernel.org/r/20210421105132.3965998-3-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jann Horn <jannh@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/kfence/core.c~kfence-maximize-allocation-wait-timeout-duration
+++ a/mm/kfence/core.c
@@ -20,6 +20,7 @@
 #include <linux/moduleparam.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
+#include <linux/sched/sysctl.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -621,7 +622,16 @@ static void toggle_allocation_gate(struc
 	/* Enable static key, and await allocation to happen. */
 	static_branch_enable(&kfence_allocation_key);
 
-	wait_event_timeout(allocation_wait, atomic_read(&kfence_allocation_gate), HZ);
+	if (sysctl_hung_task_timeout_secs) {
+		/*
+		 * During low activity with no allocations we might wait a
+		 * while; let's avoid the hung task warning.
+		 */
+		wait_event_timeout(allocation_wait, atomic_read(&kfence_allocation_gate),
+				   sysctl_hung_task_timeout_secs * HZ / 2);
+	} else {
+		wait_event(allocation_wait, atomic_read(&kfence_allocation_gate));
+	}
 
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
_

Patches currently in -mm which might be from elver@google.com are

kfence-zero-guard-page-after-out-of-bounds-access.patch
kfence-await-for-allocation-using-wait_event.patch
kfence-maximize-allocation-wait-timeout-duration.patch
kfence-use-power-efficient-work-queue-to-run-delayed-work.patch

