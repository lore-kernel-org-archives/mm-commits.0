Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAC53F12C4
	for <mm-commits@vger.kernel.org>; Sat, 12 Sep 2026 07:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197902; cv=none; b=qXPT028e2TYSeUHH6yostI/YNgqfulA8Q44uAMcqhuShjuzHLXqosN/ujNKYRXltOlqtf5AkCJ7DPpUviMTAFIr7jAX/MeHGAjYw+JVuFB/8kr1bE2hUiRxmO/8SDm9kgufcW/Lf3f+iBBOR4y9z4vmLJJZkU24kEy6xFrINSy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197902; c=relaxed/simple;
	bh=9mR444a8dq90Zetn7P+auliwxvP1X3xW1L8kDQhgs+w=;
	h=Date:To:From:Subject:Message-Id; b=HxfvRz9C7Z0YR2NlXAoRX/sBqSetUBzxDu2eZsqBLMfUj5RgffdUlsyzb54ayjTnMeIWpHW53lVwPoo/6tcyxjdWpRc41CVR0f2inZTU5+pji+5rmt0m4TNlBKMkJbsEhto+gndrY12AsUH2Q32j2M3mHsdg0cDkNs2ybsa5wl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hMJKyRsB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hMJKyRsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1211F000FF;
	Sat, 12 Sep 2026 07:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789197900;
	bh=wmZSvVXj5XSxsStmSO7Gm2kqehs3GsduWoHjblbPZJw=;
	h=Date:To:From:Subject;
	b=hMJKyRsBZt98r0HgtIyczQ66lU4JoNcrC8CumhaVObDzhNRBhf6JJ6yisI8GMHpDn
	 BG2MgJ/P0PrKpeDxUOK9bNhg4nFA8vTF4MHr9y7Aeq1EzhZzYwohMY1IojVpB3RYU7
	 PVL7Mai8B8PwL5M9w/cR6ZH68TGUpOKljA+E/mV8=
Date: Sat, 12 Sep 2026 00:25:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,usama.arif@linux.dev,pfalcato@suse.de,paulmck@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch added to mm-new branch
Message-Id: <20260912072500.6B1211F000FF@smtp.kernel.org>
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
@@ -1270,23 +1270,18 @@ static void smap_gather_stats(struct pro
 
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

