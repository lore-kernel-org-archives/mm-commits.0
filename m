From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-use-int-for-event-state-parameter-in-several-functions.patch
 added to -mm tree
Date: Thu, 27 Jul 2017 14:29:17 -0700
Message-ID: <597a5b2d.s6sKUbnTkPzPDfPb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54770 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdG0V3S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 17:29:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mka@chromium.org, dianders@chromium.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use int for event/state parameter in several functions
has been added to the -mm tree.  Its filename is
     mm-memcontrol-use-int-for-event-state-parameter-in-several-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-use-int-for-event-state-parameter-in-several-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-use-int-for-event-state-parameter-in-several-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthias Kaehlcke <mka@chromium.org>
Subject: mm: memcontrol: use int for event/state parameter in several functions

Several functions use an enum type as parameter for an event/state, but
are called in some locations with an argument of a different enum type. 
Adjust the interface of these functions to reality by changing the
parameter to int.

This fixes a ton of enum-conversion warnings that are generated when
building the kernel with clang.

Link: http://lkml.kernel.org/r/20170727211004.34435-1-mka@chromium.org
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   20 ++++++++++++--------
 mm/memcontrol.c            |    4 +++-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-use-int-for-event-state-parameter-in-several-functions include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-use-int-for-event-state-parameter-in-several-functions
+++ a/include/linux/memcontrol.h
@@ -487,8 +487,9 @@ extern int do_swap_account;
 void lock_page_memcg(struct page *page);
 void unlock_page_memcg(struct page *page);
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
-					     enum memcg_stat_item idx)
+					     int idx)
 {
 	long val = 0;
 	int cpu;
@@ -502,15 +503,17 @@ static inline unsigned long memcg_page_s
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
@@ -631,8 +634,9 @@ static inline void count_memcg_events(st
 		this_cpu_add(memcg->stat->events[idx], count);
 }
 
+/* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void count_memcg_page_event(struct page *page,
-					  enum memcg_stat_item idx)
+					  int idx)
 {
 	if (page->mem_cgroup)
 		count_memcg_events(page->mem_cgroup, idx, 1);
@@ -840,19 +844,19 @@ static inline bool mem_cgroup_oom_synchr
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
@@ -918,7 +922,7 @@ static inline void count_memcg_events(st
 }
 
 static inline void count_memcg_page_event(struct page *page,
-					  enum memcg_stat_item idx)
+					  int idx)
 {
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

Patches currently in -mm which might be from mka@chromium.org are

mm-memcontrol-use-int-for-event-state-parameter-in-several-functions.patch

