Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B3AC388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 19:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDA9620780
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 19:02:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qoupvd0S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbgKJTCI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 14:02:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgKJTCI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 14:02:08 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08F312076E;
        Tue, 10 Nov 2020 19:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605034926;
        bh=Pd7JsmXWaQhCLZl4Iqi3Opx95onFpRWTYu3G6yXdcGU=;
        h=Date:From:To:Subject:From;
        b=qoupvd0SKioR45noKd7H42iXAIzYyPmYd+t2O4V26mvF/1ZfHvMEzr3K0lRsAo1sg
         YUWmOzwfSPT0cYQKmDuuGgNaB5jT3HAe3HwA9dYYCHDcqQ6Oc22ApPZdRMLo6rLyGx
         qSXvyRjeZmj5nB2C5nW6cdRRPvp/V6246IYwubiI=
Date:   Tue, 10 Nov 2020 11:02:05 -0800
From:   akpm@linux-foundation.org
To:     anders.roxell@linaro.org, dvyukov@google.com, elver@google.com,
        glider@google.com, jannh@google.com, mm-commits@vger.kernel.org,
        sjpark@amazon.de
Subject:  + mm-add-kernel-electric-fence-infrastructure-fix-2.patch
 added to -mm tree
Message-ID: <20201110190205.zHq0IhvvM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: avoid stalling work queue task without allocations
has been added to the -mm tree.  Its filename is
     mm-add-kernel-electric-fence-infrastructure-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-kernel-electric-fence-infrastructure-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-kernel-electric-fence-infrastructure-fix-2.patch

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
Subject: kfence: avoid stalling work queue task without allocations

To toggle the allocation gates, we set up a delayed work that calls
toggle_allocation_gate().  Here we use wait_event() to await an allocation
and subsequently disable the static branch again.  However, if the kernel
has stopped doing allocations entirely, we'd wait indefinitely, and stall
the worker task.  This may also result in the appropriate warnings if
CONFIG_DETECT_HUNG_TASK=y.

Therefore, introduce a 1 second timeout and use wait_event_timeout().  If
the timeout is reached, the static branch is disabled and a new delayed
work is scheduled to try setting up an allocation at a later time.

Note that, this scenario is very unlikely during normal workloads once the
kernel has booted and user space tasks are running.  It can, however,
happen during early boot after KFENCE has been enabled, when e.g.  running
tests that do not result in any allocations.

Link: https://lkml.kernel.org/r/CADYN=9J0DQhizAGB0-jz4HOBBh+05kMBXb4c0cXMS7Qi5NAJiw@mail.gmail.com
Link: https://lkml.kernel.org/r/20201110135320.3309507-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/kfence/core.c~mm-add-kernel-electric-fence-infrastructure-fix-2
+++ a/mm/kfence/core.c
@@ -588,7 +588,11 @@ static void toggle_allocation_gate(struc
 	/* Enable static key, and await allocation to happen. */
 	atomic_set(&allocation_gate, 0);
 	static_branch_enable(&kfence_allocation_key);
-	wait_event(allocation_wait, atomic_read(&allocation_gate) != 0);
+	/*
+	 * Await an allocation. Timeout after 1 second, in case the kernel stops
+	 * doing allocations, to avoid stalling this worker task for too long.
+	 */
+	wait_event_timeout(allocation_wait, atomic_read(&allocation_gate) != 0, HZ);
 
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
_

Patches currently in -mm which might be from elver@google.com are

mm-add-kernel-electric-fence-infrastructure-fix.patch
mm-add-kernel-electric-fence-infrastructure-fix-2.patch
arm64-kfence-enable-kfence-for-arm64.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-add-test-suite.patch
maintainers-add-entry-for-kfence.patch

