From: akpm@linux-foundation.org
Subject: + fs-notify-add-procfs-fdinfo-helper-v7-fix-fix.patch added to -mm tree
Date: Tue, 27 Nov 2012 11:41:49 -0800
Message-ID: <20121127194149.B601282004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:53738 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2K0Tlu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 14:41:50 -0500
Received: by mail-ye0-f202.google.com with SMTP id m11so863653yen.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 11:41:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, fengguang.wu@intel.com


The patch titled
     Subject: fs, notify: Move bare fdinfo helpers to a header
has been added to the -mm tree.  Its filename is
     fs-notify-add-procfs-fdinfo-helper-v7-fix-fix.patch

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
linux-next.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
proc-pid-status-add-seccomp-field.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper-v2.patch
fdinfo-show-sigmask-for-signalfd-fd-v3.patch
fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch
fs-exportfs-add-exportfs_encode_inode_fh-helper.patch
fs-notify-add-procfs-fdinfo-helper-v7.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch

