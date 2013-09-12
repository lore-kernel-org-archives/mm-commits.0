From: akpm@linux-foundation.org
Subject: [merged] ipcmsg-drop-msg_unlock.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:50:57 -0700
Message-ID: <52321b21.kjdtxrSuqtRTjw4O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3ILTv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:51:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: [merged] ipcmsg-drop-msg_unlock.patch removed from -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:50:57 -0700


The patch titled
     Subject: ipc,msg: drop msg_unlock
has been removed from the -mm tree.  Its filename was
     ipcmsg-drop-msg_unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc,msg: drop msg_unlock

There is only one user left, drop this function and just call
ipc_unlock_object() and rcu_read_unlock().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN ipc/msg.c~ipcmsg-drop-msg_unlock ipc/msg.c
--- a/ipc/msg.c~ipcmsg-drop-msg_unlock
+++ a/ipc/msg.c
@@ -70,8 +70,6 @@ struct msg_sender {
 
 #define msg_ids(ns)	((ns)->ids[IPC_MSG_IDS])
 
-#define msg_unlock(msq)		ipc_unlock(&(msq)->q_perm)
