From: akpm@google.com
Subject: + ipc-mqueue-cleanup-definition-names-and-locations.patch added to -mm tree
Date: Wed, 28 Sep 2011 14:32:12 -0700
Message-ID: <201109282132.p8SLWDI9006417@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:1675 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab1I1Vcf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2011 17:32:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dledford@redhat.com, amwang@redhat.com, joe.korty@ccur.com, manfred@colorfullife.com, serue@us.ibm.com


The patch titled
     Subject: ipc/mqueue: cleanup definition names and locations
has been added to the -mm tree.  Its filename is
     ipc-mqueue-cleanup-definition-names-and-locations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Doug Ledford <dledford@redhat.com>
Subject: ipc/mqueue: cleanup definition names and locations

We had a customer come up with a problem while trying to upgrade from our
2.6.18 kernel to our 2.6.32 kernel.  In diagnosing their problem, it was
determined that when commit b231cca4 ("message queues: increase range
limits") changed the msg size max from INT_MAX to 8192*128, that's what
broke their setup.

While fixing this problem, testing showed that if you increase the max
values of a msg queue, then attempt to create one without an attr struct
passed in to the open call, it could fail because it sets the queue size
to the max of both the msg size and queue size.  If these are large
enough, they over run the default RLIMIT_MSGQUEUE.  This change was also
introduced in the b231cca4 ("message queues: increase range limits")
commit.

We then found that the msg queue limits were not all being enforced on
CAP_SYS_RESOURCE apps.

Finally, we found that commit 9cf18e1d ("ipc: HARD_MSGMAX should be higher
not lower on 64bit") fiddled with HARD_MSGMAX without realizing that the
reason it was set to what it was, was to avoid trying to kmalloc a chunk
larger than 128K.

So this series of patches cleans up the various defines, takes us back to
having a larger HARD_MSGSIZEMAX, goes back to using a separate define for
the case where a user doesn't pass in an attr struct in case the maxes
have been raised too large for RLIMIT_MSGQUEUE, enforces the maximums on
CAP_SYS_RESOURCE apps, uses vmalloc instead of kmalloc when the msg
pointer array is too large, and documents all of this so it shouldn't
happen again.



This patch:

The various defines for minimums and maximums of the sysctl controllable
mqueue values are scattered amongst different files and named
inconsistently.  Move them all into ipc_namespace.h and make them have
consistent names.  Additionally, make the number of queues per namespace
also have a minimum and maximum and use the same sysctl function as the
other two settable variables.

Signed-off-by: Doug Ledford <dledford@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Joe Korty <joe.korty@ccur.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 include/linux/ipc_namespace.h |    5 +++++
 ipc/mq_sysctl.c               |   31 ++++++++-----------------------
 2 files changed, 13 insertions(+), 23 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-mqueue-cleanup-definition-names-and-locations include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-mqueue-cleanup-definition-names-and-locations
+++ a/include/linux/ipc_namespace.h
@@ -91,10 +91,15 @@ static inline void shm_destroy_orphaned(
 #ifdef CONFIG_POSIX_MQUEUE
 extern int mq_init_ns(struct ipc_namespace *ns);
 /* default values */
+#define MIN_QUEUESMAX  1
 #define DFLT_QUEUESMAX 256     /* max number of message queues */
+#define HARD_QUEUESMAX 1024
+#define MIN_MSGMAX     1
 #define DFLT_MSGMAX    10      /* max number of messages in each queue */
 #define HARD_MSGMAX    (32768*sizeof(void *)/4)
+#define MIN_MSGSIZEMAX  128
 #define DFLT_MSGSIZEMAX 8192   /* max message size */
+#define HARD_MSGSIZEMAX (8192*128)
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
 #endif
diff -puN ipc/mq_sysctl.c~ipc-mqueue-cleanup-definition-names-and-locations ipc/mq_sysctl.c
--- a/ipc/mq_sysctl.c~ipc-mqueue-cleanup-definition-names-and-locations
+++ a/ipc/mq_sysctl.c
@@ -13,15 +13,6 @@
 #include <linux/ipc_namespace.h>
 #include <linux/sysctl.h>
 
-/*
- * Define the ranges various user-specified maximum values can
- * be set to.
- */
-#define MIN_MSGMAX	1		/* min value for msg_max */
-#define MAX_MSGMAX	HARD_MSGMAX	/* max value for msg_max */
-#define MIN_MSGSIZEMAX	128		/* min value for msgsize_max */
-#define MAX_MSGSIZEMAX	(8192*128)	/* max value for msgsize_max */
-
 #ifdef CONFIG_PROC_SYSCTL
 static void *get_mq(ctl_table *table)
 {
@@ -31,16 +22,6 @@ static void *get_mq(ctl_table *table)
 	return which;
 }
 
-static int proc_mq_dointvec(ctl_table *table, int write,
-	void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	struct ctl_table mq_table;
-	memcpy(&mq_table, table, sizeof(mq_table));
-	mq_table.data = get_mq(table);
-
-	return proc_dointvec(&mq_table, write, buffer, lenp, ppos);
-}
-
 static int proc_mq_dointvec_minmax(ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -52,15 +33,17 @@ static int proc_mq_dointvec_minmax(ctl_t
 					lenp, ppos);
 }
 #else
-#define proc_mq_dointvec NULL
 #define proc_mq_dointvec_minmax NULL
 #endif
 
+static int msg_queues_limit_min = MIN_QUEUESMAX;
+static int msg_queues_limit_max = HARD_QUEUESMAX;
+
 static int msg_max_limit_min = MIN_MSGMAX;
-static int msg_max_limit_max = MAX_MSGMAX;
+static int msg_max_limit_max = HARD_MSGMAX;
 
 static int msg_maxsize_limit_min = MIN_MSGSIZEMAX;
-static int msg_maxsize_limit_max = MAX_MSGSIZEMAX;
+static int msg_maxsize_limit_max = HARD_MSGSIZEMAX;
 
 static ctl_table mq_sysctls[] = {
 	{
@@ -68,7 +51,9 @@ static ctl_table mq_sysctls[] = {
 		.data		= &init_ipc_ns.mq_queues_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_mq_dointvec,
+		.proc_handler	= proc_mq_dointvec_minmax,
+		.extra1		= &msg_queues_limit_min,
+		.extra2		= &msg_queues_limit_max,
 	},
 	{
 		.procname	= "msg_max",
_
Subject: Subject: ipc/mqueue: cleanup definition names and locations

Patches currently in -mm which might be from dledford@redhat.com are

linux-next.patch
ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch

