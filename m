Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93772C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbjDFDFF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235183AbjDFDEO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B4B7687
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:04:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C30C64174
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96599C433EF;
        Thu,  6 Apr 2023 03:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750244;
        bh=KPF1aLSIn1uazLngbSmnqVZZ5+w4eZsNNbaKRQKuZxM=;
        h=Date:To:From:Subject:From;
        b=vIGHSg38fC8zjkbYVXVPR18T4CUw9Nmn+DvBodcMfu8cTjwM/YlLMRsigaTCmPYdv
         ev2jtUrMGEumHUrUnOAIPlVnjSUOWcTotlOrISJ27S5ST+qwahT/tVzgaCCRVyC5al
         T77rBvADSRYvHUSq9qi0vg6H/zJzVF+QtvH3vUR4=
Date:   Wed, 05 Apr 2023 20:04:04 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, mingo@redhat.com,
        mgorman@techsingularity.net, dishaa.talreja@amd.com,
        david@redhat.com, raghavendra.kt@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-numa-enhance-vma-scanning-logic.patch removed from -mm tree
Message-Id: <20230406030404.96599C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sched/numa: enhance vma scanning logic
has been removed from the -mm tree.  Its filename was
     sched-numa-enhance-vma-scanning-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Raghavendra K T <raghavendra.kt@amd.com>
Subject: sched/numa: enhance vma scanning logic
Date: Wed, 1 Mar 2023 17:49:01 +0530

During Numa scanning make sure only relevant vmas of the tasks are
scanned.

Before:
 All the tasks of a process participate in scanning the vma even if they
 do not access vma in it's lifespan.

Now:
 Except cases of first few unconditional scans, if a process do
 not touch vma (exluding false positive cases of PID collisions)
 tasks no longer scan all vma

Logic used:

1) 6 bits of PID used to mark active bit in vma numab status during
   fault to remember PIDs accessing vma.  (Thanks Mel)

2) Subsequently in scan path, vma scanning is skipped if current PID
   had not accessed vma.

3) First two times we do allow unconditional scan to preserve earlier
   behaviour of scanning.

Acknowledgement to Bharata B Rao <bharata@amd.com> for initial patch to
store pid information and Peter Zijlstra <peterz@infradead.org> (Usage of
test and set bit)

Link: https://lkml.kernel.org/r/092f03105c7c1d3450f4636b1ea350407f07640e.1677672277.git.raghavendra.kt@amd.com
Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
Suggested-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Disha Talreja <dishaa.talreja@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   14 ++++++++++++++
 include/linux/mm_types.h |    1 +
 kernel/sched/fair.c      |   19 +++++++++++++++++++
 mm/memory.c              |    3 +++
 4 files changed, 37 insertions(+)

--- a/include/linux/mm.h~sched-numa-enhance-vma-scanning-logic
+++ a/include/linux/mm.h
@@ -1686,6 +1686,16 @@ static inline int xchg_page_access_time(
 	last_time = page_cpupid_xchg_last(page, time >> PAGE_ACCESS_TIME_BUCKETS);
 	return last_time << PAGE_ACCESS_TIME_BUCKETS;
 }
+
+static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
+{
+	unsigned int pid_bit;
+
+	pid_bit = current->pid % BITS_PER_LONG;
+	if (vma->numab_state && !test_bit(pid_bit, &vma->numab_state->access_pids)) {
+		__set_bit(pid_bit, &vma->numab_state->access_pids);
+	}
+}
 #else /* !CONFIG_NUMA_BALANCING */
 static inline int page_cpupid_xchg_last(struct page *page, int cpupid)
 {
@@ -1735,6 +1745,10 @@ static inline bool cpupid_match_pid(stru
 {
 	return false;
 }
+
+static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
+{
+}
 #endif /* CONFIG_NUMA_BALANCING */
 
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
--- a/include/linux/mm_types.h~sched-numa-enhance-vma-scanning-logic
+++ a/include/linux/mm_types.h
@@ -477,6 +477,7 @@ struct vma_lock {
 
 struct vma_numab_state {
 	unsigned long next_scan;
+	unsigned long access_pids;
 };
 
 /*
--- a/kernel/sched/fair.c~sched-numa-enhance-vma-scanning-logic
+++ a/kernel/sched/fair.c
@@ -2928,6 +2928,21 @@ static void reset_ptenuma_scan(struct ta
 	p->mm->numa_scan_offset = 0;
 }
 
+static bool vma_is_accessed(struct vm_area_struct *vma)
+{
+	/*
+	 * Allow unconditional access first two times, so that all the (pages)
+	 * of VMAs get prot_none fault introduced irrespective of accesses.
+	 * This is also done to avoid any side effect of task scanning
+	 * amplifying the unfairness of disjoint set of VMAs' access.
+	 */
+	if (READ_ONCE(current->mm->numa_scan_seq) < 2)
+		return true;
+
+	return test_bit(current->pid % BITS_PER_LONG,
+				&vma->numab_state->access_pids);
+}
+
 /*
  * The expensive part of numa migration is done from task_work context.
  * Triggered from task_tick_numa().
@@ -3046,6 +3061,10 @@ static void task_numa_work(struct callba
 						vma->numab_state->next_scan))
 			continue;
 
+		/* Do not scan the VMA if task has not accessed */
+		if (!vma_is_accessed(vma))
+			continue;
+
 		do {
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
--- a/mm/memory.c~sched-numa-enhance-vma-scanning-logic
+++ a/mm/memory.c
@@ -4661,6 +4661,9 @@ int numa_migrate_prep(struct page *page,
 {
 	get_page(page);
 
+	/* Record the current PID acceesing VMA */
+	vma_set_access_pid_bit(vma);
+
 	count_vm_numa_event(NUMA_HINT_FAULTS);
 	if (page_nid == numa_node_id()) {
 		count_vm_numa_event(NUMA_HINT_FAULTS_LOCAL);
_

Patches currently in -mm which might be from raghavendra.kt@amd.com are


