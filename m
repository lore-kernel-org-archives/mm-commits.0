From: akpm@linux-foundation.org
Subject: + memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:40:29 -0800
Message-ID: <200811212340.mALNeTq5031004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113AbYKUXky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:40:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org


The patch titled
     memcontrol: rcu_read_lock() to protect mm_match_cgroup()
has been added to the -mm tree.  Its filename is
     memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch
cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch
cgroups-fix-cgroup_iter_next-bug.patch
cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch
cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch
cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch
devcgroup-use-list_for_each_entry_rcu.patch
memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch

