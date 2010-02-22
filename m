From: akpm@linux-foundation.org
Subject: + cgroups-fix-race-between-userspace-and-kernelspace.patch added to -mm tree
Date: Mon, 22 Feb 2010 15:53:09 -0800
Message-ID: <201002222353.o1MNr9GM031482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766Ab0BVXxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 18:53:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, balbir@linux.vnet.ibm.com, dan@embeddedalley.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, xemul@openvz.org


The patch titled
     cgroups: fix race between userspace and kernelspace
has been added to the -mm tree.  Its filename is
     cgroups-fix-race-between-userspace-and-kernelspace.patch

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
Subject: cgroups: fix race between userspace and kernelspace
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Notify userspace about cgroup removing only after rmdir of cgroup
directory to avoid race between userspace and kernelspace.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
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
@@ -780,28 +780,15 @@ static struct inode *cgroup_new_inode(mo
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
 
@@ -2991,7 +2978,6 @@ static void cgroup_event_remove(struct w
 	event->cft->unregister_event(cgrp, event->cft, event->eventfd);
 
 	eventfd_ctx_put(event->eventfd);
-	remove_wait_queue(event->wqh, &event->wait);
 	kfree(event);
 }
 
@@ -3009,6 +2995,7 @@ static int cgroup_event_wake(wait_queue_
 	unsigned long flags = (unsigned long)key;
 
 	if (flags & POLLHUP) {
+		remove_wait_queue_locked(event->wqh, &event->wait);
 		spin_lock(&cgrp->event_list_lock);
 		list_del(&event->list);
 		spin_unlock(&cgrp->event_list_lock);
@@ -3457,6 +3444,7 @@ static int cgroup_rmdir(struct inode *un
 	struct dentry *d;
 	struct cgroup *parent;
 	DEFINE_WAIT(wait);
+	struct cgroup_event *event, *tmp;
 	int ret;
 
 	/* the vfs holds both inode->i_mutex already */
@@ -3540,6 +3528,20 @@ again:
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

