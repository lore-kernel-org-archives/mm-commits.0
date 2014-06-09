From: akpm@linux-foundation.org
Subject: [merged] ipcmsg-document-volatile-r_msg.patch removed from -mm
 tree
Date: Mon, 09 Jun 2014 12:37:47 -0700
Message-ID: <53960d0b.zROgwLTZlinyU2Gi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaFIThs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:37:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, aswin@hp.com, davidlohr@hp.com

Subject: [merged] ipcmsg-document-volatile-r_msg.patch removed from -mm tree
To: davidlohr@hp.com,aswin@hp.com,manfred@colorfullife.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:37:47 -0700


The patch titled
     Subject: ipc,msg: document volatile r_msg
has been removed from the -mm tree.  Its filename was
     ipcmsg-document-volatile-r_msg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc,msg: document volatile r_msg

The need for volatile is not obvious, document it.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN ipc/msg.c~ipcmsg-document-volatile-r_msg ipc/msg.c
--- a/ipc/msg.c~ipcmsg-document-volatile-r_msg
+++ a/ipc/msg.c
@@ -42,9 +42,7 @@
 #include <linux/uaccess.h>
 #include "util.h"
 
-/*
- * one msg_receiver structure for each sleeping receiver:
- */
+/* one msg_receiver structure for each sleeping receiver */
 struct msg_receiver {
 	struct list_head	r_list;
 	struct task_struct	*r_tsk;
@@ -53,6 +51,12 @@ struct msg_receiver {
 	long			r_msgtype;
 	long			r_maxsize;
 
+	/*
+	 * Mark r_msg volatile so that the compiler
+	 * does not try to get smart and optimize
+	 * it. We rely on this for the lockless
+	 * receive algorithm.
+	 */
 	struct msg_msg		*volatile r_msg;
 };
 
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
linux-next.patch

