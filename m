From: akpm@linux-foundation.org
Subject: [merged] ipc-hard_msgmax-should-be-higher-not-lower-on-64bit.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:57 -0800
Message-ID: <200912162038.nBGKcvCc013487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964988AbZLPUj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:39:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, clg@fr.ibm.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ipc: HARD_MSGMAX should be higher not lower on 64bit
has been removed from the -mm tree.  Its filename was
     ipc-hard_msgmax-should-be-higher-not-lower-on-64bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: HARD_MSGMAX should be higher not lower on 64bit
From: Amerigo Wang <amwang@redhat.com>

We have HARD_MSGMAX lower on 64bit than on 32bit, since usually 64bit
machines have more memory than 32bit machines.

Making it higher on 64bit seems reasonable, and keep the original number
on 32bit.

Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/ipc_namespace.h~ipc-hard_msgmax-should-be-higher-not-lower-on-64bit include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-hard_msgmax-should-be-higher-not-lower-on-64bit
+++ a/include/linux/ipc_namespace.h
@@ -87,7 +87,7 @@ extern int mq_init_ns(struct ipc_namespa
 /* default values */
 #define DFLT_QUEUESMAX 256     /* max number of message queues */
 #define DFLT_MSGMAX    10      /* max number of messages in each queue */
-#define HARD_MSGMAX    (131072/sizeof(void *))
+#define HARD_MSGMAX    (32768*sizeof(void *)/4)
 #define DFLT_MSGSIZEMAX 8192   /* max message size */
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
linux-next.patch
xtensa-use-generic-sys_pipe.patch

