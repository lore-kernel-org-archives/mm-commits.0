From: akpm@linux-foundation.org
Subject: [patch 065/119] mm: memcontrol: use int for event/state
 parameter in several functions
Date: Wed, 06 Sep 2017 16:22:09 -0700
Message-ID: <20170906232209.eBdfrUrOv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50128 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754752AbdIFXWK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dianders@chromium.org, hannes@cmpxchg.org, mhocko@suse.com, mka@chromium.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Matthias Kaehlcke <mka@chromium.org>
Subject: mm: memcontrol: use int for event/state parameter in several functions

Several functions use an enum type as parameter for an event/state, but
are called in some locations with an argument of a different enum type. 
Adjust the interface of these functions to reality by changing the
parameter to int.

This fixes a ton of enum-conversion warnings that are generated when
building the kernel with clang.

[mka@chromium.org: also change parameter type of inc/dec/mod_memcg_page_state()]
  Link: http://lkml.kernel.org/r/20170728213442.93823-1-mka@chromium.org
Link: http://lkml.kernel.org/r/20170727211004.34435-1-mka@chromium.org
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   52 +++++++++++++++++++++--------------
 mm/memcontrol.c            |    4 ++
 2 files changed, 35 insertions(+), 21 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-use-int-for-event-state-parameter-in-several-functions include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-use-int-for-event-state-parameter-in-several-functions
+++ a/include/linux/memcontrol.h
@@ -488,8 +488,9 @@ struct mem_cgroup *lock_page_memcg(struc
 void __unlock_page_memcg(struct mem_cgroup *memcg);
 void unlock_page_memcg(struct page *page);
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
-					     enum memcg_stat_item idx)
+					     int idx)
 {
 	long val = 0;
 	int cpu;
@@ -503,15 +504,17 @@ static inline unsigned long memcg_page_s
 	return val;
 }
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void __mod_memcg_state(struct mem_cgroup *memcg,
-				     enum memcg_stat_item idx, int val)
+				     int idx, int val)
 {
 	if (!mem_cgroup_disabled())
 		__this_cpu_add(memcg->stat->count[idx], val);
 }
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void mod_memcg_state(struct mem_cgroup *memcg,
-				   enum memcg_stat_item idx, int val)
+				   int idx, int val)
 {
 	if (!mem_cgroup_disabled())
 		this_cpu_add(memcg->stat->count[idx], val);
@@ -535,14 +538,14 @@ static inline void mod_memcg_state(struc
  * Kernel pages are an exception to this, since they'll never move.
  */
 static inline void __mod_memcg_page_state(struct page *page,
-					  enum memcg_stat_item idx, int val)
+					  int idx, int val)
 {
 	if (page->mem_cgroup)
 		__mod_memcg_state(page->mem_cgroup, idx, val);
 }
 
 static inline void mod_memcg_page_state(struct page *page,
-					enum memcg_stat_item idx, int val)
+					int idx, int val)
 {
 	if (page->mem_cgroup)
 		mod_memcg_state(page->mem_cgroup, idx, val);
@@ -632,8 +635,9 @@ static inline void count_memcg_events(st
 		this_cpu_add(memcg->stat->events[idx], count);
 }
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void count_memcg_page_event(struct page *page,
-					  enum memcg_stat_item idx)
+					  int idx)
 {
 	if (page->mem_cgroup)
 		count_memcg_events(page->mem_cgroup, idx, 1);
@@ -846,31 +850,31 @@ static inline bool mem_cgroup_oom_synchr
 }
 
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
-					     enum memcg_stat_item idx)
+					     int idx)
 {
 	return 0;
 }
 
 static inline void __mod_memcg_state(struct mem_cgroup *memcg,
-				     enum memcg_stat_item idx,
+				     int idx,
 				     int nr)
 {
 }
 
 static inline void mod_memcg_state(struct mem_cgroup *memcg,
-				   enum memcg_stat_item idx,
+				   int idx,
 				   int nr)
 {
 }
 
 static inline void __mod_memcg_page_state(struct page *page,
-					  enum memcg_stat_item idx,
+					  int idx,
 					  int nr)
 {
 }
 
 static inline void mod_memcg_page_state(struct page *page,
-					enum memcg_stat_item idx,
+					int idx,
 					int nr)
 {
 }
@@ -924,7 +928,7 @@ static inline void count_memcg_events(st
 }
 
 static inline void count_memcg_page_event(struct page *page,
-					  enum memcg_stat_item idx)
+					  int idx)
 {
 }
 
@@ -934,26 +938,30 @@ void count_memcg_event_mm(struct mm_stru
 }
 #endif /* CONFIG_MEMCG */
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void __inc_memcg_state(struct mem_cgroup *memcg,
-				     enum memcg_stat_item idx)
+				     int idx)
 {
 	__mod_memcg_state(memcg, idx, 1);
 }
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void __dec_memcg_state(struct mem_cgroup *memcg,
-				     enum memcg_stat_item idx)
+				     int idx)
 {
 	__mod_memcg_state(memcg, idx, -1);
 }
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void __inc_memcg_page_state(struct page *page,
-					  enum memcg_stat_item idx)
+					  int idx)
 {
 	__mod_memcg_page_state(page, idx, 1);
 }
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void __dec_memcg_page_state(struct page *page,
-					  enum memcg_stat_item idx)
+					  int idx)
 {
 	__mod_memcg_page_state(page, idx, -1);
 }
@@ -982,26 +990,30 @@ static inline void __dec_lruvec_page_sta
 	__mod_lruvec_page_state(page, idx, -1);
 }
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void inc_memcg_state(struct mem_cgroup *memcg,
-				   enum memcg_stat_item idx)
+				   int idx)
 {
 	mod_memcg_state(memcg, idx, 1);
 }
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void dec_memcg_state(struct mem_cgroup *memcg,
-				   enum memcg_stat_item idx)
+				   int idx)
 {
 	mod_memcg_state(memcg, idx, -1);
 }
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void inc_memcg_page_state(struct page *page,
-					enum memcg_stat_item idx)
+					int idx)
 {
 	mod_memcg_page_state(page, idx, 1);
 }
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void dec_memcg_page_state(struct page *page,
-					enum memcg_stat_item idx)
+					int idx)
 {
 	mod_memcg_page_state(page, idx, -1);
 }
diff -puN mm/memcontrol.c~mm-memcontrol-use-int-for-event-state-parameter-in-several-functions mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-use-int-for-event-state-parameter-in-several-functions
+++ a/mm/memcontrol.c
@@ -550,10 +550,12 @@ mem_cgroup_largest_soft_limit_node(struc
  * value, and reading all cpu value can be performance bottleneck in some
  * common workload, threshold and synchronization as vmstat[] should be
  * implemented.
+ *
+ * The parameter idx can be of type enum memcg_event_item or vm_event_item.
  */
 
 static unsigned long memcg_sum_events(struct mem_cgroup *memcg,
-				      enum memcg_event_item event)
+				      int event)
 {
 	unsigned long val = 0;
 	int cpu;
_
