From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-zap-oom_info_lock.patch removed from -mm
 tree
Date: Mon, 21 Mar 2016 11:40:29 -0700
Message-ID: <56f0401d.x7/M6p6to9w7PvDC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364AbcCUT4b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: zap oom_info_lock
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-zap-oom_info_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: zap oom_info_lock

mem_cgroup_print_oom_info is always called under oom_lock, so
oom_info_lock is redundant.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-zap-oom_info_lock mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-zap-oom_info_lock
+++ a/mm/memcontrol.c
@@ -1150,12 +1150,9 @@ static bool mem_cgroup_wait_acct_move(st
  */
 void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
-	/* oom_info_lock ensures that parallel ooms do not interleave */
-	static DEFINE_MUTEX(oom_info_lock);
 	struct mem_cgroup *iter;
 	unsigned int i;
 
-	mutex_lock(&oom_info_lock);
 	rcu_read_lock();
 
 	if (p) {
@@ -1199,7 +1196,6 @@ void mem_cgroup_print_oom_info(struct me
 
 		pr_cont("\n");
 	}
-	mutex_unlock(&oom_info_lock);
 }
 
 /*
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-oom_reaper-implement-oom-victims-queuing-fix.patch

