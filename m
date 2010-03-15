From: akpm@linux-foundation.org
Subject: [merged] cgroups-remove-events-before-destroying-subsystem-state-objects.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:05 -0400
Message-ID: <201003150700.o2F70caE016649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935755Ab0COHBA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:01:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, balbir@linux.vnet.ibm.com, dan@embeddedalley.com, kamezawa.hioryu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, xemul@open


The patch titled
     cgroups: remove events before destroying subsystem state objects
has been removed from the -mm tree.  Its filename was
     cgroups-remove-events-before-destroying-subsystem-state-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
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
@@ -396,9 +396,6 @@ struct cftype {
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
@@ -2994,6 +2994,7 @@ static void cgroup_event_remove(struct w
 
 	eventfd_ctx_put(event->eventfd);
 	kfree(event);
+	dput(cgrp->dentry);
 }
 
 /*
@@ -3114,6 +3115,13 @@ static int cgroup_write_event_control(st
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
@@ -3361,12 +3361,6 @@ static int mem_cgroup_register_event(str
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
@@ -3460,9 +3454,6 @@ assign:
 	/* To be sure that nobody uses thresholds before freeing it */
 	synchronize_rcu();
 
-	for (i = 0; i < thresholds->size - size; i++)
-		mem_cgroup_put(memcg);
