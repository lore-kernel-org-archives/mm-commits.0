Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1CAC43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbiGRAdY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbiGRAdI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:33:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F044F140D2
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 67C59CE117E
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEC7C3411E;
        Mon, 18 Jul 2022 00:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104365;
        bh=bY0m+5bns42Lk13cYd0P0HvL9BPFTGQDhxyAMXwrgY8=;
        h=Date:To:From:Subject:From;
        b=IDnsFtL0qDafGd8gqTgJV0Tjrrqx8HMekn9iP0kTGuAdCPkfIO5Hv+Ud2SoXTlbqw
         OXP8C1eWVCW1EZ+qOAdolPCNdtjAefCrXu9zZ4YthID8vSET8Kw8V6mrCnFtU4HvKb
         79zan6H1YK6BLrRvHUj2zZoM3H0BirEtBBVoA+pE=
Date:   Sun, 17 Jul 2022 17:32:45 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, alexandre.chartre@oracle.com,
        penguin-kernel@I-love.SAKURA.ne.jp, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-smp_processor_id-fix-imbalanced-instrumentation_end-call.patch removed from -mm tree
Message-Id: <20220718003245.9AEC7C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/smp_processor_id: fix imbalanced instrumentation_end() call
has been removed from the -mm tree.  Its filename was
     lib-smp_processor_id-fix-imbalanced-instrumentation_end-call.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: lib/smp_processor_id: fix imbalanced instrumentation_end() call
Date: Wed, 22 Jun 2022 14:46:31 +0900

Currently instrumentation_end() won't be called if printk_ratelimit()
returned false.

Link: https://lkml.kernel.org/r/a636d8e0-ad32-5888-acac-671f7f553bb3@I-love.SAKURA.ne.jp
Fixes: 126f21f0e8d46e2c ("lib/smp_processor_id: Move it into noinstr section")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexandre Chartre <alexandre.chartre@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/smp_processor_id.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/smp_processor_id.c~lib-smp_processor_id-fix-imbalanced-instrumentation_end-call
+++ a/lib/smp_processor_id.c
@@ -47,9 +47,9 @@ unsigned int check_preemption_disabled(c
 
 	printk("caller is %pS\n", __builtin_return_address(0));
 	dump_stack();
-	instrumentation_end();
 
 out_enable:
+	instrumentation_end();
 	preempt_enable_no_resched_notrace();
 out:
 	return this_cpu;
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are


