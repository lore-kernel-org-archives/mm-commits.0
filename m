Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D4A4FE2C6
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 16:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662177; cv=none; b=At9RuxtkUyWngOsMGYZHQBmfdvV0khv9K2b24Tqwipz30PASu/za9DWTvHL3K3W/stIM0ODrCDQi0dVAu1HWPhlm1VkIp+3nuTP5rHTcBWOJ3hS+gkc7PRiXcOHw2KTlV+10UVy/Hdp2UO7sPnJqrKZYd1StWrOuI4Uhbf8CFGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662177; c=relaxed/simple;
	bh=EMjZvDYHwXVMSFQJPd2X26Sn2c14E9J4VC5jV9HlsuM=;
	h=Date:To:From:Subject:Message-Id; b=faCt9VqDuGgzEJUmn54qRF5ihP07U49oYzfTk0ga6zTuHi4Mcrz/Uz4N194n1WMnXad7N2jaoc4gZIDBIhXJXo/bTb4jhAyMGALMpk7uuVQ+odbjhqApL6b/2fnH8s5V4Rri10MofOUO/YEdECuDSq7kB9xLOGWPzFWH3gxcSTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ax4oZP2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ax4oZP2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD2A1F000FF;
	Thu, 17 Sep 2026 16:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789662175;
	bh=DlUdUA3XTRGFwMNpdgeo4T4nIgLChFdQwl/O2XClwHk=;
	h=Date:To:From:Subject;
	b=ax4oZP2SS34UtAgvbGdNjJ8P05qwDYRewE3EqjPa/CirmiibYAIc7kVCN+UYIsl/W
	 tFYRFpPbRSI2fhH8LgBq+68nfbYGPhpmETqN2LRBG1kYXuVCh/0/cDVnlp/FRHGcUn
	 R594udA9TpW3/BKXkJbM/3bvW7Q5855rUtSzyuqQ=
Date: Thu, 17 Sep 2026 09:22:55 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch removed from -mm tree
Message-Id: <20260917162255.ABD2A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc/task_mmu: clarify shmem mapping walk conditions in smap_gather_stats()
has been removed from the -mm tree.  Its filename was
     proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: proc/task_mmu: clarify shmem mapping walk conditions in smap_gather_stats()
Date: Fri, 11 Sep 2026 12:41:41 -0700

smap_gather_stats() optimizes stats gathering by skipping the walk for
shmem mappings in certain conditions.  Update the comment to clarify these
conditions and use vma_is_cow_mapping() for CoW identification instead of
open-coding it.

No functional change intended.

Link: https://lore.kernel.org/20260911194145.1781926-4-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 fs/proc/task_mmu.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats
+++ a/fs/proc/task_mmu.c
@@ -1272,23 +1272,18 @@ static void smap_gather_stats(struct pro
 
 	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
 		/*
-		 * For shared or readonly shmem mappings we know that all
-		 * swapped out pages belong to the shmem object, and we can
-		 * obtain the swap value much more efficiently. For private
-		 * writable mappings, we might have COW pages that are
-		 * not affected by the parent swapped out pages of the shmem
-		 * object, so we have to distinguish them during the page walk.
-		 * Unless we know that the shmem object (or the part mapped by
-		 * our VMA) has no swapped out pages at all.
+		 * CoW mappings might map anon folios that do not belong to
+		 * shmem. Perform a less efficient page table walk in this
+		 * situation, unless we know that the shmem object (or the
+		 * part mapped by our VMA) has no swapped out pages at all.
 		 */
-		unsigned long shmem_swapped = shmem_swap_usage(vma);
+		const unsigned long shmem_swapped = shmem_swap_usage(vma);
+		const bool is_cow = vma_is_cow_mapping(vma);
 
-		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
-					!(vma->vm_flags & VM_WRITE))) {
-			mss->swap += shmem_swapped;
-		} else {
+		if (start || (shmem_swapped && is_cow))
 			ops = get_smaps_shmem_walk_ops(priv);
-		}
+		else
+			mss->swap += shmem_swapped;
 	}
 
 	if (!start)
_

Patches currently in -mm which might be from surenb@google.com are

proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter.patch
proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch
proc-task_mmu-read-proc-pid-smaps_rollup-under-per-vma-lock.patch
selftests-proc-add-proc-pid-smaps_rollup-tearing-tests.patch

