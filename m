From: akpm@linux-foundation.org
Subject: + ipc-remove-forced-assignment-of-selected-message.patch added to -mm tree
Date: Wed, 24 Oct 2012 14:38:47 -0700
Message-ID: <20121024213848.4AB1D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:49094 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935411Ab2JXViw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 17:38:52 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so62033fae.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 14:38:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skinsbursky@parallels.com, ebiederm@xmission.com, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: ipc: remove forced assignment of selected message
has been added to the -mm tree.  Its filename is
     ipc-remove-forced-assignment-of-selected-message.patch

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
Subject: ipc: remove forced assignment of selected message

This is a cleanup patch. The assignment is redundant.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN ipc/msg.c~ipc-remove-forced-assignment-of-selected-message ipc/msg.c
--- a/ipc/msg.c~ipc-remove-forced-assignment-of-selected-message
+++ a/ipc/msg.c
@@ -793,12 +793,9 @@ long do_msgrcv(int msqid, long *pmtype, 
 				msg = walk_msg;
 				if (mode == SEARCH_LESSEQUAL &&
 						walk_msg->m_type != 1) {
-					msg = walk_msg;
 					msgtyp = walk_msg->m_type - 1;
-				} else {
-					msg = walk_msg;
+				} else
 					break;
-				}
 			}
 			tmp = tmp->next;
 		}
_

Patches currently in -mm which might be from skinsbursky@parallels.com are

origin.patch
proc-check-vma-vm_file-before-dereferencing.patch
ipc-remove-forced-assignment-of-selected-message.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup.patch
ipc-message-queue-copy-feature-introduced.patch
selftests-ipc-message-queue-copy-feature-test.patch

