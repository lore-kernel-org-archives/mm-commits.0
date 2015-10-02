From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-pcp_counter_lock.patch removed from -mm
 tree
Date: Fri, 02 Oct 2015 12:36:35 -0700
Message-ID: <560edcc3.+DMUHDEzOt2ni2uZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbbJBTgf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Oct 2015 15:36:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove pcp_counter_lock
has been removed from the -mm tree.  Its filename was
     memcg-remove-pcp_counter_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: memcg: remove pcp_counter_lock

Commit 733a572e66d2 ("memcg: make mem_cgroup_read_{stat|event}() iterate
possible cpus instead of online") removed the last use of the per memcg
pcp_counter_lock but forgot to remove the variable.

Kill the vestigial variable.

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 -
 mm/memcontrol.c            |    1 -
 2 files changed, 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-remove-pcp_counter_lock include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-remove-pcp_counter_lock
+++ a/include/linux/memcontrol.h
@@ -242,7 +242,6 @@ struct mem_cgroup {
 	 * percpu counter.
 	 */
 	struct mem_cgroup_stat_cpu __percpu *stat;
-	spinlock_t pcp_counter_lock;
 
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
 	struct cg_proto tcp_mem;
diff -puN mm/memcontrol.c~memcg-remove-pcp_counter_lock mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-pcp_counter_lock
+++ a/mm/memcontrol.c
@@ -4185,7 +4185,6 @@ static struct mem_cgroup *mem_cgroup_all
 	if (memcg_wb_domain_init(memcg, GFP_KERNEL))
 		goto out_free_stat;
 
-	spin_lock_init(&memcg->pcp_counter_lock);
 	return memcg;
 
 out_free_stat:
_

Patches currently in -mm which might be from gthelen@google.com are

fs-seqfile-always-allow-oom-killer.patch

