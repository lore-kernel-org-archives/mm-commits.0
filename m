From: akpm@linux-foundation.org
Subject: [patch 03/11] mm: rmap: fix huge file mmap accounting in the
 memcg stats
Date: Fri, 31 Mar 2017 15:11:50 -0700
Message-ID: <58ded426.K0bocRe+OLKG8lD4%akpm__39.2250404276595$1490998313$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41576 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933149AbdCaWLv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Mar 2017 18:11:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, mhocko@suse.com, stable@vger.kernel.org, vdavydov.dev@gmail.com

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: rmap: fix huge file mmap accounting in the memcg stats

Huge pages are accounted as single units in the memcg's "file_mapped"
counter. Account the correct number of base pages, like we do in the
corresponding node counter.

Link: http://lkml.kernel.org/r/20170322005111.3156-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>	[4.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++++
 mm/rmap.c                  |    4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~mm-rmap-fix-huge-file-mmap-accounting-in-the-memcg-stats include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-rmap-fix-huge-file-mmap-accounting-in-the-memcg-stats
+++ a/include/linux/memcontrol.h
@@ -740,6 +740,12 @@ static inline bool mem_cgroup_oom_synchr
 	return false;
 }
 
+static inline void mem_cgroup_update_page_stat(struct page *page,
+					       enum mem_cgroup_stat_index idx,
+					       int nr)
+{
+}
+
 static inline void mem_cgroup_inc_page_stat(struct page *page,
 					    enum mem_cgroup_stat_index idx)
 {
diff -puN mm/rmap.c~mm-rmap-fix-huge-file-mmap-accounting-in-the-memcg-stats mm/rmap.c
--- a/mm/rmap.c~mm-rmap-fix-huge-file-mmap-accounting-in-the-memcg-stats
+++ a/mm/rmap.c
@@ -1159,7 +1159,7 @@ void page_add_file_rmap(struct page *pag
 			goto out;
 	}
 	__mod_node_page_state(page_pgdat(page), NR_FILE_MAPPED, nr);
-	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
+	mem_cgroup_update_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED, nr);
 out:
 	unlock_page_memcg(page);
 }
@@ -1199,7 +1199,7 @@ static void page_remove_file_rmap(struct
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
 	__mod_node_page_state(page_pgdat(page), NR_FILE_MAPPED, -nr);
-	mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
+	mem_cgroup_update_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED, -nr);
 
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
_
