From: akpm@linux-foundation.org
Subject: [merged] cgroup-implement-eventfd-based-generic-api-for-notifications.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:59:01 -0400
Message-ID: <201003150659.o2F6xZbX016560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935633Ab0COG77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:59:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, balbir@linux.vnet.ibm.com, dan@embeddedalley.com, davidel@xmailserver.org, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.


The patch titled
     cgroup: implement eventfd-based generic API for notifications
has been removed from the -mm tree.  Its filename was
     cgroup-implement-eventfd-based-generic-api-for-notifications.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: implement eventfd-based generic API for notifications
From: "Kirill A. Shutemov" <kirill@shutemov.name>

This patchset introduces eventfd-based API for notifications in cgroups
and implements memory notifications on top of it.

It uses statistics in memory controler to track memory usage.

Output of time(1) on building kernel on tmpfs:

Root cgroup before changes:
	make -j2  506.37 user 60.93s system 193% cpu 4:52.77 total
Non-root cgroup before changes:
	make -j2  507.14 user 62.66s system 193% cpu 4:54.74 total
Root cgroup after changes (0 thresholds):
	make -j2  507.13 user 62.20s system 193% cpu 4:53.55 total
Non-root cgroup after changes (0 thresholds):
	make -j2  507.70 user 64.20s system 193% cpu 4:55.70 total
Root cgroup after changes (1 thresholds, never crossed):
	make -j2  506.97 user 62.20s system 193% cpu 4:53.90 total
Non-root cgroup after changes (1 thresholds, never crossed):
	make -j2  507.55 user 64.08s system 193% cpu 4:55.63 total
						


This patch:

Introduce the write-only file "cgroup.event_control" in every cgroup.

To register new notification handler you need:
- create an eventfd;
- open a control file to be monitored. Callbacks register_event() and
  unregister_event() must be defined for the control file;
- write "<event_fd> <control_fd> <args>" to cgroup.event_control.
  Interpretation of args is defined by control file implementation;

eventfd will be woken up by control file implementation or when the
cgroup is removed.

To unregister notification handler just close eventfd.

If you need notification functionality for a control file you have to
implement callbacks register_event() and unregister_event() in the
struct cftype.

[kamezawa.hiroyu@jp.fujitsu.com: Kconfig fix]
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Dan Malek <dan@embeddedalley.com>
Cc: Vladislav Buzov <vbuzov@embeddedalley.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Alexander Shishkin <virtuoso@slind.org>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |   20 ++
 include/linux/cgroup.h            |   24 ++
 init/Kconfig                      |    1 
 kernel/cgroup.c                   |  228 +++++++++++++++++++++++++++-
 4 files changed, 272 insertions(+), 1 deletion(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroup-implement-eventfd-based-generic-api-for-notifications Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroup-implement-eventfd-based-generic-api-for-notifications
+++ a/Documentation/cgroups/cgroups.txt
@@ -23,6 +23,7 @@ CONTENTS:
   2.1 Basic Usage
   2.2 Attaching processes
   2.3 Mounting hierarchies by name
+  2.4 Notification API
 3. Kernel API
   3.1 Overview
   3.2 Synchronization
@@ -435,6 +436,25 @@ you give a subsystem a name.
 The name of the subsystem appears as part of the hierarchy description
 in /proc/mounts and /proc/<pid>/cgroups.
 
+2.4 Notification API
+--------------------
+
+There is mechanism which allows to get notifications about changing
+status of a cgroup.
+
+To register new notification handler you need:
+ - create a file descriptor for event notification using eventfd(2);
+ - open a control file to be monitored (e.g. memory.usage_in_bytes);
+ - write "<event_fd> <control_fd> <args>" to cgroup.event_control.
+   Interpretation of args is defined by control file implementation;
+
+eventfd will be woken up by control file implementation or when the
+cgroup is removed.
+
+To unregister notification handler just close eventfd.
+
+NOTE: Support of notifications should be implemented for the control
+file. See documentation for the subsystem.
 
 3. Kernel API
 =============
diff -puN include/linux/cgroup.h~cgroup-implement-eventfd-based-generic-api-for-notifications include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-implement-eventfd-based-generic-api-for-notifications
+++ a/include/linux/cgroup.h
@@ -235,6 +235,10 @@ struct cgroup {
 
 	/* For RCU-protected deletion */
 	struct rcu_head rcu_head;
+
+	/* List of events which userspace want to recieve */
+	struct list_head event_list;
+	spinlock_t event_list_lock;
 };
 
 /*
@@ -378,6 +382,26 @@ struct cftype {
 	int (*trigger)(struct cgroup *cgrp, unsigned int event);
 
 	int (*release)(struct inode *inode, struct file *file);
+
+	/*
+	 * register_event() callback will be used to add new userspace
+	 * waiter for changes related to the cftype. Implement it if
+	 * you want to provide this functionality. Use eventfd_signal()
+	 * on eventfd to send notification to userspace.
+	 */
+	int (*register_event)(struct cgroup *cgrp, struct cftype *cft,
+			struct eventfd_ctx *eventfd, const char *args);
+	/*
+	 * unregister_event() callback will be called when userspace
+	 * closes the eventfd or on cgroup removing.
+	 * This callback must be implemented, if you want provide
+	 * notification functionality.
+	 *
+	 * Be careful. It can be called after destroy(), so you have
+	 * to keep all nesessary data, until all events are removed.
+	 */
+	int (*unregister_event)(struct cgroup *cgrp, struct cftype *cft,
+			struct eventfd_ctx *eventfd);
 };
 
 struct cgroup_scanner {
diff -puN init/Kconfig~cgroup-implement-eventfd-based-generic-api-for-notifications init/Kconfig
--- a/init/Kconfig~cgroup-implement-eventfd-based-generic-api-for-notifications
+++ a/init/Kconfig
@@ -463,6 +463,7 @@ config HAVE_UNSTABLE_SCHED_CLOCK
 
 menuconfig CGROUPS
 	boolean "Control Group support"
+	depends on EVENTFD
 	help
 	  This option adds support for grouping sets of processes together, for
 	  use with process control subsystems such as Cpusets, CFS, memory
diff -puN kernel/cgroup.c~cgroup-implement-eventfd-based-generic-api-for-notifications kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-implement-eventfd-based-generic-api-for-notifications
+++ a/kernel/cgroup.c
@@ -4,6 +4,10 @@
  *  Based originally on the cpuset system, extracted by Paul Menage
  *  Copyright (C) 2006 Google, Inc
  *
+ *  Notifications support
+ *  Copyright (C) 2009 Nokia Corporation
+ *  Author: Kirill A. Shutemov
+ *
  *  Copyright notices from the original cpuset code:
  *  --------------------------------------------------
  *  Copyright (C) 2003 BULL SA.
@@ -53,6 +57,8 @@
 #include <linux/pid_namespace.h>
 #include <linux/idr.h>
 #include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
+#include <linux/eventfd.h>
+#include <linux/poll.h>
 
 #include <asm/atomic.h>
 
@@ -152,6 +158,35 @@ struct css_id {
 	unsigned short stack[0]; /* Array of Length (depth+1) */
 };
 
+/*
+ * cgroup_event represents events which userspace want to recieve.
+ */
+struct cgroup_event {
+	/*
+	 * Cgroup which the event belongs to.
+	 */
+	struct cgroup *cgrp;
+	/*
+	 * Control file which the event associated.
+	 */
+	struct cftype *cft;
+	/*
+	 * eventfd to signal userspace about the event.
+	 */
+	struct eventfd_ctx *eventfd;
+	/*
+	 * Each of these stored in a list by the cgroup.
+	 */
+	struct list_head list;
+	/*
+	 * All fields below needed to unregister event when
+	 * userspace closes eventfd.
+	 */
+	poll_table pt;
+	wait_queue_head_t *wqh;
+	wait_queue_t wait;
+	struct work_struct remove;
+};
 
 /* The list of hierarchy roots */
 
@@ -760,14 +795,28 @@ static struct inode *cgroup_new_inode(mo
 static int cgroup_call_pre_destroy(struct cgroup *cgrp)
 {
 	struct cgroup_subsys *ss;
+	struct cgroup_event *event, *tmp;
 	int ret = 0;
 
 	for_each_subsys(cgrp->root, ss)
 		if (ss->pre_destroy) {
 			ret = ss->pre_destroy(ss, cgrp);
 			if (ret)
-				break;
+				goto out;
 		}
+
+	/*
+	 * Unregister events and notify userspace.
+	 */
+	spin_lock(&cgrp->event_list_lock);
+	list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
+		list_del(&event->list);
+		eventfd_signal(event->eventfd, 1);
+		schedule_work(&event->remove);
+	}
+	spin_unlock(&cgrp->event_list_lock);
+
+out:
 	return ret;
 }
 
@@ -1239,6 +1288,8 @@ static void init_cgroup_housekeeping(str
 	INIT_LIST_HEAD(&cgrp->release_list);
 	INIT_LIST_HEAD(&cgrp->pidlists);
 	mutex_init(&cgrp->pidlist_mutex);
+	INIT_LIST_HEAD(&cgrp->event_list);
+	spin_lock_init(&cgrp->event_list_lock);
 }
 
 static void init_cgroup_root(struct cgroupfs_root *root)
@@ -2077,6 +2128,16 @@ static const struct inode_operations cgr
 	.rename = cgroup_rename,
 };
 
+/*
+ * Check if a file is a control file
+ */
+static inline struct cftype *__file_cft(struct file *file)
+{
+	if (file->f_dentry->d_inode->i_fop != &cgroup_file_operations)
+		return ERR_PTR(-EINVAL);
+	return __d_cft(file->f_dentry);
+}
+
 static int cgroup_create_file(struct dentry *dentry, mode_t mode,
 				struct super_block *sb)
 {
@@ -2931,6 +2992,166 @@ static int cgroup_write_notify_on_releas
 }
 
 /*
+ * Unregister event and free resources.
+ *
+ * Gets called from workqueue.
+ */
+static void cgroup_event_remove(struct work_struct *work)
+{
+	struct cgroup_event *event = container_of(work, struct cgroup_event,
+			remove);
+	struct cgroup *cgrp = event->cgrp;
+
+	/* TODO: check return code */
+	event->cft->unregister_event(cgrp, event->cft, event->eventfd);
+
+	eventfd_ctx_put(event->eventfd);
+	remove_wait_queue(event->wqh, &event->wait);
+	kfree(event);
+}
+
+/*
+ * Gets called on POLLHUP on eventfd when user closes it.
+ *
+ * Called with wqh->lock held and interrupts disabled.
+ */
+static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
+		int sync, void *key)
+{
+	struct cgroup_event *event = container_of(wait,
+			struct cgroup_event, wait);
+	struct cgroup *cgrp = event->cgrp;
+	unsigned long flags = (unsigned long)key;
+
+	if (flags & POLLHUP) {
+		spin_lock(&cgrp->event_list_lock);
+		list_del(&event->list);
+		spin_unlock(&cgrp->event_list_lock);
+		/*
+		 * We are in atomic context, but cgroup_event_remove() may
+		 * sleep, so we have to call it in workqueue.
+		 */
+		schedule_work(&event->remove);
+	}
+
+	return 0;
+}
+
+static void cgroup_event_ptable_queue_proc(struct file *file,
+		wait_queue_head_t *wqh, poll_table *pt)
+{
+	struct cgroup_event *event = container_of(pt,
+			struct cgroup_event, pt);
+
+	event->wqh = wqh;
+	add_wait_queue(wqh, &event->wait);
+}
+
+/*
+ * Parse input and register new cgroup event handler.
+ *
+ * Input must be in format '<event_fd> <control_fd> <args>'.
+ * Interpretation of args is defined by control file implementation.
+ */
+static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
+				      const char *buffer)
+{
+	struct cgroup_event *event = NULL;
+	unsigned int efd, cfd;
+	struct file *efile = NULL;
+	struct file *cfile = NULL;
+	char *endp;
+	int ret;
+
+	efd = simple_strtoul(buffer, &endp, 10);
+	if (*endp != ' ')
+		return -EINVAL;
+	buffer = endp + 1;
+
+	cfd = simple_strtoul(buffer, &endp, 10);
+	if ((*endp != ' ') && (*endp != '\0'))
+		return -EINVAL;
+	buffer = endp + 1;
+
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+	event->cgrp = cgrp;
+	INIT_LIST_HEAD(&event->list);
+	init_poll_funcptr(&event->pt, cgroup_event_ptable_queue_proc);
+	init_waitqueue_func_entry(&event->wait, cgroup_event_wake);
+	INIT_WORK(&event->remove, cgroup_event_remove);
+
+	efile = eventfd_fget(efd);
+	if (IS_ERR(efile)) {
+		ret = PTR_ERR(efile);
+		goto fail;
+	}
+
+	event->eventfd = eventfd_ctx_fileget(efile);
+	if (IS_ERR(event->eventfd)) {
+		ret = PTR_ERR(event->eventfd);
+		goto fail;
+	}
+
+	cfile = fget(cfd);
+	if (!cfile) {
+		ret = -EBADF;
+		goto fail;
+	}
+
+	/* the process need read permission on control file */
+	ret = file_permission(cfile, MAY_READ);
+	if (ret < 0)
+		goto fail;
+
+	event->cft = __file_cft(cfile);
+	if (IS_ERR(event->cft)) {
+		ret = PTR_ERR(event->cft);
+		goto fail;
+	}
+
+	if (!event->cft->register_event || !event->cft->unregister_event) {
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	ret = event->cft->register_event(cgrp, event->cft,
+			event->eventfd, buffer);
+	if (ret)
+		goto fail;
+
+	if (efile->f_op->poll(efile, &event->pt) & POLLHUP) {
+		event->cft->unregister_event(cgrp, event->cft, event->eventfd);
+		ret = 0;
+		goto fail;
+	}
+
+	spin_lock(&cgrp->event_list_lock);
+	list_add(&event->list, &cgrp->event_list);
+	spin_unlock(&cgrp->event_list_lock);
+
+	fput(cfile);
+	fput(efile);
+
+	return 0;
+
+fail:
+	if (cfile)
+		fput(cfile);
+
+	if (event && event->eventfd && !IS_ERR(event->eventfd))
+		eventfd_ctx_put(event->eventfd);
+
+	if (!IS_ERR_OR_NULL(efile))
+		fput(efile);
+
+	kfree(event);
+
+	return ret;
+}
+
+/*
  * for the common functions, 'private' gives the type of file
  */
 /* for hysterical raisins, we can't put this on the older files */
@@ -2955,6 +3176,11 @@ static struct cftype files[] = {
 		.read_u64 = cgroup_read_notify_on_release,
 		.write_u64 = cgroup_write_notify_on_release,
 	},
+	{
+		.name = CGROUP_FILE_GENERIC_PREFIX "event_control",
+		.write_string = cgroup_write_event_control,
+		.mode = S_IWUGO,
+	},
 };
 
 static struct cftype cft_release_agent = {
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch

