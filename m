Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E661F4168
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 05:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755323955; cv=none; b=fLxQO3a1NezESXYhZ49Ujav2zwimQhK97hGQAptfqrG6vGLtrrPfY5A/5rMjORSvpm052Ev4V1RsKrD8mEbO+PUazkeF/oeGqMmMuo/zJLNLy4mWEki9j0YPUVcomp16ZBtOt7/v0qkKjrUAm4GGz+fCQrjHAnmSzUAdGpNpJw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755323955; c=relaxed/simple;
	bh=99C+bHhcx9g3mNyJaxTlggSxskjIcqFf9UkY49mnMe4=;
	h=Date:To:From:Subject:Message-Id; b=b6XPty/5gS3WQ/nXtQCaH/K4ld+5A9PZBzj5hf/O9oZhFpOGJMHYUIqsDzR5zCBbiiHM/9u6bC4QijEu1QSNZ5KKY+bajzW2PqKvzC9WbOUG4EtcpUVLh6OzfmB9GNIr+l2S9u82nO9Gpy3Snqlzq+c1tH+MahL+5vybzsZgfZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eAmMMuzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eAmMMuzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E471BC4CEEF;
	Sat, 16 Aug 2025 05:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755323954;
	bh=99C+bHhcx9g3mNyJaxTlggSxskjIcqFf9UkY49mnMe4=;
	h=Date:To:From:Subject:From;
	b=eAmMMuzhKllmlKit23UJfZ2lO9j+1ao+yXU68c/G4JWrAr5wHjExnmTe0dR/Y0ccw
	 0VFYtSpIZwQzygYFQOwhgsH4Z1sA3gLmutwvqAnfItwL0DI1mpz8ZYa6XoCuM0w0Iw
	 HVR0q/KjsRS3xO56jNpR+vCsL3B9DNX9cg4RHZCk=
Date: Fri, 15 Aug 2025 22:59:13 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,shakeel.butt@linux.dev,rientjes@google.com,peterz@infradead.org,npache@redhat.com,mingo@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,jsavitz@redhat.com,dvhart@infradead.org,dave@stgolabs.net,andrealmeid@igalia.com,zhongjinji@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-oom_kill-have-the-oom-reaper-and-exit_mmap-traverse-the-maple-tree-in-opposite-orders.patch removed from -mm tree
Message-Id: <20250816055913.E471BC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/oom_kill: have the OOM reaper and exit_mmap() traverse the maple tree in opposite orders
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-have-the-oom-reaper-and-exit_mmap-traverse-the-maple-tree-in-opposite-orders.patch

This patch was dropped because an updated version will be issued

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

