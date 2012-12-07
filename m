From: akpm@linux-foundation.org
Subject: + docs-update-documentation-about-proc-pid-fdinfo-fd-fanotify-output.patch added to -mm tree
Date: Fri, 07 Dec 2012 13:05:21 -0800
Message-ID: <20121207210522.99FE620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:34922 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424337Ab2LGVF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2012 16:05:26 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so58060fae.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Dec 2012 13:05:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: docs: update documentation about /proc/<pid>/fdinfo/<fd> fanotify output
has been added to the -mm tree.  Its filename is
     docs-update-documentation-about-proc-pid-fdinfo-fd-fanotify-output.patch

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
Subject: docs: update documentation about /proc/<pid>/fdinfo/<fd> fanotify output

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

 Documentation/filesystems/proc.txt |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN Documentation/filesystems/proc.txt~docs-update-documentation-about-proc-pid-fdinfo-fd-fanotify-output Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~docs-update-documentation-about-proc-pid-fdinfo-fd-fanotify-output
+++ a/Documentation/filesystems/proc.txt
@@ -1698,21 +1698,27 @@ pair provide additional information part
 	If the kernel is built without exportfs support the file handle won't be
 	printed out.
 
-	For fanotify files the format is
+	If there is no inotify mark attached yet the 'inotify' line will be omitted.
 
-	pos:	0
-	flags:	02
-	fanotify ino:2 sdev:800013 mask:1 ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:0200000000000000
-
-	or
+	For fanotify files the format is
 
 	pos:	0
 	flags:	02
-	fanotify mnt_id:13 mask:1 ignored_mask:40000000
+	fanotify flags:10 event-flags:0
+	fanotify mnt_id:12 mflags:40 mask:38 ignored_mask:40000003
+	fanotify ino:4f969 sdev:800013 mflags:0 mask:3b ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:69f90400c275b5b4
+
+	where fanotify 'flags' and 'event-flags' are values used in fanotify_init
+	call, 'mnt_id' is the mount point identifier, 'mflags' is the value of
+	flags associated with mark which are tracked separately from events
+	mask. 'ino', 'sdev' are target inode and device, 'mask' is the events
+	mask and 'ignored_mask' is the mask of events which are to be ignored.
+	All in hex format. Incorporation of 'mflags', 'mask' and 'ignored_mask'
+	does provide information about flags and mask used in fanotify_mark
+	call [see fsnotify manpage for details].
 
-	where 'ino', 'sdev' are target inode and device, 'mnt_id' is the mount
-	point identifier, 'mask' is the events mask used and 'ignored_mask' is
-	the mask of events which are to be ignored. All in hex format.
+	While the first three lines are mandatory and always printed, the rest is
+	optional and may be omitted if no marks created yet.
 
 
 ------------------------------------------------------------------------------
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
fs-fanotify-add-mflags-field-to-fanotify-output.patch
docs-update-documentation-about-proc-pid-fdinfo-fd-fanotify-output.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch

