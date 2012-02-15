From: akpm@linux-foundation.org
Subject: + mm-replace-numa_build-with-is_enabledconfig_numa.patch added to -mm tree
Date: Wed, 15 Feb 2012 14:50:59 -0800
Message-ID: <20120215225059.EA5C0A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:55798 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab2BOWvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2012 17:51:03 -0500
Received: by eekb15 with SMTP id b15so59077eek.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2012 14:51:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org


The patch titled
     Subject: mm: replace NUMA_BUILD with IS_ENABLED(CONFIG_NUMA)
has been added to the -mm tree.  Its filename is
     mm-replace-numa_build-with-is_enabledconfig_numa.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: replace NUMA_BUILD with IS_ENABLED(CONFIG_NUMA)

And another candidate for replacing with IS_ENABLED() macro.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |    2 +-
 include/linux/kernel.h |    7 -------
 mm/page_alloc.c        |   18 ++++++++++--------
 mm/vmalloc.c           |    4 ++--
 4 files changed, 13 insertions(+), 18 deletions(-)

diff -puN include/linux/gfp.h~mm-replace-numa_build-with-is_enabledconfig_numa include/linux/gfp.h
--- a/include/linux/gfp.h~mm-replace-numa_build-with-is_enabledconfig_numa
+++ a/include/linux/gfp.h
@@ -264,7 +264,7 @@ static inline enum zone_type gfp_zone(gf
 
 static inline int gfp_zonelist(gfp_t flags)
 {
-	if (NUMA_BUILD && unlikely(flags & __GFP_THISNODE))
+	if (IS_ENABLED(CONFIG_NUMA) && unlikely(flags & __GFP_THISNODE))
 		return 1;
 
 	return 0;
diff -puN include/linux/kernel.h~mm-replace-numa_build-with-is_enabledconfig_numa include/linux/kernel.h
--- a/include/linux/kernel.h~mm-replace-numa_build-with-is_enabledconfig_numa
+++ a/include/linux/kernel.h
@@ -726,13 +726,6 @@ extern int __build_bug_on_failed;
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
 
-/* This helps us to avoid #ifdef CONFIG_NUMA */
-#ifdef CONFIG_NUMA
-#define NUMA_BUILD 1
-#else
-#define NUMA_BUILD 0
-#endif
-
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
diff -puN mm/page_alloc.c~mm-replace-numa_build-with-is_enabledconfig_numa mm/page_alloc.c
--- a/mm/page_alloc.c~mm-replace-numa_build-with-is_enabledconfig_numa
+++ a/mm/page_alloc.c
@@ -1720,7 +1720,7 @@ zonelist_scan:
 	 */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						high_zoneidx, nodemask) {
-		if (NUMA_BUILD && zlc_active &&
+		if (IS_ENABLED(CONFIG_NUMA) && zlc_active &&
 			!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
 		if ((alloc_flags & ALLOC_CPUSET) &&
@@ -1766,7 +1766,8 @@ zonelist_scan:
 				    classzone_idx, alloc_flags))
 				goto try_this_zone;
 
-			if (NUMA_BUILD && !did_zlc_setup && nr_online_nodes > 1) {
+			if (IS_ENABLED(CONFIG_NUMA) &&
+			    !did_zlc_setup && nr_online_nodes > 1) {
 				/*
 				 * we do zlc_setup if there are multiple nodes
 				 * and before considering the first zone allowed
@@ -1784,7 +1785,7 @@ zonelist_scan:
 			 * As we may have just activated ZLC, check if the first
 			 * eligible zone has failed zone_reclaim recently.
 			 */
-			if (NUMA_BUILD && zlc_active &&
+			if (IS_ENABLED(CONFIG_NUMA) && zlc_active &&
 				!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
 
@@ -1810,11 +1811,11 @@ try_this_zone:
 		if (page)
 			break;
 this_zone_full:
-		if (NUMA_BUILD)
+		if (IS_ENABLED(CONFIG_NUMA))
 			zlc_mark_zone_full(zonelist, z);
 	}
 
-	if (unlikely(NUMA_BUILD && page == NULL && zlc_active)) {
+	if (IS_ENABLED(CONFIG_NUMA) && unlikely(page == NULL && zlc_active)) {
 		/* Disable zlc cache for second zonelist scan */
 		zlc_active = 0;
 		goto zonelist_scan;
@@ -2082,7 +2083,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 		return NULL;
 
 	/* After successful reclaim, reconsider all zones for allocation */
-	if (NUMA_BUILD)
+	if (IS_ENABLED(CONFIG_NUMA))
 		zlc_clear_zones_full(zonelist);
 
 retry:
@@ -2215,7 +2216,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	 * allowed per node queues are empty and that nodes are
 	 * over allocated.
 	 */
-	if (NUMA_BUILD && (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
+	if (IS_ENABLED(CONFIG_NUMA) &&
+	    (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
 		goto nopage;
 
 restart:
@@ -2591,7 +2593,7 @@ unsigned int nr_free_pagecache_pages(voi
 
 static inline void show_node(struct zone *zone)
 {
-	if (NUMA_BUILD)
+	if (IS_ENABLED(CONFIG_NUMA))
 		printk("Node %d ", zone_to_nid(zone));
 }
 
diff -puN mm/vmalloc.c~mm-replace-numa_build-with-is_enabledconfig_numa mm/vmalloc.c
--- a/mm/vmalloc.c~mm-replace-numa_build-with-is_enabledconfig_numa
+++ a/mm/vmalloc.c
@@ -2538,7 +2538,7 @@ static void s_stop(struct seq_file *m, v
 
 static void show_numa_info(struct seq_file *m, struct vm_struct *v)
 {
-	if (NUMA_BUILD) {
+	if (IS_ENABLED(CONFIG_NUMA)) {
 		unsigned int nr, *counters = m->private;
 
 		if (!counters)
@@ -2603,7 +2603,7 @@ static int vmalloc_open(struct inode *in
 	unsigned int *ptr = NULL;
 	int ret;
 
-	if (NUMA_BUILD) {
+	if (IS_ENABLED(CONFIG_NUMA)) {
 		ptr = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
 		if (ptr == NULL)
 			return -ENOMEM;
_
Subject: Subject: mm: replace NUMA_BUILD with IS_ENABLED(CONFIG_NUMA)

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
mm-add-rss-counters-consistency-check.patch
mm-make-get_mm_counter-static-inline.patch
mm-replace-page_migration-with-is_enabledconfig_migration.patch
mm-replace-compaction_build-with-is_enabledconfig_compaction.patch
mm-replace-numa_build-with-is_enabledconfig_numa.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
memcg-kill-dead-prev_priority-stubs.patch

