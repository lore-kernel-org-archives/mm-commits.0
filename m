From: akpm@linux-foundation.org
Subject: [folded-merged] fs-notify-add-procfs-fdinfo-helper-v7-fix-fix.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:49:39 -0800
Message-ID: <20121217234940.A5AD2200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f73.google.com ([74.125.82.73]:64374 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab2LQXtn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:49:43 -0500
Received: by mail-wg0-f73.google.com with SMTP id dt12so366183wgb.4
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:49:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, notify: Move bare fdinfo helpers to a header
has been removed from the -mm tree.  Its filename was
     fs-notify-add-procfs-fdinfo-helper-v7-fix-fix.patch

This patch was dropped because it was folded into fs-notify-add-procfs-fdinfo-helper-v7.patch

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, notify: Move bare fdinfo helpers to a header

Otherwise if the kernel gets build without procfs support
we will have build error

 | fs/notify/inotify/inotify_user.c:333:17: error: 'inotify_show_fdinfo' undeclared here (not in a function)

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fdinfo.c |    5 -----
 fs/notify/fdinfo.h |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/notify/fdinfo.c~fs-notify-add-procfs-fdinfo-helper-v7-fix-fix fs/notify/fdinfo.c
--- a/fs/notify/fdinfo.c~fs-notify-add-procfs-fdinfo-helper-v7-fix-fix
+++ a/fs/notify/fdinfo.c
@@ -145,9 +145,4 @@ int fanotify_show_fdinfo(struct seq_file
 
 #endif /* CONFIG_INOTIFY_USER || CONFIG_FANOTIFY */
 
-#else /* CONFIG_PROC_FS */
-
-#define inotify_show_fdinfo	NULL
-#define fanotify_show_fdinfo	NULL
-
 #endif /* CONFIG_PROC_FS */
diff -puN fs/notify/fdinfo.h~fs-notify-add-procfs-fdinfo-helper-v7-fix-fix fs/notify/fdinfo.h
--- a/fs/notify/fdinfo.h~fs-notify-add-procfs-fdinfo-helper-v7-fix-fix
+++ a/fs/notify/fdinfo.h
@@ -17,6 +17,11 @@ extern int inotify_show_fdinfo(struct se
 extern int fanotify_show_fdinfo(struct seq_file *m, struct file *f);
 #endif
 
+#else /* CONFIG_PROC_FS */
+
+#define inotify_show_fdinfo	NULL
+#define fanotify_show_fdinfo	NULL
+
 #endif /* CONFIG_PROC_FS */
 
 #endif /* __FSNOTIFY_FDINFO_H__ */
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
fs-notify-add-procfs-fdinfo-helper-v7-add-missing-space-after-prefix.patch
fs-notify-add-procfs-fdinfo-helper-v7-dont-forget-to-provide-fhandle-for-inode-fanotify.patch
fs-notify-add-procfs-fdinfo-helper-v7-fs-fanotify-ddd-missing-pieces-in-fdinfo-for-ability-to-call-fanotify_init.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-fanotify-add-mflags-field-to-fanotify-output.patch
docs-update-documentation-about-proc-pid-fdinfo-fd-fanotify-output.patch

