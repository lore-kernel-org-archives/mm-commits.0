From: akpm@linux-foundation.org
Subject: + cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch added to -mm tree
Date: Fri, 22 Jan 2010 15:13:13 -0800
Message-ID: <201001222313.o0MNDD8R002034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322Ab0AVXNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 18:13:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroup-implement-eventfd-based-generic-api-for-notifications-fixes
has been added to the -mm tree.  Its filename is
     cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch

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
Subject: cgroup-implement-eventfd-based-generic-api-for-notifications-fixes
From: "Kirill A. Shutemov" <kirill@shutemov.name>

Several random fixes.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    1 +
 kernel/cgroup.c                   |   26 +++++++++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroup-implement-eventfd-based-generic-api-for-notifications-fixes Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroup-implement-eventfd-based-generic-api-for-notifications-fixes
+++ a/Documentation/cgroups/cgroups.txt
@@ -23,6 +23,7 @@ CONTENTS:
   2.1 Basic Usage
   2.2 Attaching processes
   2.3 Mounting hierarchies by name
+  2.4 Notification API
 3. Kernel API
   3.1 Overview
   3.2 Synchronization
diff -puN kernel/cgroup.c~cgroup-implement-eventfd-based-generic-api-for-notifications-fixes kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-implement-eventfd-based-generic-api-for-notifications-fixes
+++ a/kernel/cgroup.c
@@ -2978,13 +2978,18 @@ static int cgroup_write_notify_on_releas
 	return 0;
 }
 
+/*
+ * Unregister event and free resources.
+ *
+ * Gets called from workqueue.
+ */
 static void cgroup_event_remove(struct work_struct *work)
 {
 	struct cgroup_event *event = container_of(work, struct cgroup_event,
 			remove);
 	struct cgroup *cgrp = event->cgrp;
 
-	/* TODO: check return code*/
+	/* TODO: check return code */
 	event->cft->unregister_event(cgrp, event->cft, event->eventfd);
 
 	eventfd_ctx_put(event->eventfd);
@@ -2992,6 +2997,11 @@ static void cgroup_event_remove(struct w
 	kfree(event);
 }
 
+/*
+ * Gets called on POLLHUP on eventfd when user closes it.
+ *
+ * Called with wqh->lock held and interrupts disabled.
+ */
 static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
 		int sync, void *key)
 {
@@ -3004,6 +3014,10 @@ static int cgroup_event_wake(wait_queue_
 		spin_lock(&cgrp->event_list_lock);
 		list_del(&event->list);
 		spin_unlock(&cgrp->event_list_lock);
+		/*
+		 * We are in atomic context, but cgroup_event_remove() may
+		 * sleep, so we have to call it in workqueue.
+		 */
 		schedule_work(&event->remove);
 	}
 
@@ -3020,6 +3034,12 @@ static void cgroup_event_ptable_queue_pr
 	add_wait_queue(wqh, &event->wait);
 }
 
+/*
+ * Parse input and register new cgroup event handler.
+ *
+ * Input must be in format '<event_fd> <control_fd> <args>'.
+ * Interpretation of args is defined by control file implementation.
+ */
 static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 				      const char *buffer)
 {
@@ -3104,13 +3124,13 @@ static int cgroup_write_event_control(st
 	return 0;
 
 fail:
-	if (!IS_ERR(cfile))
+	if (!cfile)
 		fput(cfile);
 
 	if (event && event->eventfd && !IS_ERR(event->eventfd))
 		eventfd_ctx_put(event->eventfd);
 
-	if (!IS_ERR(efile))
+	if (!IS_ERR_OR_NULL(efile))
 		fput(efile);
 
 	kfree(event);
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
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch

