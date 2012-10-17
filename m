From: akpm@linux-foundation.org
Subject: + mm-use-is_enabledconfig_numa-instead-of-numa_build.patch added to -mm tree
Date: Wed, 17 Oct 2012 15:02:38 -0700
Message-ID: <20121017220239.32427200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:44581 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2JQWCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 18:02:41 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so320582eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 15:02:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     Subject: mm: use IS_ENABLED(CONFIG_NUMA) instead of NUMA_BUILD
has been added to the -mm tree.  Its filename is
     mm-use-is_enabledconfig_numa-instead-of-numa_build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: use IS_ENABLED(CONFIG_NUMA) instead of NUMA_BUILD

We don't need custom NUMA_BUILD anymore, since we have handy
IS_ENABLED().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |    2 +-
 include/linux/kernel.h |    7 -------
 mm/page_alloc.c        |   18 ++++++++++--------
 mm/vmalloc.c           |    4 ++--
 4 files changed, 13 insertions(+), 18 deletions(-)

diff -puN include/linux/gfp.h~mm-use-is_enabledconfig_numa-instead-of-numa_build include/linux/gfp.h
--- a/include/linux/gfp.h~mm-use-is_enabledconfig_numa-instead-of-numa_build
+++ a/include/linux/gfp.h
@@ -263,7 +263,7 @@ static inline enum zone_type gfp_zone(gf
 
 static inline int gfp_zonelist(gfp_t flags)
 {
-	if (NUMA_BUILD && unlikely(flags & __GFP_THISNODE))
+	if (IS_ENABLED(CONFIG_NUMA) && unlikely(flags & __GFP_THISNODE))
 		return 1;
 
 	return 0;
diff -puN include/linux/kernel.h~mm-use-is_enabledconfig_numa-instead-of-numa_build include/linux/kernel.h
--- a/include/linux/kernel.h~mm-use-is_enabledconfig_numa-instead-of-numa_build
+++ a/include/linux/kernel.h
@@ -687,13 +687,6 @@ static inline void ftrace_dump(enum ftra
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
 
-/* This helps us to avoid #ifdef CONFIG_NUMA */
-#ifdef CONFIG_NUMA
-#define NUMA_BUILD 1
-#else
-#define NUMA_BUILD 0
-#endif
-
 /* This helps us avoid #ifdef CONFIG_COMPACTION */
 #ifdef CONFIG_COMPACTION
 #define COMPACTION_BUILD 1
diff -puN mm/page_alloc.c~mm-use-is_enabledconfig_numa-instead-of-numa_build mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-is_enabledconfig_numa-instead-of-numa_build
+++ a/mm/page_alloc.c
@@ -1870,7 +1870,7 @@ zonelist_scan:
 	 */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						high_zoneidx, nodemask) {
-		if (NUMA_BUILD && zlc_active &&
+		if (IS_ENABLED(CONFIG_NUMA) && zlc_active &&
 			!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
 		if ((alloc_flags & ALLOC_CPUSET) &&
@@ -1916,7 +1916,8 @@ zonelist_scan:
 				    classzone_idx, alloc_flags))
 				goto try_this_zone;
 
-			if (NUMA_BUILD && !did_zlc_setup && nr_online_nodes > 1) {
+			if (IS_ENABLED(CONFIG_NUMA) &&
+					!did_zlc_setup && nr_online_nodes > 1) {
 				/*
 				 * we do zlc_setup if there are multiple nodes
 				 * and before considering the first zone allowed
@@ -1935,7 +1936,7 @@ zonelist_scan:
 			 * As we may have just activated ZLC, check if the first
 			 * eligible zone has failed zone_reclaim recently.
 			 */
-			if (NUMA_BUILD && zlc_active &&
+			if (IS_ENABLED(CONFIG_NUMA) && zlc_active &&
 				!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
 
@@ -1961,11 +1962,11 @@ try_this_zone:
 		if (page)
 			break;
 this_zone_full:
-		if (NUMA_BUILD)
+		if (IS_ENABLED(CONFIG_NUMA))
 			zlc_mark_zone_full(zonelist, z);
 	}
 
-	if (unlikely(NUMA_BUILD && page == NULL && zlc_active)) {
+	if (unlikely(IS_ENABLED(CONFIG_NUMA) && page == NULL && zlc_active)) {
 		/* Disable zlc cache for second zonelist scan */
 		zlc_active = 0;
 		goto zonelist_scan;
@@ -2265,7 +2266,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 		return NULL;
 
 	/* After successful reclaim, reconsider all zones for allocation */
-	if (NUMA_BUILD)
+	if (IS_ENABLED(CONFIG_NUMA))
 		zlc_clear_zones_full(zonelist);
 
 retry:
@@ -2411,7 +2412,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	 * allowed per node queues are empty and that nodes are
 	 * over allocated.
 	 */
-	if (NUMA_BUILD && (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
+	if (IS_ENABLED(CONFIG_NUMA) &&
+			(gfp_mask & GFP_THISNODE) == GFP_THISNODE)
 		goto nopage;
 
 restart:
@@ -2817,7 +2819,7 @@ unsigned int nr_free_pagecache_pages(voi
 
 static inline void show_node(struct zone *zone)
 {
-	if (NUMA_BUILD)
+	if (IS_ENABLED(CONFIG_NUMA))
 		printk("Node %d ", zone_to_nid(zone));
 }
 
diff -puN mm/vmalloc.c~mm-use-is_enabledconfig_numa-instead-of-numa_build mm/vmalloc.c
--- a/mm/vmalloc.c~mm-use-is_enabledconfig_numa-instead-of-numa_build
+++ a/mm/vmalloc.c
@@ -2550,7 +2550,7 @@ static void s_stop(struct seq_file *m, v
 
 static void show_numa_info(struct seq_file *m, struct vm_struct *v)
 {
-	if (NUMA_BUILD) {
+	if (IS_ENABLED(CONFIG_NUMA)) {
 		unsigned int nr, *counters = m->private;
 
 		if (!counters)
@@ -2615,7 +2615,7 @@ static int vmalloc_open(struct inode *in
 	unsigned int *ptr = NULL;
 	int ret;
 
-	if (NUMA_BUILD) {
+	if (IS_ENABLED(CONFIG_NUMA)) {
 		ptr = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
 		if (ptr == NULL)
 			return -ENOMEM;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch

