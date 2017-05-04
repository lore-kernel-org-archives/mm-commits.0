From: akpm@linux-foundation.org
Subject: [merged] proc-show-madv_free-pages-info-in-smaps.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:09:53 -0700
Message-ID: <20170504190953.bLVxg8662%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51024 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756253AbdEDTJz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:09:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, shli@fb.com


The patch titled
     Subject: proc: show MADV_FREE pages info in smaps
has been removed from the -mm tree.  Its filename was
     proc-show-madv_free-pages-info-in-smaps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shaohua Li <shli@fb.com>
Subject: proc: show MADV_FREE pages info in smaps

Show MADV_FREE pages info of each vma in smaps.  The interface is for
diganose or monitoring purpose, userspace could use it to understand what
happens in the application.  Since userspace could dirty MADV_FREE pages
without notice from kernel, this interface is the only place we can get
accurate accounting info about MADV_FREE pages.

[mhocko@kernel.org: update Documentation/filesystems/proc.txt]
Link: http://lkml.kernel.org/r/89efde633559de1ec07444f2ef0f4963a97a2ce8.1487965799.git.shli@fb.com
Signed-off-by: Shaohua Li <shli@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    6 ++++++
 fs/proc/task_mmu.c                 |    8 +++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~proc-show-madv_free-pages-info-in-smaps Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-show-madv_free-pages-info-in-smaps
+++ a/Documentation/filesystems/proc.txt
@@ -413,6 +413,7 @@ Private_Clean:         0 kB
 Private_Dirty:         0 kB
 Referenced:          892 kB
 Anonymous:             0 kB
+LazyFree:              0 kB
 AnonHugePages:         0 kB
 ShmemPmdMapped:        0 kB
 Shared_Hugetlb:        0 kB
@@ -442,6 +443,11 @@ accessed.
 "Anonymous" shows the amount of memory that does not belong to any file.  Even
 a mapping associated with a file may contain anonymous pages: when MAP_PRIVATE
 and a page is modified, the file page is replaced by a private anonymous copy.
+"LazyFree" shows the amount of memory which is marked by madvise(MADV_FREE).
+The memory isn't freed immediately with madvise(). It's freed in memory
+pressure if the memory is clean. Please note that the printed value might
+be lower than the real value due to optimizations used in the current
+implementation. If this is not desirable please file a bug report.
 "AnonHugePages" shows the ammount of memory backed by transparent hugepage.
 "ShmemPmdMapped" shows the ammount of shared (shmem/tmpfs) memory backed by
 huge pages.
diff -puN fs/proc/task_mmu.c~proc-show-madv_free-pages-info-in-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-show-madv_free-pages-info-in-smaps
+++ a/fs/proc/task_mmu.c
@@ -441,6 +441,7 @@ struct mem_size_stats {
 	unsigned long private_dirty;
 	unsigned long referenced;
 	unsigned long anonymous;
+	unsigned long lazyfree;
 	unsigned long anonymous_thp;
 	unsigned long shmem_thp;
 	unsigned long swap;
@@ -457,8 +458,11 @@ static void smaps_account(struct mem_siz
 	int i, nr = compound ? 1 << compound_order(page) : 1;
 	unsigned long size = nr * PAGE_SIZE;
 
-	if (PageAnon(page))
+	if (PageAnon(page)) {
 		mss->anonymous += size;
+		if (!PageSwapBacked(page) && !dirty && !PageDirty(page))
+			mss->lazyfree += size;
+	}
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
@@ -771,6 +775,7 @@ static int show_smap(struct seq_file *m,
 		   "Private_Dirty:  %8lu kB\n"
 		   "Referenced:     %8lu kB\n"
 		   "Anonymous:      %8lu kB\n"
+		   "LazyFree:       %8lu kB\n"
 		   "AnonHugePages:  %8lu kB\n"
 		   "ShmemPmdMapped: %8lu kB\n"
 		   "Shared_Hugetlb: %8lu kB\n"
@@ -789,6 +794,7 @@ static int show_smap(struct seq_file *m,
 		   mss.private_dirty >> 10,
 		   mss.referenced >> 10,
 		   mss.anonymous >> 10,
+		   mss.lazyfree >> 10,
 		   mss.anonymous_thp >> 10,
 		   mss.shmem_thp >> 10,
 		   mss.shared_hugetlb >> 10,
_

Patches currently in -mm which might be from shli@fb.com are


