From: akpm@linux-foundation.org
Subject: [folded-merged] fs-notify-add-procfs-fdinfo-helper-v7-dont-forget-to-provide-fhandle-for-inode-fanotify.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:49:49 -0800
Message-ID: <20121217234950.318B2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:34874 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2LQXtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:49:52 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so30734qad.4
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:49:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, notify: don't forget to provide fhandle for inode fanotify
has been removed from the -mm tree.  Its filename was
     fs-notify-add-procfs-fdinfo-helper-v7-dont-forget-to-provide-fhandle-for-inode-fanotify.patch

This patch was dropped because it was folded into fs-notify-add-procfs-fdinfo-helper-v7.patch

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, notify: don't forget to provide fhandle for inode fanotify

For inode based fanotify I missed to add fhandle output. This patch
brings it in.

 | pos:	0
 | flags:	02
 | fanotify ino:2 sdev:800013 mask:1 ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:0200000000000000

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fdinfo.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/notify/fdinfo.c~fs-notify-add-procfs-fdinfo-helper-v7-dont-forget-to-provide-fhandle-for-inode-fanotify fs/notify/fdinfo.c
--- a/fs/notify/fdinfo.c~fs-notify-add-procfs-fdinfo-helper-v7-dont-forget-to-provide-fhandle-for-inode-fanotify
+++ a/fs/notify/fdinfo.c
@@ -36,8 +36,6 @@ static int show_fdinfo(struct seq_file *
 	return ret;
 }
 
-#ifdef CONFIG_INOTIFY_USER
-
 #if defined(CONFIG_EXPORTFS)
 static int show_mark_fhandle(struct seq_file *m, struct inode *inode)
 {
@@ -74,6 +72,8 @@ static int show_mark_fhandle(struct seq_
 }
 #endif
 
+#ifdef CONFIG_INOTIFY_USER
+
 static int inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 {
 	struct inotify_inode_mark *inode_mark;
@@ -121,9 +121,11 @@ static int fanotify_fdinfo(struct seq_fi
 		if (!inode)
 			goto out;
 		ret = seq_printf(m, "fanotify ino:%lx sdev:%x "
-				 "mask:%x ignored_mask:%x\n",
+				 "mask:%x ignored_mask:%x ",
 				 inode->i_ino, inode->i_sb->s_dev,
 				 mark->mask, mark->ignored_mask);
+		ret |= show_mark_fhandle(m, inode);
+		ret |= seq_putc(m, '\n');
 		iput(inode);
 	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT) {
 		struct mount *mnt = real_mount(mark->m.mnt);
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
fs-notify-add-procfs-fdinfo-helper-v7-fs-fanotify-ddd-missing-pieces-in-fdinfo-for-ability-to-call-fanotify_init.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-fanotify-add-mflags-field-to-fanotify-output.patch
docs-update-documentation-about-proc-pid-fdinfo-fd-fanotify-output.patch

