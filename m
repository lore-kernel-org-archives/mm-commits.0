Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C325DC678D4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 02:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjCCCZn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCCCZi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 21:25:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA37E4393D
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 18:25:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5625661470
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 02:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7FDC433D2;
        Fri,  3 Mar 2023 02:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677810336;
        bh=LPMhmkSh0kLlfgVB1gkVt5xA8COuLvYhqh4XzM0/JoE=;
        h=Date:To:From:Subject:From;
        b=Fxz70EPcz5nDB34Ro83m2DOuQ1LCOKHRo+hNXuLtBUap8v+3WTcGbiS22HdQf9pb8
         wM3xcTUQ6mmvebfdz/qOrxYtoFi5kMC+OBkSL4golP7/x3g2OBRfVbFYuc3UI2xYfY
         EANaYQVi3lxsmB4eAl/xpzFh3YOW6pdcjqafcYws=
Date:   Thu, 02 Mar 2023 18:25:36 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, peterz@infradead.org,
        mingo@redhat.com, mgorman@techsingularity.net,
        dishaa.talreja@amd.com, david@redhat.com, bharata@amd.com,
        raghavendra.kt@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-numa-use-hash_32-to-mix-up-pids-accessing-vma.patch added to mm-unstable branch
Message-Id: <20230303022536.AD7FDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sched/numa: use hash_32 to mix up PIDs accessing VMA
has been added to the -mm mm-unstable branch.  Its filename is
     sched-numa-use-hash_32-to-mix-up-pids-accessing-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-numa-use-hash_32-to-mix-up-pids-accessing-vma.patch

This patch will later appear in the mm-unstable branch at
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
From: Raghavendra K T <raghavendra.kt@amd.com>
Subject: sched/numa: use hash_32 to mix up PIDs accessing VMA
Date: Wed, 1 Mar 2023 17:49:03 +0530

before: last 6 bits of PID is used as index to store information about
tasks accessing VMA's.

after: hash_32 is used to take of cases where tasks are created over a
period of time, and thus improve collision probability.

Result:
The patch series overall improves autonuma cost.

Kernbench around more than 5% improvement and system time in mmtest
autonuma showed more than 80% improvement

Link: https://lkml.kernel.org/r/d5a9f75513300caed74e5c8570bba9317b963c2b.1677672277.git.raghavendra.kt@amd.com
Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Disha Talreja <dishaa.talreja@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~sched-numa-use-hash_32-to-mix-up-pids-accessing-vma
+++ a/include/linux/mm.h
@@ -1671,7 +1671,7 @@ static inline void vma_set_access_pid_bi
 {
 	unsigned int pid_bit;
 
-	pid_bit = current->pid % BITS_PER_LONG;
+	pid_bit = hash_32(current->pid, ilog2(BITS_PER_LONG));
 	if (vma->numab_state && !test_bit(pid_bit, &vma->numab_state->access_pids[1])) {
 		__set_bit(pid_bit, &vma->numab_state->access_pids[1]);
 	}
--- a/kernel/sched/fair.c~sched-numa-use-hash_32-to-mix-up-pids-accessing-vma
+++ a/kernel/sched/fair.c
@@ -2941,7 +2941,7 @@ static bool vma_is_accessed(struct vm_ar
 		return true;
 
 	pids = vma->numab_state->access_pids[0] | vma->numab_state->access_pids[1];
-	return test_bit(current->pid % BITS_PER_LONG, &pids);
+	return test_bit(hash_32(current->pid, ilog2(BITS_PER_LONG)), &pids);
 }
 
 #define VMA_PID_RESET_PERIOD (4 * sysctl_numa_balancing_scan_delay)
_

Patches currently in -mm which might be from raghavendra.kt@amd.com are

sched-numa-enhance-vma-scanning-logic.patch
sched-numa-implement-access-pid-reset-logic.patch
sched-numa-use-hash_32-to-mix-up-pids-accessing-vma.patch

