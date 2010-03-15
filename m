From: akpm@linux-foundation.org
Subject: [merged] cgroups-fix-race-between-userspace-and-kernelspace.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:02 -0400
Message-ID: <201003150700.o2F70Z4D016646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757247Ab0COHAz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:00:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, balbir@linux.vnet.ibm.com, dan@embeddedalley.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, xemul@open


The patch titled
     cgroups: fix race between userspace and kernelspace
has been removed from the -mm tree.  Its filename was
     cgroups-fix-race-between-userspace-and-kernelspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix race between userspace and kernelspace
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Notify userspace about cgroup removing only after rmdir of cgroup
directory to avoid race between userspace and kernelspace.

eventfd are used to notify about two types of event:
 - control file-specific, like crossing memory threshold;
 - cgroup removing.

To understand what really happen, userspace can check if the cgroup still
exists.  To avoid race beetween userspace and kernelspace we have to
notify userspace about cgroup removing only after rmdir of cgroup
directory.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Dan Malek <dan@embeddedalley.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff -puN kernel/cgroup.c~cgroups-fix-race-between-userspace-and-kernelspace kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-race-between-userspace-and-kernelspace
+++ a/kernel/cgroup.c
@@ -795,28 +795,15 @@ static struct inode *cgroup_new_inode(mo
 static int cgroup_call_pre_destroy(struct cgroup *cgrp)
 {
 	struct cgroup_subsys *ss;
-	struct cgroup_event *event, *tmp;
 	int ret = 0;
 
 	for_each_subsys(cgrp->root, ss)
 		if (ss->pre_destroy) {
 			ret = ss->pre_destroy(ss, cgrp);
 			if (ret)
-				goto out;
+				break;
 		}
 
-	/*
-	 * Unregister events and notify userspace.
-	 */
-	spin_lock(&cgrp->event_list_lock);
-	list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
-		list_del(&event->list);
-		eventfd_signal(event->eventfd, 1);
-		schedule_work(&event->remove);
-	}
-	spin_unlock(&cgrp->event_list_lock);
-
-out:
 	return ret;
 }
 
@@ -3006,7 +2993,6 @@ static void cgroup_event_remove(struct w
 	event->cft->unregister_event(cgrp, event->cft, event->eventfd);
 
 	eventfd_ctx_put(event->eventfd);
-	remove_wait_queue(event->wqh, &event->wait);
 	kfree(event);
 }
 
@@ -3024,6 +3010,7 @@ static int cgroup_event_wake(wait_queue_
 	unsigned long flags = (unsigned long)key;
 
 	if (flags & POLLHUP) {
+		remove_wait_queue_locked(event->wqh, &event->wait);
 		spin_lock(&cgrp->event_list_lock);
 		list_del(&event->list);
 		spin_unlock(&cgrp->event_list_lock);
@@ -3472,6 +3459,7 @@ static int cgroup_rmdir(struct inode *un
 	struct dentry *d;
 	struct cgroup *parent;
 	DEFINE_WAIT(wait);
+	struct cgroup_event *event, *tmp;
 	int ret;
 
 	/* the vfs holds both inode->i_mutex already */
@@ -3555,6 +3543,20 @@ again:
 	set_bit(CGRP_RELEASABLE, &parent->flags);
 	check_for_release(parent);
 
+	/*
+	 * Unregister events and notify userspace.
+	 * Notify userspace about cgroup removing only after rmdir of cgroup
+	 * directory to avoid race between userspace and kernelspace
+	 */
+	spin_lock(&cgrp->event_list_lock);
+	list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
+		list_del(&event->list);
+		remove_wait_queue(event->wqh, &event->wait);
+		eventfd_signal(event->eventfd, 1);
+		schedule_work(&event->remove);
+	}
+	spin_unlock(&cgrp->event_list_lock);
+
 	mutex_unlock(&cgroup_mutex);
 	return 0;
 }
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch

