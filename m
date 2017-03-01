From: akpm@linux-foundation.org
Subject: + proc-show-madv_free-pages-info-in-smaps.patch added to -mm tree
Date: Tue, 28 Feb 2017 16:32:43 -0800
Message-ID: <58b616ab.1L55QiUdUttdzxX7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40912 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751657AbdCAA46 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 19:56:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@fb.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: show MADV_FREE pages info in smaps
has been added to the -mm tree.  Its filename is
     proc-show-madv_free-pages-info-in-smaps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-show-madv_free-pages-info-in-smaps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-show-madv_free-pages-info-in-smaps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shli@fb.com>
Subject: proc: show MADV_FREE pages info in smaps

Show MADV_FREE pages info of each vma in smaps.  The interface is for
diganose or monitoring purpose, userspace could use it to understand what
happens in the application.  Since userspace could dirty MADV_FREE pages
without notice from kernel, this interface is the only place we can get
accurate accounting info about MADV_FREE pages.

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

 Documentation/filesystems/proc.txt |    4 ++++
 fs/proc/task_mmu.c                 |    8 +++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~proc-show-madv_free-pages-info-in-smaps Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-show-madv_free-pages-info-in-smaps
+++ a/Documentation/filesystems/proc.txt
@@ -412,6 +412,7 @@ Private_Clean:         0 kB
 Private_Dirty:         0 kB
 Referenced:          892 kB
 Anonymous:             0 kB
+LazyFree:              0 kB
 AnonHugePages:         0 kB
 ShmemPmdMapped:        0 kB
 Shared_Hugetlb:        0 kB
@@ -441,6 +442,9 @@ accessed.
 "Anonymous" shows the amount of memory that does not belong to any file.  Even
 a mapping associated with a file may contain anonymous pages: when MAP_PRIVATE
 and a page is modified, the file page is replaced by a private anonymous copy.
+"LazyFree" shows the amount of memory which is marked by madvise(MADV_FREE).
+The memory isn't freed immediately with madvise(). It's freed in memory
+pressure if the memory is clean.
 "AnonHugePages" shows the ammount of memory backed by transparent hugepage.
 "ShmemPmdMapped" shows the ammount of shared (shmem/tmpfs) memory backed by
 huge pages.
diff -puN fs/proc/task_mmu.c~proc-show-madv_free-pages-info-in-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-show-madv_free-pages-info-in-smaps
+++ a/fs/proc/task_mmu.c
@@ -440,6 +440,7 @@ struct mem_size_stats {
 	unsigned long private_dirty;
 	unsigned long referenced;
 	unsigned long anonymous;
+	unsigned long lazyfree;
 	unsigned long anonymous_thp;
 	unsigned long shmem_thp;
 	unsigned long swap;
@@ -456,8 +457,11 @@ static void smaps_account(struct mem_siz
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
@@ -770,6 +774,7 @@ static int show_smap(struct seq_file *m,
 		   "Private_Dirty:  %8lu kB\n"
 		   "Referenced:     %8lu kB\n"
 		   "Anonymous:      %8lu kB\n"
+		   "LazyFree:       %8lu kB\n"
 		   "AnonHugePages:  %8lu kB\n"
 		   "ShmemPmdMapped: %8lu kB\n"
 		   "Shared_Hugetlb: %8lu kB\n"
@@ -788,6 +793,7 @@ static int show_smap(struct seq_file *m,
 		   mss.private_dirty >> 10,
 		   mss.referenced >> 10,
 		   mss.anonymous >> 10,
+		   mss.lazyfree >> 10,
 		   mss.anonymous_thp >> 10,
 		   mss.shmem_thp >> 10,
 		   mss.shared_hugetlb >> 10,
_

Patches currently in -mm which might be from shli@fb.com are

mm-delete-unnecessary-ttu_-flags.patch
mm-dont-assume-anonymous-pages-have-swapbacked-flag.patch
mm-move-madv_free-pages-into-lru_inactive_file-list.patch
mm-reclaim-madv_free-pages.patch
mm-enable-madv_free-for-swapless-system.patch
proc-show-madv_free-pages-info-in-smaps.patch

