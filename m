Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FCE1E47CC
	for <mm-commits@vger.kernel.org>; Wed, 14 Oct 2026 21:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792012603; cv=none; b=OInTfMlv1KTaPLwtqNQEE8RF/fbp0QGK5Ka/MIPNJOzbJrLC9CyXbEL+bYCuyCIDTGbojJ6t1ZlMquaR7J3On56ioIpE1DsicbQiyQB1tzaon3I5Xu3BPdnQUN6dnr7IXHqPnjn9VP1a837jIm6mBivgPV+I73PkZsFWp4vjp54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792012603; c=relaxed/simple;
	bh=+6cqnQkahs32vyXxZ/8YVCfzqfAAhFGIX/DIw3bdF/U=;
	h=Date:To:From:Subject:Message-Id; b=XLAbrjJemXB+kfqPYeI5vYtOrUODhBtrzBOyjGTYLEK2oBQ0f/vu9Rg5XHeQ+qfc4tWCLTM9qGKmXu7tDTW8jZYj+B6aMqJA9RpmGK4ze6nEY5y1dKdYyY9o8og6L29d+eGv/+ol8Hs5STlJDBRN1nEah01axN+GpGFSEs18d64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RgUNdyeV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RgUNdyeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258501F000C4;
	Wed, 14 Oct 2026 21:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792012602;
	bh=3/+9WY4ezJ3r/RgRnHekmJ98mTc/6BEiNKj0gMnor04=;
	h=Date:To:From:Subject;
	b=RgUNdyeVw0toq/Or21JtwZknt+GQgLREv3va3lGZIQNM+6TbBTM/Mjc84RS/Ap9an
	 odvph7NH19DPabsJ59oSYDBRMKW0CtAHgqNkei4thIbzdQ/RY6H/uYs/2lVptYlvwd
	 TV55kKYT3moEqntC7Qaaqqh9ksY+qYuHkoi9Cdbk=
Date: Wed, 14 Oct 2026 14:16:41 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch added to mm-unstable branch
Message-Id: <20261014211642.258501F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
Date: Wed, 14 Oct 2026 18:11:34 +0100

Patch series "mm/collapse: separate a collapse from its callers", v5.

There is no line between the collapse engine and the callers that ask for
a collapse.  khugepaged.c holds both, and they reach into each other.

 - Sixteen tests through the collapse path read cc->is_khugepaged to work
   out what they are allowed to do, when every one of those decisions was
   made by the caller before it asked.

 - collapse_single_pmd() does both halves of a collapse behind one call.
   Where it gives up mmap_lock between them is buried in the anonymous
   scan on one side and ahead of the file scan on the other.

Start drawing the line.  The caller states what it allows in a policy,
and the collapse code reads the policy instead of asking who called.  The
scan of a PTE table and the collapse that follows get a function each,
with the mmap_lock drop between them in one place.


This patch (of 9):

madvise_collapse() holds an mmgrab() reference across its work. It is
redundant. Every caller already holds mm_users:

 - madvise(2) works on current->mm, which lives as long as the task is in
   the syscall;
 - process_madvise(2) reaches a remote mm through mm_access(), which takes
   an mm_users reference and holds it until the syscall returns;
 - io_uring passes current->mm;
 - DAMON takes one with get_task_mm() and drops it after the call.

Drop the mmgrab()/mmdrop() pair.

Link: https://lore.kernel.org/20261014171145.3292736-1-kas@kernel.org
Link: https://lore.kernel.org/20261014171145.3292736-2-kas@kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
---

 mm/khugepaged.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse
+++ a/mm/khugepaged.c
@@ -3259,7 +3259,6 @@ int madvise_collapse(struct vm_area_stru
 	cc->is_khugepaged = false;
 	cc->progress = 0;
 
-	mmgrab(mm);
 	lru_add_drain_all();
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
@@ -3315,7 +3314,6 @@ out_maybelock:
 	}
 out_nolock:
 	mmap_assert_locked(mm);
-	mmdrop(mm);
 	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch

