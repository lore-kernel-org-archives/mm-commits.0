From: akpm@linux-foundation.org
Subject: [merged] ipc-remove-forced-assignment-of-selected-message.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:25:00 -0800
Message-ID: <20130107192500.C81C2820059@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:35822 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab3AGTZC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:25:02 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so2115753qch.4
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:25:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skinsbursky@parallels.com, ebiederm@xmission.com, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: remove forced assignment of selected message
has been removed from the -mm tree.  Its filename was
     ipc-remove-forced-assignment-of-selected-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

