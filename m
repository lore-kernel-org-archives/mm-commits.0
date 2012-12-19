From: akpm@linux-foundation.org
Subject: [merged] memcg-change-defines-to-an-enum.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:40:06 -0800
Message-ID: <20121219204007.16139820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:54516 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2LSUkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:40:09 -0500
Received: by mail-vc0-f201.google.com with SMTP id p1so277615vcq.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:40:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: change defines to an enum
has been removed from the -mm tree.  Its filename was
     memcg-change-defines-to-an-enum.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: change defines to an enum

This is just a cleanup patch for clarity of expression.  In earlier
submissions, people asked it to be in a separate patch, so here it is.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~memcg-change-defines-to-an-enum mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-change-defines-to-an-enum
+++ a/mm/memcontrol.c
@@ -388,9 +388,12 @@ enum charge_type {
 };
 
 /* for encoding cft->private value on file */
-#define _MEM			(0)
-#define _MEMSWAP		(1)
-#define _OOM_TYPE		(2)
+enum res_type {
+	_MEM,
+	_MEMSWAP,
+	_OOM_TYPE,
+};
+
 #define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
 #define MEMFILE_TYPE(val)	((val) >> 16 & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
@@ -3952,7 +3955,8 @@ static ssize_t mem_cgroup_read(struct cg
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 	char str[64];
 	u64 val;
-	int type, name, len;
+	int name, len;
+	enum res_type type;
 
 	type = MEMFILE_TYPE(cft->private);
 	name = MEMFILE_ATTR(cft->private);
@@ -3988,7 +3992,8 @@ static int mem_cgroup_write(struct cgrou
 			    const char *buffer)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
-	int type, name;
+	enum res_type type;
+	int name;
 	unsigned long long val;
 	int ret;
 
@@ -4064,7 +4069,8 @@ out:
 static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
-	int type, name;
+	int name;
+	enum res_type type;
 
 	type = MEMFILE_TYPE(event);
 	name = MEMFILE_ATTR(event);
@@ -4400,7 +4406,7 @@ static int mem_cgroup_usage_register_eve
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 	struct mem_cgroup_thresholds *thresholds;
 	struct mem_cgroup_threshold_ary *new;
-	int type = MEMFILE_TYPE(cft->private);
+	enum res_type type = MEMFILE_TYPE(cft->private);
 	u64 threshold, usage;
 	int i, size, ret;
 
@@ -4483,7 +4489,7 @@ static void mem_cgroup_usage_unregister_
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 	struct mem_cgroup_thresholds *thresholds;
 	struct mem_cgroup_threshold_ary *new;
-	int type = MEMFILE_TYPE(cft->private);
+	enum res_type type = MEMFILE_TYPE(cft->private);
 	u64 usage;
 	int i, j, size;
 
@@ -4561,7 +4567,7 @@ static int mem_cgroup_oom_register_event
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 	struct mem_cgroup_eventfd_list *event;
-	int type = MEMFILE_TYPE(cft->private);
+	enum res_type type = MEMFILE_TYPE(cft->private);
 
 	BUG_ON(type != _OOM_TYPE);
 	event = kmalloc(sizeof(*event),	GFP_KERNEL);
@@ -4586,7 +4592,7 @@ static void mem_cgroup_oom_unregister_ev
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 	struct mem_cgroup_eventfd_list *ev, *tmp;
-	int type = MEMFILE_TYPE(cft->private);
+	enum res_type type = MEMFILE_TYPE(cft->private);
 
 	BUG_ON(type != _OOM_TYPE);
 
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

