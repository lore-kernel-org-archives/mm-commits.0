Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA7C1C77B71
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbjDFDFH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235123AbjDFDEP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4069ECC
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:04:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFA0C64218
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E939C4339B;
        Thu,  6 Apr 2023 03:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750247;
        bh=rtFMw9zIM5eQMDpemRFUW+hBQbt/PiKwrpZqWzM4lf8=;
        h=Date:To:From:Subject:From;
        b=JTYAnLki2HoDqxujzqT7YMf0l+bVwDGAeCg7Z5xKFX/aQ/KSxk/CKV0ph85FrcnZo
         CcwAUY8c09xeoSNpRbpg5wis4Lhj8+6yH4RxjUlTE5FDEgA6Ri48lxIj6Eq0i+Rafa
         hveark4lJ+CNZngueeevssWCL7yoMf2jZ0J2fiUA=
Date:   Wed, 05 Apr 2023 20:04:06 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, peterz@infradead.org,
        mingo@redhat.com, mgorman@techsingularity.net,
        dishaa.talreja@amd.com, david@redhat.com, bharata@amd.com,
        raghavendra.kt@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-numa-use-hash_32-to-mix-up-pids-accessing-vma.patch removed from -mm tree
Message-Id: <20230406030407.2E939C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sched/numa: use hash_32 to mix up PIDs accessing VMA
has been removed from the -mm tree.  Its filename was
     sched-numa-use-hash_32-to-mix-up-pids-accessing-vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 include/linux/mm.h  |    2 +-
 kernel/sched/fair.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~sched-numa-use-hash_32-to-mix-up-pids-accessing-vma
+++ a/include/linux/mm.h
@@ -1691,7 +1691,7 @@ static inline void vma_set_access_pid_bi
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


