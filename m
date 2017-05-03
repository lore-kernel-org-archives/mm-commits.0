From: akpm@linux-foundation.org
Subject: [patch 025/102] mm: memcontrol: provide shmem statistics
Date: Wed, 03 May 2017 14:52:45 -0700
Message-ID: <20170503215245.VmG8MgQ7s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751535AbdECVwr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:52:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cdown@fb.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: provide shmem statistics

Cgroups currently don't report how much shmem they use, which can be
useful data to have, in particular since shmem is included in the
cache/file item while being reclaimed like anonymous memory.

Add a counter to track shmem pages during charging and uncharging.

Link: http://lkml.kernel.org/r/20170221164343.32252-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Chris Down <cdown@fb.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v2.txt |    5 +++++
 include/linux/memcontrol.h  |    1 +
 mm/memcontrol.c             |   28 ++++++++++++++++++++--------
 3 files changed, 26 insertions(+), 8 deletions(-)

diff -puN Documentation/cgroup-v2.txt~mm-memcontrol-provide-shmem-statistics Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt~mm-memcontrol-provide-shmem-statistics
+++ a/Documentation/cgroup-v2.txt
@@ -871,6 +871,11 @@ PAGE_SIZE multiple when read back.
 
 		Amount of memory used in network transmission buffers
 
+	  shmem
+
+		Amount of cached filesystem data that is swap-backed,
+		such as tmpfs, shm segments, shared anonymous mmap()s
+
 	  file_mapped
 
 		Amount of cached filesystem data mapped with mmap()
diff -puN include/linux/memcontrol.h~mm-memcontrol-provide-shmem-statistics include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-provide-shmem-statistics
+++ a/include/linux/memcontrol.h
@@ -46,6 +46,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_CACHE,		/* # of pages charged as cache */
 	MEM_CGROUP_STAT_RSS,		/* # of pages charged as anon rss */
 	MEM_CGROUP_STAT_RSS_HUGE,	/* # of pages charged as anon huge */
+	MEM_CGROUP_STAT_SHMEM,		/* # of pages charged as shmem */
 	MEM_CGROUP_STAT_FILE_MAPPED,	/* # of pages charged as file rss */
 	MEM_CGROUP_STAT_DIRTY,          /* # of dirty pages in page cache */
 	MEM_CGROUP_STAT_WRITEBACK,	/* # of pages under writeback */
diff -puN mm/memcontrol.c~mm-memcontrol-provide-shmem-statistics mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-provide-shmem-statistics
+++ a/mm/memcontrol.c
@@ -104,6 +104,7 @@ static const char * const mem_cgroup_sta
 	"cache",
 	"rss",
 	"rss_huge",
+	"shmem",
 	"mapped_file",
 	"dirty",
 	"writeback",
@@ -608,9 +609,13 @@ static void mem_cgroup_charge_statistics
 	if (PageAnon(page))
 		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_RSS],
 				nr_pages);
-	else
+	else {
 		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_CACHE],
 				nr_pages);
+		if (PageSwapBacked(page))
+			__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SHMEM],
+				       nr_pages);
+	}
 
 	if (compound) {
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
@@ -5208,6 +5213,8 @@ static int memory_stat_show(struct seq_f
 	seq_printf(m, "sock %llu\n",
 		   (u64)stat[MEMCG_SOCK] * PAGE_SIZE);
 
+	seq_printf(m, "shmem %llu\n",
+		   (u64)stat[MEM_CGROUP_STAT_SHMEM] * PAGE_SIZE);
 	seq_printf(m, "file_mapped %llu\n",
 		   (u64)stat[MEM_CGROUP_STAT_FILE_MAPPED] * PAGE_SIZE);
 	seq_printf(m, "file_dirty %llu\n",
@@ -5476,8 +5483,8 @@ void mem_cgroup_cancel_charge(struct pag
 
 static void uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 			   unsigned long nr_anon, unsigned long nr_file,
-			   unsigned long nr_huge, unsigned long nr_kmem,
-			   struct page *dummy_page)
+			   unsigned long nr_kmem, unsigned long nr_huge,
+			   unsigned long nr_shmem, struct page *dummy_page)
 {
 	unsigned long nr_pages = nr_anon + nr_file + nr_kmem;
 	unsigned long flags;
@@ -5495,6 +5502,7 @@ static void uncharge_batch(struct mem_cg
 	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS], nr_anon);
 	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_CACHE], nr_file);
 	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS_HUGE], nr_huge);
+	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_SHMEM], nr_shmem);
 	__this_cpu_add(memcg->stat->events[MEM_CGROUP_EVENTS_PGPGOUT], pgpgout);
 	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
 	memcg_check_events(memcg, dummy_page);
@@ -5507,6 +5515,7 @@ static void uncharge_batch(struct mem_cg
 static void uncharge_list(struct list_head *page_list)
 {
 	struct mem_cgroup *memcg = NULL;
+	unsigned long nr_shmem = 0;
 	unsigned long nr_anon = 0;
 	unsigned long nr_file = 0;
 	unsigned long nr_huge = 0;
@@ -5539,9 +5548,9 @@ static void uncharge_list(struct list_he
 		if (memcg != page->mem_cgroup) {
 			if (memcg) {
 				uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
-					       nr_huge, nr_kmem, page);
-				pgpgout = nr_anon = nr_file =
-					nr_huge = nr_kmem = 0;
+					       nr_kmem, nr_huge, nr_shmem, page);
+				pgpgout = nr_anon = nr_file = nr_kmem = 0;
+				nr_huge = nr_shmem = 0;
 			}
 			memcg = page->mem_cgroup;
 		}
@@ -5555,8 +5564,11 @@ static void uncharge_list(struct list_he
 			}
 			if (PageAnon(page))
 				nr_anon += nr_pages;
-			else
+			else {
 				nr_file += nr_pages;
+				if (PageSwapBacked(page))
+					nr_shmem += nr_pages;
+			}
 			pgpgout++;
 		} else {
 			nr_kmem += 1 << compound_order(page);
@@ -5568,7 +5580,7 @@ static void uncharge_list(struct list_he
 
 	if (memcg)
 		uncharge_batch(memcg, pgpgout, nr_anon, nr_file,
-			       nr_huge, nr_kmem, page);
+			       nr_kmem, nr_huge, nr_shmem, page);
 }
 
 /**
_
