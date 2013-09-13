From: akpm@linux-foundation.org
Subject: [merged]
 memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch
 removed from -mm tree
Date: Fri, 13 Sep 2013 13:02:44 -0700
Message-ID: <52336f64.3UqzLB8pXVK4mRmZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3IMUCp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, gthelen@google.com, fengguang.wu@intel.com, handai.szj@taobao.com

Subject: [merged] memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch removed from -mm tree
To: handai.szj@taobao.com,fengguang.wu@intel.com,gthelen@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:44 -0700


The patch titled
     Subject: memcg: check for proper lock held in mem_cgroup_update_page_stat
has been removed from the -mm tree.  Its filename was
     memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: memcg: check for proper lock held in mem_cgroup_update_page_stat

We should call mem_cgroup_begin_update_page_stat() before
mem_cgroup_update_page_stat() to get proper locks, however the latter
doesn't do any checking that we use proper locking, which would be hard. 
Suggested by Michal Hock we could at least test for rcu_read_lock_held()
because RCU is held if !mem_cgroup_disabled().

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Greg Thelen <gthelen@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memcontrol.c~memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat
+++ a/mm/memcontrol.c
@@ -2225,6 +2225,7 @@ void mem_cgroup_update_page_stat(struct
 	if (mem_cgroup_disabled())
 		return;
 
+	VM_BUG_ON(!rcu_read_lock_held());
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
 		return;
_

Patches currently in -mm which might be from handai.szj@taobao.com are

origin.patch

