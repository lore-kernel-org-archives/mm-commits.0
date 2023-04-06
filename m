Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22B8C77B73
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbjDFDFG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235187AbjDFDEO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E34593DD
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:04:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8312262D65
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1D8C4339B;
        Thu,  6 Apr 2023 03:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750245;
        bh=ETQZ9KnGR9ejU1sIauAeErNBxKCz2HqMFsal21kq0+0=;
        h=Date:To:From:Subject:From;
        b=CWV76r1ns+Y1Og6B+PTJvWLTNTN9Js1j6RwkDJKz23/f4/SNGqGPwEl/A9USOWhXD
         Pzo2pZfAVqoA5M8dxZ18pkoDh+EHj8Zw2In4fVEfExo7qtaYI3HNyt1JyBIYQ82H3z
         xFecndy1is5zDpZAz6z0jW1M6EW+SiST1kIw8mUQ=
Date:   Wed, 05 Apr 2023 20:04:05 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, peterz@infradead.org,
        mingo@redhat.com, mgorman@techsingularity.net,
        dishaa.talreja@amd.com, david@redhat.com, bharata@amd.com,
        raghavendra.kt@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-numa-implement-access-pid-reset-logic.patch removed from -mm tree
Message-Id: <20230406030405.DA1D8C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sched/numa: implement access PID reset logic
has been removed from the -mm tree.  Its filename was
     sched-numa-implement-access-pid-reset-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Raghavendra K T <raghavendra.kt@amd.com>
Subject: sched/numa: implement access PID reset logic
Date: Wed, 1 Mar 2023 17:49:02 +0530

This helps to ensure that only recently accessed PIDs scan the VMAs.

Current implementation: (idea supported by PeterZ)

 1. Accessing PID information is maintained in two windows. 
    access_pids[1] being newest.

 2. Reset old access PID info i.e.  access_pid[0] every (4 *
    sysctl_numa_balancing_scan_delay) interval after initial scan delay
    period expires.

The above interval seemed to be experimentally optimum since it avoids
frequent reset of access info as well as helps clearing the old access
info regularly.  The reset logic is implemented in scan path.

Link: https://lkml.kernel.org/r/f7a675f66d1442d048b4216b2baf94515012c405.1677672277.git.raghavendra.kt@amd.com
Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
Suggested-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Bharata B Rao <bharata@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Disha Talreja <dishaa.talreja@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    4 ++--
 include/linux/mm_types.h |    3 ++-
 kernel/sched/fair.c      |   23 +++++++++++++++++++++--
 3 files changed, 25 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~sched-numa-implement-access-pid-reset-logic
+++ a/include/linux/mm.h
@@ -1692,8 +1692,8 @@ static inline void vma_set_access_pid_bi
 	unsigned int pid_bit;
 
 	pid_bit = current->pid % BITS_PER_LONG;
-	if (vma->numab_state && !test_bit(pid_bit, &vma->numab_state->access_pids)) {
-		__set_bit(pid_bit, &vma->numab_state->access_pids);
+	if (vma->numab_state && !test_bit(pid_bit, &vma->numab_state->access_pids[1])) {
+		__set_bit(pid_bit, &vma->numab_state->access_pids[1]);
 	}
 }
 #else /* !CONFIG_NUMA_BALANCING */
--- a/include/linux/mm_types.h~sched-numa-implement-access-pid-reset-logic
+++ a/include/linux/mm_types.h
@@ -477,7 +477,8 @@ struct vma_lock {
 
 struct vma_numab_state {
 	unsigned long next_scan;
-	unsigned long access_pids;
+	unsigned long next_pid_reset;
+	unsigned long access_pids[2];
 };
 
 /*
--- a/kernel/sched/fair.c~sched-numa-implement-access-pid-reset-logic
+++ a/kernel/sched/fair.c
@@ -2930,6 +2930,7 @@ static void reset_ptenuma_scan(struct ta
 
 static bool vma_is_accessed(struct vm_area_struct *vma)
 {
+	unsigned long pids;
 	/*
 	 * Allow unconditional access first two times, so that all the (pages)
 	 * of VMAs get prot_none fault introduced irrespective of accesses.
@@ -2939,10 +2940,12 @@ static bool vma_is_accessed(struct vm_ar
 	if (READ_ONCE(current->mm->numa_scan_seq) < 2)
 		return true;
 
-	return test_bit(current->pid % BITS_PER_LONG,
-				&vma->numab_state->access_pids);
+	pids = vma->numab_state->access_pids[0] | vma->numab_state->access_pids[1];
+	return test_bit(current->pid % BITS_PER_LONG, &pids);
 }
 
+#define VMA_PID_RESET_PERIOD (4 * sysctl_numa_balancing_scan_delay)
+
 /*
  * The expensive part of numa migration is done from task_work context.
  * Triggered from task_tick_numa().
@@ -3051,6 +3054,10 @@ static void task_numa_work(struct callba
 
 			vma->numab_state->next_scan = now +
 				msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
+
+			/* Reset happens after 4 times scan delay of scan start */
+			vma->numab_state->next_pid_reset =  vma->numab_state->next_scan +
+				msecs_to_jiffies(VMA_PID_RESET_PERIOD);
 		}
 
 		/*
@@ -3065,6 +3072,18 @@ static void task_numa_work(struct callba
 		if (!vma_is_accessed(vma))
 			continue;
 
+		/*
+		 * RESET access PIDs regularly for old VMAs. Resetting after checking
+		 * vma for recent access to avoid clearing PID info before access..
+		 */
+		if (mm->numa_scan_seq &&
+				time_after(jiffies, vma->numab_state->next_pid_reset)) {
+			vma->numab_state->next_pid_reset = vma->numab_state->next_pid_reset +
+				msecs_to_jiffies(VMA_PID_RESET_PERIOD);
+			vma->numab_state->access_pids[0] = READ_ONCE(vma->numab_state->access_pids[1]);
+			vma->numab_state->access_pids[1] = 0;
+		}
+
 		do {
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
_

Patches currently in -mm which might be from raghavendra.kt@amd.com are


