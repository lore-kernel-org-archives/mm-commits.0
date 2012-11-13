From: akpm@linux-foundation.org
Subject: + procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch added to -mm tree
Date: Mon, 12 Nov 2012 17:05:47 -0800
Message-ID: <20121113010547.DB3355C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:55479 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab2KMBFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 20:05:51 -0500
Received: by mail-lb0-f202.google.com with SMTP id i15so42980lbo.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 17:05:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, viro@ZenIV.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: procfs: add ability to plug in auxiliary fdinfo providers
has been added to the -mm tree.  Its filename is
     procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch

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
Subject: procfs: add ability to plug in auxiliary fdinfo providers

This patch brings ability to print out auxiliary data associated with file
in procfs interface /proc/pid/fdinfo/fd.

In particular further patches make eventfd, evenpoll, signalfd and
fsnotify to print additional information complete enough to restore these
objects after checkpoint.

To simplify the code we add show_fdinfo callback inside struct
file_operations (as Al and Pavel are proposing).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c       |    2 ++
 include/linux/fs.h |    3 +++
 2 files changed, 5 insertions(+)

diff -puN fs/proc/fd.c~procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers fs/proc/fd.c
--- a/fs/proc/fd.c~procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers
+++ a/fs/proc/fd.c
@@ -50,6 +50,8 @@ static int seq_show(struct seq_file *m, 
 	if (!ret) {
                 seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
 			   (long long)file->f_pos, f_flags);
+		if (file->f_op->show_fdinfo)
+			ret = file->f_op->show_fdinfo(m, file);
 		fput(file);
 	}
 
diff -puN include/linux/fs.h~procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers include/linux/fs.h
--- a/include/linux/fs.h~procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers
+++ a/include/linux/fs.h
@@ -1517,6 +1517,8 @@ struct block_device_operations;
 #define HAVE_COMPAT_IOCTL 1
 #define HAVE_UNLOCKED_IOCTL 1
 
+struct seq_file;
+
 struct file_operations {
 	struct module *owner;
 	loff_t (*llseek) (struct file *, loff_t, int);
@@ -1545,6 +1547,7 @@ struct file_operations {
 	int (*setlease)(struct file *, long, struct file_lock **);
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
+	int (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
 
 struct inode_operations {
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
proc-check-vma-vm_file-before-dereferencing.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
proc-pid-status-add-seccomp-field.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers-fix.patch
fs-exportfs-avoid-nil-dereference-if-no-s_export_op-present.patch
fs-notify-add-file-handle-entry-into-inotify_inode_mark.patch
fs-notify-add-procfs-fdinfo-helper.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper.patch
fdinfo-show-sigmask-for-signalfd-fd.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

