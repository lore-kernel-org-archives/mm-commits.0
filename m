From: akpm@linux-foundation.org
Subject: [folded] memcg-use-new-logic-for-page-stat-accounting-fix.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:25:24 -0700
Message-ID: <20120321232524.78F22A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:60442 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab2CUXZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:25:27 -0400
Received: by eaaq10 with SMTP id q10so82573eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:25:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-use-new-logic-for-page-stat-accounting-fix
has been removed from the -mm tree.  Its filename was
     memcg-use-new-logic-for-page-stat-accounting-fix.patch

This patch was dropped because it was folded into memcg-use-new-logic-for-page-stat-accounting.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-use-new-logic-for-page-stat-accounting-fix

s/lock/locked/

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   18 +++++++++---------
 mm/memcontrol.c            |    8 +++-----
 2 files changed, 12 insertions(+), 14 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-use-new-logic-for-page-stat-accounting-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-use-new-logic-for-page-stat-accounting-fix
+++ a/include/linux/memcontrol.h
@@ -141,27 +141,27 @@ static inline bool mem_cgroup_disabled(v
 	return false;
 }
 
-void __mem_cgroup_begin_update_page_stat(struct page *page,
-					bool *lock, unsigned long *flags);
+void __mem_cgroup_begin_update_page_stat(struct page *page, bool *locked,
+					 unsigned long *flags);
 
 static inline void mem_cgroup_begin_update_page_stat(struct page *page,
-					bool *lock, unsigned long *flags)
+					bool *locked, unsigned long *flags)
 {
 	if (mem_cgroup_disabled())
 		return;
 	rcu_read_lock();
-	*lock = false;
-	return __mem_cgroup_begin_update_page_stat(page, lock, flags);
+	*locked = false;
+	return __mem_cgroup_begin_update_page_stat(page, locked, flags);
 }
 
 void __mem_cgroup_end_update_page_stat(struct page *page,
 				unsigned long *flags);
 static inline void mem_cgroup_end_update_page_stat(struct page *page,
-					bool *lock, unsigned long *flags)
+					bool *locked, unsigned long *flags)
 {
 	if (mem_cgroup_disabled())
 		return;
-	if (*lock)
+	if (*locked)
 		__mem_cgroup_end_update_page_stat(page, flags);
 	rcu_read_unlock();
 }
@@ -367,12 +367,12 @@ mem_cgroup_print_oom_info(struct mem_cgr
 }
 
 static inline void mem_cgroup_begin_update_page_stat(struct page *page,
-					bool *lock, unsigned long *flags)
+					bool *locked, unsigned long *flags)
 {
 }
 
 static inline void mem_cgroup_end_update_page_stat(struct page *page,
-					bool *lock, unsigned long *flags)
+					bool *locked, unsigned long *flags)
 {
 }
 
diff -puN mm/memcontrol.c~memcg-use-new-logic-for-page-stat-accounting-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-new-logic-for-page-stat-accounting-fix
+++ a/mm/memcontrol.c
@@ -1911,7 +1911,7 @@ bool mem_cgroup_handle_oom(struct mem_cg
  */
 
 void __mem_cgroup_begin_update_page_stat(struct page *page,
-				bool *lock, unsigned long *flags)
+				bool *locked, unsigned long *flags)
 {
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc;
@@ -1935,11 +1935,10 @@ again:
 		move_unlock_mem_cgroup(memcg, flags);
 		goto again;
 	}
-	*lock = true;
+	*locked = true;
 }
 
-void __mem_cgroup_end_update_page_stat(struct page *page,
-				unsigned long *flags)
+void __mem_cgroup_end_update_page_stat(struct page *page, unsigned long *flags)
 {
 	struct page_cgroup *pc = lookup_page_cgroup(page);
 
@@ -1951,7 +1950,6 @@ void __mem_cgroup_end_update_page_stat(s
 	move_unlock_mem_cgroup(pc->mem_cgroup, flags);
 }
 
-
 void mem_cgroup_update_page_stat(struct page *page,
 				 enum mem_cgroup_page_stat_item idx, int val)
 {
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
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch

