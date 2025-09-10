Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D281DDDD
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 05:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757480826; cv=none; b=pEBAo8+okFvu0ZY5Z0J3zEGfi1hb83u0oHcKtpAQE3n7/gemlRxpeyMuJi+b/0E+hYsCve5favcQXswlkSDX4Ik7NkVv+oyrzh9FcGqUneeA9wRCfanmYDhlJtH824sjFeaKLfT4E7cYQMrcMPQjrJI3o4jJ6gB98q0TRDsqBA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757480826; c=relaxed/simple;
	bh=ovEwPQ04/j2Z0UvVFcm6nZmbsEcigiej5CQBtg6m7lM=;
	h=Date:To:From:Subject:Message-Id; b=qf+VQd7Qw78PMlhGFMg02NAtPSJxtazezfo/GeiXlVP6sONofmwuMY6jnyOalc7kdUOnYfEUIuRxrnuvy2lRIDHvvDoB5LqOAgNArDqoH2FSh4eSBB4CXjJqTy+lVF6MFm4wT/R5ck+WfvV3SK2beEuam61tGaJubV6M6MDC7eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZQe2rtS5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZQe2rtS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BF4C4CEF0;
	Wed, 10 Sep 2025 05:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757480826;
	bh=ovEwPQ04/j2Z0UvVFcm6nZmbsEcigiej5CQBtg6m7lM=;
	h=Date:To:From:Subject:From;
	b=ZQe2rtS5Rhl8bOysLr45n0MeLlXubPdwwb8pW3jkCRKECt+WPS+GptVAAm3y6mw3G
	 RwqDfwhQMFgeZSXE4uQo5RKK94/yVdO+Vtn8vHWCZvb/XJrLXmNEhqlf8iG6li9+6s
	 7mms1+86ulBonM0Mo5Nau9pJdY4qw1wcAW46yUR0=
Date: Tue, 09 Sep 2025 22:07:05 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,surenb@google.com,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lenb@kernel.org,zhongjinji@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_kill-the-oom-reaper-traverses-the-vma-maple-tree-in-reverse-order.patch added to mm-new branch
Message-Id: <20250910050705.F1BF4C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/oom_kill: the OOM reaper traverses the VMA maple tree in reverse order
has been added to the -mm mm-new branch.  Its filename is
     mm-oom_kill-the-oom-reaper-traverses-the-vma-maple-tree-in-reverse-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom_kill-the-oom-reaper-traverses-the-vma-maple-tree-in-reverse-order.patch

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
Subject: mm/oom_kill: the OOM reaper traverses the VMA maple tree in reverse order
Date: Tue, 9 Sep 2025 17:06:59 +0800

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

The test is based on arm64.

Without the patch:
|--99.57%-- oom_reaper
|    |--0.28%-- [hit in function]
|    |--73.58%-- unmap_page_range
|    |    |--8.67%-- [hit in function]
|    |    |--41.59%-- __pte_offset_map_lock
|    |    |--29.47%-- folio_remove_rmap_ptes
|    |    |--16.11%-- tlb_flush_mmu
|    |    |--1.66%-- folio_mark_accessed
|    |    |--0.74%-- free_swap_and_cache_nr
|    |    |--0.69%-- __tlb_remove_folio_pages
|    |--19.94%-- tlb_finish_mmu
|    |--3.21%-- folio_remove_rmap_ptes
|    |--1.16%-- __tlb_remove_folio_pages
|    |--1.16%-- folio_mark_accessed
|    |--0.36%-- __pte_offset_map_lock

With the patch:
|--99.53%-- oom_reaper
|    |--55.77%-- unmap_page_range
|    |    |--20.49%-- [hit in function]
|    |    |--58.30%-- folio_remove_rmap_ptes
|    |    |--11.48%-- tlb_flush_mmu
|    |    |--3.33%-- folio_mark_accessed
|    |    |--2.65%-- __tlb_remove_folio_pages
|    |    |--1.37%-- _raw_spin_lock
|    |    |--0.68%-- __mod_lruvec_page_state
|    |    |--0.51%-- __pte_offset_map_lock
|    |--32.21%-- tlb_finish_mmu
|    |--6.93%-- folio_remove_rmap_ptes
|    |--1.90%-- __tlb_remove_folio_pages
|    |--1.55%-- folio_mark_accessed
|    |--0.69%-- __pte_offset_map_lock

Link: https://lkml.kernel.org/r/20250909090659.26400-4-zhongjinji@honor.com
Signed-off-by: zhongjinji <zhongjinji@honor.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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

mm-oom_kill-the-oom-reaper-traverses-the-vma-maple-tree-in-reverse-order.patch

