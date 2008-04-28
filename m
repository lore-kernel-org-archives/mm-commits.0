From: akpm@linux-foundation.org
Subject: - smaps-account-swap-entries.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:37 -0700
Message-ID: <200804282152.m3SLqbmm017792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934797AbYD1Vw4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, a.p.zijlstra@chello.nl, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     smaps: account swap entries
has been removed from the -mm tree.  Its filename was
     smaps-account-swap-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smaps: account swap entries
From: Peter Zijlstra <peterz@infradead.org>

Show the amount of swap for each vma.  This can be used to see where all the
swap goes.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Matt Mackall <mpm@selenic.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN fs/proc/task_mmu.c~smaps-account-swap-entries fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-account-swap-entries
+++ a/fs/proc/task_mmu.c
@@ -338,8 +338,7 @@ const struct file_operations proc_maps_o
 #define PSS_SHIFT 12
 
 #ifdef CONFIG_PROC_PAGE_MONITOR
-struct mem_size_stats
-{
+struct mem_size_stats {
 	struct vm_area_struct *vma;
 	unsigned long resident;
 	unsigned long shared_clean;
@@ -347,6 +346,7 @@ struct mem_size_stats
 	unsigned long private_clean;
 	unsigned long private_dirty;
 	unsigned long referenced;
+	unsigned long swap;
 	u64 pss;
 };
 
@@ -363,6 +363,12 @@ static int smaps_pte_range(pmd_t *pmd, u
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
 
@@ -421,7 +427,8 @@ static int show_smap(struct seq_file *m,
 		   "Shared_Dirty:   %8lu kB\n"
 		   "Private_Clean:  %8lu kB\n"
 		   "Private_Dirty:  %8lu kB\n"
-		   "Referenced:     %8lu kB\n",
+		   "Referenced:     %8lu kB\n"
+		   "Swap:           %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
 		   mss.resident >> 10,
 		   (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
@@ -429,7 +436,8 @@ static int show_smap(struct seq_file *m,
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

origin.patch
git-x86.patch
git-s390.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix.patch
ipmi-convert-locked-counters-to-atomics-convert-message-handler-defines-to-an-enum.patch
ipmi-convert-locked-counters-to-atomics-in-the-system-interface-convert-system-interface-defines-to-an-enum.patch

