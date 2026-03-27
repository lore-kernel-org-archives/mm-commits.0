Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004C637F8A3
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 19:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774641403; cv=none; b=jQlnslotLf02is2NmXuLDzMTUsbFzoEjJonhXDxv9LjAWtEhnAnX7dNNgRfrGcKR5WfNeIHqMB7RfdIMiSWfB/9Rn0RSZDPuHMbAo5xf1WVdoFGEMCpjEQ53r4zUB++p5YL2V9a0rZv+k4b15lXsTzq6XFp4+Z/VLLyO1D72XGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774641403; c=relaxed/simple;
	bh=BrdE4kFygf/lJ87ljNfT37/4wHG2/yZhNuJBwsjeMno=;
	h=Date:To:From:Subject:Message-Id; b=cO4eiQQpBvD2Pn1m6Lx+OLEj9cq1Femi+WrFvd7TIb9+UQwZg2D7IU+ZBcXBNbV4k+sPVr+dAxvn50Sy2c3w03jW9ZvWPNqrp0inwCaegzdv4a3bs2SjAX+q3hLwNc5w+gbkpDqura7zoXbK91/VEqr/adoilAdLptUQDgf6rVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oe752e+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oe752e+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD69C19423;
	Fri, 27 Mar 2026 19:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774641402;
	bh=BrdE4kFygf/lJ87ljNfT37/4wHG2/yZhNuJBwsjeMno=;
	h=Date:To:From:Subject:From;
	b=Oe752e+2mLamn2QvbDPrGMFSfk1Z7Di5269zR60VUBeEJMBzz2m9Z3BRcgveIImvT
	 zXkhMFKxBT0VEVu1DgPqkbk8BArhJxm/Di1jW+IELIWOfDAjwJcwxkBVNR/p1lw9RP
	 dYPYSUDEmnXJ8u9t/vH+ysb8U1pGzp/KgBvasNSw=
Date: Fri, 27 Mar 2026 12:56:42 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuzhao@google.com,yuanchu@google.com,willy@infradead.org,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,kaleshsingh@google.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-prevent-mglru-reclaim-from-pinning-address-space.patch added to mm-new branch
Message-Id: <20260327195642.8AD69C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: prevent MGLRU reclaim from pinning address space
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-prevent-mglru-reclaim-from-pinning-address-space.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-prevent-mglru-reclaim-from-pinning-address-space.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/vmscan: prevent MGLRU reclaim from pinning address space
Date: Sun, 22 Mar 2026 00:08:43 -0700

When shrinking lruvec, MGLRU pins address space before walking it.  This
is excessive since all it needs for walking the page range is a stable
mm_struct to be able to take and release mmap_read_lock and a stable
mm->mm_mt tree to walk.  This address space pinning results in delays when
releasing the memory of a dying process.  This also prevents mm reapers
(both in-kernel oom-reaper and userspace process_mrelease()) from doing
their job during MGLRU scan because they check task_will_free_mem() which
will yield negative result due to the elevated mm->mm_users.

Replace unnecessary address space pinning with mm_struct pinning by
replacing mmget/mmput with mmgrab/mmdrop calls.  mm_mt is contained within
mm_struct itself, therefore it won't be freed as long as mm_struct is
stable and it won't change during the walk because mmap_read_lock is being
held.

Link: https://lkml.kernel.org/r/20260322070843.941997-1-surenb@google.com
Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-prevent-mglru-reclaim-from-pinning-address-space
+++ a/mm/vmscan.c
@@ -2863,8 +2863,9 @@ static struct mm_struct *get_next_mm(str
 		return NULL;
 
 	clear_bit(key, &mm->lru_gen.bitmap);
+	mmgrab(mm);
 
-	return mmget_not_zero(mm) ? mm : NULL;
+	return mm;
 }
 
 void lru_gen_add_mm(struct mm_struct *mm)
@@ -3064,7 +3065,7 @@ done:
 		reset_bloom_filter(mm_state, walk->seq + 1);
 
 	if (*iter)
-		mmput_async(*iter);
+		mmdrop(*iter);
 
 	*iter = mm;
 
_

Patches currently in -mm which might be from surenb@google.com are

mm-vma-cleanup-error-handling-path-in-vma_expand.patch
mm-use-vma_start_write_killable-in-mm-syscalls.patch
mm-khugepaged-use-vma_start_write_killable-in-collapse_huge_page.patch
mm-vma-use-vma_start_write_killable-in-vma-operations.patch
mm-use-vma_start_write_killable-in-process_vma_walk_lock.patch
kvm-ppc-use-vma_start_write_killable-in-kvmppc_memslot_page_merge.patch
mm-vmscan-prevent-mglru-reclaim-from-pinning-address-space.patch

