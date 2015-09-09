From: akpm@linux-foundation.org
Subject: [merged]
 memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:45:48 -0700
Message-ID: <55f08c6c.s9rT3GHdbwuwQSxE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbbIITpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:45:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: get rid of extern for functions in memcontrol.h
has been removed from the -mm tree.  Its filename was
     memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: get rid of extern for functions in memcontrol.h

Most of the exported functions in this header are not marked extern so
change the rest to follow the same style.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-get-rid-of-extern-for-functions-in-memcontrolh include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-get-rid-of-extern-for-functions-in-memcontrolh
+++ a/include/linux/memcontrol.h
@@ -306,10 +306,10 @@ struct lruvec *mem_cgroup_page_lruvec(st
 
 bool task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *memcg);
 
-extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
-extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
+struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
+struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
-extern struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg);
+struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg);
 static inline
 struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
 	return css ? container_of(css, struct mem_cgroup, css) : NULL;
@@ -344,7 +344,7 @@ static inline bool mm_match_cgroup(struc
 	return match;
 }
 
-extern struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page);
+struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page);
 
 static inline bool mem_cgroup_disabled(void)
 {
@@ -403,8 +403,8 @@ static inline int mem_cgroup_inactive_an
 	return inactive * inactive_ratio < active;
 }
 
-extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
-					struct task_struct *p);
+void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
+				struct task_struct *p);
 
 static inline void mem_cgroup_oom_enable(void)
 {
@@ -719,8 +719,8 @@ static inline void sock_release_memcg(st
 extern struct static_key memcg_kmem_enabled_key;
 
 extern int memcg_nr_cache_ids;
-extern void memcg_get_cache_ids(void);
-extern void memcg_put_cache_ids(void);
+void memcg_get_cache_ids(void);
+void memcg_put_cache_ids(void);
 
 /*
  * Helper macro to loop through all memcg-specific caches. Callers must still
_

Patches currently in -mm which might be from mhocko@suse.cz are


