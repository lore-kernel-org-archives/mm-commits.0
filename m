From: akpm@linux-foundation.org
Subject: [merged]
 memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch removed
 from -mm tree
Date: Fri, 13 Sep 2013 13:01:59 -0700
Message-ID: <52336f37.kFTqgwrnGtV65UH+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab3IMUCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, lizefan@huawei.com

Subject: [merged] memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch removed from -mm tree
To: lizefan@huawei.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:01:59 -0700


The patch titled
     Subject: memcg: remove redundant code in mem_cgroup_force_empty_write()
has been removed from the -mm tree.  Its filename was
     memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: memcg: remove redundant code in mem_cgroup_force_empty_write()

vfs guarantees the cgroup won't be destroyed, so it's redundant to get a
css reference.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-redundant-code-in-mem_cgroup_force_empty_write mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-redundant-code-in-mem_cgroup_force_empty_write
+++ a/mm/memcontrol.c
@@ -4990,18 +4990,12 @@ static int mem_cgroup_force_empty_write(
 					unsigned int event)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	int ret;
 
 	if (mem_cgroup_is_root(memcg))
 		return -EINVAL;
-	css_get(&memcg->css);
-	ret = mem_cgroup_force_empty(memcg);
-	css_put(&memcg->css);
-
-	return ret;
+	return mem_cgroup_force_empty(memcg);
 }
 
