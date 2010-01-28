From: akpm@linux-foundation.org
Subject: + cgroups-clean-up-cgroup_pidlist_find-a-bit.patch added to -mm tree
Date: Wed, 27 Jan 2010 16:52:47 -0800
Message-ID: <201001280052.o0S0qlih010617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754354Ab0A1AxB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 19:53:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, serue@us.ibm.com


The patch titled
     cgroups: clean up cgroup_pidlist_find() a bit
has been added to the -mm tree.  Its filename is
     cgroups-clean-up-cgroup_pidlist_find-a-bit.patch

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
Subject: cgroups: clean up cgroup_pidlist_find() a bit
From: Li Zefan <lizf@cn.fujitsu.com>

Don't call get_pid_ns() before we locate/alloc the ns.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c      |    8 -
 kernel/cgroup.c.orig |  208 -----------------------------------------
 2 files changed, 4 insertions(+), 212 deletions(-)

diff -puN kernel/cgroup.c~cgroups-clean-up-cgroup_pidlist_find-a-bit kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-clean-up-cgroup_pidlist_find-a-bit
+++ a/kernel/cgroup.c
@@ -2582,7 +2582,8 @@ static struct cgroup_pidlist *cgroup_pid
 {
 	struct cgroup_pidlist *l;
 	/* don't need task_nsproxy() if we're looking at ourself */
-	struct pid_namespace *ns = get_pid_ns(current->nsproxy->pid_ns);
+	struct pid_namespace *ns = current->nsproxy->pid_ns;
+
 	/*
 	 * We can't drop the pidlist_mutex before taking the l->mutex in case
 	 * the last ref-holder is trying to remove l from the list at the same
@@ -2592,8 +2593,6 @@ static struct cgroup_pidlist *cgroup_pid
 	mutex_lock(&cgrp->pidlist_mutex);
 	list_for_each_entry(l, &cgrp->pidlists, links) {
 		if (l->key.type == type && l->key.ns == ns) {
-			/* found a matching list - drop the extra refcount */
-			put_pid_ns(ns);
 			/* make sure l doesn't vanish out from under us */
 			down_write(&l->mutex);
 			mutex_unlock(&cgrp->pidlist_mutex);
@@ -2604,13 +2603,12 @@ static struct cgroup_pidlist *cgroup_pid
 	l = kmalloc(sizeof(struct cgroup_pidlist), GFP_KERNEL);
 	if (!l) {
 		mutex_unlock(&cgrp->pidlist_mutex);
-		put_pid_ns(ns);
 		return l;
 	}
 	init_rwsem(&l->mutex);
 	down_write(&l->mutex);
 	l->key.type = type;
-	l->key.ns = ns;
+	l->key.ns = get_pid_ns(ns);
 	l->use_count = 0; /* don't increment here */
 	l->list = NULL;
 	l->owner = cgrp;
diff -puN kernel/cgroup.c.orig~cgroups-clean-up-cgroup_pidlist_find-a-bit kernel/cgroup.c.orig
--- a/kernel/cgroup.c.orig~cgroups-clean-up-cgroup_pidlist_find-a-bit
+++ a/kernel/cgroup.c.orig
@@ -4,10 +4,6 @@
  *  Based originally on the cpuset system, extracted by Paul Menage
  *  Copyright (C) 2006 Google, Inc
  *
- *  Notifications support
- *  Copyright (C) 2009 Nokia Corporation
- *  Author: Kirill A. Shutemov
- *
  *  Copyright notices from the original cpuset code:
  *  --------------------------------------------------
  *  Copyright (C) 2003 BULL SA.
@@ -56,8 +52,6 @@
 #include <linux/pid_namespace.h>
 #include <linux/idr.h>
 #include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
-#include <linux/eventfd.h>
-#include <linux/poll.h>
 
 #include <asm/atomic.h>
 
@@ -157,35 +151,6 @@ struct css_id {
 	unsigned short stack[0]; /* Array of Length (depth+1) */
 };
 
-/*
- * cgroup_event represents events which userspace want to recieve.
- */
-struct cgroup_event {
-	/*
-	 * Cgroup which the event belongs to.
-	 */
-	struct cgroup *cgrp;
-	/*
-	 * Control file which the event associated.
-	 */
-	struct cftype *cft;
-	/*
-	 * eventfd to signal userspace about the event.
-	 */
-	struct eventfd_ctx *eventfd;
-	/*
-	 * Each of these stored in a list by the cgroup.
-	 */
-	struct list_head list;
-	/*
-	 * All fields below needed to unregister event when
-	 * userspace closes eventfd.
-	 */
-	poll_table pt;
-	wait_queue_head_t *wqh;
-	wait_queue_t wait;
-	struct work_struct remove;
-};
 
 /* The list of hierarchy roots */
 
@@ -780,28 +745,14 @@ static struct inode *cgroup_new_inode(mo
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
-
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
 
@@ -1273,8 +1224,6 @@ static void init_cgroup_housekeeping(str
 	INIT_LIST_HEAD(&cgrp->release_list);
 	INIT_LIST_HEAD(&cgrp->pidlists);
 	mutex_init(&cgrp->pidlist_mutex);
-	INIT_LIST_HEAD(&cgrp->event_list);
-	spin_lock_init(&cgrp->event_list_lock);
 }
 
 static void init_cgroup_root(struct cgroupfs_root *root)
@@ -2113,16 +2062,6 @@ static const struct inode_operations cgr
 	.rename = cgroup_rename,
 };
 
-/*
- * Check if a file is a control file
- */
-static inline struct cftype *__file_cft(struct file *file)
-{
-	if (file->f_dentry->d_inode->i_fop != &cgroup_file_operations)
-		return ERR_PTR(-EINVAL);
-	return __d_cft(file->f_dentry);
-}
-
 static int cgroup_create_file(struct dentry *dentry, mode_t mode,
 				struct super_block *sb)
 {
@@ -2978,146 +2917,6 @@ static int cgroup_write_notify_on_releas
 	return 0;
 }
 
-static void cgroup_event_remove(struct work_struct *work)
-{
-	struct cgroup_event *event = container_of(work, struct cgroup_event,
-			remove);
-	struct cgroup *cgrp = event->cgrp;
-
-	/* TODO: check return code*/
-	event->cft->unregister_event(cgrp, event->cft, event->eventfd);
-
-	eventfd_ctx_put(event->eventfd);
-	remove_wait_queue(event->wqh, &event->wait);
-	kfree(event);
-}
-
-static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
-		int sync, void *key)
-{
-	struct cgroup_event *event = container_of(wait,
-			struct cgroup_event, wait);
-	struct cgroup *cgrp = event->cgrp;
-	unsigned long flags = (unsigned long)key;
-
-	if (flags & POLLHUP) {
-		spin_lock(&cgrp->event_list_lock);
-		list_del(&event->list);
-		spin_unlock(&cgrp->event_list_lock);
-		schedule_work(&event->remove);
-	}
-
-	return 0;
-}
-
-static void cgroup_event_ptable_queue_proc(struct file *file,
-		wait_queue_head_t *wqh, poll_table *pt)
-{
-	struct cgroup_event *event = container_of(pt,
-			struct cgroup_event, pt);
-
-	event->wqh = wqh;
-	add_wait_queue(wqh, &event->wait);
-}
-
-static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
-				      const char *buffer)
-{
-	struct cgroup_event *event = NULL;
-	unsigned int efd, cfd;
-	struct file *efile = NULL;
-	struct file *cfile = NULL;
-	char *endp;
-	int ret;
-
-	efd = simple_strtoul(buffer, &endp, 10);
-	if (*endp != ' ')
-		return -EINVAL;
-	buffer = endp + 1;
-
-	cfd = simple_strtoul(buffer, &endp, 10);
-	if ((*endp != ' ') && (*endp != '\0'))
-		return -EINVAL;
-	buffer = endp + 1;
-
-	event = kzalloc(sizeof(*event), GFP_KERNEL);
-	if (!event)
-		return -ENOMEM;
-	event->cgrp = cgrp;
-	INIT_LIST_HEAD(&event->list);
-	init_poll_funcptr(&event->pt, cgroup_event_ptable_queue_proc);
-	init_waitqueue_func_entry(&event->wait, cgroup_event_wake);
-	INIT_WORK(&event->remove, cgroup_event_remove);
-
-	efile = eventfd_fget(efd);
-	if (IS_ERR(efile)) {
-		ret = PTR_ERR(efile);
-		goto fail;
-	}
-
-	event->eventfd = eventfd_ctx_fileget(efile);
-	if (IS_ERR(event->eventfd)) {
-		ret = PTR_ERR(event->eventfd);
-		goto fail;
-	}
-
-	cfile = fget(cfd);
-	if (!cfile) {
-		ret = -EBADF;
-		goto fail;
-	}
-
-	/* the process need read permission on control file */
-	ret = file_permission(cfile, MAY_READ);
-	if (ret < 0)
-		goto fail;
-
-	event->cft = __file_cft(cfile);
-	if (IS_ERR(event->cft)) {
-		ret = PTR_ERR(event->cft);
-		goto fail;
-	}
-
-	if (!event->cft->register_event || !event->cft->unregister_event) {
-		ret = -EINVAL;
-		goto fail;
-	}
-
-	ret = event->cft->register_event(cgrp, event->cft,
-			event->eventfd, buffer);
-	if (ret)
-		goto fail;
-
-	if (efile->f_op->poll(efile, &event->pt) & POLLHUP) {
-		event->cft->unregister_event(cgrp, event->cft, event->eventfd);
-		ret = 0;
-		goto fail;
-	}
-
-	spin_lock(&cgrp->event_list_lock);
-	list_add(&event->list, &cgrp->event_list);
-	spin_unlock(&cgrp->event_list_lock);
-
-	fput(cfile);
-	fput(efile);
-
-	return 0;
-
-fail:
-	if (!IS_ERR(cfile))
-		fput(cfile);
-
-	if (event && event->eventfd && !IS_ERR(event->eventfd))
-		eventfd_ctx_put(event->eventfd);
-
-	if (!IS_ERR(efile))
-		fput(efile);
-
-	kfree(event);
-
-	return ret;
-}
-
 /*
  * for the common functions, 'private' gives the type of file
  */
@@ -3143,11 +2942,6 @@ static struct cftype files[] = {
 		.read_u64 = cgroup_read_notify_on_release,
 		.write_u64 = cgroup_write_notify_on_release,
 	},
-	{
-		.name = CGROUP_FILE_GENERIC_PREFIX "event_control",
-		.write_string = cgroup_write_event_control,
-		.mode = S_IWUGO,
-	},
 };
 
 static struct cftype cft_release_agent = {
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
cgroups-fix-to-return-errno-in-a-failure-path.patch
lib-stringc-simplify-strnstr.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch

