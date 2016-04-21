From: akpm@linux-foundation.org
Subject: [to-be-updated]
 huge-tmpfs-mem_cgroup-shmem_pmdmapped-accounting.patch removed from -mm
 tree
Date: Thu, 21 Apr 2016 13:46:33 -0700
Message-ID: <57193c29.iaHDsxoCGZ60VNjf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbcDUUqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 16:46:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreslc@google.com, aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: mem_cgroup shmem_pmdmapped accounting
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-mem_cgroup-shmem_pmdmapped-accounting.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andres Lagar-Cavilla <andreslc@google.com>
Subject: huge tmpfs: mem_cgroup shmem_pmdmapped accounting

Grep now for shmem_pmdmapped in memory.stat (and also for "total_..." in a
hierarchical setting).

This metric allows for easy checking on a per-cgroup basis of the amount
of page team memory hugely mapped (at least once) out there.

The metric is counted towards the cgroup owning the page (unlike in an
event such as THP split) because the team page may be mapped hugely for
the first time via a shared map in some other process.

Moved up mem_group_move_account()'s PageWriteback block: that movement is
irrelevant to this patch, but lets us concentrate better on the PageTeam
locking issues which follow in the next patch.

Signed-off-by: Andres Lagar-Cavilla <andreslc@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 ++
 include/linux/pageteam.h   |   16 ++++++++++++++++
 mm/huge_memory.c           |    4 ++++
 mm/memcontrol.c            |   35 ++++++++++++++++++++++++++---------
 4 files changed, 48 insertions(+), 9 deletions(-)

diff -puN include/linux/memcontrol.h~huge-tmpfs-mem_cgroup-shmem_pmdmapped-accounting include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~huge-tmpfs-mem_cgroup-shmem_pmdmapped-accounting
+++ a/include/linux/memcontrol.h
@@ -50,6 +50,8 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_DIRTY,          /* # of dirty pages in page cache */
 	MEM_CGROUP_STAT_WRITEBACK,	/* # of pages under writeback */
 	MEM_CGROUP_STAT_SWAP,		/* # of pages, swapped out */
+	/* # of pages charged as hugely mapped teams */
+	MEM_CGROUP_STAT_SHMEM_PMDMAPPED,
 	MEM_CGROUP_STAT_NSTATS,
 	/* default hierarchy stats */
 	MEMCG_KERNEL_STACK = MEM_CGROUP_STAT_NSTATS,
diff -puN include/linux/pageteam.h~huge-tmpfs-mem_cgroup-shmem_pmdmapped-accounting include/linux/pageteam.h
--- a/include/linux/pageteam.h~huge-tmpfs-mem_cgroup-shmem_pmdmapped-accounting
+++ a/include/linux/pageteam.h
@@ -135,6 +135,22 @@ static inline bool dec_team_pmd_mapped(s
 }
 
 /*
+ * Supplies those values which mem_cgroup_move_account()
+ * needs to maintain memcg's huge tmpfs stats correctly.
+ */
+static inline void count_team_pmd_mapped(struct page *head, int *file_mapped,
+					 bool *pmd_mapped)
+{
+	long team_usage;
+
+	*file_mapped = 1;
+	team_usage = atomic_long_read(&head->team_usage);
+	*pmd_mapped = team_usage >= TEAM_PMD_MAPPED;
+	if (*pmd_mapped)
+		*file_mapped = HPAGE_PMD_NR - team_pte_count(team_usage);
+}
+
+/*
  * Returns true if this pte mapping is of a non-team page, or of a team page not
  * covered by an existing huge pmd mapping: whereupon stats need to be updated.
  * Only called when mapcount goes up from 0 to 1 i.e. _mapcount from -1 to 0.
diff -puN mm/huge_memory.c~huge-tmpfs-mem_cgroup-shmem_pmdmapped-accounting mm/huge_memory.c
--- a/mm/huge_memory.c~huge-tmpfs-mem_cgroup-shmem_pmdmapped-accounting
+++ a/mm/huge_memory.c
@@ -3512,6 +3512,8 @@ static void page_add_team_rmap(struct pa
 		__mod_zone_page_state(zone, NR_FILE_MAPPED, nr_pages);
 		mem_cgroup_update_page_stat(page,
 				MEM_CGROUP_STAT_FILE_MAPPED, nr_pages);
+		mem_cgroup_update_page_stat(page,
+				MEM_CGROUP_STAT_SHMEM_PMDMAPPED, HPAGE_PMD_NR);
 	}
 	unlock_page_memcg(page);
 }
@@ -3531,6 +3533,8 @@ static void page_remove_team_rmap(struct
 		__mod_zone_page_state(zone, NR_FILE_MAPPED, -nr_pages);
 		mem_cgroup_update_page_stat(page,
 				MEM_CGROUP_STAT_FILE_MAPPED, -nr_pages);
+		mem_cgroup_update_page_stat(page,
+				MEM_CGROUP_STAT_SHMEM_PMDMAPPED, -HPAGE_PMD_NR);
 	}
 	unlock_page_memcg(page);
 }
diff -puN mm/memcontrol.c~huge-tmpfs-mem_cgroup-shmem_pmdmapped-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~huge-tmpfs-mem_cgroup-shmem_pmdmapped-accounting
+++ a/mm/memcontrol.c
@@ -37,6 +37,7 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
+#include <linux/pageteam.h>
 #include <linux/smp.h>
 #include <linux/page-flags.h>
 #include <linux/backing-dev.h>
@@ -106,6 +107,7 @@ static const char * const mem_cgroup_sta
 	"dirty",
 	"writeback",
 	"swap",
+	"shmem_pmdmapped",
 };
 
 static const char * const mem_cgroup_events_names[] = {
@@ -4444,7 +4446,8 @@ static int mem_cgroup_move_account(struc
 				   struct mem_cgroup *to)
 {
 	unsigned long flags;
-	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
+	int nr_pages = compound ? hpage_nr_pages(page) : 1;
+	int file_mapped = 1;
 	int ret;
 	bool anon;
 
@@ -4468,10 +4471,10 @@ static int mem_cgroup_move_account(struc
 
 	spin_lock_irqsave(&from->move_lock, flags);
 
-	if (!anon && page_mapped(page)) {
-		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
+	if (PageWriteback(page)) {
+		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_WRITEBACK],
 			       nr_pages);
-		__this_cpu_add(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
+		__this_cpu_add(to->stat->count[MEM_CGROUP_STAT_WRITEBACK],
 			       nr_pages);
 	}
 
@@ -4491,11 +4494,25 @@ static int mem_cgroup_move_account(struc
 		}
 	}
 
-	if (PageWriteback(page)) {
-		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_WRITEBACK],
-			       nr_pages);
-		__this_cpu_add(to->stat->count[MEM_CGROUP_STAT_WRITEBACK],
-			       nr_pages);
+	if (!anon && PageTeam(page)) {
+		if (page == team_head(page)) {
+			bool pmd_mapped;
+
+			count_team_pmd_mapped(page, &file_mapped, &pmd_mapped);
+			if (pmd_mapped) {
+				__this_cpu_sub(from->stat->count[
+				MEM_CGROUP_STAT_SHMEM_PMDMAPPED], HPAGE_PMD_NR);
+				__this_cpu_add(to->stat->count[
+				MEM_CGROUP_STAT_SHMEM_PMDMAPPED], HPAGE_PMD_NR);
+			}
+		}
+	}
+
+	if (!anon && page_mapped(page)) {
+		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
+			       file_mapped);
+		__this_cpu_add(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
+			       file_mapped);
 	}
 
 	/*
_

Patches currently in -mm which might be from andreslc@google.com are

tmpfs-mem_cgroup-charge-fault-to-vm_mm-not-current-mm.patch
huge-tmpfs-mem_cgroup-shmem_hugepages-accounting.patch
huge-tmpfs-show-page-team-flag-in-pageflags.patch

