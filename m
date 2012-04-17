From: akpm@linux-foundation.org
Subject: + ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch added to -mm tree
Date: Tue, 17 Apr 2012 15:17:56 -0700
Message-ID: <20120417221757.06F17A038B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:53861 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab2DQWR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Apr 2012 18:17:58 -0400
Received: by qcsp5 with SMTP id p5so789924qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Apr 2012 15:17:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dledford@redhat.com, amwang@redhat.com, joe.korty@ccur.com, jslaby@suse.cz, kosaki.motohiro@jp.fujitsu.com, manfred@colorfullife.com, serue@us.ibm.com


The patch titled
     Subject: ipc/mqueue: update maximums for the mqueue subsystem
has been added to the -mm tree.  Its filename is
     ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Doug Ledford <dledford@redhat.com>
Subject: ipc/mqueue: update maximums for the mqueue subsystem

Commit b231cca4381e ("message queues: increase range limits") changed the
maximum size of a message in a message queue from INT_MAX to 8192*128. 
Unfortunately, we had customers that relied on a size much larger than
8192*128 on their production systems.  After reviewing POSIX, we found
that it is silent on the maximum message size.  We did find a couple other
areas in which it was not silent.  Fix up the mqueue maximums so that the
customer's system can continue to work, and document both the POSIX and
real world requirements in ipc_namespace.h so that we don't have this
issue crop back up.

Also, commit 9cf18e1dd74cd0 ("ipc: HARD_MSGMAX should be higher not lower
on 64bit") fiddled with HARD_MSGMAX without realizing that the number was
intentionally in place to limit the msg queue depth to one that was small
enough to kmalloc an array of pointers (hence why we divided 128k by
sizeof(long)).  If we wish to meet POSIX requirements, we have no choice
but to change our allocation to a vmalloc instead (at least for the large
queue size case).  With that, it's possible to increase our allowed
maximum to the POSIX requirements (or more if we choose).

Signed-off-by: Doug Ledford <dledford@redhat.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Joe Korty <joe.korty@ccur.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |   47 +++++++++++++++++++++++---------
 ipc/mqueue.c                  |   10 +++++-
 2 files changed, 43 insertions(+), 14 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-mqueue-update-maximums-for-the-mqueue-subsystem include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-mqueue-update-maximums-for-the-mqueue-subsystem
+++ a/include/linux/ipc_namespace.h
@@ -90,18 +90,41 @@ static inline void shm_destroy_orphaned(
 
 #ifdef CONFIG_POSIX_MQUEUE
 extern int mq_init_ns(struct ipc_namespace *ns);
-/* default values */
-#define MIN_QUEUESMAX  1
-#define DFLT_QUEUESMAX 256     /* max number of message queues */
-#define HARD_QUEUESMAX 1024
-#define MIN_MSGMAX     1
-#define DFLT_MSG       10U
-#define DFLT_MSGMAX    10      /* max number of messages in each queue */
-#define HARD_MSGMAX    (32768*sizeof(void *)/4)
-#define MIN_MSGSIZEMAX  128
-#define DFLT_MSGSIZE    8192U
-#define DFLT_MSGSIZEMAX 8192   /* max message size */
-#define HARD_MSGSIZEMAX (8192*128)
+/*
+ * POSIX Message Queue default values:
+ *
+ * MIN_*: Lowest value an admin can set the maximum unprivileged limit to
+ * DFLT_*MAX: Default values for the maximum unprivileged limits
+ * DFLT_{MSG,MSGSIZE}: Default values used when the user doesn't supply
+ *   an attribute to the open call and the queue must be created
+ * HARD_*: Highest value the maximums can be set to.  These are enforced
+ *   on CAP_SYS_RESOURCE apps as well making them inviolate (so make them
+ *   suitably high)
+ *
+ * POSIX Requirements:
+ *   Per app minimum openable message queues - 8.  This does not map well
+ *     to the fact that we limit the number of queues on a per namespace
+ *     basis instead of a per app basis.  So, make the default high enough
+ *     that no given app should have a hard time opening 8 queues.
+ *   Minimum maximum for HARD_MSGMAX - 32767.  I bumped this to 65536.
+ *   Minimum maximum for HARD_MSGSIZEMAX - POSIX is silent on this.  However,
+ *     we have run into a situation where running applications in the wild
+ *     require this to be at least 5MB, and preferably 10MB, so I set the
+ *     value to 16MB in hopes that this user is the worst of the bunch and
+ *     the new maximum will handle anyone else.  I may have to revisit this
+ *     in the future.
+ */
+#define MIN_QUEUESMAX			1
+#define DFLT_QUEUESMAX		      256
+#define HARD_QUEUESMAX		     1024
+#define MIN_MSGMAX			1
+#define DFLT_MSG		       64U
+#define DFLT_MSGMAX		     1024
+#define HARD_MSGMAX		    65536
+#define MIN_MSGSIZEMAX		      128
+#define DFLT_MSGSIZE		     8192U
+#define DFLT_MSGSIZEMAX	       (1024*1024)
+#define HARD_MSGSIZEMAX	    (16*1024*1024)
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
 #endif
diff -puN ipc/mqueue.c~ipc-mqueue-update-maximums-for-the-mqueue-subsystem ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-update-maximums-for-the-mqueue-subsystem
+++ a/ipc/mqueue.c
@@ -150,7 +150,10 @@ static struct inode *mqueue_get_inode(st
 			info->attr.mq_msgsize = attr->mq_msgsize;
 		}
 		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
-		info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
+		if (mq_msg_tblsz > KMALLOC_MAX_SIZE)
+			info->messages = vmalloc(mq_msg_tblsz);
+		else
+			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
 		if (!info->messages)
 			goto out_inode;
 
@@ -260,7 +263,10 @@ static void mqueue_evict_inode(struct in
 	spin_lock(&info->lock);
 	for (i = 0; i < info->attr.mq_curmsgs; i++)
 		free_msg(info->messages[i]);
-	kfree(info->messages);
+	if (info->attr.mq_maxmsg * sizeof(struct msg_msg *) > KMALLOC_MAX_SIZE)
+		vfree(info->messages);
+	else
+		kfree(info->messages);
 	spin_unlock(&info->lock);
 
 	/* Total amount of bytes accounted for the mqueue */
_
Subject: Subject: ipc/mqueue: update maximums for the mqueue subsystem

Patches currently in -mm which might be from dledford@redhat.com are

ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
mqueue-revert-bump-up-dflt_max.patch
mqueue-dont-use-kmalloc-with-kmalloc_max_size.patch
mqueue-separate-mqueue-default-value-from-maximum-value-v2.patch
selftests-add-mq_open_tests.patch

