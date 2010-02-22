From: akpm@linux-foundation.org
Subject: + cgroups-remove-events-before-destroying-subsystem-state-objects.patch added to -mm tree
Date: Mon, 22 Feb 2010 15:53:12 -0800
Message-ID: <201002222353.o1MNrCTb031485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766Ab0BVXx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 18:53:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, balbir@linux.vnet.ibm.com, dan@embeddedalley.com, kamezawa.hioryu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, xemul@openvz.org


The patch titled
     cgroups: remove events before destroying subsystem state objects
has been added to the -mm tree.  Its filename is
     cgroups-remove-events-before-destroying-subsystem-state-objects.patch

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
Subject: cgroups: remove events before destroying subsystem state objects
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Events should be removed after rmdir of cgroup directory, but before
destroying subsystem state objects.  Let's take reference to cgroup
directory dentry to do that.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hioryu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Dan Malek <dan@embeddedalley.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    3 ---
 kernel/cgroup.c        |    8 ++++++++
 mm/memcontrol.c        |    9 ---------
 3 files changed, 8 insertions(+), 12 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-remove-events-before-destroying-subsystem-state-objects include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-remove-events-before-destroying-subsystem-state-objects
+++ a/include/linux/cgroup.h
@@ -395,9 +395,6 @@ struct cftype {
 	 * closes the eventfd or on cgroup removing.
 	 * This callback must be implemented, if you want provide
 	 * notification functionality.
-	 *
-	 * Be careful. It can be called after destroy(), so you have
-	 * to keep all nesessary data, until all events are removed.
 	 */
 	int (*unregister_event)(struct cgroup *cgrp, struct cftype *cft,
 			struct eventfd_ctx *eventfd);
diff -puN kernel/cgroup.c~cgroups-remove-events-before-destroying-subsystem-state-objects kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-remove-events-before-destroying-subsystem-state-objects
+++ a/kernel/cgroup.c
@@ -2979,6 +2979,7 @@ static void cgroup_event_remove(struct w
 
 	eventfd_ctx_put(event->eventfd);
 	kfree(event);
+	dput(cgrp->dentry);
 }
 
 /*
@@ -3099,6 +3100,13 @@ static int cgroup_write_event_control(st
 		goto fail;
 	}
 
+	/*
+	 * Events should be removed after rmdir of cgroup directory, but before
+	 * destroying subsystem state objects. Let's take reference to cgroup
+	 * directory dentry to do that.
+	 */
+	dget(cgrp->dentry);
+
 	spin_lock(&cgrp->event_list_lock);
 	list_add(&event->list, &cgrp->event_list);
 	spin_unlock(&cgrp->event_list_lock);
diff -puN mm/memcontrol.c~cgroups-remove-events-before-destroying-subsystem-state-objects mm/memcontrol.c
--- a/mm/memcontrol.c~cgroups-remove-events-before-destroying-subsystem-state-objects
+++ a/mm/memcontrol.c
@@ -3353,12 +3353,6 @@ static int mem_cgroup_register_event(str
 		}
 	}
 
-	/*
-	 * We need to increment refcnt to be sure that all thresholds
-	 * will be unregistered before calling __mem_cgroup_free()
-	 */
-	mem_cgroup_get(memcg);
-
 	if (type == _MEM)
 		rcu_assign_pointer(memcg->thresholds, thresholds_new);
 	else
@@ -3452,9 +3446,6 @@ assign:
 	/* To be sure that nobody uses thresholds before freeing it */
 	synchronize_rcu();
 
-	for (i = 0; i < thresholds->size - size; i++)
-		mem_cgroup_put(memcg);
-
 	kfree(thresholds);
 unlock:
 	mutex_unlock(&memcg->thresholds_lock);
_

Patches currently in -mm which might be from kirill@shutemov.name are

cgroups-fix-contents-in-cgroups-documentation.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch
cgroups-fix-race-between-userspace-and-kernelspace.patch
cgroups-remove-events-before-destroying-subsystem-state-objects.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch
memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch

