From: akpm@linux-foundation.org
Subject: [merged] smaps-have-smaps-show-transparent-huge-pages.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:44 -0700
Message-ID: <201103232040.p2NKeKbG028522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933423Ab1CWUmD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:42:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@linux.vnet.ibm.com, aarcange@redhat.com, emunson@mgebm.net, hannes@cmpxchg.org, jeremy@goop.org, mel@csn.ul.ie, mjwolf@us.ibm.com, mpm@selenic.com, rientjes@google.com, mm-commit


The patch titled
     smaps: have smaps show transparent huge pages
has been removed from the -mm tree.  Its filename was
     smaps-have-smaps-show-transparent-huge-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem.patch
page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix.patch

