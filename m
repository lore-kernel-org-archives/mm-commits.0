From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-mem_cgroup_relize_xxx_limit-can-guarantee-memcg-reslimit-=-memcg-memswlimit.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:14:33 -0700
Message-ID: <20120801201434.0B88A5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:63949 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUOg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:14:36 -0400
Received: by eaao12 with SMTP id o12so293238eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:14:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: mem_cgroup_relize_xxx_limit can guarantee memcg->res.limit <= memcg->memsw.limit
has been removed from the -mm tree.  Its filename was
     mm-memcg-mem_cgroup_relize_xxx_limit-can-guarantee-memcg-reslimit-=-memcg-memswlimit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: mm/memcg: mem_cgroup_relize_xxx_limit can guarantee memcg->res.limit <= memcg->memsw.limit

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-mem_cgroup_relize_xxx_limit-can-guarantee-memcg-reslimit-=-memcg-memswlimit mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-mem_cgroup_relize_xxx_limit-can-guarantee-memcg-reslimit-=-memcg-memswlimit
+++ a/mm/memcontrol.c
@@ -3416,7 +3416,7 @@ static int mem_cgroup_resize_limit(struc
 		/*
 		 * Rather than hide all in some function, I do this in
 		 * open coded manner. You see what this really does.
-		 * We have to guarantee memcg->res.limit < memcg->memsw.limit.
+		 * We have to guarantee memcg->res.limit <= memcg->memsw.limit.
 		 */
 		mutex_lock(&set_limit_mutex);
 		memswlimit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
@@ -3477,7 +3477,7 @@ static int mem_cgroup_resize_memsw_limit
 		/*
 		 * Rather than hide all in some function, I do this in
 		 * open coded manner. You see what this really does.
-		 * We have to guarantee memcg->res.limit < memcg->memsw.limit.
+		 * We have to guarantee memcg->res.limit <= memcg->memsw.limit.
 		 */
 		mutex_lock(&set_limit_mutex);
 		memlimit = res_counter_read_u64(&memcg->res, RES_LIMIT);
_

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

origin.patch
linux-next.patch

