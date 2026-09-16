Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFFD45FFA8
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 22:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789598529; cv=none; b=K3B05uF/ox2xdhfMUIaIar8C42VWW+BVCwQQ6Uqb9rEHTZYAvq4NwWvwayg572IHyLFg8EmVzvtifmGhj4tqpy5L2uTAFEWdmWk4x9JdqWTnI+EnOeFeMdypA5IeiNHOjUD39rJu/IJQ1mxhdEH7kbZny5zaer52Bz6taDS28Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789598529; c=relaxed/simple;
	bh=MUCHiGSGkz27HkVEz+lHL0ofda9jRWo2r6WOuXzxuak=;
	h=Date:To:From:Subject:Message-Id; b=W2F6CNfyJaXYSENLc0ino0hzMEBjKiipbBmbUD8Kws2Hkwr3xF6+coHqOVTIQ8n1vv1a3zsxE+LG9vO4QZ/S4BsRSQBGoNZ/IMQkwLqFgInvY8gGu1Yode5xuET9edS4oyPhjXiyYadbg9+YsdQL5NqEESxRtKUSne9KN2GYoyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nbrwka2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nbrwka2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD4C1F000FF;
	Wed, 16 Sep 2026 22:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789598515;
	bh=mY+9PmQ6axB2l4ofNpwwvZ48UCgkf2uwBwnZGUwjafE=;
	h=Date:To:From:Subject;
	b=nbrwka2hD/EizUPmVXrRQm2SAarQ4dWfFl91wncCVEU8111LMACE1h4WBS7x0BfKU
	 vGjDt2bnSt7xL9bJixh8uinU4PmeWcnbYy0IPEjR8ua32xaCKDzG+kUkPFa3HJVxDh
	 p+S5mqxXsmeCosYpaDoiYW96VWMDjEi0XsNzdhys=
Date: Wed, 16 Sep 2026 15:41:54 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch removed from -mm tree
Message-Id: <20260916224154.DDD4C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
Date: Thu, 10 Sep 2026 13:02:21 +0100

Patch series "mm/collapse: separate a collapse from its callers", v2.

There is no line between the collapse engine and the callers that ask for
a collapse.  khugepaged.c holds both, and they reach into each other.

 - Sixteen tests through the collapse path read cc->is_khugepaged to work
   out what they are allowed to do, when every one of those decisions was
   made by the caller before it asked.

 - collapse_single_pmd() does both halves of a collapse behind one call and
   drops mmap_lock somewhere in the middle.  Which of its paths dropped it
   is not something a caller can see, so it hands back a bool and the
   caller keeps track.

 - MADV_COLLAPSE's implementation -- the walk over the user's range, the
   per-PMD loop, the errno translation -- sits in khugepaged.c, which is
   the daemon's file.

So: draw the line.  State what a caller allows in a policy, split the call
in two with the lock as the boundary, and move the syscall to madvise.c. 
What the engine offers is then four calls, with the lock state written
down against each, and a policy the caller fills for itself:

    collapse_control_init(cc)         once, before the first table
    collapse_policy_*(&cc->policy)    what this caller allows
    collapse_scan_pmd(vma, addr, ...) per table, under mmap_lock
    collapse_run_pmd(mm, addr, cc)    when a scan found work, no mmap_lock
    collapse_control_release(cc)      once, when done

The engine stays in khugepaged.c for now; what changes is that it has an
interface, and that neither half has to ask about the other.  madvise.c
gains the operation it should have had all along.


This patch (of 12):

madvise_collapse() holds an mmgrab() reference across its work.  It is
redundant.  Every caller already holds mm_users:

 - madvise(2) works on current->mm, which lives as long as the task is in
   the syscall;
 - process_madvise(2) reaches a remote mm through mm_access(), which takes
   an mm_users reference and holds it until the syscall returns;
 - io_uring passes current->mm;
 - DAMON takes one with get_task_mm() and drops it after the call.

Drop the mmgrab()/mmdrop() pair.

Assisted-by: LLM
Link: https://lore.kernel.org/20260910120238.2529819-1-kirill@shutemov.name
Link: https://lore.kernel.org/20260910120238.2529819-2-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/khugepaged.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse
+++ a/mm/khugepaged.c
@@ -3222,7 +3222,6 @@ int madvise_collapse(struct vm_area_stru
 	cc->is_khugepaged = false;
 	cc->progress = 0;
 
-	mmgrab(mm);
 	lru_add_drain_all();
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
@@ -3278,7 +3277,6 @@ out_maybelock:
 	}
 out_nolock:
 	mmap_assert_locked(mm);
-	mmdrop(mm);
 	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
mm-huge_memory-add-folio_reset_partially_mapped.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch
a.patch

