Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB143BBFB3
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 21:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632797; cv=none; b=iQ2pm6HpVAZOmeXj+cWkqxOjniBit9pgC+fP0s6jkOoqwuLBCz7qMf8gcSOYoW/y8qdJNUFoulN8EOVALck4Dy9uL6JCGeM1/CrFqhJPVgCn5J9cdpSHYkFI+4QxHHLh2tzelPdpI9t4G5Po2WOYP53Ok2dOg/STrJAnTdsEZN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632797; c=relaxed/simple;
	bh=09VAa/cmxaXX8pO7wmO9p9RSko7mZXkUtM5pjZV6daU=;
	h=Date:To:From:Subject:Message-Id; b=c70cQJWgY4vilp0WujgQU8p5BEOY842PzsdOhN1rofcRJLeWCPuKq5mK+FNjY2LlzWSDJMcSP9noRlTC6wsIIo8nJukPTqvFzdHwS/FwgygCrxlYIbCB11J7c/8gL+NGBtVJktoDE/A8Rz1vwCJNPzTUDd3MEGXE9uw3bY+WFkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1sp6sfMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1sp6sfMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAD11F000FF;
	Mon, 28 Sep 2026 21:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790632793;
	bh=vUGwr9RqQraQEpVoniQ39c7AU0k+reKMeJnRUSXIMYQ=;
	h=Date:To:From:Subject;
	b=1sp6sfMqYjphZ1NNifHr5Zcizq+pqAn7rFqgtZ5Q4qGByunPfoDLYiWXg7NECtNm5
	 PtxdLZbzYjBNKs7OxNoVNzHPJefJ7j7Maebgi+bbfDVqkKp0MEncs0BoUChnKztton
	 3DgClrg8dNpgToC3wRVvtBvPldTun+Oj82MiekWM=
Date: Mon, 28 Sep 2026 14:59:52 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + a.patch added to mm-unstable branch
Message-Id: <20260928215953.2CAD11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: a
has been added to the -mm mm-unstable branch.  Its filename is
     a.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/a.patch

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
Subject: a
Date: Mon Sep 28 02:50:37 PM PDT 2026
Subject: mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
Date: Wed, 16 Sep 2026 10:31:28 +0100

Patch series "mm/collapse: separate a collapse from its callers", v3.

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

Link: https://lore.kernel.org/20260916093145.4022188-1-kirill@shutemov.name
Link: https://lore.kernel.org/20260916093145.4022188-2-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Subject: mm/khugepaged: count collapses where khugepaged makes them
Date: Wed, 16 Sep 2026 10:31:29 +0100

collapse_single_pmd() bumps khugepaged_pages_collapsed for its caller, and
tests cc->is_khugepaged to know whether it should: the counter belongs to
the daemon, and MADV_COLLAPSE must not touch it.

The daemon sees every result of every collapse it asks for, so it can keep
its own counter without the shared path testing who called.

Link: https://lore.kernel.org/20260916093145.4022188-3-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Subject: mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
Date: Wed, 16 Sep 2026 10:31:30 +0100

The name says less than the bit means.  A set bit means not only that the
PTE is present, but also that it passed the other checks: uffd, lazyfree,
anonymity, sharing.  The PTE can be considered a collapse source.

mthp_collapse() then reads the bitmap starting at the PMD order, so the
bitmap is not specific to mTHP either.

Name it for what a set bit means, and update the comments that named it.

No functional change.

Link: https://lore.kernel.org/20260916093145.4022188-4-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Subject: mm/collapse: add collapse.h for the collapse interface
Date: Wed, 16 Sep 2026 10:31:31 +0100

khugepaged.c holds both the users of collapse and the machinery that
performs it.  The daemon's scan loop, the sysfs tunables, MADV_COLLAPSE's
entry point and the collapse itself all sit in one file and reach into
each other freely.  Nothing marks where a user ends and the engine begins.

Start drawing that line.

Add mm/collapse.h for what the two sides have to agree on:

  - enum scan_result - what the engine hands back;
  - struct collapse_control - the state a request carries.

And two constants move with them:

  - KHUGEPAGED_MAX_PTES_LIMIT -> COLLAPSE_MAX_PTES_LIMIT;
  - KHUGEPAGED_MIN_MTHP_ORDER -> COLLAPSE_MIN_MTHP_ORDER.

Neither is a fact about the daemon, so both lose the KHUGEPAGED_ prefix.

No functional change.

Link: https://lore.kernel.org/20260916093145.4022188-5-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Subject: mm/collapse: state what a collapse may do in the policy
Date: Wed, 16 Sep 2026 10:31:32 +0100

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

Add struct collapse_policy for the caller to fill: khugepaged from its own
settings, MADV_COLLAPSE from the fact that a user asked explicitly.  Every
test becomes a read of a field, and cc->is_khugepaged goes, having no
reader left.

khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
call.  That is the one change in behaviour.  The max_ptes_* limits and the
defrag setting behind the allocation mask are sampled once per pass rather
than on every table.  A table scanned early in a pass and one scanned late
are then treated alike.

collapse_file() also drops a NULL check on the collapse_control.  It has
one call site, reached only from collapse_single_pmd(), which dereferences
cc unconditionally, so the check was already dead.

Link: https://lore.kernel.org/20260916093145.4022188-6-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Subject: mm/collapse: drop the collapse_possible() wrapper
Date: Wed, 16 Sep 2026 10:31:33 +0100

collapse_possible() only forwards to collapse_possible_orders() and turns
its mask into a bool.  Its three callers can test the mask themselves.

No functional change.

Link: https://lore.kernel.org/20260916093145.4022188-7-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Subject: mm/collapse: name the per-table scan reset for what it resets
Date: Wed, 16 Sep 2026 10:31:34 +0100

collapse_control_init_scan() resets what one scan accumulates: the node
load, the allocation nodemask and the eligible-PTE bitmap.  It runs before
every PTE table a scan is given, not once per control, so its name points
at the wrong thing.

Call it collapse_scan_reset().

Preparation for giving a control a real init and release, run once each
for a whole series of scans.  Two names a word apart would then stand for
two different jobs.

No functional change.

Link: https://lore.kernel.org/20260916093145.4022188-8-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Subject: mm/collapse: separate scanning a PTE table from collapsing it
Date: Wed, 16 Sep 2026 10:31:35 +0100

A collapse is two jobs.  One reads a PTE table under mmap_lock and decides
whether the range is worth collapsing.  The other allocates, isolates,
copies and flushes, and wants the lock given up first.

collapse_single_pmd() did both, so the boundary between them was somewhere
in the middle of a function.

Give each half its own function:

  - collapse_scan_pmd() scans one table and only reads.  The anonymous
    scan that used to carry that name keeps its body as
    collapse_scan_anon_pmd(), and collapse_scan_pmd() is now the entry
    that picks the anonymous or the file side.

  - collapse_run_pmd() does the collapse the scan asked for, and is
    handed what the scan returned.  SCAN_SUCCEED means there is
    something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page
    cache already holds the PMD folio and only the PTE table is left to
    retract.  Both are work for the run; anything else is why there is
    nothing to do.

collapse_single_pmd() is now the two of them with the mmap_lock drop in
between, so its callers see what they saw before.

What the scan found and the run needs travels in collapse_control.  For an
anonymous table that is the orders and the referenced and swapped-out
counts, which mthp_collapse() and collapse_huge_page() now read from there
instead of taking as arguments.  For a file it is the file itself and the
offset in it.

The file side moves with the anonymous one.  collapse_scan_file() used to
run with mmap_lock already given up, and called collapse_file() itself
when the page cache looked worth it.  It now runs under the lock like the
anonymous scan and only reads; the run does the collapse.  A file collapse
works on the page cache and never sees a VMA, so the scan takes the file
reference while it still has one and the run gives it back.

That changes what a refused file table costs khugepaged.  Every file table
it scanned used to end its pass over that mm, because the lock had been
dropped to scan it; now only a table it goes on to collapse does.

Two things on the file side stop being rescanned.  When the page cache
already holds the PMD folio, the scan says so and the run goes straight to
retracting the PTE table.  A run that refuses dirty pages and may write
them back retries collapse_file() alone.  The checks the scan makes ahead
of it are ones collapse_file() repeats under the page cache lock.

Tracing changes with it.  mm_khugepaged_scan_pmd and
mm_khugepaged_scan_file used to fire after the collapse, so for an
accepted table their status field carried what the collapse made of it. 
They now fire before it and read SCAN_SUCCEED for an accepted table.  What
the collapse then made of it is for mm_collapse_huge_page and
mm_khugepaged_collapse_file to report.

Link: https://lore.kernel.org/20260916093145.4022188-9-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Subject: mm/collapse: open-code collapse_single_pmd() in its two callers
Date: Wed, 16 Sep 2026 10:31:36 +0100

collapse_scan_pmd() and collapse_run_pmd() each have a clear locking
contract.  The scan is called with mmap_lock held for reading and returns
with it still held.  The collapse is called without it.

collapse_single_pmd() kept that boundary inside itself.  It dropped the
lock on some paths and not others, and reported which by way of a bool its
callers had to carry along and then act on.

Open-code it in the two callers.  Each scans under the lock it already
holds and, when the scan found work, gives the lock up before running the
collapse.  khugepaged's lock_dropped and madvise_collapse()'s
mmap_unlocked both go: the code dropping the lock is now the code that
wanted to know.

khugepaged's walk carries on to the next table while the scan keeps
refusing, and ends once a collapse has taken the lock from under it. 
madvise_collapse() re-finds its VMA after a collapse, which it did before,
and now uses a NULL vma to say that it has to.  It still reports the drop
to its own caller, from the line that does it.

The lock is given up and taken again at the same points as before.  No
functional change.

Link: https://lore.kernel.org/20260916093145.4022188-10-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Subject: mm/collapse: work out the orders a VMA allows once per VMA
Date: Wed, 16 Sep 2026 10:31:37 +0100

The scan asked collapse_possible_orders() for every PTE table, for an
answer that is a property of the VMA.  Both callers walk a VMA a table at
a time, so let them work it out once and pass the mask in.  It is only
good while the lock that produced it is held, so madvise_collapse() takes
it again after every collapse.

The mask is then sampled once per VMA rather than once per table.  A thp
enabled knob written during a walk takes effect one VMA later, and cannot
widen a collapse: hugepage_vma_revalidate() tests the order again under
the lock the collapse retakes.

Link: https://lore.kernel.org/20260916093145.4022188-11-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Subject: mm/collapse: declare the collapse interface in collapse.h
Date: Wed, 16 Sep 2026 10:31:38 +0100

A collapse takes four calls:

  - collapse_control_init() - set up the control a caller carries;
  - collapse_scan_pmd() - scan one PTE table, under mmap_lock;
  - collapse_run_pmd() - collapse what the scan found, no mmap_lock;
  - collapse_control_release() - done with the control.

All four are static in khugepaged.c, as are collapse_possible_orders(),
which says what a VMA allows, and the revalidate a caller needs once a
collapse has given the mmap_lock up.  No other file can ask for a collapse
without them.

Declare them in collapse.h, with a comment stating the order they are
called in and who holds the lock over each step.  Each function says what
it needs and what it does where it is defined.

hugepage_vma_revalidate() becomes collapse_vma_revalidate(): it is part of
what a collapse offers now, not a helper of the daemon.

Preparation for implementing MADV_COLLAPSE in madvise.c.

No functional change.

Link: https://lore.kernel.org/20260916093145.4022188-12-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: LLM
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Subject: mm/collapse: implement MADV_COLLAPSE in madvise.c
Date: Wed, 16 Sep 2026 10:31:39 +0100

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

Link: https://lore.kernel.org/20260916093145.4022188-13-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 MAINTAINERS             |    1 
 include/linux/huge_mm.h |    9 
 mm/collapse.h           |  154 ++++++++++
 mm/khugepaged.c         |  573 +++++++++++++++-----------------------
 mm/madvise.c            |  169 +++++++++++
 5 files changed, 554 insertions(+), 352 deletions(-)

--- a/include/linux/huge_mm.h~a
+++ a/include/linux/huge_mm.h
@@ -510,8 +510,6 @@ change_huge_pud(struct mmu_gather *tlb,
 
 int hugepage_madvise(struct vm_area_struct *vma, vm_flags_t *vm_flags,
 		     int advice);
-int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
-		     unsigned long end, bool *lock_dropped);
 void vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
 			   unsigned long end, struct vm_area_struct *next);
 spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma);
@@ -714,13 +712,6 @@ static inline int hugepage_madvise(struc
 {
 	return -EINVAL;
 }
-
-static inline int madvise_collapse(struct vm_area_struct *vma,
-				   unsigned long start,
-				   unsigned long end, bool *lock_dropped)
-{
-	return -EINVAL;
-}
 
 static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 					 unsigned long start,
--- a/MAINTAINERS~a
+++ a/MAINTAINERS
@@ -17447,6 +17447,7 @@ F:	Documentation/admin-guide/mm/transhug
 F:	include/linux/huge_mm.h
 F:	include/linux/khugepaged.h
 F:	include/trace/events/huge_memory.h
+F:	mm/collapse.h
 F:	mm/huge_memory.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
diff --git a/mm/collapse.h a/mm/collapse.h
new file mode 100644
--- /dev/null
+++ a/mm/collapse.h
@@ -0,0 +1,154 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __MM_COLLAPSE_H
+#define __MM_COLLAPSE_H
+
+#include <linux/mm.h>
+#include <linux/nodemask.h>
+#include <linux/pgtable.h>
+#include <linux/types.h>
+
+#define COLLAPSE_MAX_PTES_LIMIT		(HPAGE_PMD_NR - 1)
+#define COLLAPSE_MIN_MTHP_ORDER		2
+
+enum scan_result {
+	SCAN_FAIL,
+	SCAN_SUCCEED,
+	SCAN_NO_PTE_TABLE,
+	SCAN_PMD_MAPPED,
+	SCAN_EXCEED_NONE_PTE,
+	SCAN_EXCEED_SWAP_PTE,
+	SCAN_EXCEED_SHARED_PTE,
+	SCAN_PTE_NON_PRESENT,
+	SCAN_PTE_UFFD,
+	SCAN_PTE_MAPPED_HUGEPAGE,
+	SCAN_LACK_REFERENCED_PAGE,
+	SCAN_PAGE_NULL,
+	SCAN_SCAN_ABORT,
+	SCAN_PAGE_COUNT,
+	SCAN_PAGE_LRU,
+	SCAN_PAGE_LOCK,
+	SCAN_PAGE_ANON,
+	SCAN_PAGE_LAZYFREE,
+	SCAN_PAGE_COMPOUND,
+	SCAN_ANY_PROCESS,
+	SCAN_VMA_NULL,
+	SCAN_VMA_CHECK,
+	SCAN_ADDRESS_RANGE,
+	SCAN_DEL_PAGE_LRU,
+	SCAN_ALLOC_HUGE_PAGE_FAIL,
+	SCAN_CGROUP_CHARGE_FAIL,
+	SCAN_TRUNCATED,
+	SCAN_PAGE_HAS_PRIVATE,
+	SCAN_STORE_FAILED,
+	SCAN_COPY_MC,
+	SCAN_PAGE_FILLED,
+	SCAN_PAGE_DIRTY_OR_WRITEBACK,
+};
+
+/* What a collapse is allowed to do, decided by the caller that asks for it */
+struct collapse_policy {
+	/* Limits, stated per PMD; HPAGE_PMD_NR means "no limit" */
+	unsigned int max_ptes_none;
+	unsigned int max_ptes_swap;
+	unsigned int max_ptes_shared;
+
+	/* Take no swapped-out or shared PTE into a sub-PMD collapse */
+	bool strict_sub_pmd;
+
+	/* Leave clean lazyfree folios to reclaim rather than collapse them */
+	bool skip_lazyfree;
+
+	/* Refuse a range with no sign of use */
+	bool require_referenced;
+
+	/* Map the PMD over a file collapse instead of leaving it to a fault */
+	bool install_pmd;
+
+	/* Write dirty pages back and retry once instead of refusing them */
+	bool writeback_dirty;
+
+	/* How hard to try for a destination folio */
+	gfp_t gfp;
+
+	/* Which VMAs are eligible, as thp_vma_allowable_orders() spells it */
+	enum tva_type tva_type;
+};
+
+struct collapse_control {
+	struct collapse_policy policy;
+
+	/* Num pages scanned per node */
+	u32 node_load[MAX_NUMNODES];
+
+	/* Num pages scanned (see khugepaged_pages_to_scan) */
+	unsigned int progress;
+
+	/* nodemask for allocation fallback */
+	nodemask_t alloc_nmask;
+
+	/* Each bit marks a PTE the scan accepted as a collapse source */
+	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
+
+	/*
+	 * What a scan found and the run after it needs.  Live only between the
+	 * two, and read by nobody else.
+	 *
+	 * The file side takes a reference while it still has the VMA, since a
+	 * file collapse works on the page cache and never sees one; the run is
+	 * what gives it back.
+	 */
+	unsigned long scan_orders;
+	int scan_referenced;
+	int scan_unmapped;
+	struct file *scan_file;
+	pgoff_t scan_pgoff;
+};
+
+/* Which orders a VMA may collapse to, zero when it may not collapse at all */
+unsigned long collapse_possible_orders(struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type tva_flags);
+
+/*
+ * A caller states what it allows in cc->policy and then hands over one PTE
+ * table's worth of a VMA at a time:
+ *
+ *     collapse_control_init(cc)              once, before the first table
+ *     collapse_scan_pmd(vma, addr, ...)      per table
+ *     collapse_run_pmd(mm, addr, result, cc) when a scan found work
+ *     collapse_control_release(cc)           once, when done with the control
+ *
+ * The caller holds mmap_lock for reading over the scan and passes an address
+ * within @vma, aligned to the PTE table to scan.
+ *
+ * The scan returns with that lock still held.  It only reads, and almost every
+ * table it is offered has nothing to collapse, so a caller walks a whole VMA
+ * under the one lock it took to get there.  SCAN_SUCCEED means there is
+ * something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page cache
+ * already holds the PMD folio and only the PTE table is left to retract.
+ * Both are work for the run, which is handed what the scan returned; anything
+ * else is why there is nothing to do.
+ *
+ * The run is called without the lock and returns without it, taking what it
+ * needs in between: what it does -- allocate, isolate, copy, flush -- is slow
+ * enough that a writer would wait behind it.  The caller gives the lock up
+ * first, and with it @vma and anything derived under it, so a caller carrying
+ * on has to look up again with collapse_vma_revalidate().  The run revalidates
+ * for itself rather than trusting what the scan saw.
+ *
+ * A scan that found something has to be run: the file side takes a reference on
+ * the file while it still has the VMA to take it from, and the run is what
+ * gives it back.
+ */
+void collapse_control_init(struct collapse_control *cc);
+void collapse_control_release(struct collapse_control *cc);
+enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+		unsigned long addr, struct collapse_control *cc,
+		unsigned long orders);
+enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
+		enum scan_result result, struct collapse_control *cc);
+enum scan_result collapse_vma_revalidate(struct mm_struct *mm,
+		unsigned long address, bool expect_anon,
+		struct vm_area_struct **vmap, struct collapse_control *cc,
+		unsigned int order);
+
+#endif	/* __MM_COLLAPSE_H */
--- a/mm/khugepaged.c~a
+++ a/mm/khugepaged.c
@@ -26,44 +26,10 @@
 #include <linux/cleanup.h>
 
 #include <asm/tlb.h>
+#include "collapse.h"
 #include "internal.h"
-#include "page_alloc.h"
 #include "mm_slot.h"
-
-enum scan_result {
-	SCAN_FAIL,
-	SCAN_SUCCEED,
-	SCAN_NO_PTE_TABLE,
-	SCAN_PMD_MAPPED,
-	SCAN_EXCEED_NONE_PTE,
-	SCAN_EXCEED_SWAP_PTE,
-	SCAN_EXCEED_SHARED_PTE,
-	SCAN_PTE_NON_PRESENT,
-	SCAN_PTE_UFFD,
-	SCAN_PTE_MAPPED_HUGEPAGE,
-	SCAN_LACK_REFERENCED_PAGE,
-	SCAN_PAGE_NULL,
-	SCAN_SCAN_ABORT,
-	SCAN_PAGE_COUNT,
-	SCAN_PAGE_LRU,
-	SCAN_PAGE_LOCK,
-	SCAN_PAGE_ANON,
-	SCAN_PAGE_LAZYFREE,
-	SCAN_PAGE_COMPOUND,
-	SCAN_ANY_PROCESS,
-	SCAN_VMA_NULL,
-	SCAN_VMA_CHECK,
-	SCAN_ADDRESS_RANGE,
-	SCAN_DEL_PAGE_LRU,
-	SCAN_ALLOC_HUGE_PAGE_FAIL,
-	SCAN_CGROUP_CHARGE_FAIL,
-	SCAN_TRUNCATED,
-	SCAN_PAGE_HAS_PRIVATE,
-	SCAN_STORE_FAILED,
-	SCAN_COPY_MC,
-	SCAN_PAGE_FILLED,
-	SCAN_PAGE_DIRTY_OR_WRITEBACK,
-};
+#include "page_alloc.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/huge_memory.h>
@@ -91,7 +57,6 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepage
  *
  * Note that these are only respected if collapse was initiated by khugepaged.
  */
-#define KHUGEPAGED_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
 unsigned int khugepaged_max_ptes_none __read_mostly;
 static unsigned int khugepaged_max_ptes_swap __read_mostly;
 static unsigned int khugepaged_max_ptes_shared __read_mostly;
@@ -101,24 +66,6 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_s
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
-#define KHUGEPAGED_MIN_MTHP_ORDER	2
-
-struct collapse_control {
-	bool is_khugepaged;
-
-	/* Num pages scanned per node */
-	u32 node_load[MAX_NUMNODES];
-
-	/* Num pages scanned (see khugepaged_pages_to_scan) */
-	unsigned int progress;
-
-	/* nodemask for allocation fallback */
-	nodemask_t alloc_nmask;
-
-	/* Each bit represents a single occupied (!none/zero) page. */
-	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
-};
-
 /**
  * struct khugepaged_scan - cursor for scanning
  * @mm_head: the head of the mm list to scan
@@ -267,7 +214,7 @@ static ssize_t max_ptes_none_store(struc
 	unsigned long max_ptes_none;
 
 	err = kstrtoul(buf, 10, &max_ptes_none);
-	if (err || max_ptes_none > KHUGEPAGED_MAX_PTES_LIMIT)
+	if (err || max_ptes_none > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_none = max_ptes_none;
@@ -292,7 +239,7 @@ static ssize_t max_ptes_swap_store(struc
 	unsigned long max_ptes_swap;
 
 	err  = kstrtoul(buf, 10, &max_ptes_swap);
-	if (err || max_ptes_swap > KHUGEPAGED_MAX_PTES_LIMIT)
+	if (err || max_ptes_swap > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_swap = max_ptes_swap;
@@ -318,7 +265,7 @@ static ssize_t max_ptes_shared_store(str
 	unsigned long max_ptes_shared;
 
 	err  = kstrtoul(buf, 10, &max_ptes_shared);
-	if (err || max_ptes_shared > KHUGEPAGED_MAX_PTES_LIMIT)
+	if (err || max_ptes_shared > COLLAPSE_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_shared = max_ptes_shared;
@@ -367,30 +314,27 @@ static bool pte_none_or_zero(pte_t pte)
 static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order)
 {
-	const unsigned int max_ptes_none = khugepaged_max_ptes_none;
+	const unsigned int max_ptes_none = cc->policy.max_ptes_none;
 
 	if (vma && userfaultfd_armed(vma))
 		return 0;
-	/* for MADV_COLLAPSE, allow any empty/shared zeropage PTEs */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/* for PMD collapse, respect the user defined maximum */
-	if (is_pmd_order(order))
+	/* The limit as given, at the PMD order and wherever it is not capped */
+	if (is_pmd_order(order) || !cc->policy.strict_sub_pmd)
 		return max_ptes_none;
 	/*
-	 * for mTHP collapse with the sysctl value set to KHUGEPAGED_MAX_PTES_LIMIT,
+	 * for mTHP collapse with the sysctl value set to COLLAPSE_MAX_PTES_LIMIT,
 	 * scale the maximum number of PTEs to the order of the collapse.
 	 */
-	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
+	if (max_ptes_none == COLLAPSE_MAX_PTES_LIMIT)
 		return (1 << order) - 1;
 	/*
-	 * For mTHP collapse of values other than 0 or KHUGEPAGED_MAX_PTES_LIMIT,
+	 * For mTHP collapse of values other than 0 or COLLAPSE_MAX_PTES_LIMIT,
 	 * emit a warning and return 0.
 	 */
 	if (max_ptes_none)
 		pr_warn_once("mTHP collapse does not support max_ptes_none"
 		     " values other than 0 or %u, defaulting to 0.\n",
-		     KHUGEPAGED_MAX_PTES_LIMIT);
+		     COLLAPSE_MAX_PTES_LIMIT);
 	return 0;
 }
 
@@ -407,19 +351,12 @@ static unsigned int collapse_max_ptes_sh
 		unsigned int order)
 {
 	/*
-	 * For MADV_COLLAPSE, do not restrict the number of PTEs that map shared
-	 * anonymous pages.
-	 */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/*
-	 * for mTHP collapse do not allow collapsing anonymous memory pages that
-	 * are shared between processes.
+	 * A sub-PMD window held to the strict rule takes no shared page at all:
+	 * an mTHP is not worth the CoW-breaking.
 	 */
-	if (!is_pmd_order(order))
+	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
 		return 0;
-	/* for PMD collapse, respect the user defined maximum */
-	return khugepaged_max_ptes_shared;
+	return cc->policy.max_ptes_shared;
 }
 
 /**
@@ -435,16 +372,12 @@ static unsigned int collapse_max_ptes_sw
 		unsigned int order)
 {
 	/*
-	 * For MADV_COLLAPSE, do not restrict the number PTEs entries or
-	 * pagecache entries that are non-present.
+	 * A sub-PMD window held to the strict rule takes nothing non-present:
+	 * reading pages back to build an mTHP is not worth the latency.
 	 */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/* for mTHP collapse do not allow any non-present PTEs or pagecache entries */
-	if (!is_pmd_order(order))
+	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
 		return 0;
-	/* for PMD collapse, respect the user defined maximum */
-	return khugepaged_max_ptes_swap;
+	return cc->policy.max_ptes_swap;
 }
 
 int hugepage_madvise(struct vm_area_struct *vma,
@@ -476,7 +409,7 @@ int __init khugepaged_init(void)
 		return -ENOMEM;
 
 	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
-	khugepaged_max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
+	khugepaged_max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
 	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
 	khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;
 
@@ -565,7 +498,7 @@ void __khugepaged_enter(struct mm_struct
  * Check what orders are possible based on the vma and collapse type.
  * This is used to determine if mTHP collapse is a viable option.
  */
-static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
+unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags)
 {
 	unsigned long orders;
@@ -579,17 +512,11 @@ static unsigned long collapse_possible_o
 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
-static bool collapse_possible(struct vm_area_struct *vma,
-		vm_flags_t vm_flags, enum tva_type tva_flags)
-{
-	return collapse_possible_orders(vma, vm_flags, tva_flags);
-}
-
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
-	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled()
-	    && collapse_possible(vma, vm_flags, TVA_KHUGEPAGED))
+	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled() &&
+	    collapse_possible_orders(vma, vm_flags, TVA_KHUGEPAGED))
 		__khugepaged_enter(vma->vm_mm);
 }
 
@@ -623,11 +550,11 @@ void __khugepaged_exit(struct mm_struct
 	}
 }
 
-static void collapse_control_init_scan(struct collapse_control *cc)
+static void collapse_scan_reset(struct collapse_control *cc)
 {
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
-	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
+	bitmap_zero(cc->eligible_ptes, MAX_PTRS_PER_PTE);
 }
 
 static void release_pte_folio(struct folio *folio)
@@ -731,7 +658,7 @@ static enum scan_result __collapse_huge_
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			goto out;
@@ -820,12 +747,12 @@ static enum scan_result __collapse_huge_
 		if (folio_test_large(folio))
 			list_add_tail(&folio->lru, compound_pagelist);
 next:
-		if (cc->is_khugepaged &&
+		if (cc->policy.require_referenced &&
 		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
 
-	if (unlikely(cc->is_khugepaged && !referenced)) {
+	if (unlikely(cc->policy.require_referenced && !referenced)) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -991,9 +918,7 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-static struct collapse_control khugepaged_collapse_control = {
-	.is_khugepaged = true,
-};
+static struct collapse_control khugepaged_collapse_control;
 
 static bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
@@ -1029,6 +954,21 @@ static inline gfp_t alloc_hugepage_khuge
 	return khugepaged_defrag() ? GFP_TRANSHUGE : GFP_TRANSHUGE_LIGHT;
 }
 
+/* khugepaged collapses on its own initiative, so it obeys its own settings */
+static void collapse_policy_khugepaged(struct collapse_policy *p)
+{
+	p->max_ptes_none = READ_ONCE(khugepaged_max_ptes_none);
+	p->max_ptes_swap = READ_ONCE(khugepaged_max_ptes_swap);
+	p->max_ptes_shared = READ_ONCE(khugepaged_max_ptes_shared);
+	p->strict_sub_pmd = true;
+	p->skip_lazyfree = true;
+	p->require_referenced = true;
+	p->install_pmd = false;
+	p->writeback_dirty = false;
+	p->gfp = alloc_hugepage_khugepaged_gfpmask();
+	p->tva_type = TVA_KHUGEPAGED;
+}
+
 #ifdef CONFIG_NUMA
 static int collapse_find_target_node(struct collapse_control *cc)
 {
@@ -1056,18 +996,17 @@ static int collapse_find_target_node(str
 #endif
 
 /*
- * If mmap_lock temporarily dropped, revalidate vma
- * after taking the mmap_lock again.
- * Returns enum scan_result value.
+ * Find the VMA at @address again once mmap_lock has been given up and taken
+ * back, and check it still allows a collapse of @order there.  The VMA has to
+ * span the whole PMD whatever @order is; with @expect_anon it also has to be
+ * anonymous and have an anon_vma.  *@vmap is the VMA found, if any.
  */
-
-static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
+enum scan_result collapse_vma_revalidate(struct mm_struct *mm, unsigned long address,
 		bool expect_anon, struct vm_area_struct **vmap,
 		struct collapse_control *cc, unsigned int order)
 {
 	struct vm_area_struct *vma;
-	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
-				 TVA_FORCED_COLLAPSE;
+	enum tva_type type = cc->policy.tva_type;
 
 	if (unlikely(collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
@@ -1250,8 +1189,7 @@ out:
 static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 		struct collapse_control *cc, unsigned int order)
 {
-	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
-		     GFP_TRANSHUGE);
+	gfp_t gfp = cc->policy.gfp;
 	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
@@ -1301,8 +1239,8 @@ static pgtable_t alloc_deposit_pte_table
  * while allocating a THP, as that could trigger direct reclaim/compaction.
  * Note that the VMA must be rechecked after grabbing the mmap_lock again.
  */
-static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
-		int referenced, int unmapped, struct collapse_control *cc,
+static enum scan_result collapse_huge_page(struct mm_struct *mm,
+		unsigned long start_addr, struct collapse_control *cc,
 		unsigned int order)
 {
 	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
@@ -1336,7 +1274,7 @@ static enum scan_result collapse_huge_pa
 	}
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
@@ -1349,14 +1287,14 @@ static enum scan_result collapse_huge_pa
 		goto out_nolock;
 	}
 
-	if (unmapped) {
+	if (cc->scan_unmapped) {
 		/*
 		 * __collapse_huge_page_swapin() will return with mmap_lock
 		 * released when it fails. So we jump out_nolock directly in
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
 		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
-						     referenced, order);
+						     cc->scan_referenced, order);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1371,7 +1309,7 @@ static enum scan_result collapse_huge_pa
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
@@ -1512,24 +1450,23 @@ static unsigned int max_order_from_offse
  * mthp_collapse() consumes the bitmap that is generated during
  * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
  *
- * Each bit in cc->mthp_present_ptes represents a single occupied (!none/zero)
- * page. We start at the PMD order and check if it is eligible for collapse;
+ * Each bit in cc->eligible_ptes marks a PTE the scan accepted as a collapse
+ * source. We start at the PMD order and check if it is eligible for collapse;
  * if not, we check the left and right halves of the PTE page table we are
  * examining at a lower order.
  *
- * For each of these, we determine how many PTE entries are occupied in the
- * range of PTE entries we propose to collapse, then we compare this to a
- * threshold number of PTE entries which would need to be occupied for a
- * collapse to be permitted at that order (accounting for max_ptes_none).
+ * For each of these, we count the eligible PTEs in the range we propose to
+ * collapse, then we compare this to the number of eligible PTEs the range
+ * would need for a collapse to be permitted at that order (accounting for
+ * max_ptes_none).
  *
  * If a collapse is permitted, we attempt to collapse the PTE range into a
  * mTHP.
  */
-static enum scan_result mthp_collapse(struct mm_struct *mm,
-		unsigned long address, int referenced, int unmapped,
-		struct collapse_control *cc, unsigned long enabled_orders)
+static enum scan_result mthp_collapse(struct mm_struct *mm, unsigned long address,
+		struct collapse_control *cc)
 {
-	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
+	unsigned int nr_eligible_ptes, nr_ptes, max_ptes_none;
 	enum scan_result last_result = SCAN_FAIL;
 	int collapsed = 0;
 	bool alloc_failed = false;
@@ -1540,27 +1477,26 @@ static enum scan_result mthp_collapse(st
 	while (offset < HPAGE_PMD_NR) {
 		nr_ptes = 1UL << order;
 
-		if (!test_bit(order, &enabled_orders))
+		if (!test_bit(order, &cc->scan_orders))
 			goto next_order;
 
 		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
-		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
+		nr_eligible_ptes = bitmap_weight_from(cc->eligible_ptes, offset,
 						      offset + nr_ptes);
 
 		/*
-		 * Swap PTEs accepted during the scan are counted in @unmapped,
-		 * not in the present-PTE bitmap. Account them for the PMD-order
-		 * candidate.
+		 * Swap PTEs accepted during the scan are counted in
+		 * cc->scan_unmapped, not in cc->eligible_ptes. Account them for
+		 * the PMD-order candidate.
 		 */
 		if (is_pmd_order(order))
-			nr_occupied_ptes += unmapped;
+			nr_eligible_ptes += cc->scan_unmapped;
 
-		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
+		if (nr_eligible_ptes >= nr_ptes - max_ptes_none) {
 			enum scan_result ret;
 
 			collapse_address = address + offset * PAGE_SIZE;
-			ret = collapse_huge_page(mm, collapse_address, referenced,
-						 unmapped, cc, order);
+			ret = collapse_huge_page(mm, collapse_address, cc, order);
 
 			switch (ret) {
 			/* Cases where we continue to next collapse candidate */
@@ -1601,8 +1537,8 @@ next_order:
 		 * any smaller order enabled. When at the smallest order
 		 * we must always move to the next offset.
 		 */
-		if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
-			(enabled_orders & GENMASK(order - 1, 0))) {
+		if (order > COLLAPSE_MIN_MTHP_ORDER &&
+		    (cc->scan_orders & GENMASK(order - 1, 0))) {
 			order--;
 			continue;
 		}
@@ -1627,14 +1563,14 @@ done:
 	return last_result;
 }
 
-static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		bool *lock_dropped, struct collapse_control *cc)
+static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
+		unsigned long start_addr, struct collapse_control *cc,
+		unsigned long enabled_orders)
 {
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
-	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
+	struct mm_struct *mm = vma->vm_mm;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
@@ -1644,7 +1580,6 @@ static enum scan_result collapse_scan_pm
 	struct folio *folio = NULL;
 	unsigned long failed_pfn = -1;
 	unsigned long addr;
-	unsigned long enabled_orders;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
 
@@ -1656,9 +1591,7 @@ static enum scan_result collapse_scan_pm
 		goto out;
 	}
 
-	collapse_control_init_scan(cc);
-
-	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
+	collapse_scan_reset(cc);
 
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
@@ -1666,7 +1599,7 @@ static enum scan_result collapse_scan_pm
 	 * is then checked again in mthp_collapse() for each attempted order.
 	 */
 	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
-		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
+		max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
 
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
@@ -1734,7 +1667,7 @@ static enum scan_result collapse_scan_pm
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			failed_pfn = folio_pfn(folio);
@@ -1761,8 +1694,8 @@ static enum scan_result collapse_scan_pm
 			}
 		}
 
-		/* Set bit for occupied pages */
-		__set_bit(i, cc->mthp_present_ptes);
+		/* The scan accepted this PTE as a collapse source */
+		__set_bit(i, cc->eligible_ptes);
 		/*
 		 * Record which node the original page is from and save this
 		 * information to cc->node_load[].
@@ -1800,13 +1733,13 @@ static enum scan_result collapse_scan_pm
 			goto out_unmap;
 		}
 
-		if (cc->is_khugepaged &&
+		if (cc->policy.require_referenced &&
 		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
-	if (cc->is_khugepaged &&
-		   (!referenced ||
-		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
+	if (cc->policy.require_referenced &&
+	    (!referenced ||
+	     (unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -1814,12 +1747,9 @@ static enum scan_result collapse_scan_pm
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		/* collapse_huge_page() expects the lock to be dropped before calling */
-		mmap_read_unlock(mm);
-		result = mthp_collapse(mm, start_addr, referenced,
-				       unmapped, cc, enabled_orders);
-		/* mmap_lock was released above, set lock_dropped */
-		*lock_dropped = true;
+		cc->scan_orders = enabled_orders;
+		cc->scan_referenced = referenced;
+		cc->scan_unmapped = unmapped;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
@@ -2658,11 +2588,11 @@ immap_locked:
 	xas_unlock_irq(&xas);
 
 	/*
-	 * Remove pte page tables, so we can re-fault the page as huge.
-	 * If MADV_COLLAPSE, adjust result to call try_collapse_pte_mapped_thp().
+	 * Remove pte page tables, so we can re-fault the page as huge.  A
+	 * caller that wants the PMD mapped now is told to go and do that.
 	 */
 	retract_page_tables(mapping, start);
-	if (cc && !cc->is_khugepaged)
+	if (cc->policy.install_pmd)
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
 	folio_unlock(new_folio);
 
@@ -2727,7 +2657,7 @@ static enum scan_result collapse_scan_fi
 
 	present = 0;
 	swap = 0;
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
@@ -2809,53 +2739,118 @@ static enum scan_result collapse_scan_fi
 	else
 		cc->progress += HPAGE_PMD_NR;
 
-	if (result == SCAN_SUCCEED) {
-		if (present < HPAGE_PMD_NR - max_ptes_none) {
-			result = SCAN_EXCEED_NONE_PTE;
-			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-		} else {
-			result = collapse_file(mm, addr, file, start, cc);
-		}
+	if (result == SCAN_SUCCEED && present < HPAGE_PMD_NR - max_ptes_none) {
+		result = SCAN_EXCEED_NONE_PTE;
+		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 	}
 
-	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap,
+				      result);
 	return result;
 }
 
+/* Set up a control before its first scan; cc->policy is the caller's to fill */
+void collapse_control_init(struct collapse_control *cc)
+{
+	cc->progress = 0;
+	cc->scan_file = NULL;
+}
+
+/* A scan that took a file reference should have been run */
+static void collapse_put_scan_file(struct collapse_control *cc)
+{
+	if (WARN_ON_ONCE(cc->scan_file)) {
+		fput(cc->scan_file);
+		cc->scan_file = NULL;
+	}
+}
+
 /*
- * Try to collapse a single PMD starting at a PMD aligned addr, and return
- * the results.
+ * Done with a control.  A scan that found something has to have been run by
+ * then: the file side takes a reference on the file while it still has the
+ * VMA to take it from, and the run is what gives it back.
  */
-static enum scan_result collapse_single_pmd(unsigned long addr,
-		struct vm_area_struct *vma, bool *lock_dropped,
-		struct collapse_control *cc)
+void collapse_control_release(struct collapse_control *cc)
+{
+	collapse_put_scan_file(cc);
+}
+
+/*
+ * Scan the PTE table of @vma at @addr for a collapse candidate.  @addr is
+ * aligned to the table; @orders is what the caller allows there.
+ *
+ * Called with mmap_lock held for reading and returns with it still held.  It
+ * only reads, and almost every table it is offered has nothing to collapse,
+ * so a caller walks a whole VMA under the one lock it took to get there.
+ *
+ * SCAN_SUCCEED means there is something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE
+ * means the page cache already holds the PMD folio and only the PTE table is
+ * left to retract.  Both are work for collapse_run_pmd(), which is handed
+ * what the scan returned; anything else is why there is nothing to do.
+ */
+enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+		unsigned long addr, struct collapse_control *cc,
+		unsigned long orders)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	bool triggered_wb = false;
 	enum scan_result result;
-	struct file *file;
 	pgoff_t pgoff;
 
-	mmap_assert_locked(mm);
+	mmap_assert_locked(vma->vm_mm);
+	/* Whatever the last scan found has to have been run by now */
+	collapse_put_scan_file(cc);
 
-	if (vma_is_anonymous(vma)) {
-		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
-		goto end;
-	}
+	if (vma_is_anonymous(vma))
+		return collapse_scan_anon_pmd(vma, addr, cc, orders);
 
-	file = get_file(vma->vm_file);
 	pgoff = linear_page_index(vma, addr);
-
-	mmap_read_unlock(mm);
-	*lock_dropped = true;
-retry:
-	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
+	/*
+	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
+	 * the PMD folio, and retracting the PTE table is the run's job.
+	 */
+	if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
+		return result;
 
 	/*
-	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
-	 * then retry the collapse one time.
+	 * A file collapse works on the page cache and never sees a VMA, so take
+	 * what it needs from this one while it is still here.
 	 */
-	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
+	cc->scan_file = get_file(vma->vm_file);
+	cc->scan_pgoff = pgoff;
+	return result;
+}
+
+/*
+ * Collapse the table a scan found work in.  @result is what the scan
+ * returned.
+ *
+ * Called without mmap_lock and returns without it, taking what it needs in
+ * between: what it does -- allocate, isolate, copy, flush -- is slow enough
+ * that a writer would wait behind it.  The caller gives the lock up first,
+ * and with it the VMA and anything derived under it.  The run revalidates for
+ * itself rather than trusting what the scan saw.
+ */
+enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
+		enum scan_result result, struct collapse_control *cc)
+{
+	struct file *file = cc->scan_file;
+	bool triggered_wb = false;
+	pgoff_t pgoff;
+
+	if (!file)
+		return mthp_collapse(mm, addr, cc);
+
+	cc->scan_file = NULL;
+	pgoff = cc->scan_pgoff;
+
+	/* The scan found the PMD folio in place: nothing to collapse */
+	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
+		goto retract;
+retry:
+	result = collapse_file(mm, addr, file, pgoff, cc);
+
+	/* Dirty pages are worth a writeback and one more try, if asked for */
+	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
 	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
 		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
 		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
@@ -2864,22 +2859,24 @@ retry:
 		triggered_wb = true;
 		goto retry;
 	}
+retract:
 	fput(file);
 
+	/*
+	 * A PMD folio is in the page cache, whether the collapse just put it
+	 * there or found it: retract the PTE table, and map the PMD if asked.
+	 */
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
 		mmap_read_lock(mm);
 		if (collapse_test_exit_or_disable(mm))
 			result = SCAN_ANY_PROCESS;
 		else
 			result = try_collapse_pte_mapped_thp(mm, addr,
-							     !cc->is_khugepaged);
+							cc->policy.install_pmd);
 		if (result == SCAN_PMD_MAPPED)
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
 	}
-end:
-	if (cc->is_khugepaged && result == SCAN_SUCCEED)
-		++khugepaged_pages_collapsed;
 	return result;
 }
 
@@ -2922,14 +2919,17 @@ static void collapse_scan_mm_slot(unsign
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
 	for_each_vma(vmi, vma) {
-		unsigned long hstart, hend;
+		unsigned long hstart, hend, orders;
 
 		cond_resched();
 		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
+		/* One mask for the whole VMA */
+		orders = collapse_possible_orders(vma, vma->vm_flags,
+						  cc->policy.tva_type);
+		if (!orders) {
 			cc->progress++;
 			continue;
 		}
@@ -2944,7 +2944,7 @@ static void collapse_scan_mm_slot(unsign
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
 
 		while (khugepaged_scan.address < hend) {
-			bool lock_dropped = false;
+			unsigned long addr;
 
 			cond_resched();
 			if (unlikely(collapse_test_exit_or_disable(mm)))
@@ -2954,21 +2954,30 @@ static void collapse_scan_mm_slot(unsign
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
 
-			*result = collapse_single_pmd(khugepaged_scan.address,
-						      vma, &lock_dropped, cc);
+			addr = khugepaged_scan.address;
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			if (lock_dropped)
-				/*
-				 * We released mmap_lock so break loop.  Note
-				 * that we drop mmap_lock before all hugepage
-				 * allocations, so if allocation fails, we are
-				 * guaranteed to break here and report the
-				 * correct result back to caller.
-				 */
-				goto breakouterloop_mmap_lock;
-			if (cc->progress >= progress_max)
-				goto breakouterloop;
+
+			*result = collapse_scan_pmd(vma, addr, cc, orders);
+			/* Nothing to do here, and the lock is still ours */
+			if (*result != SCAN_SUCCEED &&
+			    *result != SCAN_PTE_MAPPED_HUGEPAGE) {
+				if (cc->progress >= progress_max)
+					goto breakouterloop;
+				continue;
+			}
+
+			/*
+			 * A collapse takes its own locks and is slow enough
+			 * that a writer should not wait behind it, so give the
+			 * lock up.  That ends this walk: vma and the mm are
+			 * whatever the collapse leaves them.
+			 */
+			mmap_read_unlock(mm);
+			*result = collapse_run_pmd(mm, addr, *result, cc);
+			if (*result == SCAN_SUCCEED)
+				khugepaged_pages_collapsed++;
+			goto breakouterloop_mmap_lock;
 		}
 	}
 breakouterloop:
@@ -3022,7 +3031,10 @@ static void khugepaged_do_scan(struct co
 
 	lru_add_drain_all();
 
-	cc->progress = 0;
+	collapse_control_init(cc);
+	/* One policy for the whole pass, so every table is treated the same */
+	collapse_policy_khugepaged(&cc->policy);
+
 	while (true) {
 		cond_resched();
 
@@ -3053,6 +3065,8 @@ static void khugepaged_do_scan(struct co
 			khugepaged_alloc_sleep();
 		}
 	}
+
+	collapse_control_release(cc);
 }
 
 static bool khugepaged_should_wakeup(void)
@@ -3191,126 +3205,3 @@ bool current_is_khugepaged(void)
 {
 	return kthread_func(current) == khugepaged;
 }
-
-static int madvise_collapse_errno(enum scan_result r)
-{
-	/*
-	 * MADV_COLLAPSE breaks from existing madvise(2) conventions to provide
-	 * actionable feedback to caller, so they may take an appropriate
-	 * fallback measure depending on the nature of the failure.
-	 */
-	switch (r) {
-	case SCAN_ALLOC_HUGE_PAGE_FAIL:
-		return -ENOMEM;
-	case SCAN_CGROUP_CHARGE_FAIL:
-	case SCAN_EXCEED_NONE_PTE:
-		return -EBUSY;
-	/* Resource temporary unavailable - trying again might succeed */
-	case SCAN_PAGE_COUNT:
-	case SCAN_PAGE_LOCK:
-	case SCAN_PAGE_LRU:
-	case SCAN_DEL_PAGE_LRU:
-	case SCAN_PAGE_FILLED:
-	case SCAN_PAGE_HAS_PRIVATE:
-	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
-		return -EAGAIN;
-	/*
-	 * Other: Trying again likely not to succeed / error intrinsic to
-	 * specified memory range. khugepaged likely won't be able to collapse
-	 * either.
-	 */
-	default:
-		return -EINVAL;
-	}
-}
-
-int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
-		     unsigned long end, bool *lock_dropped)
-{
-	struct collapse_control *cc;
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long hstart, hend, addr;
-	enum scan_result last_fail = SCAN_FAIL;
-	int thps = 0;
-	bool mmap_unlocked = false;
-
-	BUG_ON(vma->vm_start > start);
-	BUG_ON(vma->vm_end < end);
-
-	if (!collapse_possible(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
-		return -EINVAL;
-
-	hstart = ALIGN(start, HPAGE_PMD_SIZE);
-	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
-
-	if (hstart >= hend)
-		return 0;
-
-	cc = kmalloc_obj(*cc);
-	if (!cc)
-		return -ENOMEM;
-	cc->is_khugepaged = false;
-	cc->progress = 0;
-
-	mmgrab(mm);
-	lru_add_drain_all();
-
-	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
-		enum scan_result result = SCAN_FAIL;
-
-		if (mmap_unlocked) {
-			cond_resched();
-			mmap_read_lock(mm);
-			mmap_unlocked = false;
-			*lock_dropped = true;
-			result = hugepage_vma_revalidate(mm, addr, false, &vma,
-							 cc, HPAGE_PMD_ORDER);
-			if (result != SCAN_SUCCEED) {
-				last_fail = result;
-				goto out_nolock;
-			}
-
-			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
-		}
-
-		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
-
-		switch (result) {
-		case SCAN_SUCCEED:
-		case SCAN_PMD_MAPPED:
-			++thps;
-			break;
-		/* Whitelisted set of results where continuing OK */
-		case SCAN_NO_PTE_TABLE:
-		case SCAN_PTE_NON_PRESENT:
-		case SCAN_PTE_UFFD:
-		case SCAN_LACK_REFERENCED_PAGE:
-		case SCAN_PAGE_NULL:
-		case SCAN_PAGE_COUNT:
-		case SCAN_PAGE_LOCK:
-		case SCAN_PAGE_COMPOUND:
-		case SCAN_PAGE_LRU:
-		case SCAN_DEL_PAGE_LRU:
-			last_fail = result;
-			break;
-		default:
-			last_fail = result;
-			/* Other error, exit */
-			goto out_maybelock;
-		}
-	}
-
-out_maybelock:
-	/* Caller expects us to hold mmap_lock on return */
-	if (mmap_unlocked) {
-		*lock_dropped = true;
-		mmap_read_lock(mm);
-	}
-out_nolock:
-	mmap_assert_locked(mm);
-	mmdrop(mm);
-	kfree(cc);
-
-	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
-			: madvise_collapse_errno(last_fail);
-}
--- a/mm/madvise.c~a
+++ a/mm/madvise.c
@@ -38,6 +38,7 @@
 
 #include "internal.h"
 #include "swap.h"
+#include "collapse.h"
 
 #define __MADV_SET_ANON_VMA_NAME (-1)
 
@@ -906,6 +907,171 @@ bool madvise_dontneed_free_valid_vma(str
 	return true;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+
+/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
+static void collapse_policy_forced(struct collapse_policy *p)
+{
+	p->max_ptes_none = HPAGE_PMD_NR;
+	p->max_ptes_swap = HPAGE_PMD_NR;
+	p->max_ptes_shared = HPAGE_PMD_NR;
+	p->strict_sub_pmd = false;
+	p->skip_lazyfree = false;
+	p->require_referenced = false;
+	p->install_pmd = true;
+	p->writeback_dirty = true;
+	p->gfp = GFP_TRANSHUGE;
+	p->tva_type = TVA_FORCED_COLLAPSE;
+}
+
+static int madvise_collapse_errno(enum scan_result r)
+{
+	/*
+	 * MADV_COLLAPSE breaks from existing madvise(2) conventions to provide
+	 * actionable feedback to caller, so they may take an appropriate
+	 * fallback measure depending on the nature of the failure.
+	 */
+	switch (r) {
+	case SCAN_ALLOC_HUGE_PAGE_FAIL:
+		return -ENOMEM;
+	case SCAN_CGROUP_CHARGE_FAIL:
+	case SCAN_EXCEED_NONE_PTE:
+		return -EBUSY;
+	/* Resource temporary unavailable - trying again might succeed */
+	case SCAN_PAGE_COUNT:
+	case SCAN_PAGE_LOCK:
+	case SCAN_PAGE_LRU:
+	case SCAN_DEL_PAGE_LRU:
+	case SCAN_PAGE_FILLED:
+	case SCAN_PAGE_HAS_PRIVATE:
+	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
+		return -EAGAIN;
+	/*
+	 * Other: Trying again likely not to succeed / error intrinsic to
+	 * specified memory range. khugepaged likely won't be able to collapse
+	 * either.
+	 */
+	default:
+		return -EINVAL;
+	}
+}
+
+static int madvise_collapse(struct madvise_behavior *madv_behavior)
+{
+	struct madvise_behavior_range *range = &madv_behavior->range;
+	struct vm_area_struct *vma = madv_behavior->vma;
+	struct mm_struct *mm = madv_behavior->mm;
+	struct collapse_control *cc;
+	unsigned long hstart, hend, addr, orders;
+	enum scan_result last_fail = SCAN_FAIL;
+	int thps = 0;
+
+	BUG_ON(vma->vm_start > range->start);
+	BUG_ON(vma->vm_end < range->end);
+
+	orders = collapse_possible_orders(vma, vma->vm_flags,
+					  TVA_FORCED_COLLAPSE);
+	if (!orders)
+		return -EINVAL;
+
+	hstart = ALIGN(range->start, HPAGE_PMD_SIZE);
+	hend = ALIGN_DOWN(range->end, HPAGE_PMD_SIZE);
+
+	if (hstart >= hend)
+		return 0;
+
+	cc = kmalloc_obj(*cc);
+	if (!cc)
+		return -ENOMEM;
+	collapse_control_init(cc);
+	collapse_policy_forced(&cc->policy);
+
+	lru_add_drain_all();
+
+	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
+		struct vm_area_struct *found;
+		enum scan_result result;
+
+		/*
+		 * A collapse gives the lock up, so the VMA has to be found
+		 * again after one: it can shrink while nothing is held.  A scan
+		 * that finds nothing to collapse leaves the lock alone, so a
+		 * range that is already collapsed walks on without relocking.
+		 */
+		if (!vma) {
+			cond_resched();
+			mmap_read_lock(mm);
+			result = collapse_vma_revalidate(mm, addr, false, &found,
+							 cc, HPAGE_PMD_ORDER);
+			if (result != SCAN_SUCCEED) {
+				last_fail = result;
+				goto out_locked;
+			}
+			vma = found;
+			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
+			orders = collapse_possible_orders(vma, vma->vm_flags,
+							  cc->policy.tva_type);
+		}
+
+		result = collapse_scan_pmd(vma, addr, cc, orders);
+		/* Nothing to do here, and the lock is still ours */
+		if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
+			goto tally;
+
+		/* The collapse takes its own locks, so give this up */
+		mmap_read_unlock(mm);
+		mark_mmap_lock_dropped(madv_behavior);
+		vma = NULL;
+
+		result = collapse_run_pmd(mm, addr, result, cc);
+tally:
+		switch (result) {
+		case SCAN_SUCCEED:
+		case SCAN_PMD_MAPPED:
+			++thps;
+			break;
+		/* Whitelisted set of results where continuing OK */
+		case SCAN_NO_PTE_TABLE:
+		case SCAN_PTE_NON_PRESENT:
+		case SCAN_PTE_UFFD:
+		case SCAN_LACK_REFERENCED_PAGE:
+		case SCAN_PAGE_NULL:
+		case SCAN_PAGE_COUNT:
+		case SCAN_PAGE_LOCK:
+		case SCAN_PAGE_COMPOUND:
+		case SCAN_PAGE_LRU:
+		case SCAN_DEL_PAGE_LRU:
+			last_fail = result;
+			break;
+		default:
+			last_fail = result;
+			/* Other error, exit */
+			goto out;
+		}
+	}
+
+out:
+	/* Caller expects us to hold mmap_lock on return */
+	if (!vma)
+		mmap_read_lock(mm);
+out_locked:
+	mmap_assert_locked(mm);
+	collapse_control_release(cc);
+	kfree(cc);
+
+	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
+			: madvise_collapse_errno(last_fail);
+}
+
+#else	/* CONFIG_TRANSPARENT_HUGEPAGE */
+
+static int madvise_collapse(struct madvise_behavior *madv_behavior)
+{
+	return -EINVAL;
+}
+
+#endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
+
 static long madvise_dontneed_free(struct madvise_behavior *madv_behavior)
 {
 	struct mm_struct *mm = madv_behavior->mm;
@@ -1373,8 +1539,7 @@ static int madvise_vma_behavior(struct m
 	case MADV_DONTNEED_LOCKED:
 		return madvise_dontneed_free(madv_behavior);
 	case MADV_COLLAPSE:
-		return madvise_collapse(vma, range->start, range->end,
-			&madv_behavior->lock_dropped);
+		return madvise_collapse(madv_behavior);
 	case MADV_GUARD_INSTALL:
 		return madvise_guard_install(madv_behavior);
 	case MADV_GUARD_REMOVE:
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

