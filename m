Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F40C678D4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 02:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjCCCZh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCCCZg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 21:25:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D3E42BEF
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 18:25:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E582B61707
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 02:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4D1C433D2;
        Fri,  3 Mar 2023 02:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677810334;
        bh=DxS4dLgYwz0OnIpEuWOHNuEdWETVGmwCbodIQseegJY=;
        h=Date:To:From:Subject:From;
        b=ps/vk9yiPcpCJcpBb9xYdWV0rAcJuggsxkt0NbesdapCjdir6bL8YcTwgMncTrAy0
         4FY4YEokSygic/5YWkHZ8hKqRjclxLUOTLT35MV9VZn7bUDHPBDMIaPzuFN9KjqIN0
         9pEBfbTsU8nctbXvTrZ827rxW+DBBSKMN57UtdUU=
Date:   Thu, 02 Mar 2023 18:25:33 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, peterz@infradead.org,
        mingo@redhat.com, mgorman@techsingularity.net,
        dishaa.talreja@amd.com, david@redhat.com, bharata@amd.com,
        raghavendra.kt@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-numa-implement-access-pid-reset-logic.patch added to mm-unstable branch
Message-Id: <20230303022534.4B4D1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sched/numa: implement access PID reset logic
has been added to the -mm mm-unstable branch.  Its filename is
     sched-numa-implement-access-pid-reset-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-numa-implement-access-pid-reset-logic.patch

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


--- a/include/linux/mm.h~sched-numa-implement-access-pid-reset-logic
+++ a/include/linux/mm.h
@@ -1672,8 +1672,8 @@ static inline void vma_set_access_pid_bi
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

sched-numa-enhance-vma-scanning-logic.patch
sched-numa-implement-access-pid-reset-logic.patch
sched-numa-use-hash_32-to-mix-up-pids-accessing-vma.patch

