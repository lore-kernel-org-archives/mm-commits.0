From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-exportfs-avoid-nil-dereference-if-no-s_export_op-present.patch removed from -mm tree
Date: Tue, 13 Nov 2012 11:43:43 -0800
Message-ID: <20121113194343.D62E3100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:59578 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab2KMTnp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:43:45 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so895068qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:43:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, exportfs: avoid nil dereference if no s_export_op present
has been removed from the -mm tree.  Its filename was
     fs-exportfs-avoid-nil-dereference-if-no-s_export_op-present.patch

This patch was dropped because an updated version will be merged

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
fs-notify-add-file-handle-entry-into-inotify_inode_mark.patch
fs-notify-add-procfs-fdinfo-helper.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper.patch
fdinfo-show-sigmask-for-signalfd-fd.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

