From: akpm@linux-foundation.org
Subject: + smaps-account-swap-entries.patch added to -mm tree
Date: Thu, 27 Mar 2008 01:39:47 -0700
Message-ID: <200803270839.m2R8dl16026141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbYC0Ik0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 04:40:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, a.p.zijlstra@chello.nl, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com


The patch titled
     smaps: account swap entries
has been added to the -mm tree.  Its filename is
     smaps-account-swap-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smaps: account swap entries
From: Peter Zijlstra <peterz@infradead.org>

Show the amount of swap for each vma.  This can be used to see where all the
swap goes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Matt Mackall <mpm@selenic.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~smaps-account-swap-entries fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-account-swap-entries
+++ a/fs/proc/task_mmu.c
@@ -347,6 +347,7 @@ struct mem_size_stats
 	unsigned long private_clean;
 	unsigned long private_dirty;
 	unsigned long referenced;
+	unsigned long swap;
 	u64 pss;
 };
 
@@ -363,6 +364,12 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
+
+		if (is_swap_pte(ptent)) {
+			mss->swap += PAGE_SIZE;
+			continue;
+		}
+
 		if (!pte_present(ptent))
 			continue;
 
@@ -421,7 +428,8 @@ static int show_smap(struct seq_file *m,
 		   "Shared_Dirty:   %8lu kB\n"
 		   "Private_Clean:  %8lu kB\n"
 		   "Private_Dirty:  %8lu kB\n"
-		   "Referenced:     %8lu kB\n",
+		   "Referenced:     %8lu kB\n"
+		   "Swap:           %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
 		   mss.resident >> 10,
 		   (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
@@ -429,7 +437,8 @@ static int show_smap(struct seq_file *m,
 		   mss.shared_dirty  >> 10,
 		   mss.private_clean >> 10,
 		   mss.private_dirty >> 10,
-		   mss.referenced >> 10);
+		   mss.referenced >> 10,
+		   mss.swap >> 10);
 
 	return ret;
 }
_

Patches currently in -mm which might be from peterz@infradead.org are

smaps-account-swap-entries.patch
ipmi-convert-locked-counters-to-atomics-convert-message-handler-defines-to-an-enum.patch
ipmi-convert-locked-counters-to-atomics-in-the-system-interface-convert-system-interface-defines-to-an-enum.patch

