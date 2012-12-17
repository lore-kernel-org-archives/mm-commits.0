From: akpm@linux-foundation.org
Subject: [folded-merged] fs-notify-add-procfs-fdinfo-helper-v7-fs-fanotify-ddd-missing-pieces-in-fdinfo-for-ability-to-call-fanotify_init.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:49:53 -0800
Message-ID: <20121217234954.2E86F100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:41762 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2LQXtz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:49:55 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so696351yen.0
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:49:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, fanotify: ddd missing pieces in fdinfo for ability to call fanotify_init
has been removed from the -mm tree.  Its filename was
     fs-notify-add-procfs-fdinfo-helper-v7-fs-fanotify-ddd-missing-pieces-in-fdinfo-for-ability-to-call-fanotify_init.patch

This patch was dropped because it was folded into fs-notify-add-procfs-fdinfo-helper-v7.patch

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, fanotify: ddd missing pieces in fdinfo for ability to call fanotify_init

While restoring fanotify objects I discovered that the minimum information
we provide now is enough to restore notification marks but still a bit
incomplete for fanotify_init system call (the @flags and @event-flags are
unknown).  This patch adds missing bits into fdinfo output.

An example of output is below

 | pos:	0
 | flags:	04002
 | fanotify flags:10 event-flags:0
 | fanotify mnt_id:12 mask:3b ignored_mask:0
 | fanotify ino:50205 sdev:800013 mask:3b ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:05020500fb1d47e7

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fdinfo.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN fs/notify/fdinfo.c~fs-notify-add-procfs-fdinfo-helper-v7-fs-fanotify-ddd-missing-pieces-in-fdinfo-for-ability-to-call-fanotify_init fs/notify/fdinfo.c
--- a/fs/notify/fdinfo.c~fs-notify-add-procfs-fdinfo-helper-v7-fs-fanotify-ddd-missing-pieces-in-fdinfo-for-ability-to-call-fanotify_init
+++ a/fs/notify/fdinfo.c
@@ -4,6 +4,7 @@
 #include <linux/idr.h>
 #include <linux/init.h>
 #include <linux/inotify.h>
+#include <linux/fanotify.h>
 #include <linux/kernel.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
@@ -140,6 +141,30 @@ out:
 
 int fanotify_show_fdinfo(struct seq_file *m, struct file *f)
 {
+	struct fsnotify_group *group = f->private_data;
+	unsigned int flags = 0;
+
+	switch (group->priority) {
+	case FS_PRIO_0:
+		flags |= FAN_CLASS_NOTIF;
+		break;
+	case FS_PRIO_1:
+		flags |= FAN_CLASS_CONTENT;
+		break;
+	case FS_PRIO_2:
+		flags |= FAN_CLASS_PRE_CONTENT;
+		break;
+	}
+
+	if (group->max_events == UINT_MAX)
+		flags |= FAN_UNLIMITED_QUEUE;
+
+	if (group->fanotify_data.max_marks == UINT_MAX)
+		flags |= FAN_UNLIMITED_MARKS;
+
+	seq_printf(m, "fanotify flags:%x event-flags:%x\n",
+		   flags, group->fanotify_data.f_flags);
+
 	return show_fdinfo(m, f, fanotify_fdinfo);
 }
 
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
proc-pid-status-add-seccomp-field.patch
kcmp-selftests-make-run_tests-fix.patch
kcmp-selftests-print-fail-status-instead-of-cause-make-error.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper-v2.patch
fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch
fs-exportfs-add-exportfs_encode_inode_fh-helper.patch
fs-notify-add-procfs-fdinfo-helper-v7.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-fanotify-add-mflags-field-to-fanotify-output.patch
docs-update-documentation-about-proc-pid-fdinfo-fd-fanotify-output.patch

