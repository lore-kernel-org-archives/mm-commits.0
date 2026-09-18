Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14545509EE3
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 15:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746303; cv=none; b=tJtscZuu3GCffqiZEoQ7hanTKJ15sw59bBmTTyCB2zVCkNkObYG2Y45taXHWvVz4oWBU4YJB+EMVYw1w+nS3cgcZKI9KFpqFfAVDpLSCbXgpunRplnrIfLDw24YGCBv9M/taw53BpQZoP2YOvQdIVI0Xuv1kyhVwgpZHEY4+Lgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746303; c=relaxed/simple;
	bh=pQR7YfzboFCScLjKKZRWKZlGAK6Q9SR8tHhwC9KCGyE=;
	h=Date:To:From:Subject:Message-Id; b=ogGlDWSn6zgqgvZj89udenuCQZzbgV2gHjGGRkvVS5UbWUnAMSvFe7YU0k+58AROuq7aYMwE0T44A8C639SCz9jC8REZ92cBYfgdrZDhaM4wTBkDfltbTKGPn5Cdrmman7JG9eHHJDDst6wndgN/1VKRgvVIorUsnQosIAjJHGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q5L9mrw+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q5L9mrw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672BB1F000FF;
	Fri, 18 Sep 2026 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789746300;
	bh=RBWCZMHbYo67lBJbvKe/q01lWEalYXRr9gHU71zo7s8=;
	h=Date:To:From:Subject;
	b=Q5L9mrw+Bc4uhnN4sGrTzI+Bp4BQm5clSuwNL2+wQkeBpysRf9f8Axi4pBPcqAIUJ
	 fT5LaDuz3RP6zC+utuTQQBx9UHYdB6tdox3iQwQJdZowpHeISpLJ3+1BjtUEjCXimi
	 ivADRY7MhsJid/8O88fCdJ+hxGvnjOazhRXOJ3QI=
Date: Fri, 18 Sep 2026 08:44:59 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch added to mm-new branch
Message-Id: <20260918154500.672BB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc/task_mmu: clarify shmem mapping walk conditions in smap_gather_stats()
has been added to the -mm mm-new branch.  Its filename is
     proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch

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
Subject: proc/task_mmu: clarify shmem mapping walk conditions in smap_gather_stats()
Date: Fri, 18 Sep 2026 08:33:14 -0700

smap_gather_stats() optimizes stats gathering by skipping the walk for
shmem mappings in certain conditions.  Update the comment to clarify these
conditions and use vma_is_cow_mapping() for CoW identification instead of
open-coding it.

No functional change intended.

Link: https://lore.kernel.org/20260918153318.758387-4-surenb@google.com
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
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
@@ -1274,23 +1274,18 @@ static void smap_gather_stats(struct pro
 
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

proc-task_mmu-remove-unnecessary-helpers.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch
proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch
proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter.patch
proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch
proc-task_mmu-read-proc-pid-smaps_rollup-under-per-vma-lock.patch
selftests-proc-add-proc-pid-smaps_rollup-tearing-tests.patch

