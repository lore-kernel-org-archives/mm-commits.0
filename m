Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7A21A08AF
	for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2025 23:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755213469; cv=none; b=t4Zb9ArWoybXq6a+5hG+IKSjcrW888DEQP69oZk//orKDONyiLlAWn5lLhFsIa/scfYCsz1KaHJIrwwQlEsyxqq4pH1McXExIrzvAElVba2aqJg78bFmT6ytK8deJCCf/B1/w0HkV79nMlF+tNJq3h7fXVU9oNU3/r9SUF/S1Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755213469; c=relaxed/simple;
	bh=27CFskx8h3NBBRlSNceQ0/H4YuadADIGqAdhH9NAjw8=;
	h=Date:To:From:Subject:Message-Id; b=Qc6/fUWhPprgc1ioJqGvGtDcLT4jBjtBEFCMaxSYEr5jwuTMLFi67Lq6b+wy2EOGOj6ajA9Terj5uxUnAAup8O5qKmnR9tSH/rVAj/sS/sCm/Cv72L+2jK7HhGocWwNhQcofSDF8O3gFdqSlxTBebCrbLZUrkChrNCI12yAADwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nf7PKA6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nf7PKA6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54989C4CEED;
	Thu, 14 Aug 2025 23:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755213469;
	bh=27CFskx8h3NBBRlSNceQ0/H4YuadADIGqAdhH9NAjw8=;
	h=Date:To:From:Subject:From;
	b=Nf7PKA6VWJtLbT2Nauv1YlvZAD/z40bgwoGzs3vFtMVSyM0shHQ9rbzutA4FDCTty
	 LDZ4RxGuq1W713NvCDC9ECcwJrC2dPUxiENTgTie3AIMpmyK8wIeKKG8JLfrreodcd
	 NrVeet0RDRezY9gYtFibU4nwRpe+xQl9LcOHpOjQ=
Date: Thu, 14 Aug 2025 16:17:48 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shakeel.butt@linux.dev,rientjes@google.com,peterz@infradead.org,npache@redhat.com,mingo@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,jsavitz@redhat.com,dvhart@infradead.org,dave@stgolabs.net,andrealmeid@igalia.com,zhongjinji@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_kill-have-the-oom-reaper-and-exit_mmap-traverse-the-maple-tree-in-opposite-orders.patch added to mm-new branch
Message-Id: <20250814231749.54989C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/oom_kill: have the OOM reaper and exit_mmap() traverse the maple tree in opposite orders
has been added to the -mm mm-new branch.  Its filename is
     mm-oom_kill-have-the-oom-reaper-and-exit_mmap-traverse-the-maple-tree-in-opposite-orders.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom_kill-have-the-oom-reaper-and-exit_mmap-traverse-the-maple-tree-in-opposite-orders.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: zhongjinji <zhongjinji@honor.com>
Subject: mm/oom_kill: have the OOM reaper and exit_mmap() traverse the maple tree in opposite orders
Date: Thu, 14 Aug 2025 21:55:55 +0800

When a process is OOM killed, if the OOM reaper and the thread running
exit_mmap() execute at the same time, both will traverse the vma's maple
tree along the same path.  They may easily unmap the same vma, causing
them to compete for the pte spinlock.  This increases unnecessary load,
causing the execution time of the OOM reaper and the thread running
exit_mmap() to increase.

When a process exits, exit_mmap() traverses the vma's maple tree from low
to high address.  To reduce the chance of unmapping the same vma
simultaneously, the OOM reaper should traverse vma's tree from high to low
address.  This reduces lock contention when unmapping the same vma.

Link: https://lkml.kernel.org/r/20250814135555.17493-4-zhongjinji@honor.com
Signed-off-by: zhongjinji <zhongjinji@honor.com>
Cc: Andre Almeida <andrealmeid@igalia.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +++
 mm/oom_kill.c      |    9 +++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-oom_kill-have-the-oom-reaper-and-exit_mmap-traverse-the-maple-tree-in-opposite-orders
+++ a/include/linux/mm.h
@@ -974,6 +974,9 @@ static inline void vma_iter_set(struct v
 #define for_each_vma_range(__vmi, __vma, __end)				\
 	while (((__vma) = vma_find(&(__vmi), (__end))) != NULL)
 
+#define for_each_vma_reverse(__vmi, __vma)					\
+	while (((__vma) = vma_prev(&(__vmi))) != NULL)
+
 #ifdef CONFIG_SHMEM
 /*
  * The vma_is_shmem is not inline because it is used only by slow
--- a/mm/oom_kill.c~mm-oom_kill-have-the-oom-reaper-and-exit_mmap-traverse-the-maple-tree-in-opposite-orders
+++ a/mm/oom_kill.c
@@ -517,7 +517,7 @@ static bool __oom_reap_task_mm(struct mm
 {
 	struct vm_area_struct *vma;
 	bool ret = true;
-	VMA_ITERATOR(vmi, mm, 0);
+	VMA_ITERATOR(vmi, mm, ULONG_MAX);
 
 	/*
 	 * Tell all users of get_user/copy_from_user etc... that the content
@@ -527,7 +527,12 @@ static bool __oom_reap_task_mm(struct mm
 	 */
 	mm_flags_set(MMF_UNSTABLE, mm);
 
-	for_each_vma(vmi, vma) {
+	/*
+	 * When two tasks unmap the same vma at the same time, they may contend for the
+	 * pte spinlock. To avoid traversing the same vma as exit_mmap unmap, traverse
+	 * the vma maple tree in reverse order.
+	 */
+	for_each_vma_reverse(vmi, vma) {
 		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
 			continue;
 
_

Patches currently in -mm which might be from zhongjinji@honor.com are

futex-introduce-function-process_has_robust_futex.patch
mm-oom_kill-only-delay-oom-reaper-for-processes-using-robust-futexes.patch
mm-oom_kill-have-the-oom-reaper-and-exit_mmap-traverse-the-maple-tree-in-opposite-orders.patch

