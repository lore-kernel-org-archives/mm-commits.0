From: akpm@linux-foundation.org
Subject: [merged] docs-update-documentation-about-proc-pid-fdinfo-fd-fanotify-output.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:13:03 -0800
Message-ID: <20121218201304.57903200063@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:60085 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab2LRUNI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:13:08 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so63600eaa.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:13:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: docs: update documentation about /proc/<pid>/fdinfo/<fd> fanotify output
has been removed from the -mm tree.  Its filename was
     docs-update-documentation-about-proc-pid-fdinfo-fd-fanotify-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch

