Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C428945D1B1
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 21:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632801; cv=none; b=d6lU15n1jfswYtQOaYNnNuNERGOXKabJ/sA0OGGXwi3Buu1BVvrS3ynFJ6RxMUTWKwc7GYNl1ZsJqp3PaX68ASohtXTpOe5J3i7KlN04oz0M1ZbuTX4qtZ3JJkoocnD9VMcQbk3uSgL6Gyb9gHEG3uBwI/sbdYTd0WH+2YF0vqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632801; c=relaxed/simple;
	bh=/1jptBdViCGgN/sAhMe3QeEb9mgdwP5lTxygwt3KLwA=;
	h=Date:To:From:Subject:Message-Id; b=cYlvf5pXGtn05CQHVno+chgSUkSfdvuRLu4AgcUMnTUoPCr7DjpTBgXgZmWNBsKFpsnJn59nUgQ5surdjseG3idRxXfwVjv1F/0Q62DolL96fgbjnkxD4+Poa8VurtzqM6bbY69tODPDAkFakIS+5NViwvoXivYKOp0WX4xw138=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S0y966eQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S0y966eQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0E71F000FF;
	Mon, 28 Sep 2026 21:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790632798;
	bh=beVUQbPVHq9ZxTkWp+QxsgcTJ8ktCFvVTaUcal70ovM=;
	h=Date:To:From:Subject;
	b=S0y966eQRBa6sA5NEXPaGGca0LhWzMizbivHKiMr4yXSRRFkhlBjPkvS0nRfES3T4
	 IdE0mSznWpbvEOj1B1EeVUnGXwVyqMbpSgQ1I86up8Fh3pPw0gi5k0FK7kQv5w+5eE
	 nVRltg03qYaCZt2JWOs4ISVBcXnPt0wNUhBlL8k8=
Date: Mon, 28 Sep 2026 14:59:57 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + b.patch added to mm-unstable branch
Message-Id: <20260928215958.1E0E71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: b
has been added to the -mm mm-unstable branch.  Its filename is
     b.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/b.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: b
Date: Mon Sep 28 02:54:52 PM PDT 2026
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
Subject: mm/khugepaged: count collapses where khugepaged makes them
Date: Mon, 28 Sep 2026 11:06:16 +0100

collapse_single_pmd() bumps khugepaged_pages_collapsed for its caller, and
tests cc->is_khugepaged to know whether it should: the counter belongs to
the daemon, and MADV_COLLAPSE must not touch it.

The daemon sees every result of every collapse it asks for, so it can keep
its own counter without the shared path testing who called.

Link: https://lore.kernel.org/20260928100630.21870-3-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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
Subject: mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
Date: Mon, 28 Sep 2026 11:06:17 +0100

The name says less than the bit means.  A set bit means not only that the
PTE is present, but also that it passed the other checks: uffd,
lazyfree, anonymity, sharing.  The PTE can be considered a collapse
source.

mthp_collapse() then reads the bitmap starting at the PMD order, so the
bitmap is not specific to mTHP either.

Name it for what a set bit means, and update the comments that named it.

No functional change.

Link: https://lore.kernel.org/20260928100630.21870-4-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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
Subject: mm/collapse: add collapse.h for the collapse interface
Date: Mon, 28 Sep 2026 11:06:18 +0100

khugepaged.c holds both the users of collapse and the machinery that
performs it.  The daemon's scan loop, the sysfs tunables, MADV_COLLAPSE's
entry point and the collapse itself all sit in one file and reach into
each other freely.  Nothing marks where a user ends and the engine
begins.

Start drawing that line.

Add mm/collapse.h for what the two sides have to agree on:

  - enum scan_result - what the engine hands back;
  - struct collapse_control - the state a request carries.

And two constants move with them:

  - KHUGEPAGED_MAX_PTES_LIMIT -> COLLAPSE_MAX_PTES_LIMIT;
  - KHUGEPAGED_MIN_MTHP_ORDER -> COLLAPSE_MIN_MTHP_ORDER.

Neither is a fact about the daemon, so both lose the KHUGEPAGED_ prefix.

No functional change.

Link: https://lore.kernel.org/20260928100630.21870-5-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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
Subject: mm/collapse: state what a collapse may do in the policy
Date: Mon, 28 Sep 2026 11:06:19 +0100

Tests scattered through the collapse path decide what a collapse is
allowed to do by asking whether khugepaged started it.  Between them they
settle:

 - which VMAs are eligible, and how hard to try for a folio;
 - how many empty, swapped-out or shared PTEs a window may contain, and
   whether a sub-PMD window is held to a stricter rule than a PMD;
 - whether a range has to look used, and whether a MADV_FREE'd page is
   left alone;
 - whether the PMD is mapped as part of the request, and whether dirty
   pages are worth writing back and retrying.

None of those is a fact about khugepaged.  Each is something the caller
decided before asking, and the collapse code should not have to look up
who called to find out.

Add struct collapse_policy for the caller to fill: khugepaged from its
own settings, MADV_COLLAPSE from the fact that a user asked explicitly.
Every test becomes a read of a field, and cc->is_khugepaged goes, having
no reader left.

The PTE limits come as two sets, one for a PMD-sized window and one for
anything smaller, so that the helpers pick a set for the order and read
it.  khugepaged takes no swapped-out or shared PTE into a sub-PMD window,
and empty PTEs only when the knob says all or nothing; the warning for a
knob value in between moves to where khugepaged fills its policy.  The
fields only one side reads say which: anon_ or file_.  David Hildenbrand
asked for both.

khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
call.  That is the one change in behaviour.  The max_ptes_* limits and the
defrag setting behind the allocation mask are sampled once per pass rather
than on every table.  A table scanned early in a pass and one scanned late
are then treated alike.

collapse_file() also drops a NULL check on the collapse_control.  It has
one call site, reached only from collapse_single_pmd(), which dereferences
cc unconditionally, so the check was already dead.

Link: https://lore.kernel.org/20260928100630.21870-6-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Subject: mm/collapse: drop the collapse_possible() wrapper
Date: Mon, 28 Sep 2026 11:06:20 +0100

collapse_possible() only forwards to collapse_possible_orders() and turns
its mask into a bool.  Its three callers can test the mask themselves.

No functional change.

Link: https://lore.kernel.org/20260928100630.21870-7-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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
Subject: mm/collapse: name the per-table scan reset for what it resets
Date: Mon, 28 Sep 2026 11:06:21 +0100

collapse_control_init_scan() resets what one scan accumulates: the node
load, the allocation nodemask and the eligible-PTE bitmap.  It runs before
every PTE table a scan is given, not once per control, so its name points
at the wrong thing.

Call it collapse_scan_reset().

Preparation for giving a control a real init and release, run once each
for a whole series of scans.  Two names a word apart would then stand for
two different jobs.

No functional change.

Link: https://lore.kernel.org/20260928100630.21870-8-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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
Subject: mm/collapse: call collapse_file() from collapse_single_pmd()
Date: Mon, 28 Sep 2026 11:06:22 +0100

collapse_scan_file() reads the page cache to decide whether a table is
worth collapsing and, when it is, calls collapse_file() itself.  The
caller cannot get between the decision and the collapse.

Move the collapse_file() call up into collapse_single_pmd(), so the scan
stops at the decision.

Two things change with it.  The writeback retry re-runs collapse_file()
alone instead of rescanning first; collapse_file() repeats the scan's
checks under the page cache lock anyway.  And mm_khugepaged_scan_file
fires before the collapse, so for an accepted table its status reads
SCAN_SUCCEED; what the collapse made of the table is for
mm_khugepaged_collapse_file to report.

Preparation for splitting a collapse into a scan under mmap_lock and a
run without it.  The file scan has to stop where the anonymous one will.

Link: https://lore.kernel.org/20260928100630.21870-9-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Subject: mm/collapse: separate scanning a PTE table from collapsing it
Date: Mon, 28 Sep 2026 11:06:23 +0100

A collapse is two jobs.  One reads a PTE table under mmap_lock and decides
whether the range is worth collapsing.  The other allocates, isolates,
copies and flushes, and wants the lock given up first.

collapse_single_pmd() did both, so the boundary between them was somewhere
in the middle of a function.

Give each half its own function:

  - collapse_scan_pmd() scans one table.  The anonymous scan that used to
    carry that name keeps its body as collapse_scan_anon_pmd(), and
    collapse_scan_pmd() is now the entry that picks the anonymous or the
    file side.

  - collapse_run_pmd() does the collapse the scan asked for, and is
    handed what the scan returned.  SCAN_SUCCEED means there is
    something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page
    cache already holds the PMD folio and only the PTE table is left to
    retract.  Both are work for the run; anything else is why there is
    nothing to do.

collapse_single_pmd() is now the two of them with the mmap_lock drop in
between, so its callers see what they saw before.  collapse_control_init()
sets a control up before its first scan.

What the scan found and the run needs travels in collapse_control.  For
an anonymous table that is the orders and the referenced and swapped-out
counts, which mthp_collapse() and collapse_huge_page() now read from
there instead of taking as arguments.  For a file it is the file itself
and the offset in it: a file collapse works on the page cache and never
sees a VMA, so the scan takes the reference while it still has one and
the run gives it back.

The file scan moves under mmap_lock with the anonymous one, where before
the lock was given up first.  The lock is now held over the page cache
walk, an RCU walk over one table's worth of slots with no PTL, and taken
fewer times.  collapse_scan_mm_slot() ends its walk whenever the lock was
dropped, so a refused file table used to cost khugepaged an unlock, a
trip back through khugepaged_do_scan(), a relock and a VMA lookup.  Now
only a table that goes on to be collapsed does.

Link: https://lore.kernel.org/20260928100630.21870-10-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Subject: mm/collapse: open-code collapse_single_pmd() in its two callers
Date: Mon, 28 Sep 2026 11:06:24 +0100

A scan and a collapse want different things from mmap_lock.  The scan
reads one PTE table under the lock the caller holds, refuses most of the
time, and the caller moves on to the next table without letting go.  The
collapse allocates, may sleep in writeback and takes the lock for write
itself, so the lock it is handed is of no use to it.

collapse_single_pmd() kept that boundary inside itself.  It dropped the
lock on some paths and not others, and reported which by way of a bool
its callers had to carry along and then act on.  Both callers already
act on a drop, khugepaged by ending its walk and madvise_collapse() by
looking its VMA up again.  The code that has to know is not the code
that does it.

Open-code it in the two callers.  Each scans under the lock it already
holds and, when the scan found work, gives the lock up before running
the collapse.  The scan then has one rule, called locked and returning
locked, and the run another, called unlocked.  Nothing is left to
report, so khugepaged's lock_dropped and madvise_collapse()'s
mmap_unlocked both go.  The engine never touches a lock it did not
take, and how a caller locks its scan is the caller's business alone.

khugepaged's walk carries on to the next table while the scan keeps
refusing, and ends once a collapse has taken the lock from under it.
madvise_collapse() re-finds its VMA after a collapse, which it did
before, and now uses a NULL vma to say that it has to.  It still reports
the drop to its own caller, from the line that does it.

Preparation for moving madvise_collapse() out of khugepaged.c: what it
needs from the engine is then two calls with one lock rule each.

The lock is given up and taken again at the same points as before.  No
functional change.

Link: https://lore.kernel.org/20260928100630.21870-11-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
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
Subject: mm/collapse: work out the orders a VMA allows once per VMA
Date: Mon, 28 Sep 2026 11:06:25 +0100

The scan asked collapse_possible_orders() for every PTE table, for an
answer that is a property of the VMA.  Both callers walk a VMA a table at
a time, so let them work it out once and pass the mask in.  It is only
good while the lock that produced it is held, so madvise_collapse() takes
it again after every collapse.

The mask is then sampled once per VMA rather than once per table.  A thp
enabled knob written during a walk takes effect one VMA later, and cannot
widen a collapse: hugepage_vma_revalidate() tests the order again under
the lock the collapse retakes.

Link: https://lore.kernel.org/20260928100630.21870-12-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
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
Subject: mm/collapse: declare the collapse interface in collapse.h
Date: Mon, 28 Sep 2026 11:06:26 +0100

A collapse takes three calls:

  - collapse_control_init() - set up the control a caller carries;
  - collapse_scan_pmd() - scan one PTE table, under mmap_lock;
  - collapse_run_pmd() - collapse what the scan found, no mmap_lock.

All three are static in khugepaged.c, as are collapse_possible_orders(),
which says what a VMA allows, and the revalidate a caller needs once a
collapse has given the mmap_lock up.  No other file can ask for a collapse
without them.

Declare them in collapse.h, with a comment stating the order they are
called in and who holds the lock over each step.  Each function gets a
kerneldoc comment where it is defined: what it takes, what it does, and
the lock state on entry and exit.

hugepage_vma_revalidate() becomes collapse_vma_revalidate(): it is part of
what a collapse offers now, not a helper of the daemon.

Preparation for implementing MADV_COLLAPSE in madvise.c.

No functional change.

Link: https://lore.kernel.org/20260928100630.21870-13-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Subject: mm/collapse: implement MADV_COLLAPSE in madvise.c
Date: Mon, 28 Sep 2026 11:06:27 +0100

MADV_COLLAPSE is a madvise operation, but its implementation sat in
khugepaged.c.  The daemon's file therefore also held a syscall's worth of
code that has nothing to do with the daemon: the walk over the user's
range, the per-PMD loop, and the errno translation.

Move it to madvise.c, among the operations it belongs with, along with the
errno map and the policy it states for itself.  It takes a struct
madvise_behavior like every one of those operations, which is where the
range, the VMA and the lock-dropped flag it used to be handed separately
already live.

It stays a caller of the interface khugepaged uses, so nothing about the
collapse changes.

The !CONFIG_TRANSPARENT_HUGEPAGE stub moves in with it.

Link: https://lore.kernel.org/20260928100630.21870-14-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 mm/collapse.h   |   38 +++++---
 mm/khugepaged.c |  199 +++++++++++++++++++++++-----------------------
 mm/madvise.c    |   25 +++--
 3 files changed, 139 insertions(+), 123 deletions(-)

--- a/mm/collapse.h~b
+++ a/mm/collapse.h
@@ -45,27 +45,37 @@ enum scan_result {
 	SCAN_PAGE_DIRTY_OR_WRITEBACK,
 };
 
-/* What a collapse is allowed to do, decided by the caller that asks for it */
-struct collapse_policy {
-	/* Limits, stated per PMD; HPAGE_PMD_NR means "no limit" */
+/* How many PTEs of a window may be missing, swapped out or shared */
+struct collapse_limits {
+	/* Counted over a PMD-sized window; HPAGE_PMD_NR means "no limit" */
 	unsigned int max_ptes_none;
 	unsigned int max_ptes_swap;
 	unsigned int max_ptes_shared;
+};
+
+/* What a collapse is allowed to do, decided by the caller that asks for it */
+struct collapse_policy {
+	/* Limits for a PMD-sized window */
+	struct collapse_limits pmd;
 
-	/* Take no swapped-out or shared PTE into a sub-PMD collapse */
-	bool strict_sub_pmd;
+	/*
+	 * Limits for a smaller window.  Its max_ptes_none is either 0 or
+	 * COLLAPSE_MAX_PTES_LIMIT, the latter meaning all but one PTE of the
+	 * window whatever its order; any other value counts as 0.
+	 */
+	struct collapse_limits sub_pmd;
 
 	/* Leave clean lazyfree folios to reclaim rather than collapse them */
-	bool skip_lazyfree;
+	bool anon_skip_lazyfree;
 
-	/* Refuse a range with no sign of use */
-	bool require_referenced;
+	/* Refuse an anonymous range with no sign of use */
+	bool anon_require_referenced;
 
 	/* Map the PMD over a file collapse instead of leaving it to a fault */
-	bool install_pmd;
+	bool file_install_pmd;
 
 	/* Write dirty pages back and retry once instead of refusing them */
-	bool writeback_dirty;
+	bool file_writeback_dirty;
 
 	/* How hard to try for a destination folio */
 	gfp_t gfp;
@@ -115,14 +125,13 @@ unsigned long collapse_possible_orders(s
  *     collapse_control_init(cc)              once, before the first table
  *     collapse_scan_pmd(vma, addr, ...)      per table
  *     collapse_run_pmd(mm, addr, result, cc) when a scan found work
- *     collapse_control_release(cc)           once, when done with the control
  *
  * The caller holds mmap_lock for reading over the scan and passes an address
  * within @vma, aligned to the PTE table to scan.
  *
- * The scan returns with that lock still held.  It only reads, and almost every
- * table it is offered has nothing to collapse, so a caller walks a whole VMA
- * under the one lock it took to get there.  SCAN_SUCCEED means there is
+ * The scan returns with that lock still held.  Almost every table it is
+ * offered has nothing to collapse, so a caller walks a whole VMA under the one
+ * lock it took to get there.  SCAN_SUCCEED means there is
  * something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page cache
  * already holds the PMD folio and only the PTE table is left to retract.
  * Both are work for the run, which is handed what the scan returned; anything
@@ -140,7 +149,6 @@ unsigned long collapse_possible_orders(s
  * gives it back.
  */
 void collapse_control_init(struct collapse_control *cc);
-void collapse_control_release(struct collapse_control *cc);
 enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 		unsigned long addr, struct collapse_control *cc,
 		unsigned long orders);
--- a/mm/khugepaged.c~b
+++ a/mm/khugepaged.c
@@ -314,27 +314,17 @@ static bool pte_none_or_zero(pte_t pte)
 static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order)
 {
-	const unsigned int max_ptes_none = cc->policy.max_ptes_none;
+	unsigned int max_ptes_none;
 
 	if (vma && userfaultfd_armed(vma))
 		return 0;
-	/* The limit as given, at the PMD order and wherever it is not capped */
-	if (is_pmd_order(order) || !cc->policy.strict_sub_pmd)
-		return max_ptes_none;
-	/*
-	 * for mTHP collapse with the sysctl value set to COLLAPSE_MAX_PTES_LIMIT,
-	 * scale the maximum number of PTEs to the order of the collapse.
-	 */
+	if (is_pmd_order(order))
+		return cc->policy.pmd.max_ptes_none;
+
+	/* Below PMD order: all but one PTE of the window, or none */
+	max_ptes_none = cc->policy.sub_pmd.max_ptes_none;
 	if (max_ptes_none == COLLAPSE_MAX_PTES_LIMIT)
 		return (1 << order) - 1;
-	/*
-	 * For mTHP collapse of values other than 0 or COLLAPSE_MAX_PTES_LIMIT,
-	 * emit a warning and return 0.
-	 */
-	if (max_ptes_none)
-		pr_warn_once("mTHP collapse does not support max_ptes_none"
-		     " values other than 0 or %u, defaulting to 0.\n",
-		     COLLAPSE_MAX_PTES_LIMIT);
 	return 0;
 }
 
@@ -350,13 +340,9 @@ static unsigned int collapse_max_ptes_no
 static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
 		unsigned int order)
 {
-	/*
-	 * A sub-PMD window held to the strict rule takes no shared page at all:
-	 * an mTHP is not worth the CoW-breaking.
-	 */
-	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
-		return 0;
-	return cc->policy.max_ptes_shared;
+	if (is_pmd_order(order))
+		return cc->policy.pmd.max_ptes_shared;
+	return cc->policy.sub_pmd.max_ptes_shared;
 }
 
 /**
@@ -371,13 +357,9 @@ static unsigned int collapse_max_ptes_sh
 static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
 		unsigned int order)
 {
-	/*
-	 * A sub-PMD window held to the strict rule takes nothing non-present:
-	 * reading pages back to build an mTHP is not worth the latency.
-	 */
-	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
-		return 0;
-	return cc->policy.max_ptes_swap;
+	if (is_pmd_order(order))
+		return cc->policy.pmd.max_ptes_swap;
+	return cc->policy.sub_pmd.max_ptes_swap;
 }
 
 int hugepage_madvise(struct vm_area_struct *vma,
@@ -494,9 +476,16 @@ void __khugepaged_enter(struct mm_struct
 		wake_up_interruptible(&khugepaged_wait);
 }
 
-/*
- * Check what orders are possible based on the vma and collapse type.
- * This is used to determine if mTHP collapse is a viable option.
+/**
+ * collapse_possible_orders - which orders a VMA may collapse to
+ * @vma: the VMA
+ * @vm_flags: its flags, passed separately where they are about to change
+ * @tva_flags: who is asking, as thp_vma_allowable_orders() spells it
+ *
+ * khugepaged may collapse anonymous memory to any enabled order; everything
+ * else collapses to PMD order only.
+ *
+ * Return: the orders as a bitmask, zero when the VMA may not collapse at all.
  */
 unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags)
@@ -658,7 +647,7 @@ static enum scan_result __collapse_huge_
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.anon_skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			goto out;
@@ -747,12 +736,12 @@ static enum scan_result __collapse_huge_
 		if (folio_test_large(folio))
 			list_add_tail(&folio->lru, compound_pagelist);
 next:
-		if (cc->policy.require_referenced &&
+		if (cc->policy.anon_require_referenced &&
 		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
 
-	if (unlikely(cc->policy.require_referenced && !referenced)) {
+	if (unlikely(cc->policy.anon_require_referenced && !referenced)) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -957,14 +946,28 @@ static inline gfp_t alloc_hugepage_khuge
 /* khugepaged collapses on its own initiative, so it obeys its own settings */
 static void collapse_policy_khugepaged(struct collapse_policy *p)
 {
-	p->max_ptes_none = READ_ONCE(khugepaged_max_ptes_none);
-	p->max_ptes_swap = READ_ONCE(khugepaged_max_ptes_swap);
-	p->max_ptes_shared = READ_ONCE(khugepaged_max_ptes_shared);
-	p->strict_sub_pmd = true;
-	p->skip_lazyfree = true;
-	p->require_referenced = true;
-	p->install_pmd = false;
-	p->writeback_dirty = false;
+	p->pmd.max_ptes_none = READ_ONCE(khugepaged_max_ptes_none);
+	p->pmd.max_ptes_swap = READ_ONCE(khugepaged_max_ptes_swap);
+	p->pmd.max_ptes_shared = READ_ONCE(khugepaged_max_ptes_shared);
+
+	/*
+	 * A sub-PMD window takes no swapped-out and no shared PTE: reading
+	 * pages back or breaking CoW is not worth it for an mTHP.  Empty PTEs
+	 * it takes all or nothing, since anything in between would let one
+	 * collapse feed the next.
+	 */
+	p->sub_pmd.max_ptes_none = p->pmd.max_ptes_none;
+	if (p->sub_pmd.max_ptes_none &&
+	    p->sub_pmd.max_ptes_none != COLLAPSE_MAX_PTES_LIMIT)
+		pr_warn_once("mTHP collapse does not support max_ptes_none values other than 0 or %u, defaulting to 0.\n",
+			     COLLAPSE_MAX_PTES_LIMIT);
+	p->sub_pmd.max_ptes_swap = 0;
+	p->sub_pmd.max_ptes_shared = 0;
+
+	p->anon_skip_lazyfree = true;
+	p->anon_require_referenced = true;
+	p->file_install_pmd = false;
+	p->file_writeback_dirty = false;
 	p->gfp = alloc_hugepage_khugepaged_gfpmask();
 	p->tva_type = TVA_KHUGEPAGED;
 }
@@ -995,11 +998,20 @@ static int collapse_find_target_node(str
 }
 #endif
 
-/*
- * Find the VMA at @address again once mmap_lock has been given up and taken
- * back, and check it still allows a collapse of @order there.  The VMA has to
- * span the whole PMD whatever @order is; with @expect_anon it also has to be
- * anonymous and have an anon_vma.  *@vmap is the VMA found, if any.
+/**
+ * collapse_vma_revalidate - look a VMA up again after mmap_lock was dropped
+ * @mm: the mm
+ * @address: an address within the PTE table being collapsed
+ * @expect_anon: the collapse started on an anonymous VMA
+ * @vmap: the VMA found, if any
+ * @cc: the control, for the policy that says who is asking
+ * @order: the order the collapse is going for
+ *
+ * Called with mmap_lock held, for reading or writing, once it has been given up
+ * and taken back.  The VMA has to span the whole PMD whatever @order is; with
+ * @expect_anon it also has to be anonymous and have an anon_vma.
+ *
+ * Return: SCAN_SUCCEED, or why a collapse of @order at @address is off.
  */
 enum scan_result collapse_vma_revalidate(struct mm_struct *mm, unsigned long address,
 		bool expect_anon, struct vm_area_struct **vmap,
@@ -1667,7 +1679,7 @@ static enum scan_result collapse_scan_an
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.anon_skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			failed_pfn = folio_pfn(folio);
@@ -1733,11 +1745,11 @@ static enum scan_result collapse_scan_an
 			goto out_unmap;
 		}
 
-		if (cc->policy.require_referenced &&
+		if (cc->policy.anon_require_referenced &&
 		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
-	if (cc->policy.require_referenced &&
+	if (cc->policy.anon_require_referenced &&
 	    (!referenced ||
 	     (unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
@@ -2592,7 +2604,7 @@ immap_locked:
 	 * caller that wants the PMD mapped now is told to go and do that.
 	 */
 	retract_page_tables(mapping, start);
-	if (cc->policy.install_pmd)
+	if (cc->policy.file_install_pmd)
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
 	folio_unlock(new_folio);
 
@@ -2749,44 +2761,34 @@ static enum scan_result collapse_scan_fi
 	return result;
 }
 
-/* Set up a control before its first scan; cc->policy is the caller's to fill */
+/**
+ * collapse_control_init - set up a control before its first scan
+ * @cc: the control the caller carries across its scans
+ *
+ * cc->policy is the caller's to fill.
+ */
 void collapse_control_init(struct collapse_control *cc)
 {
 	cc->progress = 0;
 	cc->scan_file = NULL;
 }
 
-/* A scan that took a file reference should have been run */
-static void collapse_put_scan_file(struct collapse_control *cc)
-{
-	if (WARN_ON_ONCE(cc->scan_file)) {
-		fput(cc->scan_file);
-		cc->scan_file = NULL;
-	}
-}
-
-/*
- * Done with a control.  A scan that found something has to have been run by
- * then: the file side takes a reference on the file while it still has the
- * VMA to take it from, and the run is what gives it back.
- */
-void collapse_control_release(struct collapse_control *cc)
-{
-	collapse_put_scan_file(cc);
-}
-
-/*
- * Scan the PTE table of @vma at @addr for a collapse candidate.  @addr is
- * aligned to the table; @orders is what the caller allows there.
+/**
+ * collapse_scan_pmd - scan one PTE table for a collapse candidate
+ * @vma: the VMA the table belongs to
+ * @addr: start of the table, PMD aligned
+ * @cc: the caller's control
+ * @orders: the orders the caller allows for @vma
  *
- * Called with mmap_lock held for reading and returns with it still held.  It
- * only reads, and almost every table it is offered has nothing to collapse,
- * so a caller walks a whole VMA under the one lock it took to get there.
- *
- * SCAN_SUCCEED means there is something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE
- * means the page cache already holds the PMD folio and only the PTE table is
- * left to retract.  Both are work for collapse_run_pmd(), which is handed
- * what the scan returned; anything else is why there is nothing to do.
+ * Called with mmap_lock held for reading and returns with it still held.
+ * Almost every table it is offered has nothing to collapse, so a caller walks
+ * a whole VMA under the one lock it took to get there.
+ *
+ * Return: SCAN_SUCCEED when there is something to collapse;
+ * SCAN_PTE_MAPPED_HUGEPAGE when the page cache already holds the PMD folio and
+ * only the PTE table is left to retract.  Both are work for collapse_run_pmd(),
+ * which is handed what the scan returned.  Anything else is why there is
+ * nothing to do.
  */
 enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 		unsigned long addr, struct collapse_control *cc,
@@ -2797,7 +2799,10 @@ enum scan_result collapse_scan_pmd(struc
 
 	mmap_assert_locked(vma->vm_mm);
 	/* Whatever the last scan found has to have been run by now */
-	collapse_put_scan_file(cc);
+	if (WARN_ON_ONCE(cc->scan_file)) {
+		fput(cc->scan_file);
+		cc->scan_file = NULL;
+	}
 
 	if (vma_is_anonymous(vma))
 		return collapse_scan_anon_pmd(vma, addr, cc, orders);
@@ -2820,15 +2825,20 @@ enum scan_result collapse_scan_pmd(struc
 	return result;
 }
 
-/*
- * Collapse the table a scan found work in.  @result is what the scan
- * returned.
+/**
+ * collapse_run_pmd - collapse the table a scan found work in
+ * @mm: the mm
+ * @addr: start of the table, as given to the scan
+ * @result: what the scan returned
+ * @cc: the control the scan ran with
  *
  * Called without mmap_lock and returns without it, taking what it needs in
  * between: what it does -- allocate, isolate, copy, flush -- is slow enough
  * that a writer would wait behind it.  The caller gives the lock up first,
  * and with it the VMA and anything derived under it.  The run revalidates for
  * itself rather than trusting what the scan saw.
+ *
+ * Return: what the collapse made of the table.
  */
 enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
 		enum scan_result result, struct collapse_control *cc)
@@ -2845,12 +2855,12 @@ enum scan_result collapse_run_pmd(struct
 
 	/* The scan found the PMD folio in place: nothing to collapse */
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
-		goto retract;
+		goto put;
 retry:
 	result = collapse_file(mm, addr, file, pgoff, cc);
 
 	/* Dirty pages are worth a writeback and one more try, if asked for */
-	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
+	if (cc->policy.file_writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
 	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
 		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
 		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
@@ -2859,7 +2869,7 @@ retry:
 		triggered_wb = true;
 		goto retry;
 	}
-retract:
+put:
 	fput(file);
 
 	/*
@@ -2872,7 +2882,7 @@ retract:
 			result = SCAN_ANY_PROCESS;
 		else
 			result = try_collapse_pte_mapped_thp(mm, addr,
-							cc->policy.install_pmd);
+							cc->policy.file_install_pmd);
 		if (result == SCAN_PMD_MAPPED)
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
@@ -2928,7 +2938,7 @@ static void collapse_scan_mm_slot(unsign
 		}
 		/* One mask for the whole VMA */
 		orders = collapse_possible_orders(vma, vma->vm_flags,
-						  cc->policy.tva_type);
+						  TVA_KHUGEPAGED);
 		if (!orders) {
 			cc->progress++;
 			continue;
@@ -3032,7 +3042,6 @@ static void khugepaged_do_scan(struct co
 	lru_add_drain_all();
 
 	collapse_control_init(cc);
-	/* One policy for the whole pass, so every table is treated the same */
 	collapse_policy_khugepaged(&cc->policy);
 
 	while (true) {
@@ -3065,8 +3074,6 @@ static void khugepaged_do_scan(struct co
 			khugepaged_alloc_sleep();
 		}
 	}
-
-	collapse_control_release(cc);
 }
 
 static bool khugepaged_should_wakeup(void)
--- a/mm/madvise.c~b
+++ a/mm/madvise.c
@@ -910,16 +910,18 @@ bool madvise_dontneed_free_valid_vma(str
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
 /* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
-static void collapse_policy_forced(struct collapse_policy *p)
+static void collapse_policy_madvise(struct collapse_policy *p)
 {
-	p->max_ptes_none = HPAGE_PMD_NR;
-	p->max_ptes_swap = HPAGE_PMD_NR;
-	p->max_ptes_shared = HPAGE_PMD_NR;
-	p->strict_sub_pmd = false;
-	p->skip_lazyfree = false;
-	p->require_referenced = false;
-	p->install_pmd = true;
-	p->writeback_dirty = true;
+	p->pmd.max_ptes_none = HPAGE_PMD_NR;
+	p->pmd.max_ptes_swap = HPAGE_PMD_NR;
+	p->pmd.max_ptes_shared = HPAGE_PMD_NR;
+	/* Never read: MADV_COLLAPSE collapses to PMD order only */
+	p->sub_pmd = p->pmd;
+
+	p->anon_skip_lazyfree = false;
+	p->anon_require_referenced = false;
+	p->file_install_pmd = true;
+	p->file_writeback_dirty = true;
 	p->gfp = GFP_TRANSHUGE;
 	p->tva_type = TVA_FORCED_COLLAPSE;
 }
@@ -984,7 +986,7 @@ static int madvise_collapse(struct madvi
 	if (!cc)
 		return -ENOMEM;
 	collapse_control_init(cc);
-	collapse_policy_forced(&cc->policy);
+	collapse_policy_madvise(&cc->policy);
 
 	lru_add_drain_all();
 
@@ -1010,7 +1012,7 @@ static int madvise_collapse(struct madvi
 			vma = found;
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 			orders = collapse_possible_orders(vma, vma->vm_flags,
-							  cc->policy.tva_type);
+							  TVA_FORCED_COLLAPSE);
 		}
 
 		result = collapse_scan_pmd(vma, addr, cc, orders);
@@ -1056,7 +1058,6 @@ out:
 		mmap_read_lock(mm);
 out_locked:
 	mmap_assert_locked(mm);
-	collapse_control_release(cc);
 	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
a.patch
b.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch
mm-selftests-add-shmem-into-memory-failure-test-fix.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

