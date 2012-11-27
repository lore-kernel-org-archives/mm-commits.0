From: akpm@linux-foundation.org
Subject: + docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch added to -mm tree
Date: Tue, 27 Nov 2012 14:48:20 -0800
Message-ID: <20121127224821.472C782004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:35405 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab2K0WsX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 17:48:23 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so1540785vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 14:48:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: docs: add documentation about /proc/<pid>/fdinfo/<fd> output
has been added to the -mm tree.  Its filename is
     docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch

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
Subject: docs: add documentation about /proc/<pid>/fdinfo/<fd> output

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

 Documentation/filesystems/proc.txt |   81 +++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff -puN Documentation/filesystems/proc.txt~docs-add-documentation-about-proc-pid-fdinfo-fd-output Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~docs-add-documentation-about-proc-pid-fdinfo-fd-output
+++ a/Documentation/filesystems/proc.txt
@@ -41,6 +41,7 @@ Table of Contents
   3.5	/proc/<pid>/mountinfo - Information about mounts
   3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
   3.7   /proc/<pid>/task/<tid>/children - Information about task children
+  3.8   /proc/<pid>/fdinfo/<fd> - Information about opened file
 
   4	Configuring procfs
   4.1	Mount options
@@ -1633,6 +1634,86 @@ pids, so one need to either stop or free
 if precise results are needed.
 
 
+3.7	/proc/<pid>/fdinfo/<fd> - Information about opened file
+---------------------------------------------------------------
+This file provides information associated with an opened file. The regular
+files have at least two fields -- 'pos' and 'flags'. The 'pos' represents
+the current offset of the opened file in decimal form [see lseek(2) for
+details] and the 'flags' denotes octal O_xxx mask the file has been
+created with [see open(2) for details].
+
+A typical output is
+
+	pos:	0
+	flags:	0100002
+
+The files such as eventfd, fsnotify, signalfd, epoll among the regular pos/flags
+pair provide additional information peculiar to the objects they represent.
+
+	Eventfd files
+	~~~~~~~~~~~~~
+	pos:	0
+	flags:	04002
+	eventfd-count:	5a
+
+	where 'eventfd-count' is hex value of a counter.
+
+	Signalfd files
+	~~~~~~~~~~~~~~
+	pos:	0
+	flags:	04002
+	sigmask:	0000000000000200
+
+	where 'sigmask' is hex value of the signal mask associated
+	with a file.
+
+	Epoll files
+	~~~~~~~~~~~
+	pos:	0
+	flags:	02
+	tfd:        5 events:       1d data: ffffffffffffffff
+
+	where 'tfd' is a target file descriptor number in decimal form,
+	'events' is events mask being watched and the 'data' is data
+	associated with a target [see epoll(7) for more details].
+
+	Fsnotify files
+	~~~~~~~~~~~~~~
+	For inotify files the format is the following
+
+	pos:	0
+	flags:	02000000
+	inotify wd:3 ino:9e7e sdev:800013 mask:800afce ignored_mask:0 fhandle-bytes:8 fhandle-type:1 f_handle:7e9e0000640d1b6d
+
+	where 'wd' is a watch descriptor in decimal form, ie a target file
+	descriptor number, 'ino' and 'sdev' are inode and device where the
+	target file lays on and the 'mask' is the mask of events, all in hex
+	form [see inotify(7) for more details].
+
+	In case if the kernel built with exportfs the path to the target file
+	is encoded as a file handle. The file handle provided by three fields
+	'fhandle-bytes', 'fhandle-type' and 'f_handle', all in hex format.
+
+	If the kernel is built without exportfs support the file handle won't be
+	printed out.
+
+	For fanotify files the format is the following
+
+	pos:	0
+	flags:	02
+	fanotify ino:2 sdev:800013 mask:1 ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:0200000000000000
+
+	or
+
+	pos:	0
+	flags:	02
+	fanotify mnt_id:13 mask:1 ignored_mask:40000000
+
+	where 'ino', 'sdev' are target inode and device, 'mnt_id' is the mount point identifier,
+	'mask' is the events mask used and 'ignored_mask' is the mask of events which are
+	to be ignored. All written in hex format.
+
+
 ------------------------------------------------------------------------------
 Configuring procfs
 ------------------------------------------------------------------------------
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
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
docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch

