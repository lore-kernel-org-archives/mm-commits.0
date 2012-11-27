From: akpm@linux-foundation.org
Subject: + fs-epoll-add-procfs-fdinfo-helper-v2-fs-epoll-drop-enabled-field-from-fdinfo-output.patch added to -mm tree
Date: Tue, 27 Nov 2012 14:48:03 -0800
Message-ID: <20121127224804.03A7920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:35545 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab2K0WsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 17:48:08 -0500
Received: by mail-wi0-f202.google.com with SMTP id cb5so412813wib.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 14:48:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: fs, epoll: drop enabled field from fdinfo output
has been added to the -mm tree.  Its filename is
     fs-epoll-add-procfs-fdinfo-helper-v2-fs-epoll-drop-enabled-field-from-fdinfo-output.patch

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
Subject: fs, epoll: drop enabled field from fdinfo output

Once EPOLL_CTL_DISABLE get merged into mainline I'll bring "enabled" field
back.  Plain check for rdllink is not enough here and should be extended,
thus to not confuse the readers drop it for a while.

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

 fs/eventpoll.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/eventpoll.c~fs-epoll-add-procfs-fdinfo-helper-v2-fs-epoll-drop-enabled-field-from-fdinfo-output fs/eventpoll.c
--- a/fs/eventpoll.c~fs-epoll-add-procfs-fdinfo-helper-v2-fs-epoll-drop-enabled-field-from-fdinfo-output
+++ a/fs/eventpoll.c
@@ -826,10 +826,9 @@ static int ep_show_fdinfo(struct seq_fil
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		struct epitem *epi = rb_entry(rbp, struct epitem, rbn);
 
-		ret = seq_printf(m, "tfd: %8d events: %8x data: %16llx enabled: %d\n",
+		ret = seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
 				 epi->ffd.fd, epi->event.events,
-				 (long long)epi->event.data,
-				 ep_is_linked(&epi->rdllink));
+				 (long long)epi->event.data);
 		if (ret)
 			break;
 	}
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

