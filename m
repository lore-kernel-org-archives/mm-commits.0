Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7797C2C11E5
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490008; cv=none; b=WeClFkkcvFIhj4LnSSldJfYTJCjEDvu2KypMncREr0/97dhoILqv7dlaVIVgD+9rXMnObffGnuYAmoqgPBow3M2/rdNZRN2T4ccaQ5iJz6vUWiATESt2GVPCxbV65hBf3TV2fya4S6tXSIPEuf+AdovSkb2z1cdSaldw+SB1hFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490008; c=relaxed/simple;
	bh=sQeTOUiVOw29PpNON9rGFKk+w6+6ndbu+u1o/d1Ilo0=;
	h=Date:To:From:Subject:Message-Id; b=HNv2FPJqW/DLVdo2dQFh0spwBnMmK0U9ypWeo0bL3mxlvwsUyXjIVYz5JLCmNSos+wKuqoy7ZASt85AvHvNXN24F05+N+H9118K4mVm2eSvidD9XGq5Sbcw9Flb0nVseLtRMS4fJzlTWCQk7t1NUF/tYjF8a1/bu6PMCd0U+AMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rlasRjrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rlasRjrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E626C4CEE7;
	Sun, 21 Sep 2025 21:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490008;
	bh=sQeTOUiVOw29PpNON9rGFKk+w6+6ndbu+u1o/d1Ilo0=;
	h=Date:To:From:Subject:From;
	b=rlasRjrcKBnhAKH4Hp9RBPlTHudpKWW7uKxQQ/1S7L0j+xqvgLVMRNGcDYndZEaQP
	 tJqzeMS7zBS1/C8wFBtPFj1l8qL940HpNLIbcNnM6kotLxtjkatOBxG/YKWvDtZUsn
	 0x4EX00A0owNTkL7TLoQ+/pq6Wdwbt8cIcyxxe80=
Date: Sun, 21 Sep 2025 14:26:47 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,surenb@google.com,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lenb@kernel.org,zhongjinji@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-oom_kill-the-oom-reaper-traverses-the-vma-maple-tree-in-reverse-order.patch removed from -mm tree
Message-Id: <20250921212648.4E626C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/oom_kill: the OOM reaper traverses the VMA maple tree in reverse order
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-the-oom-reaper-traverses-the-vma-maple-tree-in-reverse-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhongjinji <zhongjinji@honor.com>
Subject: mm/oom_kill: the OOM reaper traverses the VMA maple tree in reverse order
Date: Tue, 16 Sep 2025 00:29:46 +0800

Although the oom_reaper is delayed and it gives the oom victim chance to
clean up its address space this might take a while especially for
processes with a large address space footprint.  In those cases oom_reaper
might start racing with the dying task and compete for shared resources -
e.g.  page table lock contention has been observed.

Reduce those races by reaping the oom victim from the other end of the
address space.

It is also a significant improvement for process_mrelease().  When a
process is killed, process_mrelease is used to reap the killed process and
often runs concurrently with the dying task.  The test data shows that
after applying the patch, lock contention is greatly reduced during the
procedure of reaping the killed process.

The test is conducted on arm64.  The following basic perf numbers show
that applying this patch significantly reduces pte spin lock contention.

Without the patch:
|--99.57%-- oom_reaper
|    |--73.58%-- unmap_page_range
|    |    |--8.67%-- [hit in function]
|    |    |--41.59%-- __pte_offset_map_lock
|    |    |--29.47%-- folio_remove_rmap_ptes
|    |    |--16.11%-- tlb_flush_mmu
|    |--19.94%-- tlb_finish_mmu
|    |--3.21%-- folio_remove_rmap_ptes

With the patch:
|--99.53%-- oom_reaper
|    |--55.77%-- unmap_page_range
|    |    |--20.49%-- [hit in function]
|    |    |--58.30%-- folio_remove_rmap_ptes
|    |    |--11.48%-- tlb_flush_mmu
|    |    |--3.33%-- folio_mark_accessed
|    |--32.21%-- tlb_finish_mmu
|    |--6.93%-- folio_remove_rmap_ptes
|    |--0.69%-- __pte_offset_map_lock

Detailed breakdowns for both scenarios are provided below.  The cumulative
time for oom_reaper plus exit_mmap(victim) in both cases is also
summarized, making the performance improvements clear.

+----------------------------------------------------------------+
| Category                      | Applying patch | Without patch |
+-------------------------------+----------------+---------------+
| Total running time            |    132.6       |    167.1      |
|   (exit_mmap + reaper work)   |  72.4 + 60.2   |  90.7 + 76.4  |
+-------------------------------+----------------+---------------+
| Time waiting for pte spinlock |     1.0        |    33.1       |
|   (exit_mmap + reaper work)   |   0.4 + 0.6    |  10.0 + 23.1  |
+-------------------------------+----------------+---------------+
| folio_remove_rmap_ptes time   |    42.0        |    41.3       |
|   (exit_mmap + reaper work)   |  18.4 + 23.6   |  22.4 + 18.9  |
+----------------------------------------------------------------+

From this report, we can see that:

1. The reduction in total time comes mainly from the decrease in time
   spent on pte spinlock and other locks.

2. oom_reaper performs more work in some areas, but at the same time,
   exit_mmap also handles certain tasks more efficiently, such as
   folio_remove_rmap_ptes.

Here is a more detailed perf report. [1]

Link: https://lkml.kernel.org/r/20250915162946.5515-3-zhongjinji@honor.com
Link: https://lore.kernel.org/all/20250915162619.5133-1-zhongjinji@honor.com/ [1]
Signed-off-by: zhongjinji <zhongjinji@honor.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-the-oom-reaper-traverses-the-vma-maple-tree-in-reverse-order
+++ a/mm/oom_kill.c
@@ -516,7 +516,7 @@ static bool __oom_reap_task_mm(struct mm
 {
 	struct vm_area_struct *vma;
 	bool ret = true;
-	VMA_ITERATOR(vmi, mm, 0);
+	MA_STATE(mas, &mm->mm_mt, ULONG_MAX, ULONG_MAX);
 
 	/*
 	 * Tell all users of get_user/copy_from_user etc... that the content
@@ -526,7 +526,13 @@ static bool __oom_reap_task_mm(struct mm
 	 */
 	mm_flags_set(MMF_UNSTABLE, mm);
 
-	for_each_vma(vmi, vma) {
+	/*
+	 * It might start racing with the dying task and compete for shared
+	 * resources - e.g. page table lock contention has been observed.
+	 * Reduce those races by reaping the oom victim from the other end
+	 * of the address space.
+	 */
+	mas_for_each_rev(&mas, vma, 0) {
 		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
 			continue;
 
_

Patches currently in -mm which might be from zhongjinji@honor.com are


