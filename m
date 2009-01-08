From: akpm@linux-foundation.org
Subject: - memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:45 -0800
Message-ID: <200901082248.n08MmjAU028077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759319AbZAHW6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:58:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcontrol: rcu_read_lock() to protect mm_match_cgroup()
has been removed from the -mm tree.  Its filename was
     memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcontrol: rcu_read_lock() to protect mm_match_cgroup()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

mm_match_cgroup() calls cgroup_subsys_state().

We must use rcu_read_lock() to protect cgroup_subsys_state().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcontrol-rcu_read_lock-to-protect-mm_match_cgroup include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcontrol-rcu_read_lock-to-protect-mm_match_cgroup
+++ a/include/linux/memcontrol.h
@@ -61,8 +61,15 @@ int task_in_mem_cgroup(struct task_struc
 
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
-#define mm_match_cgroup(mm, cgroup)	\
-	((cgroup) == mem_cgroup_from_task((mm)->owner))
+static inline
+int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
+{
+	struct mem_cgroup *mem;
+	rcu_read_lock();
+	mem = mem_cgroup_from_task((mm)->owner);
+	rcu_read_unlock();
+	return cgroup == mem;
+}
 
 extern int
 mem_cgroup_prepare_migration(struct page *page, struct mem_cgroup **ptr);
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

