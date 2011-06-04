From: akpm@linux-foundation.org
Subject: + mm-fix-wrong-kunmap_atomic-pointer.patch added to -mm tree
Date: Fri, 03 Jun 2011 21:13:52 -0700
Message-ID: <201106040413.p544D9ox027032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806Ab1FDEN5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 4 Jun 2011 00:13:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, a.p.zijlstra@chello.nl, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     mm: fix wrong kunmap_atomic() pointer
has been added to the -mm tree.  Its filename is
     mm-fix-wrong-kunmap_atomic-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix wrong kunmap_atomic() pointer
From: Steven Rostedt <rostedt@goodmis.org>

Running a ktest.pl test, I hit the following bug on x86_32:

/bin/sh: line 41------------[ cut here ]------------
: /proc/meminfo:WARNING: at arch/x86/mm/highmem_32.c:81 __kunmap_atomic+0x64/0xc1()
 No such file orHardware name:
 directory
/binModules linked in:/sh: line 42: [:
Pid: 93, comm: sh Not tainted 2.6.39-test+ #1
Call Trace:
 [<c04450da>] warn_slowpath_common+0x7c/0x91
 [<c042f5df>] ? __kunmap_atomic+0x64/0xc1
 [<c042f5df>] ? __kunmap_atomic+0x64/0xc1^M
 [<c0445111>] warn_slowpath_null+0x22/0x24
 [<c042f5df>] __kunmap_atomic+0x64/0xc1
 [<c04d4a22>] unmap_vmas+0x43a/0x4e0
 [<c04d9065>] exit_mmap+0x91/0xd2
 [<c0443057>] mmput+0x43/0xad
 [<c0448358>] exit_mm+0x111/0x119
 [<c044855f>] do_exit+0x1ff/0x5fa
 too many argume [<c0454ea2>] ? set_current_blocked+0x3c/0x40
 [<c0454f24>] ? sigprocmask+0x7e/0x8e
 [<c0448b55>] do_group_exit+0x65/0x88
 [<c0448b90>] sys_exit_group+0x18/0x1c
 [<c0c3915f>] sysenter_do_call+0x12/0x38
---[ end trace 8055f74ea3c0eb62 ]---^M

Running a ktest.pl git bisect, found the culprit commit:

e303297e6 mm: extended batches for generic mmu_gather

But although this was the commit triggering the bug, it was not the one
originally responsible for the bug. That was:

d16dfc55 mm: mmu_gather rework

The code in zap_pte_range() has something that looks like the following:

	pte =  pte_offset_map_lock(mm, pmd, addr, &ptl);
	do {
		[...]
	} while (pte++, addr += PAGE_SIZE, addr != end);
	pte_unmap_unlock(pte - 1, ptl);

The pte starts off pointing at the first element in the page table
directory that was returned by the pte_offset_map_lock().  When it's done
with the page, pte will be pointing to anything between the next entry and
the first entry of the next page inclusive.  By doing a pte - 1, this puts
the pte back onto the original page, which is all that pte_unmap_unlock()
needs.

In most archs (64 bit), this is not an issue as the pte is ignored in the
pte_unmap_unlock().  But on 32 bit archs, where things may be kmapped, it
is essential that the pte passed to pte_unmap_unlock() resides on the same
page that was given by pte_offest_map_lock().

The problem came in d16dfc55 ("mm: mmu_gather rework") where it introduced
a "break;" from the while loop.  This alone did not seem to easily trigger
the bug.  But the modifications made by e303297e6 caused that "break;" to
be hit on the first iteration, before the pte++.

The pte not being incremented will now cause pte_unmap_unlock(pte - 1) to
be pointing to the previous page.  This will cause the wrong page to be
unmapped, and also trigger the warning above.

The simple solution is to just save the pointer given by
pte_offset_map_lock() and use it in the unlock.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-fix-wrong-kunmap_atomic-pointer mm/memory.c
--- a/mm/memory.c~mm-fix-wrong-kunmap_atomic-pointer
+++ a/mm/memory.c
@@ -1112,11 +1112,13 @@ static unsigned long zap_pte_range(struc
 	int force_flush = 0;
 	int rss[NR_MM_COUNTERS];
 	spinlock_t *ptl;
+	pte_t *start_pte;
 	pte_t *pte;
 
 again:
 	init_rss_vec(rss);
-	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	start_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	pte = start_pte;
 	arch_enter_lazy_mmu_mode();
 	do {
 		pte_t ptent = *pte;
@@ -1196,7 +1198,7 @@ again:
 
 	add_mm_rss_vec(mm, rss);
 	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(pte - 1, ptl);
+	pte_unmap_unlock(start_pte, ptl);
 
 	/*
 	 * mmu_gather ran out of room to batch pages, we break out of
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
mm-fix-wrong-kunmap_atomic-pointer.patch

