Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E0AC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 571F364F24
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhBZAok (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:44:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:32772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232027AbhBZAod (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:44:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D247D60202;
        Fri, 26 Feb 2021 00:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300233;
        bh=07md9cK3mTD6ms/252rq8zV4kfEJW+zUM9DYO77zHNk=;
        h=Date:From:To:Subject:From;
        b=VLPiMq1eD8CoqJJZM55ZMvM0uHHSvOmOq/MQoIy566o8GfIF//Gh1wp4RQOP3HmmD
         LP9kA/VVygKEy37tLVyMTR/If4NdB3nNX0ubLWANUXT64CjnllO+LQ+p1FmptVi8i2
         WUQ7zl2wlE807qeV3tu9n9fVocqylH2IVOWoD4DU=
Date:   Thu, 25 Feb 2021 16:43:52 -0800
From:   akpm@linux-foundation.org
To:     anders.roxell@linaro.org, dvyukov@google.com, elver@google.com,
        glider@google.com, jannh@google.com, mm-commits@vger.kernel.org,
        sjpark@amazon.de
Subject:  [folded-merged]
 mm-add-kernel-electric-fence-infrastructure-fix-2.patch removed from -mm
 tree
Message-ID: <20210226004352.2BHSRKgZd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: avoid stalling work queue task without allocations
has been removed from the -mm tree.  Its filename was
     mm-add-kernel-electric-fence-infrastructure-fix-2.patch

This patch was dropped because it was folded into mm-add-kernel-electric-fence-infrastructure.patch

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

mm-add-kernel-electric-fence-infrastructure.patch
mm-add-kernel-electric-fence-infrastructure-fix-3.patch
mm-add-kernel-electric-fence-infrastructure-fix-4.patch
mm-add-kernel-electric-fence-infrastructure-fix-5.patch
x86-kfence-enable-kfence-for-x86-fix.patch
arm64-kfence-enable-kfence-for-arm64.patch
arm64-kfence-enable-kfence-for-arm64-fix.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-documentation-add-kfence-documentation-fix.patch
kfence-add-test-suite.patch
kfence-add-test-suite-fix.patch
kfence-add-test-suite-fix-2.patch
maintainers-add-entry-for-kfence.patch
kfence-report-sensitive-information-based-on-no_hash_pointers.patch

