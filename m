From: akpm@linux-foundation.org
Subject: + ipc-remove-forced-assignment-of-selected-message.patch added to -mm tree
Date: Wed, 24 Oct 2012 14:36:37 -0700
Message-ID: <20121024213638.8EACD20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:39504 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964877Ab2JXVgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 17:36:40 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so62705wey.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 14:36:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skinsbursky@parallels.com


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
ipc-message-queue-receive-cleanup.patch
ipc-message-queue-copy-feature-introduced.patch
selftests-ipc-message-queue-copy-feature-test.patch

