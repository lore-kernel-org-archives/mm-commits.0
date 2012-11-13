From: akpm@linux-foundation.org
Subject: + fs-exportfs-avoid-nil-dereference-if-no-s_export_op-present.patch added to -mm tree
Date: Mon, 12 Nov 2012 17:05:56 -0800
Message-ID: <20121113010557.96EC420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:60566 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab2KMBGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 20:06:00 -0500
Received: by mail-we0-f202.google.com with SMTP id x43so437053wey.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 17:05:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, viro@ZenIV.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: fs, exportfs: avoid nil dereference if no s_export_op present
has been added to the -mm tree.  Its filename is
     fs-exportfs-avoid-nil-dereference-if-no-s_export_op-present.patch

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
Subject: fs, exportfs: avoid nil dereference if no s_export_op present

This routine will be used to generate a file handle in fdinfo output for
inotify subsystem, where if no s_export_op present the general
export_encode_fh should be used.  Thus add a test if s_export_op present
inside exportfs_encode_fh itself.

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

 fs/exportfs/expfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/exportfs/expfs.c~fs-exportfs-avoid-nil-dereference-if-no-s_export_op-present fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~fs-exportfs-avoid-nil-dereference-if-no-s_export_op-present
+++ a/fs/exportfs/expfs.c
@@ -357,7 +357,7 @@ int exportfs_encode_fh(struct dentry *de
 		 */
 		parent = p->d_inode;
 	}
-	if (nop->encode_fh)
+	if (nop && nop->encode_fh)
 		error = nop->encode_fh(inode, fid->raw, max_len, parent);
 	else
 		error = export_encode_fh(inode, fid, max_len, parent);
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

