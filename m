From: akpm@linux-foundation.org
Subject: [folded-merged] docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:51:22 -0800
Message-ID: <20121217235123.31BB082004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:62814 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2LQXvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:51:24 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so31098qaq.3
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:51:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, gorcunov@openvz.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix
has been removed from the -mm tree.  Its filename was
     docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch

This patch was dropped because it was folded into docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN Documentation/filesystems/proc.txt~docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix
+++ a/Documentation/filesystems/proc.txt
@@ -1639,7 +1639,7 @@ if precise results are needed.
 This file provides information associated with an opened file. The regular
 files have at least two fields -- 'pos' and 'flags'. The 'pos' represents
 the current offset of the opened file in decimal form [see lseek(2) for
-details] and the 'flags' denotes octal O_xxx mask the file has been
+details] and 'flags' denotes the octal O_xxx mask the file has been
 created with [see open(2) for details].
 
 A typical output is
@@ -1648,7 +1648,7 @@ A typical output is
 	flags:	0100002
 
 The files such as eventfd, fsnotify, signalfd, epoll among the regular pos/flags
-pair provide additional information peculiar to the objects they represent.
+pair provide additional information particular to the objects they represent.
 
 	Eventfd files
 	~~~~~~~~~~~~~
@@ -1687,17 +1687,18 @@ pair provide additional information pecu
 
 	where 'wd' is a watch descriptor in decimal form, ie a target file
 	descriptor number, 'ino' and 'sdev' are inode and device where the
-	target file lays on and the 'mask' is the mask of events, all in hex
+	target file resides and the 'mask' is the mask of events, all in hex
 	form [see inotify(7) for more details].
 
-	In case if the kernel built with exportfs the path to the target file
-	is encoded as a file handle. The file handle provided by three fields
-	'fhandle-bytes', 'fhandle-type' and 'f_handle', all in hex format.
+	If the kernel was built with exportfs support, the path to the target
+	file is encoded as a file handle.  The file handle is provided by three
+	fields 'fhandle-bytes', 'fhandle-type' and 'f_handle', all in hex
+	format.
 
 	If the kernel is built without exportfs support the file handle won't be
 	printed out.
 
-	For fanotify files the format is the following
+	For fanotify files the format is
 
 	pos:	0
 	flags:	02
@@ -1709,9 +1710,9 @@ pair provide additional information pecu
 	flags:	02
 	fanotify mnt_id:13 mask:1 ignored_mask:40000000
 
-	where 'ino', 'sdev' are target inode and device, 'mnt_id' is the mount point identifier,
-	'mask' is the events mask used and 'ignored_mask' is the mask of events which are
-	to be ignored. All written in hex format.
+	where 'ino', 'sdev' are target inode and device, 'mnt_id' is the mount
+	point identifier, 'mask' is the events mask used and 'ignored_mask' is
+	the mask of events which are to be ignored. All in hex format.
 
 
 ------------------------------------------------------------------------------
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
create-non-empty-arch-x86-include-uapi-asm-files.patch
mm-memoryc-suppress-warning.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
backlight-add-of_find_backlight_by_node-function.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch

