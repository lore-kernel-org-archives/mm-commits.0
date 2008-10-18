From: akpm@linux-foundation.org
Subject: - memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:10:17 -0700
Message-ID: <200810182310.m9INAHBR027496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbYJRXLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com


The patch titled
     memrlimit: cgroup mm owner callback changes to add task info
has been removed from the -mm tree.  Its filename was
     memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memrlimit: cgroup mm owner callback changes to add task info
From: Balbir Singh <balbir@linux.vnet.ibm.com>

This patch adds an additional field to the mm_owner callbacks. This field
is required to get to the mm that changed. Hold mmap_sem in write mode
before calling the mm_owner_changed callback

[hugh@veritas.com: fix mmap_sem deadlock]
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    3 ++-
 kernel/cgroup.c        |    4 +++-
 kernel/exit.c          |    9 ++++-----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff -puN include/linux/cgroup.h~memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info include/linux/cgroup.h
--- a/include/linux/cgroup.h~memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info
+++ a/include/linux/cgroup.h
@@ -326,7 +326,8 @@ struct cgroup_subsys {
 	 */
 	void (*mm_owner_changed)(struct cgroup_subsys *ss,
 					struct cgroup *old,
-					struct cgroup *new);
+					struct cgroup *new,
+					struct task_struct *p);
 	int subsys_id;
 	int active;
 	int disabled;
diff -puN kernel/cgroup.c~memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info kernel/cgroup.c
--- a/kernel/cgroup.c~memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info
+++ a/kernel/cgroup.c
@@ -2735,6 +2735,8 @@ void cgroup_fork_callbacks(struct task_s
  * Called on every change to mm->owner. mm_init_owner() does not
  * invoke this routine, since it assigns the mm->owner the first time
  * and does not change it.
+ *
+ * The callbacks are invoked with mmap_sem held in read mode.
  */
 void cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
 {
@@ -2750,7 +2752,7 @@ void cgroup_mm_owner_callbacks(struct ta
 			if (oldcgrp == newcgrp)
 				continue;
 			if (ss->mm_owner_changed)
-				ss->mm_owner_changed(ss, oldcgrp, newcgrp);
+				ss->mm_owner_changed(ss, oldcgrp, newcgrp, new);
 		}
 	}
 }
diff -puN kernel/exit.c~memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info kernel/exit.c
--- a/kernel/exit.c~memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info
+++ a/kernel/exit.c
@@ -640,24 +640,23 @@ retry:
 assign_new_owner:
 	BUG_ON(c == p);
 	get_task_struct(c);
+	read_unlock(&tasklist_lock);
+	down_write(&mm->mmap_sem);
 	/*
 	 * The task_lock protects c->mm from changing.
 	 * We always want mm->owner->mm == mm
 	 */
 	task_lock(c);
-	/*
-	 * Delay read_unlock() till we have the task_lock()
-	 * to ensure that c does not slip away underneath us
-	 */
-	read_unlock(&tasklist_lock);
 	if (c->mm != mm) {
 		task_unlock(c);
+		up_write(&mm->mmap_sem);
 		put_task_struct(c);
 		goto retry;
 	}
 	cgroup_mm_owner_callbacks(mm->owner, c);
 	mm->owner = c;
 	task_unlock(c);
+	up_write(&mm->mmap_sem);
 	put_task_struct(c);
 }
 #endif /* CONFIG_MM_OWNER */
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
memcg-move-charge-swapin-under-lock.patch
memcg-make-page-mapping-null-before-uncharge.patch
memcg-avoid-accounting-special-pages.patch
memcg-optimize-per-cpu-statistics.patch
memcg-atomic-ops-for-page_cgroup-flags.patch
memcg-allocate-all-page_cgroup-at-boot.patch

