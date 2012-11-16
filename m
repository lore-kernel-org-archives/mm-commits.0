From: akpm@linux-foundation.org
Subject: + fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch added to -mm tree
Date: Fri, 16 Nov 2012 15:56:51 -0800
Message-ID: <20121116235651.7268C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:63410 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab2KPX4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Nov 2012 18:56:52 -0500
Received: by mail-gg0-f202.google.com with SMTP id i4so364523ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Nov 2012 15:56:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: fs, exportfs: escape nil dereference if no s_export_op present
has been added to the -mm tree.  Its filename is
     fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch

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
Subject: fs, exportfs: escape nil dereference if no s_export_op present

This routine will be used to generate a file handle in fdinfo output for
inotify subsystem, where if no s_export_op present the general
export_encode_fh should be used.  Thus add a test if s_export_op present
inside exportfs_encode_fh itself.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
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

 fs/exportfs/expfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/exportfs/expfs.c~fs-exportfs-escape-nil-dereference-if-no-s_export_op-present fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~fs-exportfs-escape-nil-dereference-if-no-s_export_op-present
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
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper-v2.patch
fdinfo-show-sigmask-for-signalfd-fd-v3.patch
fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch
fs-exportfs-add-exportfs_encode_inode_fh-helper.patch
fs-notify-add-procfs-fdinfo-helper-v6.patch
fs-notify-add-procfs-fdinfo-helper-v6-fix.patch

