From: akpm@linux-foundation.org
Subject: + mm-fix-global-nr_slab_claimable-counter-reads.patch added to
 -mm tree
Date: Tue, 01 Aug 2017 13:55:27 -0700
Message-ID: <5980eabf.4gdndRKrhn+w51NP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54198 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752004AbdHAUz2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2017 16:55:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, josef@toxicpanda.com, mhocko@suse.com, penguin-kernel@i-love.sakura.ne.jp, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix global NR_SLAB_.*CLAIMABLE counter reads
has been added to the -mm tree.  Its filename is
     mm-fix-global-nr_slab_claimable-counter-reads.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-global-nr_slab_claimable-counter-reads.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-global-nr_slab_claimable-counter-reads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: fix global NR_SLAB_.*CLAIMABLE counter reads

As Tetsuo points out:

    Commit 385386cff4c6f047 ("mm: vmstat: move slab statistics from
    zone to node counters") broke "Slab:" field of /proc/meminfo . It
    shows nearly 0kB.

In addition to /proc/meminfo, this problem also affects the slab counters
OOM/allocation failure info dumps, can cause early -ENOMEM from overcommit
protection, and miscalculate image size requirements during
suspend-to-disk.

This is because the patch in question switched the slab counters from the
zone level to the node level, but forgot to update the global accessor
functions to read the aggregate node data instead of the aggregate zone
data.

Use global_node_page_state() to access the global slab counters.

Fixes: 385386cff4c6 ("mm: vmstat: move slab statistics from zone to node counters")
Link: http://lkml.kernel.org/r/20170801134256.5400-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c       |    8 ++++----
 kernel/power/snapshot.c |    2 +-
 mm/page_alloc.c         |    9 +++++----
 mm/util.c               |    2 +-
 4 files changed, 11 insertions(+), 10 deletions(-)

diff -puN fs/proc/meminfo.c~mm-fix-global-nr_slab_claimable-counter-reads fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-fix-global-nr_slab_claimable-counter-reads
+++ a/fs/proc/meminfo.c
@@ -106,13 +106,13 @@ static int meminfo_proc_show(struct seq_
 		    global_node_page_state(NR_FILE_MAPPED));
 	show_val_kb(m, "Shmem:          ", i.sharedram);
 	show_val_kb(m, "Slab:           ",
-		    global_page_state(NR_SLAB_RECLAIMABLE) +
-		    global_page_state(NR_SLAB_UNRECLAIMABLE));
+		    global_node_page_state(NR_SLAB_RECLAIMABLE) +
+		    global_node_page_state(NR_SLAB_UNRECLAIMABLE));
 
 	show_val_kb(m, "SReclaimable:   ",
-		    global_page_state(NR_SLAB_RECLAIMABLE));
+		    global_node_page_state(NR_SLAB_RECLAIMABLE));
 	show_val_kb(m, "SUnreclaim:     ",
-		    global_page_state(NR_SLAB_UNRECLAIMABLE));
+		    global_node_page_state(NR_SLAB_UNRECLAIMABLE));
 	seq_printf(m, "KernelStack:    %8lu kB\n",
 		   global_page_state(NR_KERNEL_STACK_KB));
 	show_val_kb(m, "PageTables:     ",
diff -puN kernel/power/snapshot.c~mm-fix-global-nr_slab_claimable-counter-reads kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~mm-fix-global-nr_slab_claimable-counter-reads
+++ a/kernel/power/snapshot.c
@@ -1650,7 +1650,7 @@ static unsigned long minimum_image_size(
 {
 	unsigned long size;
 
-	size = global_page_state(NR_SLAB_RECLAIMABLE)
+	size = global_node_page_state(NR_SLAB_RECLAIMABLE)
 		+ global_node_page_state(NR_ACTIVE_ANON)
 		+ global_node_page_state(NR_INACTIVE_ANON)
 		+ global_node_page_state(NR_ACTIVE_FILE)
diff -puN mm/page_alloc.c~mm-fix-global-nr_slab_claimable-counter-reads mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-global-nr_slab_claimable-counter-reads
+++ a/mm/page_alloc.c
@@ -4458,8 +4458,9 @@ long si_mem_available(void)
 	 * Part of the reclaimable slab consists of items that are in use,
 	 * and cannot be freed. Cap this estimate at the low watermark.
 	 */
-	available += global_page_state(NR_SLAB_RECLAIMABLE) -
-		     min(global_page_state(NR_SLAB_RECLAIMABLE) / 2, wmark_low);
+	available += global_node_page_state(NR_SLAB_RECLAIMABLE) -
+		     min(global_node_page_state(NR_SLAB_RECLAIMABLE) / 2,
+			 wmark_low);
 
 	if (available < 0)
 		available = 0;
@@ -4602,8 +4603,8 @@ void show_free_areas(unsigned int filter
 		global_node_page_state(NR_FILE_DIRTY),
 		global_node_page_state(NR_WRITEBACK),
 		global_node_page_state(NR_UNSTABLE_NFS),
-		global_page_state(NR_SLAB_RECLAIMABLE),
-		global_page_state(NR_SLAB_UNRECLAIMABLE),
+		global_node_page_state(NR_SLAB_RECLAIMABLE),
+		global_node_page_state(NR_SLAB_UNRECLAIMABLE),
 		global_node_page_state(NR_FILE_MAPPED),
 		global_node_page_state(NR_SHMEM),
 		global_page_state(NR_PAGETABLE),
diff -puN mm/util.c~mm-fix-global-nr_slab_claimable-counter-reads mm/util.c
--- a/mm/util.c~mm-fix-global-nr_slab_claimable-counter-reads
+++ a/mm/util.c
@@ -633,7 +633,7 @@ int __vm_enough_memory(struct mm_struct
 		 * which are reclaimable, under pressure.  The dentry
 		 * cache and most inode caches should fall into this
 		 */
-		free += global_page_state(NR_SLAB_RECLAIMABLE);
+		free += global_node_page_state(NR_SLAB_RECLAIMABLE);
 
 		/*
 		 * Leave reserved pages. The pages are not for anonymous pages.
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-global-nr_slab_claimable-counter-reads.patch

