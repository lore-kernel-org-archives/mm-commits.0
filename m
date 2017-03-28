From: akpm@linux-foundation.org
Subject: + mm-rmap-fix-huge-file-mmap-accounting-in-the-memcg-stats.patch
 added to -mm tree
Date: Tue, 28 Mar 2017 13:29:38 -0700
Message-ID: <58dac7b2.xPQxqUf2saODb+h9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53652 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753487AbdC1U3p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 16:29:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, mhocko@suse.com, stable@vger.kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: fix huge file mmap accounting in the memcg stats
has been added to the -mm tree.  Its filename is
     mm-rmap-fix-huge-file-mmap-accounting-in-the-memcg-stats.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-fix-huge-file-mmap-accounting-in-the-memcg-stats.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-fix-huge-file-mmap-accounting-in-the-memcg-stats.patch

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
Subject: mm: rmap: fix huge file mmap accounting in the memcg stats

Huge pages are accounted as single units in the memcg's "file_mapped"
counter. Account the correct number of base pages, like we do in the
corresponding node counter.

Link: http://lkml.kernel.org/r/20170322005111.3156-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-rmap-fix-huge-file-mmap-accounting-in-the-memcg-stats.patch
mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch
mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix.patch
mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch
mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch
mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch
mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim.patch
mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch
revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch
mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch
mm-memcontrol-provide-shmem-statistics.patch
mm-page_alloc-__gfp_nowarn-shouldnt-suppress-stall-warnings.patch

