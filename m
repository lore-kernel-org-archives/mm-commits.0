From: akpm@linux-foundation.org
Subject: + fs-notify-add-procfs-fdinfo-helper-v7-fs-fanotify-ddd-missing-pieces-in-fdinfo-for-ability-to-call-fanotify_init.patch added to -mm tree
Date: Tue, 04 Dec 2012 14:20:41 -0800
Message-ID: <20121204222042.025B082004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:59213 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2LDWUn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 17:20:43 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so437887yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 14:20:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: fs, fanotify: ddd missing pieces in fdinfo for ability to call fanotify_init
has been added to the -mm tree.  Its filename is
     fs-notify-add-procfs-fdinfo-helper-v7-fs-fanotify-ddd-missing-pieces-in-fdinfo-for-ability-to-call-fanotify_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
proc-pid-status-add-seccomp-field.patch
kcmp-selftests-make-run_tests-fix.patch
kcmp-selftests-print-fail-status-instead-of-cause-make-error.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper-v2.patch
fs-epoll-add-procfs-fdinfo-helper-v2-fs-epoll-drop-enabled-field-from-fdinfo-output.patch
fdinfo-show-sigmask-for-signalfd-fd-v3.patch
fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch
fs-exportfs-add-exportfs_encode_inode_fh-helper.patch
fs-notify-add-procfs-fdinfo-helper-v7.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-add-missing-space-after-prefix.patch
fs-notify-add-procfs-fdinfo-helper-v7-dont-forget-to-provide-fhandle-for-inode-fanotify.patch
fs-notify-add-procfs-fdinfo-helper-v7-fs-fanotify-ddd-missing-pieces-in-fdinfo-for-ability-to-call-fanotify_init.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch

