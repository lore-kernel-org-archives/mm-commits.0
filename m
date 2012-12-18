From: akpm@linux-foundation.org
Subject: [merged] docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:53 -0800
Message-ID: <20121218201253.DBC33100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:35738 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab2LRUMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:12:55 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so126434yen.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:12:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: docs: add documentation about /proc/<pid>/fdinfo/<fd> output
has been removed from the -mm tree.  Its filename was
     docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: docs: add documentation about /proc/<pid>/fdinfo/<fd> output

[akpm@linux-foundation.org: tweak documentation]
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

 Documentation/filesystems/proc.txt |   82 +++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

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
@@ -1633,6 +1634,87 @@ pids, so one need to either stop or free
 if precise results are needed.
 
 
+3.7	/proc/<pid>/fdinfo/<fd> - Information about opened file
+---------------------------------------------------------------
+This file provides information associated with an opened file. The regular
+files have at least two fields -- 'pos' and 'flags'. The 'pos' represents
+the current offset of the opened file in decimal form [see lseek(2) for
+details] and 'flags' denotes the octal O_xxx mask the file has been
+created with [see open(2) for details].
+
+A typical output is
+
+	pos:	0
+	flags:	0100002
+
+The files such as eventfd, fsnotify, signalfd, epoll among the regular pos/flags
+pair provide additional information particular to the objects they represent.
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
+	target file resides and the 'mask' is the mask of events, all in hex
+	form [see inotify(7) for more details].
+
+	If the kernel was built with exportfs support, the path to the target
+	file is encoded as a file handle.  The file handle is provided by three
+	fields 'fhandle-bytes', 'fhandle-type' and 'f_handle', all in hex
+	format.
+
+	If the kernel is built without exportfs support the file handle won't be
+	printed out.
+
+	For fanotify files the format is
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
+	where 'ino', 'sdev' are target inode and device, 'mnt_id' is the mount
+	point identifier, 'mask' is the events mask used and 'ignored_mask' is
+	the mask of events which are to be ignored. All in hex format.
+
+
 ------------------------------------------------------------------------------
 Configuring procfs
 ------------------------------------------------------------------------------
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch

