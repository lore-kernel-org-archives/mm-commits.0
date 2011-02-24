From: akpm@linux-foundation.org
Subject: + smaps-have-smaps-show-transparent-huge-pages.patch added to -mm tree
Date: Wed, 23 Feb 2011 16:48:17 -0800
Message-ID: <201102240048.p1O0mIGx002207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157Ab1BXAt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 19:49:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, aarcange@redhat.com, emunson@mgebm.net, hannes@cmpxchg.org, jeremy@goop.org, mel@csn.ul.ie, mjwolf@us.ibm.com, mpm@selenic.com, rientjes@google.com


The patch titled
     smaps: have smaps show transparent huge pages
has been added to the -mm tree.  Its filename is
     smaps-have-smaps-show-transparent-huge-pages.patch

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
Subject: smaps: have smaps show transparent huge pages
From: Dave Hansen <dave@linux.vnet.ibm.com>

Now that the mere act of _looking_ at /proc/$pid/smaps will not destroy
transparent huge pages, tell how much of the VMA is actually mapped with
them.

This way, we can make sure that we're getting THPs where we
expect to see them.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Eric B Munson <emunson@mgebm.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Cc: Michael J Wolf <mjwolf@us.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/proc/task_mmu.c~smaps-have-smaps-show-transparent-huge-pages fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-have-smaps-show-transparent-huge-pages
+++ a/fs/proc/task_mmu.c
@@ -331,6 +331,7 @@ struct mem_size_stats {
 	unsigned long private_dirty;
 	unsigned long referenced;
 	unsigned long anonymous;
+	unsigned long anonymous_thp;
 	unsigned long swap;
 	u64 pss;
 };
@@ -396,6 +397,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 			smaps_pte_entry(*(pte_t *)pmd, addr,
 					HPAGE_PMD_SIZE, walk);
 			spin_unlock(&walk->mm->page_table_lock);
+			mss->anonymous_thp += HPAGE_PMD_SIZE;
 			return 0;
 		}
 	} else {
@@ -444,6 +446,7 @@ static int show_smap(struct seq_file *m,
 		   "Private_Dirty:  %8lu kB\n"
 		   "Referenced:     %8lu kB\n"
 		   "Anonymous:      %8lu kB\n"
+		   "AnonHugePages:  %8lu kB\n"
 		   "Swap:           %8lu kB\n"
 		   "KernelPageSize: %8lu kB\n"
 		   "MMUPageSize:    %8lu kB\n"
@@ -457,6 +460,7 @@ static int show_smap(struct seq_file *m,
 		   mss.private_dirty >> 10,
 		   mss.referenced >> 10,
 		   mss.anonymous >> 10,
+		   mss.anonymous_thp >> 10,
 		   mss.swap >> 10,
 		   vma_kernel_pagesize(vma) >> 10,
 		   vma_mmu_pagesize(vma) >> 10,
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

pagewalk-only-split-huge-pages-when-necessary.patch
smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch
smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch
smaps-teach-smaps_pte_range-about-thp-pmds.patch
smaps-have-smaps-show-transparent-huge-pages.patch

