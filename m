From: akpm@linux-foundation.org
Subject: [merged]
 mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:09:49 -0700
Message-ID: <552eb77d.7HSpt90tcnZ/yWXl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933166AbbDOTJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:09:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: completely remove dumping per-cpu lists from show_mem()
has been removed from the -mm tree.  Its filename was
     mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm: completely remove dumping per-cpu lists from show_mem()

It seems nobody needs this.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/page_alloc.c    |   22 ++--------------------
 2 files changed, 2 insertions(+), 21 deletions(-)

diff -puN include/linux/mm.h~mm-completely-remove-dumping-per-cpu-lists-from-show_mem include/linux/mm.h
--- a/include/linux/mm.h~mm-completely-remove-dumping-per-cpu-lists-from-show_mem
+++ a/include/linux/mm.h
@@ -1126,7 +1126,6 @@ extern void pagefault_out_of_memory(void
  * various contexts.
  */
 #define SHOW_MEM_FILTER_NODES		(0x0001u)	/* disallowed nodes */
-#define SHOW_MEM_PERCPU_LISTS		(0x0002u)	/* per-zone per-cpu */
 
 extern void show_free_areas(unsigned int flags);
 extern bool skip_free_areas_node(unsigned int flags, int nid);
diff -puN mm/page_alloc.c~mm-completely-remove-dumping-per-cpu-lists-from-show_mem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-completely-remove-dumping-per-cpu-lists-from-show_mem
+++ a/mm/page_alloc.c
@@ -3255,7 +3255,6 @@ static void show_migration_types(unsigne
  * Bits in @filter:
  * SHOW_MEM_FILTER_NODES: suppress nodes that are not allowed by current's
  *   cpuset.
- * SHOW_MEM_PERCPU_LISTS: display full per-node per-cpu pcp lists
  */
 void show_free_areas(unsigned int filter)
 {
@@ -3267,25 +3266,8 @@ void show_free_areas(unsigned int filter
 		if (skip_free_areas_node(filter, zone_to_nid(zone)))
 			continue;
 
-		if (filter & SHOW_MEM_PERCPU_LISTS) {
-			show_node(zone);
-			printk("%s per-cpu:\n", zone->name);
-		}
-
-		for_each_online_cpu(cpu) {
-			struct per_cpu_pageset *pageset;
-
-			pageset = per_cpu_ptr(zone->pageset, cpu);
-
-			free_pcp += pageset->pcp.count;
-
-			if (!(filter & SHOW_MEM_PERCPU_LISTS))
-				continue;
