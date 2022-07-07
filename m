Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB73C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jul 2022 17:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbiGGRwg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 13:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236031AbiGGRwa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 13:52:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4715B59253
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 10:52:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB35B61452
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 17:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364DBC3411E;
        Thu,  7 Jul 2022 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657216349;
        bh=cN6ftKYjrACPMQ7Ozfn4b/Sv8BekRg2u80qNi/DkYxg=;
        h=Date:To:From:Subject:From;
        b=gFjRHc4JBu3O4k/2bYKvDRK+2+rMJI8cIFSqnVJFQNKsaWIS7tBgA0PezYG8TIfmM
         LInUpIXFnOvJNVKIpj1gC0vRsb2zYGvwWCncVQlgLQG2eOfNLvn49/icqyYF0FkU5s
         BtJ32ZG9aY/LFFJO7DJqWVTnvRHo+OFHumVX/xn8=
Date:   Thu, 07 Jul 2022 10:52:28 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, alexandre.chartre@oracle.com,
        penguin-kernel@I-love.SAKURA.ne.jp, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-smp_processor_id-fix-imbalanced-instrumentation_end-call.patch added to mm-nonmm-unstable branch
Message-Id: <20220707175229.364DBC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/smp_processor_id: fix imbalanced instrumentation_end() call
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-smp_processor_id-fix-imbalanced-instrumentation_end-call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-smp_processor_id-fix-imbalanced-instrumentation_end-call.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

lib-smp_processor_id-fix-imbalanced-instrumentation_end-call.patch

