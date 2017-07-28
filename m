From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-use-int-for-event-state-parameter-in-several-functions-v2.patch added to -mm tree
Date: Fri, 28 Jul 2017 14:47:18 -0700
Message-ID: <597bb0e6.QAlShWFUv+djwzK1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55082 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752628AbdG1VrT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2017 17:47:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mka@chromium.org, dianders@chromium.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-use-int-for-event-state-parameter-in-several-functions-v2
has been added to the -mm tree.  Its filename is
     mm-memcontrol-use-int-for-event-state-parameter-in-several-functions-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-use-int-for-event-state-parameter-in-several-functions-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-use-int-for-event-state-parameter-in-several-functions-v2.patch

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
Subject: mm-memcontrol-use-int-for-event-state-parameter-in-several-functions-v2

also change parameter type of inc/dec/mod_memcg_page_state()

Link: http://lkml.kernel.org/r/20170728213442.93823-1-mka@chromium.org
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-use-int-for-event-state-parameter-in-several-functions-v2 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-use-int-for-event-state-parameter-in-several-functions-v2
+++ a/include/linux/memcontrol.h
@@ -537,14 +537,14 @@ static inline void mod_memcg_state(struc
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
@@ -862,13 +862,13 @@ static inline void mod_memcg_state(struc
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
@@ -932,26 +932,30 @@ void count_memcg_event_mm(struct mm_stru
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
@@ -980,26 +984,30 @@ static inline void __dec_lruvec_page_sta
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
_

Patches currently in -mm which might be from mka@chromium.org are

mm-memcontrol-use-int-for-event-state-parameter-in-several-functions.patch
mm-memcontrol-use-int-for-event-state-parameter-in-several-functions-v2.patch

