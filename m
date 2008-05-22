From: akpm@linux-foundation.org
Subject: + memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch added to -mm tree
Date: Wed, 21 May 2008 21:29:22 -0700
Message-ID: <200805220429.m4M4TMXK017025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbYEVEaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 00:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memrlimit: cgroup mm owner callback changes to add task info
has been added to the -mm tree.  Its filename is
     memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memrlimit: cgroup mm owner callback changes to add task info
From: Balbir Singh <balbir@linux.vnet.ibm.com>

This patch adds an additional field to the mm_owner callbacks. This field
is required to get to the mm that changed. Hold mmap_sem in write mode
before calling the mm_owner_changed callback

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    3 ++-
 kernel/cgroup.c        |    4 +++-
 kernel/exit.c          |    3 +++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff -puN include/linux/cgroup.h~memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info include/linux/cgroup.h
--- a/include/linux/cgroup.h~memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info
+++ a/include/linux/cgroup.h
@@ -310,7 +310,8 @@ struct cgroup_subsys {
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
@@ -2759,6 +2759,8 @@ void cgroup_fork_callbacks(struct task_s
  * Called on every change to mm->owner. mm_init_owner() does not
  * invoke this routine, since it assigns the mm->owner the first time
  * and does not change it.
+ *
+ * The callbacks are invoked with mmap_sem held in read mode.
  */
 void cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
 {
@@ -2773,7 +2775,7 @@ void cgroup_mm_owner_callbacks(struct ta
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
@@ -626,6 +626,7 @@ retry:
 assign_new_owner:
 	BUG_ON(c == p);
 	get_task_struct(c);
+	down_write(&mm->mmap_sem);
 	/*
 	 * The task_lock protects c->mm from changing.
 	 * We always want mm->owner->mm == mm
@@ -639,12 +640,14 @@ assign_new_owner:
 	if (c->mm != mm) {
 		task_unlock(c);
 		put_task_struct(c);
+		up_write(&mm->mmap_sem);
 		goto retry;
 	}
 	cgroup_mm_owner_callbacks(mm->owner, c);
 	mm->owner = c;
 	task_unlock(c);
 	put_task_struct(c);
+	up_write(&mm->mmap_sem);
 }
 #endif /* CONFIG_MM_OWNER */
 
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

linux-next.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch

