From: akpm@linux-foundation.org
Subject: [folded] memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:27:39 -0700
Message-ID: <20120321232739.2F93FA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:37235 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345Ab2CUX1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:27:40 -0400
Received: by ghbz15 with SMTP id z15so274126ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:27:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gthelen@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix
has been removed from the -mm tree.  Its filename was
     memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch

This patch was dropped because it was folded into memcg-fix-performance-of-mem_cgroup_begin_update_page_stat.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix

don't return a void

Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix
+++ a/include/linux/memcontrol.h
@@ -154,8 +154,7 @@ static inline void mem_cgroup_begin_upda
 	rcu_read_lock();
 	*locked = false;
 	if (atomic_read(&memcg_moving))
-		return __mem_cgroup_begin_update_page_stat(page, locked,
-								flags);
+		__mem_cgroup_begin_update_page_stat(page, locked, flags);
 }
 
 void __mem_cgroup_end_update_page_stat(struct page *page,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode.patch
fs-nameic-fix-warnings-on-32-bit.patch
make-swapin-readahead-skip-over-holes.patch
vmscan-kswapd-carefully-call-compaction.patch
mm-compaction-make-compact_control-order-signed.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
thp-optimize-away-unnecessary-page-table-locking.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
mm-fix-move-migrate_pages-race-on-task-struct.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section.patch
hugetlbfs-fix-alignment-of-huge-page-requests.patch
hugetlbfs-return-error-code-when-initializing-module.patch
mmapc-fix-comment-for-__insert_vm_struct.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-use-new-logic-for-page-stat-accounting.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat.patch
mm-memcontrolc-s-stealed-stolen.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch

