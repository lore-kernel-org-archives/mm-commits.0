Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBF552CCC6
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 18:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791915963; cv=none; b=To7RiJxroX7oV2OGUVRrm1AW2ISHfAkkT84Y+KedIRSbXhuFUMlrrknEzXCZu9LlIsv1vXUoLa4I0Tpq092CGxQwuJmQQJbGKIpkIAGKiOJDPgJxuoGeoAJnQfP9gAu6zsH1qRGCteMlmO0DHrpUyLQ9I89jeDr+TmIIJO0FKBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791915963; c=relaxed/simple;
	bh=jozNAaOxQxGph0EARApP3TVWtG3Gx6qpKRN3A2V+3AI=;
	h=Date:To:From:Subject:Message-Id; b=VFqrM6NDnitQIL1cxRMLzmb5YO+MSuQPwGoTT9++bcgH+8b/ngSFNI7vfoiNunN7KzscqD6HNdySjiEgbb5azvssw/0CrOrwCOAkmCfRFHkzj8WMnGL3WH7gesHXUFQbcGOq7U4mxmMwTgqrki7abCawXHGbKMhVoehj9qgtGg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uzhpvpZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uzhpvpZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD641F000FF;
	Tue, 13 Oct 2026 18:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791915961;
	bh=0bqM8tuxj1iwunI+rEjCgIA+RXbshTg3KiQlWp+IL8k=;
	h=Date:To:From:Subject;
	b=uzhpvpZOOkbkppDNJRYWckZhkHe5rSH4K/UciwMyHEcdVxQmmSiRVcd5vIkpPoNSu
	 izS4wCv4PV/vSzOzWJ3fUKyWIPYfd94ME7ldjEajE6uuIfXMFF/aZ0ZcUqjSQLpHnX
	 fTAO/lqX1mjcZWI/VK6IZmnpdt2m9D1U4Qw4kJYc=
Date: Tue, 13 Oct 2026 11:26:01 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch removed from -mm tree
Message-Id: <20261013182601.ACD641F000FF@smtp.kernel.org>
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
Date: Mon, 28 Sep 2026 11:06:15 +0100

Patch series "mm/collapse: separate a collapse from its callers", v4.

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
What the engine offers is then three calls, with the lock state written
down against each, and a policy the caller fills for itself:

    collapse_control_init(cc)         once, before the first table
    collapse_policy_*(&cc->policy)    what this caller allows
    collapse_scan_pmd(vma, addr, ...) per table, under mmap_lock
    collapse_run_pmd(mm, addr, ...)   when a scan found work, no mmap_lock

The engine stays in khugepaged.c for now; what changes is that it has an
interface, and that neither half has to ask about the other.  madvise.c
gains the operation it should have had all along.


This patch (of 13):

madvise_collapse() holds an mmgrab() reference across its work. It is
redundant. Every caller already holds mm_users:

 - madvise(2) works on current->mm, which lives as long as the task is in
   the syscall;
 - process_madvise(2) reaches a remote mm through mm_access(), which takes
   an mm_users reference and holds it until the syscall returns;
 - io_uring passes current->mm;
 - DAMON takes one with get_task_mm() and drops it after the call.

Drop the mmgrab()/mmdrop() pair.

Link: https://lore.kernel.org/20260928100630.21870-1-kirill@shutemov.name
Link: https://lore.kernel.org/20260928100630.21870-2-kirill@shutemov.name
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
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

