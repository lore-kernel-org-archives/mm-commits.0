From: akpm@linux-foundation.org
Subject: + ipc-add-sysctl-to-specify-desired-next-object-id-documentation-update-sysctl-kerneltxt.patch added to -mm tree
Date: Mon, 29 Oct 2012 14:46:31 -0700
Message-ID: <20121029214632.326D91E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55845 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092Ab2J2Vqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 17:46:33 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so700257vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 14:46:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skinsbursky@parallels.com, ebiederm@xmission.com, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: Documentation: update sysctl/kernel.txt
has been added to the -mm tree.  Its filename is
     ipc-add-sysctl-to-specify-desired-next-object-id-documentation-update-sysctl-kerneltxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: Documentation: update sysctl/kernel.txt

Add documentation about new "msg_next_id", "sem_next_id" and "shm_next_id"
sysctls.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN Documentation/sysctl/kernel.txt~ipc-add-sysctl-to-specify-desired-next-object-id-documentation-update-sysctl-kerneltxt Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~ipc-add-sysctl-to-specify-desired-next-object-id-documentation-update-sysctl-kerneltxt
+++ a/Documentation/sysctl/kernel.txt
@@ -38,6 +38,7 @@ show up in /proc/sys/kernel:
 - l2cr                        [ PPC only ]
 - modprobe                    ==> Documentation/debugging-modules.txt
 - modules_disabled
+- msg_next_id		      [ sysv ipc ]
 - msgmax
 - msgmnb
 - msgmni
@@ -62,7 +63,9 @@ show up in /proc/sys/kernel:
 - rtsig-max
 - rtsig-nr
 - sem
+- sem_next_id		      [ sysv ipc ]
 - sg-big-buff                 [ generic SCSI device (sg) ]
+- shm_next_id		      [ sysv ipc ]
 - shm_rmid_forced
 - shmall
 - shmmax                      [ sysv ipc ]
@@ -320,6 +323,22 @@ to false.
 
 ==============================================================
 
+msg_next_id, sem_next_id, and shm_next_id:
+
+These three toggles allows to specify desired id for next allocated IPC
+object: message, semaphore or shared memory respectively.
+
+By default they are equal to -1, which means generic allocation logic.
+Possible values to set are in range {0..INT_MAX}.
+
+Notes:
+1) kernel doesn't guarantee, that new object will have desired id. So,
+it's up to userspace, how to handle an object with "wrong" id.
+2) Toggle with non-default value will be set back to -1 by kernel after
+successful IPC object allocation.
+
+==============================================================
+
 nmi_watchdog:
 
 Enables/Disables the NMI watchdog on x86 systems. When the value is
_

Patches currently in -mm which might be from skinsbursky@parallels.com are

linux-next.patch
proc-check-vma-vm_file-before-dereferencing.patch
ipc-remove-forced-assignment-of-selected-message.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-add-sysctl-to-specify-desired-next-object-id-wrap-new-sysctls-for-criu-inside-config_checkpoint_restore.patch
ipc-add-sysctl-to-specify-desired-next-object-id-documentation-update-sysctl-kerneltxt.patch
ipc-message-queue-receive-cleanup.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-message-queue-copy-feature-introduced.patch
ipc-message-queue-copy-feature-introduced-remove-redundant-msg_copy-check.patch
ipc-message-queue-copy-feature-introduced-cleanup-do_msgrcv-aroung-msg_copy-feature.patch
selftests-ipc-message-queue-copy-feature-test.patch
selftests-ipc-message-queue-copy-feature-test-update.patch

