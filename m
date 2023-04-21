Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B96AFC77B7E
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjDUVx1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbjDUVxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:53:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9F830C1
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D5D961363
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C1EC4339B;
        Fri, 21 Apr 2023 21:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113975;
        bh=gGOAo+IRxzpaJVkmO7teH3aFHlVqkbT7Z926WsV/jL8=;
        h=Date:To:From:Subject:From;
        b=URNtK0kssI1YxzzWzoCeHFSXVnC1Ma2V6DS1ZvJum90ykc9yqnSIK28j9Amxa476B
         y1wCwpSNyl4XqcfpzXxHDVGYl8xOemHM37rcxPoB2kB79uR5Acr79HCxLUwMKIYhgM
         fT91lsUfwa3F9Y/yn9ms08PH5bXhiP/NjDAl5xvs=
Date:   Fri, 21 Apr 2023 14:52:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        punit.agrawal@bytedance.com, peterx@redhat.com, minchan@google.com,
        michel@lespinasse.org, mhocko@suse.com, lstoakes@gmail.com,
        Liam.Howlett@Oracle.com, ldufour@linux.ibm.com,
        josef@toxicpanda.com, jack@suse.cz, hannes@cmpxchg.org,
        dave@stgolabs.net, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-do-not-increment-pgfault-stats-when-page-fault-handler-retries.patch removed from -mm tree
Message-Id: <20230421215255.03C1EC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: do not increment pgfault stats when page fault handler retries
has been removed from the -mm tree.  Its filename was
     mm-do-not-increment-pgfault-stats-when-page-fault-handler-retries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: do not increment pgfault stats when page fault handler retries
Date: Wed, 19 Apr 2023 10:58:36 -0700

If the page fault handler requests a retry, we will count the fault
multiple times.  This is a relatively harmless problem as the retry paths
are not often requested, and the only user-visible problem is that the
fault counter will be slightly higher than it should be.  Nevertheless,
userspace only took one fault, and should not see the fact that the kernel
had to retry the fault multiple times.

Move page fault accounting into mm_account_fault() and skip incomplete
faults which will be accounted upon completion.

Link: https://lkml.kernel.org/r/20230419175836.3857458-1-surenb@google.com
Fixes: d065bd810b6d ("mm: retry page fault when blocking on disk transfer")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

--- a/mm/memory.c~mm-do-not-increment-pgfault-stats-when-page-fault-handler-retries
+++ a/mm/memory.c
@@ -5104,24 +5104,31 @@ retry_pud:
  * updates.  However, note that the handling of PERF_COUNT_SW_PAGE_FAULTS should
  * still be in per-arch page fault handlers at the entry of page fault.
  */
-static inline void mm_account_fault(struct pt_regs *regs,
+static inline void mm_account_fault(struct mm_struct *mm, struct pt_regs *regs,
 				    unsigned long address, unsigned int flags,
 				    vm_fault_t ret)
 {
 	bool major;
 
+	/* Incomplete faults will be accounted upon completion. */
+	if (ret & VM_FAULT_RETRY)
+		return;
+
+	/*
+	 * To preserve the behavior of older kernels, PGFAULT counters record
+	 * both successful and failed faults, as opposed to perf counters,
+	 * which ignore failed cases.
+	 */
+	count_vm_event(PGFAULT);
+	count_memcg_event_mm(mm, PGFAULT);
+
 	/*
-	 * We don't do accounting for some specific faults:
-	 *
-	 * - Unsuccessful faults (e.g. when the address wasn't valid).  That
-	 *   includes arch_vma_access_permitted() failing before reaching here.
-	 *   So this is not a "this many hardware page faults" counter.  We
-	 *   should use the hw profiling for that.
-	 *
-	 * - Incomplete faults (VM_FAULT_RETRY).  They will only be counted
-	 *   once they're completed.
+	 * Do not account for unsuccessful faults (e.g. when the address wasn't
+	 * valid).  That includes arch_vma_access_permitted() failing before
+	 * reaching here. So this is not a "this many hardware page faults"
+	 * counter.  We should use the hw profiling for that.
 	 */
-	if (ret & (VM_FAULT_ERROR | VM_FAULT_RETRY))
+	if (ret & VM_FAULT_ERROR)
 		return;
 
 	/*
@@ -5204,21 +5211,22 @@ static vm_fault_t sanitize_fault_flags(s
 vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 			   unsigned int flags, struct pt_regs *regs)
 {
+	/* If the fault handler drops the mmap_lock, vma may be freed */
+	struct mm_struct *mm = vma->vm_mm;
 	vm_fault_t ret;
 
 	__set_current_state(TASK_RUNNING);
 
-	count_vm_event(PGFAULT);
-	count_memcg_event_mm(vma->vm_mm, PGFAULT);
-
 	ret = sanitize_fault_flags(vma, &flags);
 	if (ret)
-		return ret;
+		goto out;
 
 	if (!arch_vma_access_permitted(vma, flags & FAULT_FLAG_WRITE,
 					    flags & FAULT_FLAG_INSTRUCTION,
-					    flags & FAULT_FLAG_REMOTE))
-		return VM_FAULT_SIGSEGV;
+					    flags & FAULT_FLAG_REMOTE)) {
+		ret = VM_FAULT_SIGSEGV;
+		goto out;
+	}
 
 	/*
 	 * Enable the memcg OOM handling for faults triggered in user
@@ -5247,8 +5255,8 @@ vm_fault_t handle_mm_fault(struct vm_are
 		if (task_in_memcg_oom(current) && !(ret & VM_FAULT_OOM))
 			mem_cgroup_oom_synchronize(false);
 	}
-
-	mm_account_fault(regs, address, flags, ret);
+out:
+	mm_account_fault(mm, regs, address, flags, ret);
 
 	return ret;
 }
_

Patches currently in -mm which might be from surenb@google.com are


