From: akpm@linux-foundation.org
Subject: [folded-merged] memcg-get_mem_cgroup_from_mm-fix.patch removed
 from -mm tree
Date: Mon, 07 Apr 2014 15:09:32 -0700
Message-ID: <5343221c.YrX82JG3pdF0Q0Pl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbaDGWJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:09:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, fengguang.wu@intel.com

Subject: [folded-merged] memcg-get_mem_cgroup_from_mm-fix.patch removed from -mm tree
To: fengguang.wu@intel.com,hannes@cmpxchg.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:09:32 -0700


The patch titled
     Subject: memcg-get_mem_cgroup_from_mm-fix
has been removed from the -mm tree.  Its filename was
     memcg-get_mem_cgroup_from_mm-fix.patch

This patch was dropped because it was folded into memcg-get_mem_cgroup_from_mm.patch

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: memcg-get_mem_cgroup_from_mm-fix

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ------
 mm/memcontrol.c            |    2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-get_mem_cgroup_from_mm-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-get_mem_cgroup_from_mm-fix
+++ a/include/linux/memcontrol.h
@@ -94,7 +94,6 @@ bool task_in_mem_cgroup(struct task_stru
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
-extern struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm);
 
 extern struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg);
 extern struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css);
@@ -293,11 +292,6 @@ static inline struct mem_cgroup *try_get
 {
 	return NULL;
 }
-
-static inline struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
-{
-	return NULL;
-}
 
 static inline bool mm_match_cgroup(struct mm_struct *mm,
 		struct mem_cgroup *memcg)
diff -puN mm/memcontrol.c~memcg-get_mem_cgroup_from_mm-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-get_mem_cgroup_from_mm-fix
+++ a/mm/memcontrol.c
@@ -1071,7 +1071,7 @@ struct mem_cgroup *mem_cgroup_from_task(
 	return mem_cgroup_from_css(task_css(p, memory_cgrp_id));
 }
 
-struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
+static struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	struct mem_cgroup *memcg = NULL;
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
tools-vm-page-typesc-page-cache-sniffing-feature.patch
memcg-get_mem_cgroup_from_mm.patch
zram-propagate-error-to-user-fix-2.patch
slub-use-raw_cpu_inc-for-incrementing-statistics.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch

