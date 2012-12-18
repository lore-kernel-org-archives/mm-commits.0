From: akpm@linux-foundation.org
Subject: [folded-merged] ipc-add-sysctl-to-specify-desired-next-object-id-documentation-update-sysctl-kerneltxt.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:48:57 -0800
Message-ID: <20121218224858.6AB0A200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:57443 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab2LRWtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:49:01 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so68727bkc.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:49:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skinsbursky@parallels.com, ebiederm@xmission.com, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: update sysctl/kernel.txt
has been removed from the -mm tree.  Its filename was
     ipc-add-sysctl-to-specify-desired-next-object-id-documentation-update-sysctl-kerneltxt.patch

This patch was dropped because it was folded into ipc-add-sysctl-to-specify-desired-next-object-id.patch

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
@@ -325,6 +328,22 @@ to false.
 
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

origin.patch
linux-next.patch
ipc-remove-forced-assignment-of-selected-message.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-message-queue-copy-feature-introduced.patch
ipc-message-queue-copy-feature-introduced-remove-redundant-msg_copy-check.patch
ipc-message-queue-copy-feature-introduced-cleanup-do_msgrcv-aroung-msg_copy-feature.patch
selftests-ipc-message-queue-copy-feature-test.patch
selftests-ipc-message-queue-copy-feature-test-update.patch
ipc-simplify-free_copy-call.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
ipc-simplify-message-copying.patch
ipc-add-more-comments-to-message-copying-related-code.patch

